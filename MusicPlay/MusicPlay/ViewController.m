//
//  ViewController.m
//  MusicPlay
//
//  Created by iOS-Mac on 2018/9/14.
//  Copyright © 2018年 iOS-Mac. All rights reserved.
//

#import "ViewController.h"
#import "DFPlayer.h"
#import "YourDataModel.h"
#import "ZQLrcModel.h"
#import "ZQLyricTool.h"
#import "ZQLabel.h"

#import "JXTProgressLabel.h"


//有关距离、位置
#define topH SCREEN_HEIGHT - AdaptedWidth(155) -LL_TabbarSafeBottomMargin 


@interface ViewController ()<DFPlayerDataSource,DFPlayerDelegate>
@property (nonatomic, strong) NSMutableArray    *dataArray;
@property (nonatomic, strong) NSMutableArray    *df_ModelArray;
@property (nonatomic, strong) UITableView *lyricsTableView;


//一首歌的所有行的歌词
@property (nonatomic, strong) NSArray *allLrcLines;
@property (nonatomic, strong) NSTimer *timer;
//歌曲logo
@property (nonatomic, strong) UIImageView *logoIM;
// 歌词
@property (nonatomic, strong) ZQLabel *lrcLabel;

@property (nonatomic, strong) JXTProgressLabel * progressLabel;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHex:@"#8FE8F8"];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    [self initNavtionBar];
    [self initSubViews];
    [self initDFPlayer];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark initNavtionBar
-(void)initNavtionBar{
    
    UIView* view_bar =[[UIView alloc]init];
    view_bar.backgroundColor=[UIColor clearColor];
    [self.view addSubview: view_bar];
    view_bar.frame = CGRectMake(0, 0, SCREEN_WIDTH, LL_StatusBarAndNavigationBarHeight);
    
    UIButton *backBtn = [[UIButton alloc]init];
    [view_bar addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"music_Back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchDown];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-14);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(14);
    }];
    
}
-(void)backBtnClick{
  
//    [DFPlayer df_playerClearCacheForCurrentUser:YES block:^(BOOL isSuccess, NSError *error) {
//        NSLog(@"%@",error);
//    }];
//    [[DFPlayer shareInstance] df_deallocPlayer];
    
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UI
- (void)initSubViews{
    
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, LL_StatusBarAndNavigationBarHeight+AdaptedWidth(30), SCREEN_WIDTH, AdaptedWidth(25))];
    [self.view addSubview:nameLab];
    nameLab.text = @"Twinkle,Twinkle,Litt";
    nameLab.font = AdaptedFontSize(18);
    nameLab.textColor = [UIColor colorWithHex:@"#0066CC"];
    nameLab.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *fromLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLab.frame)+AdaptedWidth(4), SCREEN_WIDTH, AdaptedWidth(20))];
    [self.view addSubview:fromLab];
    fromLab.text = @"by BobbyEN";
    fromLab.font = AdaptedFontSize(14);
    fromLab.textColor = [UIColor colorWithHex:@"#0066CC"];
    fromLab.textAlignment = NSTextAlignmentCenter;
    
    
    UIImageView *lawnBgIM=[UIImageView new];
    [self.view addSubview:lawnBgIM];
    lawnBgIM.image =[UIImage imageNamed:@"lawnBG"];
    lawnBgIM.frame = CGRectMake(0, SCREEN_HEIGHT-LL_TabbarSafeBottomMargin-AdaptedWidth(132), SCREEN_WIDTH, AdaptedWidth(132));
    
    
    //歌词tableview
    UITableView *lyricsTableView =
    [[DFPlayerControlManager shareInstance] df_lyricTableViewWithFrame:(CGRectMake(0, AdaptedHeight(173), SCREEN_WIDTH, AdaptedWidth(309)))
                                                          contentInset:UIEdgeInsetsMake(0, 0, 0, 0)
                                                         cellRowHeight:AdaptedHeight(45)
                                                   cellBackgroundColor:[UIColor clearColor]
                                     currentLineLrcForegroundTextColor:[UIColor redColor]
                                     currentLineLrcBackgroundTextColor:[UIColor whiteColor]
                                       otherLineLrcBackgroundTextColor:[UIColor whiteColor]
                                                    currentLineLrcFont:[UIFont systemFontOfSize:17]
                                                      otherLineLrcFont:[UIFont systemFontOfSize:14]
                                                             superView:self.view
                                                            clickBlock:^(NSIndexPath * _Nullable indexpath) {
                                                                
                                                            }];
    lyricsTableView.backgroundColor = [UIColor clearColor];
    self.lyricsTableView = lyricsTableView;
    lyricsTableView.hidden =NO;
    
    
    //歌曲logo
    UIImageView *logoIM=[UIImageView new];
    [self.view addSubview:logoIM];
    self.logoIM = logoIM;
    logoIM.image =[UIImage imageNamed:@"music_Logo"];
    logoIM.frame = CGRectMake(AdaptedWidth(70), AdaptedHeight(190), AdaptedWidth(235), AdaptedWidth(235));
    logoIM.hidden = YES;
    
    
    ZQLabel *lrcLabel =[[ZQLabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(logoIM.frame)+AdaptedWidth(47), SCREEN_WIDTH, 20)];
    [self.view addSubview:lrcLabel];
    self.lrcLabel = lrcLabel;
    lrcLabel.font = AdaptedFontSize(14);
    lrcLabel.textColor =[UIColor redColor];
    lrcLabel.textAlignment = NSTextAlignmentCenter;
    lrcLabel.text=@"波比英语";
    lrcLabel.hidden = YES;
    
    
    _progressLabel = [[JXTProgressLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoIM.frame)+AdaptedWidth(47), SCREEN_WIDTH, 20)];
    _progressLabel.backgroundColor = [UIColor lightGrayColor];
    _progressLabel.backgroundTextColor = [UIColor whiteColor];
    _progressLabel.foregroundTextColor = [UIColor orangeColor];
    _progressLabel.text = @"显示一句话，看着像歌词";
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    _progressLabel.font = [UIFont systemFontOfSize:20];
    //    _progressLabel.clipWidth = 47;
    _progressLabel.hidden = YES;
    [self.view addSubview:_progressLabel];
}

