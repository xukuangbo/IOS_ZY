//
//  ZYLiveViewController+EVENT.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/9/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYLiveViewController+EVENT.h"
#import "RCDLiveTextMessageCell.h"
#import "ZYUserZoneController.h"
#import "MinePersonSetUpModel.h"
#import "MBProgressHUD+MJ.h"
#import <CommonCrypto/CommonDigest.h>
#import "showDashangMapView.h"
#import "ZYLiveListModel.h"
#import "ZCProductDetailController.h"
#import "ChatBlackListModel.h"
#import "ZYDownloadGiftImageModel.h"
#import "ZYZCMCCacheManager.h"
#import "VersionTool.h"
@implementation ZYLiveViewController (EVENT)
- (void)initLivePersonDataView
{
    //添加个人信息view
    CGFloat personDataViewW = 230;
    CGFloat personDataViewH = 340;
    CGFloat personDataViewX = (self.view.width - personDataViewW) * 0.5;
    CGFloat personDataViewY = self.view.height;
    self.personDataView = [[LivePersonDataView alloc] initWithFrame:CGRectMake(personDataViewX, personDataViewY, personDataViewW, personDataViewH)];
    [self.personDataView.zhongchouButton setTitle:self.createLiveModel.productTitle forState:UIControlStateNormal];
    [self.view addSubview:self.personDataView];
    
    [self.personDataView.roomButton addTarget:self action:@selector(clickEnterRoomButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.personDataView.zhongchouButton addTarget:self action:@selector(clickZhongchouButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.personDataView.attentionButton addTarget:self action:@selector(clickAttentionButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.personDataView.bannedSpeakButton addTarget:self action:@selector(clickBannedSpeakButton:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setUpBottomViews
{
    //聊天区
    if(self.contentView == nil){
        CGRect contentViewFrame = CGRectMake(0, self.view.bounds.size.height-237, self.view.bounds.size.width,237);
        self.contentView.backgroundColor = RCDLive_RGBCOLOR(235, 235, 235);
        self.contentView = [[UIView alloc]initWithFrame:contentViewFrame];
        
        [self.view addSubview:self.contentView];
    }
    //聊天消息区
    if (nil == self.conversationMessageCollectionView) {
        UICollectionViewFlowLayout *customFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        customFlowLayout.minimumLineSpacing = 6;
        customFlowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 0.0f,5.0f, 0.0f);
        customFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//方向
        CGRect _conversationViewFrame = self.contentView.bounds;
        _conversationViewFrame.origin.y = 0;//y为0
        _conversationViewFrame.size.height = self.contentView.bounds.size.height - 50;//消息高度为内容view-50
        _conversationViewFrame.size.width = 240;//宽度240
        self.conversationMessageCollectionView =
        [[UICollectionView alloc] initWithFrame:_conversationViewFrame
                           collectionViewLayout:customFlowLayout];
        [self.conversationMessageCollectionView
         setBackgroundColor:[UIColor clearColor]];//背景色透明
        self.conversationMessageCollectionView.showsHorizontalScrollIndicator = NO;//展示水平条
        self.conversationMessageCollectionView.alwaysBounceVertical = YES;//垂直可弹
        self.conversationMessageCollectionView.dataSource = self;
        self.conversationMessageCollectionView.delegate = self;
        [self.contentView addSubview:self.conversationMessageCollectionView];
    }
    //打赏界面
    self.dashangMapView = [[showDashangMapView alloc] initWithFrame:CGRectMake(KEDGE_DISTANCE, self.contentView.top - showDashangMapViewH, showDashangMapViewW, showDashangMapViewH)];
    [self.view addSubview:self.dashangMapView];
    
    //输入区
    if(self.inputBar == nil){
        float inputBarOriginY = self.conversationMessageCollectionView.bounds.size.height +30;
        float inputBarOriginX = self.conversationMessageCollectionView.frame.origin.x;
        float inputBarSizeWidth = self.contentView.frame.size.width;
        float inputBarSizeHeight = MinHeight_InputView;//高度50
        self.inputBar = [[RCDLiveInputBar alloc]initWithFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight)];
        self.inputBar.delegate = self;
        self.inputBar.backgroundColor = [UIColor clearColor];
        self.inputBar.hidden = YES;
        [self.view addSubview:self.inputBar];
    }
    self.collectionViewHeader = [[RCDLiveCollectionViewHeader alloc]
                                 initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, 40)];
    self.collectionViewHeader.tag = 1999;
    [self.conversationMessageCollectionView addSubview:self.collectionViewHeader];//刷新view添加到聊天信息
    [self registerClass:[RCDLiveTextMessageCell class]forCellWithReuseIdentifier:rctextCellIndentifier];//注册文字id
    [self registerClass:[RCDLiveTipMessageCell class]forCellWithReuseIdentifier:RCDLiveTipMessageCellIndentifier];//注册提示id
    [self registerClass:[RCDLiveGiftMessageCell class]forCellWithReuseIdentifier:RCDLiveGiftMessageCellIndentifier];//注册礼物id
    [self changeModel:YES];//暂时不知道功能
    self.resetBottomTapGesture =[[UITapGestureRecognizer alloc]
                             initWithTarget:self
                             action:@selector(tap4ResetDefaultBottomBarStatus:)];//点击空白
    [self.resetBottomTapGesture setDelegate:self];
    [self.view addGestureRecognizer:self.resetBottomTapGesture];

    //评论
    CGFloat buttonWH = 40;
    self.feedBackBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.feedBackBtn];
    [self.feedBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KEDGE_DISTANCE);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(buttonWH, buttonWH));
    }];
    [self.feedBackBtn setImage:[UIImage imageNamed:@"live-talk"] forState:UIControlStateNormal];
    [self.feedBackBtn addTarget:self action:@selector(showInputBar:) forControlEvents:UIControlEventTouchUpInside];
    
    //返回
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];//返回按钮
    self.backBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.backBtn];
    [self.backBtn setImage:[UIImage imageNamed:@"live-quit"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-KEDGE_DISTANCE);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-KEDGE_DISTANCE);
        make.size.mas_equalTo(CGSizeMake(buttonWH, buttonWH));
    }];
    
    //主播功能端
    self.moreBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backBtn.mas_left).offset(-KEDGE_DISTANCE);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-KEDGE_DISTANCE);
        make.size.mas_equalTo(CGSizeMake(buttonWH, buttonWH));
    }];
    [self.moreBtn setImage:[UIImage imageNamed:@"live-more"] forState:UIControlStateNormal];
    [self.moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //主播功能段的view
    self.liveFunctionView  = [[LiveFunctionView alloc] initWithSession:self.liveSession];
    [self.view addSubview:self.liveFunctionView ];
    self.liveFunctionView .hidden = YES;
    [self.liveFunctionView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.moreBtn.mas_top);
        make.centerX.mas_equalTo(self.moreBtn.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(120, 150));
    }];
    //分享按钮端
    self.shareBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.shareBtn];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.moreBtn.mas_left).offset(-KEDGE_DISTANCE);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-KEDGE_DISTANCE);
        make.size.mas_equalTo(CGSizeMake(buttonWH, buttonWH));
    }];
    [self.shareBtn setImage:[UIImage imageNamed:@"live-share"] forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //私信按钮端
    self.massageBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.massageBtn];
    [self.massageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.shareBtn.mas_left).offset(-KEDGE_DISTANCE);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-KEDGE_DISTANCE);
        make.size.mas_equalTo(CGSizeMake(buttonWH, buttonWH));
    }];
    [self.massageBtn setImage:[UIImage imageNamed:@"live-massage"] forState:UIControlStateNormal];
    [self.massageBtn addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.conversationMessageCollectionView registerClass:cellClass
                               forCellWithReuseIdentifier:identifier];
}

