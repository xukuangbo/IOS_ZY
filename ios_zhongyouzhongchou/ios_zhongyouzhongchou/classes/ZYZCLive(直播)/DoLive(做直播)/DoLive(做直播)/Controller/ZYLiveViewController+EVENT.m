//
//  ZYLiveViewController+EVENT.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/9/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYLiveViewController+EVENT.h"
#import "RCDLiveTextMessageCell.h"
#import "ZYZCPersonalController.h"
#import "MinePersonSetUpModel.h"
#import "MBProgressHUD+MJ.h"
#import <CommonCrypto/CommonDigest.h>
@implementation ZYLiveViewController (EVENT)
- (void)initLivePersonDataView
{
    //添加个人信息view
    CGFloat personDataViewW = 230;
    CGFloat personDataViewH = 340;
    CGFloat personDataViewX = (self.view.width - personDataViewW) * 0.5;
    CGFloat personDataViewY = self.view.height;
    self.personDataView = [[LivePersonDataView alloc] initWithFrame:CGRectMake(personDataViewX, personDataViewY, personDataViewW, personDataViewH)];
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
        customFlowLayout.minimumLineSpacing = 10;
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
    //输入区
    if(self.inputBar == nil){
        float inputBarOriginY = self.conversationMessageCollectionView.bounds.size.height +30;
        float inputBarOriginX = self.conversationMessageCollectionView.frame.origin.x;
        float inputBarSizeWidth = self.contentView.frame.size.width;
        float inputBarSizeHeight = MinHeight_InputView;//高度50
        self.inputBar = [[RCDLiveInputBar alloc]initWithFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight)
                                              inViewConroller:nil];
        self.inputBar.delegate = self;
        self.inputBar.backgroundColor = [UIColor clearColor];
        self.inputBar.hidden = YES;
        [self.contentView addSubview:self.inputBar];
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
    [self.personDataView showPersonDataWithUserId:@"1"];
}

// 进入个人空间界面
- (void)clickEnterRoomButton:(UIButton *)sender
{
    self.navigationController.navigationBar.hidden = NO;
    ZYZCPersonalController *personalController=[[ZYZCPersonalController alloc]init];
    personalController.hidesBottomBarWhenPushed=YES;
    personalController.userId = [NSNumber numberWithInteger:[self.personDataView.minePersonModel.userId intValue]];
    [self.navigationController pushViewController:personalController animated:YES];

}
// 进入众筹详情
- (void)clickZhongchouButton:(UIButton *)sender
{
    
}

// 点击关注按钮
- (void)clickAttentionButton:(UIButton *)sender
{
    WEAKSELF
    NSDictionary *params=@{@"userId":[ZYZCAccountTool getUserId],@"friendsId":self.personDataView.minePersonModel.userId};
    if ([self.personDataView.attentionButton.titleLabel.text isEqualToString:@"取消关注"]) {
        //取消关注
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:UNFOLLOWUSER andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess)
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
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:FOLLOWUSER andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess) {
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

- (void)showHint
{
    [self showHintWithText:@"禁言成功"];
}

- (void)messageBtnAction:(UIButton *)sender
{
    
}

- (void)shareBtnAction:(UIButton *)sender
{
    
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
    //POST请求 请求参数放在请求内部(httpBody)
    //设置请求
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    request.timeoutInterval = 10;
    request.HTTPMethod = @"POST";
    request.URL = [NSURL URLWithString:@"https://api.cn.ronghub.com/chatroom/user/gag/add.json"];
    
    NSString * appkey = RC_APPKEY;
    NSString * nonce = [NSString stringWithFormat:@"%zd",arc4random() % 10000];
//    NSString * timestamp = [[NSString alloc] initWithFormat:@"%ld",(NSInteger)[NSDate timeIntervalSinceReferenceDate]];
    //时区(中国时区  东八区:东八区（UTC/GMT+08:00）是比格林威治时间GMT快8小时的时区)
    NSTimeZone *zone = [NSTimeZone localTimeZone];

    //当前时区和格林尼治时区的时间差 8小时 = 28800s
    
    //格林尼治时间到现在的秒数[[NSDate date] timeIntervalSince1970]
    NSString *sumString = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    //截取小数点前的数
    NSString *dateString = [[sumString componentsSeparatedByString:@"."]objectAtIndex:0];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateString intValue]];
    //格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //时区
    [dateFormatter setTimeZone:zone];
    [dateFormatter setDateFormat:@"YYYY:MM:dd-HH:mm:ss"];//格式  YYYY:MM:dd-HH:mm:ss
    
    NSString *timestamp = [dateFormatter stringFromDate:date];