#pragma mark - 初始化DFPlayer
- (void)initDFPlayer{
    [[DFPlayer shareInstance] df_initPlayerWithUserId:nil];
    [DFPlayer shareInstance].dataSource  = self;
    [DFPlayer shareInstance].delegate    = self;
    [DFPlayer shareInstance].category    = DFPlayerAudioSessionCategoryPlayback;
    [DFPlayer shareInstance].isObserveWWAN = YES;
    //    [DFPlayer shareInstance].isManualToPlay = NO;
    [DFPlayer shareInstance].playMode = DFPlayerModeOrderCycle;//DFPLayer默认单曲循环。
    [[DFPlayer shareInstance] df_reloadData];//须在传入数据源后调用（类似UITableView的reloadData）
    
    
    CGRect buffRect = CGRectMake(AdaptedWidth(52), topH+AdaptedWidth(7), AdaptedWidth(271), AdaptedWidth(2));
    CGRect proRect  = CGRectMake(AdaptedWidth(52), topH, AdaptedWidth(271), AdaptedWidth(16));
    CGRect currRect = CGRectMake(AdaptedWidth(5), topH, AdaptedWidth(40), AdaptedWidth(16));
    CGRect totaRect = CGRectMake(SCREEN_WIDTH-AdaptedWidth(45), topH, AdaptedWidth(40), AdaptedWidth(16));
    
    
    CGRect playRect = CGRectMake(AdaptedWidth(158), topH+AdaptedWidth(35), AdaptedWidth(59), AdaptedWidth(59));
    CGRect nextRext = CGRectMake(AdaptedWidth(257), topH+AdaptedWidth(45), AdaptedWidth(38), AdaptedWidth(38));
    CGRect lastRect = CGRectMake(AdaptedWidth(80), topH+AdaptedWidth(45), AdaptedWidth(38), AdaptedWidth(38));
    CGRect typeRect = CGRectMake(AdaptedWidth(15), topH+AdaptedWidth(49), AdaptedWidth(30), AdaptedWidth(30));
    
    DFPlayerControlManager *manager = [DFPlayerControlManager shareInstance];
    //缓冲条
    [manager df_bufferProgressViewWithFrame:buffRect trackTintColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] progressTintColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] superView:self.view];
    //进度条
    [manager df_sliderWithFrame:proRect minimumTrackTintColor:[UIColor greenColor] maximumTrackTintColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.0] trackHeight:AdaptedHeight(2) thumbSize:(CGSizeMake(AdaptedWidth(17), AdaptedWidth(17))) superView:self.view];
    //当前时间
    UILabel *curLabel = [manager df_currentTimeLabelWithFrame:currRect superView:self.view];
    curLabel.font =AdaptedFontSize(12);
    curLabel.textColor = [UIColor whiteColor];
    //总时间
    UILabel *totLabel = [manager df_totalTimeLabelWithFrame:totaRect superView:self.view];
    totLabel.font = AdaptedFontSize(12);
    totLabel.textColor = [UIColor whiteColor];
    
    
    //播放模式按钮
    UIButton *playType = [manager df_typeControlBtnWithFrame:typeRect superView:self.view block:nil];
    playType.userInteractionEnabled = YES;
    
    //播放暂停按钮
    [manager df_playPauseBtnWithFrame:playRect superView:self.view block:^{
    }];
    
    //下一首按钮
    [manager df_nextAudioBtnWithFrame:nextRext superView:self.view block:nil];
    
    //上一首按钮
    [manager df_lastAudioBtnWithFrame:lastRect superView:self.view block:nil];
    
    //歌词
    UIButton *lyricBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-AdaptedWidth(15+30), topH+AdaptedWidth(49), AdaptedWidth(30), AdaptedWidth(30))];
    [self.view addSubview:lyricBtn];
    [lyricBtn setImage:[UIImage imageNamed:@"music_Lyric"] forState:UIControlStateNormal];
    [lyricBtn addTarget:self action:@selector(lyricClcik) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    [[DFPlayer shareInstance] df_setPlayerWithPreviousAudioModel];
    //开始播放
    [[DFPlayer shareInstance] df_playerPlayWithAudioId:[DFPlayer shareInstance].currentAudioModel.audioId];
}


