//
//  AppDelegate.m
//  MusicPlay
//
//  Created by iOS-Mac on 2018/9/14.
//  Copyright © 2018年 iOS-Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import "DFPlayer.h"

@interface AppDelegate ()
@property(nonatomic,assign)BOOL played;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    //处理电话打进时中断音乐播放
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interruptionNotificationHandler:) name:AVAudioSessionInterruptionNotification object:nil];
    
    //后台播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [session setActive:YES error:nil];
    
    
    // 在App启动后开启远程控制事件, 接收来自锁屏界面和上拉菜单的控制
    [application beginReceivingRemoteControlEvents];
    // 处理远程控制事件
    [self remoteControlEventHandler];
    
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    RootViewController *vc=[RootViewController new];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:vc];
    [self.window makeKeyAndVisible];

    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"要挂起了。。。");
    //更新锁屏信息
    [self configNowPlayingInfoCenter];
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    //在App要终止前结束接收远程控制事件, 也可以在需要终止时调用该方法终止
    [application endReceivingRemoteControlEvents];
    
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//来电中断处理
- (void)interruptionNotificationHandler:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    NSString *type = [NSString stringWithFormat:@"%@", [interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey]];
    NSUInteger interuptionType = [type integerValue];
    
    if (interuptionType == AVAudioSessionInterruptionTypeBegan) {
        //获取中断前音乐是否在播放
        _played = [DFPlayer shareInstance].isPlaying;
        NSLog(@"AVAudioSessionInterruptionTypeBegan");
    }else if (interuptionType == AVAudioSessionInterruptionTypeEnded) {
        NSLog(@"AVAudioSessionInterruptionTypeEnded");
    }
    
    if(_played)
    {
        //停止播放的事件
        [[DFPlayer shareInstance] df_audioPause];
        _played=NO;
    }else {
        //继续播放的事件
        [[DFPlayer shareInstance] df_audioPlay];
        _played=YES;
    }
}


/**
 *  设置锁屏信息
 */
-(void)configNowPlayingInfoCenter
{
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    if (playingInfoCenter) {
        
        DFPlayerInfoModel *infoModel = [DFPlayer shareInstance].currentAudioInfoModel;
        if (!infoModel) return;
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        UIImage *image = infoModel.audioImage;
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithBoundsSize:image.size requestHandler:^UIImage * _Nonnull(CGSize size) {
            return image;
        }];
        //歌曲名称
        [songInfo setObject:infoModel.audioName forKey:MPMediaItemPropertyTitle];
        //演唱者
        [songInfo setObject:infoModel.audioSinger forKey:MPMediaItemPropertyArtist];
        //专辑名
        if (!infoModel.audioAlbum) {
            infoModel.audioAlbum = infoModel.audioName;
        }
        [songInfo setObject:infoModel.audioAlbum forKey:MPMediaItemPropertyAlbumTitle];
        //专辑缩略图
        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        //音乐当前已经播放时间
        NSInteger currentTime = [DFPlayer shareInstance].currentTime;
        [songInfo setObject:[NSNumber numberWithInteger:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        //进度光标的速度 （这个随 自己的播放速率调整，我默认是原速播放）
        [songInfo setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];
        
        
        //歌曲总时间设置
        NSInteger duration = [DFPlayer shareInstance].totalTime;
        [songInfo setObject:[NSNumber numberWithInteger:duration] forKey:MPMediaItemPropertyPlaybackDuration];
        //设置锁屏状态下屏幕显示音乐信息
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    }
}


// 在需要处理远程控制事件的具体控制器或其它类中实现
- (void)remoteControlEventHandler
{
    // 直接使用sharedCommandCenter来获取MPRemoteCommandCenter的shared实例
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    // 启用播放命令 (锁屏界面和上拉快捷功能菜单处的播放按钮触发的命令)
    commandCenter.playCommand.enabled = YES;
    // 为播放命令添加响应事件, 在点击后触发
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [[DFPlayer shareInstance] df_audioPlay];
        [self configNowPlayingInfoCenter];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    // 播放, 暂停, 上下曲的命令默认都是启用状态, 即enabled默认为YES
    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        //点击了暂停
        [[DFPlayer shareInstance] df_audioPause];
        [self configNowPlayingInfoCenter];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [commandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        //点击了上一首
        [[DFPlayer shareInstance] df_audioLast];
        [self configNowPlayingInfoCenter];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [commandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        //点击了下一首
        [[DFPlayer shareInstance] df_audioNext];
        [self configNowPlayingInfoCenter];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    // 启用耳机的播放/暂停命令 (耳机上的播放按钮触发的命令)
    commandCenter.togglePlayPauseCommand.enabled = YES;
    // 为耳机的按钮操作添加相关的响应事件
    [commandCenter.togglePlayPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        // 进行播放/暂停的相关操作 (耳机的播放/暂停按钮)
        if ([DFPlayer shareInstance].isPlaying) {
            [[DFPlayer shareInstance] df_audioPause];
        }
        else{
            [[DFPlayer shareInstance] df_audioPlay];
        }
        [self configNowPlayingInfoCenter];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.skipForwardCommand setEnabled:true];
}


@end