#pragma mark ---定义展示的UICollectionViewCell的个数
- (void)tap4ResetDefaultBottomBarStatus:
(UIGestureRecognizer *)gestureRecognizer {
    //隐藏个人信息
    [self.personDataView hidePersonDataView];
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.inputBar setInputBarStatus:KBottomBarDefaultStatus];
        self.inputBar.hidden = YES;
        self.liveFunctionView.hidden = YES;
    }
}

#pragma mark - event 点击事件
// 展示个人头像
- (void)showPersonData
{
    [self.personDataView showPersonData];
    self.personDataView.attentionButton.hidden = YES;
    self.personDataView.bannedSpeakButton.hidden = YES;
    if ([self.createLiveModel.productId length] == 0) {
        [self.personDataView showTravelNull];
        [self.personDataView setHeight:258];
    } else if ([self.createLiveModel.productId length] != 0) {
        [self.personDataView showTravelNoNull];
        [self.personDataView setHeight:298];
    }
    [self requestData:[NSString stringWithFormat:@"%@", [ZYZCAccountTool getUserId]]];
}

// 展示个人头像
- (void)showPersonDataImage:(UITapGestureRecognizer *)sender
{
    ChatBlackListModel *user = self.userList[sender.view.tag - 1000];
    [self.personDataView showPersonData];
    self.personDataView.bannedSpeakButton.hidden = NO;
    if ([user.userId intValue] == [[ZYZCAccountTool getUserId] intValue] && [self.createLiveModel.productId length] == 0) {
        self.personDataView.attentionButton.hidden = YES;
        [self.personDataView showTravelNull];
        [self.personDataView setHeight:258];
    } else if ([user.userId intValue] == [[ZYZCAccountTool getUserId] intValue] && [self.createLiveModel.productId length] != 0) {
        self.personDataView.attentionButton.hidden = YES;
        [self.personDataView showTravelNoNull];
        [self.personDataView setHeight:298];
    } else if ([user.userId intValue] != [[ZYZCAccountTool getUserId] intValue] && [self.createLiveModel.productId length] == 0) {
        self.personDataView.attentionButton.hidden = NO;
        [self.personDataView setHeight:300];
        [self.personDataView showTravelNull];
    } else if ([user.userId intValue] != [[ZYZCAccountTool getUserId] intValue] && [self.createLiveModel.productId length] != 0) {
        self.personDataView.attentionButton.hidden = NO;
        [self.personDataView setHeight:340];
        [self.personDataView showTravelNoNull];
    }
//    if ([user.userId intValue] == [[ZYZCAccountTool getUserId] intValue]) {
//        self.personDataView.attentionButton.hidden = YES;
//        self.personDataView.bannedSpeakButton.hidden = YES;
//        [self.personDataView setHeight:298];
//    } else {
//        self.personDataView.attentionButton.hidden = NO;
//        self.personDataView.bannedSpeakButton.hidden = NO;
//        [self.personDataView setHeight:340];
//    }
    [self requestData:[NSString stringWithFormat:@"%@", user.userId]];
}