#pragma mark - DFPLayer dataSource
- (NSArray<DFPlayerModel *> *)df_playerModelArray{
    if (_df_ModelArray.count == 0) {
        _df_ModelArray = [NSMutableArray array];
    }else{
        [_df_ModelArray removeAllObjects];
    }
    for (int i = 0; i < self.dataArray.count; i++) {
        YourDataModel *yourModel    = self.dataArray[i];
        DFPlayerModel *model        = [[DFPlayerModel alloc] init];
        model.audioId               = i;//****重要。AudioId从0开始，仅标识当前音频在数组中的位置。
        if ([yourModel.yourUrl hasPrefix:@"http"]) {//网络音频
            model.audioUrl  = [self translateIllegalCharacterWtihUrlStr:yourModel.yourUrl];
        }else{//本地音频
            NSString *path = [[NSBundle mainBundle] pathForResource:yourModel.yourUrl ofType:@""];
            if (path) {model.audioUrl = [NSURL fileURLWithPath:path];}
        }
        [_df_ModelArray addObject:model];
    }
    return self.df_ModelArray;
}
- (DFPlayerInfoModel *)df_playerAudioInfoModel:(DFPlayer *)player{
    YourDataModel *yourModel        = self.dataArray[player.currentAudioModel.audioId];
    DFPlayerInfoModel *infoModel    = [[DFPlayerInfoModel alloc] init];
    //音频名 歌手 专辑名
    infoModel.audioName     = yourModel.yourName;
    infoModel.audioSinger   = yourModel.yourSinger;
    infoModel.audioAlbum    = yourModel.yourAlbum;
    
    // 歌词，根据歌词文件的url获取歌词内容
    if ([yourModel.yourLyric hasPrefix:@"http"] || [yourModel.yourLyric hasPrefix:@"https"]) { // 网络路径
        infoModel.audioLyric = [NSString stringWithContentsOfURL:[NSURL URLWithString:yourModel.yourLyric] encoding:NSUTF8StringEncoding error:nil];
    }
    else{// 本地路径
        NSString *lyricPath     = [[NSBundle mainBundle] pathForResource:yourModel.yourLyric ofType:nil];
        infoModel.audioLyric    = [NSString stringWithContentsOfFile:lyricPath encoding:NSUTF8StringEncoding error:nil];
    }
    
    
    //配图
    NSURL *imageUrl         = [NSURL URLWithString:yourModel.yourImage];
    NSData *imageData       = [NSData dataWithContentsOfURL:imageUrl];
    infoModel.audioImage    = [UIImage imageWithData: imageData];
    return infoModel;
}