//    //配置http header
//    [request setValue:appkey forHTTPHeaderField:@"RC-App-Key"];
//    [request setValue:nonce forHTTPHeaderField:@"RC-Nonce"];
//    [request setValue:timestamp forHTTPHeaderField:@"RC-Timestamp"];
//    
////    [request setValue:@"25UGZKq2zjE55t" forHTTPHeaderField:@"appSecret"];
//
//    //生成hashcode 用以验证签名
//    [request setValue:[self sha1:[NSString stringWithFormat:@"25UGZKq2zjE55t%@%@",nonce,timestamp]] forHTTPHeaderField:@"RC-Signature"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *headDic = [NSMutableDictionary dictionary];
    [headDic setObject:appkey forKey:@"RC-App-Key"];
    [headDic setObject:nonce forKey:@"RC-Nonce"];
    [headDic setObject:timestamp forKey:@"RC-Timestamp"];
    [headDic setObject:[self sha1:[NSString stringWithFormat:@"25UGZKq2zjE55t%@%@",nonce,timestamp]] forKey:@"RC-Signature"];

    NSMutableDictionary * paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:self.personDataView.minePersonModel.userId forKey:@"userId"];
    [paramDic setObject:self.targetId forKey:@"chatroomId"];
    [paramDic setObject:@"43200" forKey:@"minute"];
    
//    request.HTTPBody = [self httpBodyFromParamDictionary:paramDic];
//    [NSURLConnection connectionWithRequest:request delegate:self];
//    
//    NSData *retData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSLog(@"datadata%@", retData);
//    NSString *ret = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:retData options:NSJSONReadingMutableLeaves error:nil];
//    
//     NSLog(@"%@",ret);
    [ZYZCHTTPTool addHeadPostHttpDataWithEncrypt:YES andURL:@"https://api.cn.ronghub.com/chatroom/user/gag/add.json" andHeadDictionary:headDic andParameters:paramDic andSuccessGetBlock:^(id result, BOOL isSuccess) {
        NSLog(@"isSuccessisSuccess");
    } andFailBlock:^(id failResult) {
        NSLog(@"failResultfailResult");
    }];
}

- (NSData *)httpBodyFromParamDictionary:(NSDictionary *)param
{
    NSMutableString * data = [NSMutableString string];
    for (NSString * key in param.allKeys) {
        [data appendFormat:@"%@=%@&",key,param[key]];
    }
    return [[data substringToIndex:data.length-1] dataUsingEncoding:NSUTF8StringEncoding];
}
- (NSString*)sha1:(NSString *)hashString
{
    const char *cstr = [hashString cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:hashString.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}



- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response{
#pragma unused(theConnection)
    NSHTTPURLResponse * httpResponse;
    NSString *          contentTypeHeader;
    httpResponse = (NSHTTPURLResponse *) response;
    // 返回的元数据类型
    NSString *returnMIMEType= [httpResponse MIMEType];
    // 请求的URL地址
    NSURL *returnURL= [httpResponse URL];
    // 要返回的数据长度（指总共长度）
    long long returnContentLength= [httpResponse expectedContentLength];
    // 状态代码，一般根据状态代码。返回来的数据是否正常。
    NSInteger returnInteger= [httpResponse statusCode];
    // 编码名称-字符串表示；如果元数据不提供，则返回nil
    NSString *returnEncodingName=[httpResponse textEncodingName];
    // 文件名称
    NSString *returnFilename=[httpResponse suggestedFilename];
    // 返回的头文件信息
    NSDictionary *returnHeaderFields= [httpResponse allHeaderFields];
    
}



- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error{
    // 当请求失败时的相关操作；
    NSLog(@"errorerror%@", error);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"data%@", data);
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"dicdic%@", dic);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection%@", connection);

}


//#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ([touch.view.superview isKindOfClass:[UIButton class]])
//    {
//        return NO;
//    }
//    return YES;
//}


@end