// 进入个人空间界面
- (void)clickEnterRoomButton:(UIButton *)sender
{
    self.navigationController.navigationBar.hidden = NO;
    ZYUserZoneController *userZoneController=[[ZYUserZoneController alloc]init];
    userZoneController.hidesBottomBarWhenPushed=YES;
    userZoneController.friendID=[NSNumber numberWithInteger:[self.personDataView.minePersonModel.userId intValue]];
    [self.navigationController pushViewController:userZoneController animated:YES];

}
// 进入众筹详情
- (void)clickZhongchouButton:(UIButton *)sender
{
    self.navigationController.navigationBar.hidden = NO;
    //推出信息详情页
    ZCProductDetailController *productDetailVC=[[ZCProductDetailController alloc]init];
    productDetailVC.hidesBottomBarWhenPushed=YES;
//    ZCOneModel *oneModel=self.dataArr[indexPath.row/2];
//    productDetailVC.oneModel=oneModel;
    productDetailVC.productId = [NSNumber numberWithInteger:[self.createLiveModel.productId integerValue]];
    productDetailVC.detailProductType=PersonDetailProduct;
    productDetailVC.fromProductType=ZCListProduct;
    [self.navigationController pushViewController:productDetailVC animated:YES];
    
}

// 点击关注按钮
- (void)clickAttentionButton:(UIButton *)sender
{
    WEAKSELF
    NSDictionary *params=@{@"userId":[ZYZCAccountTool getUserId],@"friendsId":self.personDataView.minePersonModel.userId};
    if ([self.personDataView.attentionButton.titleLabel.text isEqualToString:@"取消关注"]) {
        NSString *unfollowUser = [[ZYZCAPIGenerate sharedInstance] API:@"friends_unfollowUser"];
        //取消关注
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:unfollowUser andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess)
         {
             if (isSuccess) {
                 [MBProgressHUD showSuccess:@"取消成功"];
                 [weakSelf.personDataView.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
             } else {
                 [MBProgressHUD showSuccess:@"取消失败"];
             }
         }andFailBlock:^(id failResult) {
             [MBProgressHUD showSuccess:@"取消失败"];
         }];
        
    } else {
        //添加关注
        NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"friends_followUser"];
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess) {
            //            NSLog(@"%@",result);
            if (isSuccess) {
                [MBProgressHUD showSuccess:@"关注成功"];
                [weakSelf.personDataView.attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
            } else {
                [MBProgressHUD showSuccess:@"关注失败"];
            }
        } andFailBlock:^(id failResult) {
            [MBProgressHUD showSuccess:@"关注失败"];
        }];
    }
}