#pragma mark - DFPlayer delegate
//加入播放队列
- (void)df_playerAudioWillAddToPlayQueue:(DFPlayer *)player{
    
}
//准备播放
- (void)df_playerReadyToPlay:(DFPlayer *)player{

    DFPlayerInfoModel *infoModel = player.currentAudioInfoModel;
    self.allLrcLines = [ZQLyricTool lyricListWithName:infoModel.audioLyric];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/30.0 target:self selector:@selector(updatePerSecond) userInfo:nil repeats:YES];
    [self.timer fire];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}
//缓冲进度代理
- (void)df_player:(DFPlayer *)player bufferProgress:(CGFloat)bufferProgress totalTime:(CGFloat)totalTime{
    
}
//播放进度代理
- (void)df_player:(DFPlayer *)player progress:(CGFloat)progress currentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime{
    
}
//状态信息代理
- (void)df_player:(DFPlayer *)player didGetStatusCode:(DFPlayerStatusCode)statusCode{
    if (statusCode == 0) {
        //        [self showAlertWithTitle:@"没有网络连接" message:nil yesBlock:nil];
    }else if(statusCode == 1){
        //        [self showAlertWithTitle:@"继续播放将产生流量费用" message:nil noBlock:nil yseBlock:^{
        [DFPlayer shareInstance].isObserveWWAN = NO;
        [[DFPlayer shareInstance] df_playerPlayWithAudioId:player.currentAudioModel.audioId];
        //        }];
        return;
    }else if(statusCode == 2){
        //        [self showAlertWithTitle:@"请求超时" message:nil yesBlock:nil];
    }else if(statusCode == 8){
        //        [self tableViewReloadData];return;
    }
}

#pragma mark - 从plist中加载音频数据
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"LocalAudioData" ofType:@"plist"];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:path1];
        for (int tag = 0; tag < 1; tag++) {
            for (int i = 0; i < arr.count; i++) {
                YourDataModel *model = [self setDataModelWithDic:arr[i]];
                [_dataArray addObject:model];
            }
        }
    }
    return _dataArray;
}
- (YourDataModel *)setDataModelWithDic:(NSDictionary *)dic{
    YourDataModel *model = [[YourDataModel alloc] init];
    model.yourUrl       = [dic valueForKey:@"audioUrl"];
    model.yourName      = [dic valueForKey:@"audioName"];
    model.yourSinger    = [dic valueForKey:@"audioSinger"];
    model.yourAlbum     = [dic valueForKey:@"audioAlbum"];
    model.yourImage     = [dic valueForKey:@"audioImage"];
    model.yourLyric     = [dic valueForKey:@"audioLyric"];
    return model;
}


- (NSURL *)translateIllegalCharacterWtihUrlStr:(NSString *)yourUrl{
    //如果链接中存在中文或某些特殊字符，需要通过以下代码转译
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)yourUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    //    NSString *encodedString = [yourUrl stringByAddingPercentEncodingWithAllowedCharacters:charactSet];
    return [NSURL URLWithString:encodedString];
}

// 每秒执行一次
-(void)updatePerSecond{
    
    self.lrcLabel.text = @"QQ音乐";
    NSTimeInterval currentTime = [DFPlayer shareInstance].currentTime;
    
    for (int i = 0; i < self.allLrcLines.count; i++) {
        
        ZQLrcModel *cureetModel = self.allLrcLines[i];
        
        ZQLrcModel *nextModel = nil;
        if (i == self.allLrcLines.count - 1) {
            nextModel = self.allLrcLines[i];
        }else {
            nextModel = self.allLrcLines[i+1];
        }
        if (currentTime >= cureetModel.time && currentTime < nextModel.time ) {
            
            self.lrcLabel.text = cureetModel.text;
            self.lrcLabel.progress =  (currentTime-cureetModel.time)/(nextModel.time - cureetModel.time);
            
            
            _progressLabel.text = cureetModel.text;
            _progressLabel.dispProgress = (currentTime-cureetModel.time)/(nextModel.time - cureetModel.time);
            
        }
    }
    
}
-(void)lyricClcik{
    self.lyricsTableView.hidden = !self.lyricsTableView.hidden;
    self.logoIM.hidden = !self.logoIM.hidden;
    self.progressLabel.hidden = !self.progressLabel.hidden;
    //    self.lrcLabel.hidden = !self.lrcLabel.hidden;
}


-(void)dealloc{
    NSLog(@"%@",self);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
