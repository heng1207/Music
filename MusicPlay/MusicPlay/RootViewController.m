//
//  RootViewController.m
//  MusicPlay
//
//  Created by iOS-Mac on 2018/9/29.
//  Copyright © 2018年 iOS-Mac. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "WebVideoPlayVC.h"
#import "AudioPlayVC.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor grayColor];
    
    
    
    UIButton *DFPlayeBtn = [[UIButton alloc]initWithFrame:CGRectMake(AdaptedWidth(80), AdaptedWidth(130), AdaptedWidth(200), AdaptedWidth(30))];
    [DFPlayeBtn addTarget:self action:@selector(DFPlayeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:DFPlayeBtn];
    [DFPlayeBtn setTitle:@"DFPlayer播放" forState:UIControlStateNormal];

    
    
    UIButton *htmlPlayBtn = [[UIButton alloc]initWithFrame:CGRectMake(AdaptedWidth(80), AdaptedWidth(230), AdaptedWidth(200), AdaptedWidth(30))];
    [htmlPlayBtn addTarget:self action:@selector(htmlPlayClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:htmlPlayBtn];
    [htmlPlayBtn setTitle:@"html播放" forState:UIControlStateNormal];
    
    
    UIButton *AudioPlayBtn = [[UIButton alloc]initWithFrame:CGRectMake(AdaptedWidth(80), AdaptedWidth(330), AdaptedWidth(200), AdaptedWidth(30))];
    [AudioPlayBtn addTarget:self action:@selector(AudioPlayClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:AudioPlayBtn];
    [AudioPlayBtn setTitle:@"AudioPlayer播放" forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
}

-(void)DFPlayeClick{
    ViewController *vc=[[ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)htmlPlayClick{
    WebVideoPlayVC *vc =[WebVideoPlayVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)AudioPlayClick{
    AudioPlayVC *vc =[AudioPlayVC new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