// 点击禁言按钮
- (void)clickBannedSpeakButton:(UIButton *)sender
{
    [self postRequest];
    
}

- (void)messageBtnAction:(UIButton *)sender
{
    
}

- (void)shareBtnAction:(UIButton *)sender
{
    [self getPayVersion];
}

-(void)showInputBar:(id)sender{
    self.inputBar.hidden = NO;
    [self.inputBar setInputBarStatus:KBottomBarKeyboardStatus];
}

// 主播功能段点击事件
- (void)moreBtnAction:(UIButton *)sender
{
    self.liveFunctionView.hidden = !self.liveFunctionView.hidden;
}

- (void)postRequest
{
    WEAKSELF
    NSMutableDictionary * paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:self.personDataView.minePersonModel.userId forKey:@"userId"];
    [paramDic setObject:self.targetId forKey:@"chatroomId"];
    [paramDic setObject:@"1440" forKey:@"minute"];

    [ZYZCHTTPTool addRongYunHeadPostHttpDataWithURL:@"https://api.cn.ronghub.com/chatroom/user/gag/add.json" andParameters:paramDic andSuccessGetBlock:^(id result, BOOL isSuccess) {
        [weakSelf showHintWithText:@"禁言成功,该用户一天内不能进行任何发言"];
    } andFailBlock:^(id failResult) {
        [weakSelf showHintWithText:@"禁言失败,请重试"];
    }];
}

#pragma mark - network
// 获取个人信息.获取个人中心数据
- (void)requestData:(NSString *)otherUserId
{
    NSString *userId = [ZYZCAccountTool getUserId];
//    NSString *getUserInfoURL = Get_SelfInfo(userId, otherUserId);
    NSString *getUserInfoURL = [[ZYZCAPIGenerate sharedInstance] API:@"u_getUserDetail_action"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:userId forKey:@"selfUserId"];
    [parameter setValue:userId forKey:@"userId"];
    WEAKSELF
    [ZYZCHTTPTool GET:getUserInfoURL parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            NSDictionary *dic = (NSDictionary *)result;
            NSDictionary *data = dic[@"data"];
            if ([[NSString stringWithFormat:@"%@", data[@"friend"]] isEqualToString:@"1"]){
                [weakSelf.personDataView.attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
            }
            MinePersonSetUpModel  *minePersonModel=[[MinePersonSetUpModel alloc] mj_setKeyValues:data[@"user"]];
            minePersonModel.gzMeAll = data[@"gzMeAll"];
            minePersonModel.meGzAll = data[@"meGzAll"];
            weakSelf.personDataView.minePersonModel = minePersonModel;
        } else {
            NSLog(@"bbbbbbb");
        }
    } andFailBlock:^(id failResult) {
        NSLog(@"aaaaaaa");
    }];
}

