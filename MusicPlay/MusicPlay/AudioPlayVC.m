//
//  AudioPlayVC.m
//  MusicPlay
//
//  Created by iOS-Mac on 2018/12/12.
//  Copyright © 2018年 iOS-Mac. All rights reserved.
//

#import "AudioPlayVC.h"
#import "STKAudioPlayer.h"
#import "DFPlayer.h"


@interface AudioPlayVC ()<STKAudioPlayerDelegate>

/** 播放工具 */
@property (nonatomic, strong) STKAudioPlayer* audioPlayer;

@property (nonatomic,strong)NSString *url;
@end

@implementation AudioPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    self.url = @"https://upload.bobbyen.com/files/C9W/nni/aTgx0eoD9jdTFnsG3exTaSUPoEmWBNwH.mp3";

    
    //已经进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    NSLog(@"%ld",(long)[DFPlayer shareInstance].state);
    if ([DFPlayer shareInstance].isPlaying) {
        [[DFPlayer shareInstance] df_audioPause];
    }
    NSLog(@"%ld",(long)[DFPlayer shareInstance].state);
    
    
    // Do any additional setup after loading the view.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     [self.audioPlayer play:self.url];
}


- (STKAudioPlayer *)audioPlayer
{
    if (!_audioPlayer)
    {
        _audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
        _audioPlayer.meteringEnabled = YES;
        _audioPlayer.volume = 1;
        _audioPlayer.delegate = self;
    }
    return _audioPlayer;
}

#pragma mark STKAudioPlayerDelegate
-(void)audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId{
}
-(void)audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId{
    
}
-(void)audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState{
    
}
-(void)audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration{
    NSLog(@"该音频播放完了");

}
-(void)audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode{
}

-(void)DidEnterForeground{
    NSLog(@"%ld",(long)[DFPlayer shareInstance].state);
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@",self);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
