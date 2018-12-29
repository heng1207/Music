//
//  WebVideoPlayVC.m
//  MusicPlay
//
//  Created by iOS-Mac on 2018/10/22.
//  Copyright © 2018年 iOS-Mac. All rights reserved.
//

#import "WebVideoPlayVC.h"
#import "DFPlayer.h"
@interface WebVideoPlayVC ()

@end

@implementation WebVideoPlayVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    if ([DFPlayer shareInstance].state == DFPlayerStatePause) {
        [[DFPlayer shareInstance] df_audioPlay];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([DFPlayer shareInstance].isPlaying) {
        [[DFPlayer shareInstance] df_audioPause];
    }
    
    
    
    UIWebView *webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, LL_StatusBarAndNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-LL_StatusBarAndNavigationBarHeight)];
    webView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:webView];
    NSString *url = @"https://topic.bobbyen.com/record.html?id=22847&userToken=PKr3jKHltRhVJGA1wV8jrdYhZjZPRo2e&babyToken=9jFmicpiVNrpIFyaiVGxEBYNK62xkhgQ";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:request];
    
    
    // Do any additional setup after loading the view.
}

-(void)dealloc{
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