#pragma mark - 获取动画
// 获取礼物清单
- (void)getPayVersion
{
    NSDictionary *parameters;
    WEAKSELF
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"zhibo_lipinVersionJson"] andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        if ([[NSString stringWithFormat:@"%@", [VersionTool getPayVersion]] isEqualToString:[NSString stringWithFormat:@"%@", result[@"data"]]]) {
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/kGiftImageDataArray"]];
            weakSelf.giftImageArray = [ZYZCMCCacheManager unarchiverCachePath:path];
        } else {
            [weakSelf downloadPayImage];
        }
        [VersionTool setPayVersion:result[@"data"]];
    } andFailBlock:^(id failResult) {
        NSLog(@"failResult");
    }];
    
}
// 请求打赏图片接口
- (void)downloadPayImage
{
    NSMutableDictionary *parameters;
    WEAKSELF
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"zhibo_lipinJson"];
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.giftImageArray = [ZYDownloadGiftImageModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            [weakSelf cacheImagePath];
        }
    } andFailBlock:^(id failResult) {
        
    }];
}

- (void)cacheImagePath
{
    WEAKSELF
    dispatch_group_t group = dispatch_group_create();
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < self.giftImageArray.count; i ++)
        {
            dispatch_group_enter(group);
            // 任务代码i 假定任务 是异步执行block回调
            __block ZYDownloadGiftImageModel *model = self.giftImageArray[self.giftImageArray.count - 1 - i];
            [self.downloadManager downloadRecordFile:[NSURL URLWithString:model.downUrl]];
            [self.downloadManager setFractionCompleted:^(double progress) {
                [VersionTool setPayVersion:@"0"];
            }];
            [self.downloadManager setSuccess:^(NSString *success) {
                NSArray *imagePaths = [ZYZCMCCacheManager zipArchive:success pathType:model.price];
                model.imageArray = imagePaths;
                [weakSelf archiverCache];
            }];
            // block 回调执行
            dispatch_group_leave(group);
            // block 回调执行
        }
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_main_queue(), ^{
        // 主线程处理  
    });
}

- (void)archiverCache
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/kGiftImageDataArray"]];
    [ZYZCMCCacheManager archiverCacheData:self.giftImageArray path:path];
    
}

#pragma mark - animtion
- (void)showAnimtion:(NSString *)payType
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/kGiftImageDataArray"]];
    NSMutableArray *GiftImageArray = [ZYZCMCCacheManager unarchiverCachePath:path];
    NSMutableArray *giftImageArray;
    for (int k = 0; k < GiftImageArray.count; k++) {
        ZYDownloadGiftImageModel *model = GiftImageArray[k];
        if ([model.price integerValue] == [payType integerValue] * 100) {
            giftImageArray = [NSMutableArray arrayWithArray:model.imageArray];
        }
    }

    int arc4randomNumber = arc4random() % 270 + 100;
    int arc4randomWidth = arc4random() % 50;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(arc4randomWidth, KSCREEN_H - arc4randomNumber * 16 / 9, arc4randomNumber, arc4randomNumber * 16 / 9)];
    [self.view addSubview:imageView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *cacheImagePath = [NSString stringWithFormat:@"%@/cacheImagePath%d", documentpath, [payType intValue] * 100];
    //创建一个数组，数组中按顺序添加要播放的图片（图片为静态的图片）
    NSInteger j;
    NSMutableArray *imgArray = [NSMutableArray array];
    for (int i=1; i < giftImageArray.count + 5; i++) {
        j = i;
        if (i > giftImageArray.count) {
            j = giftImageArray.count;
        }
        UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%ld", cacheImagePath, j]];
        if (image) {
            [imgArray addObject:image];
        }
    }
    //把存有UIImage的数组赋给动画图片数组
    imageView.animationImages = imgArray;
    //设置执行一次完整动画的时长
    imageView.animationDuration = (giftImageArray. count + 5 ) * 0.1;
    //动画重复次数 （0为重复播放）
    imageView.animationRepeatCount = 1;
    //开始播放动画
    [imageView startAnimating];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self showAnimtion:payType imageNumber:number];
    //    });
}

@end
