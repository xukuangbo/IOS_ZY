//
//  DefineCommon.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#ifndef DefineCommon_h
#define DefineCommon_h

/*
 XCode LLVM XXX - Preprocessing中Debug会添加 DEBUG=1 标志
 */
#ifdef DEBUG
#define ZYLog(xx, ...)  NSLog(@"行号:%d 时间:%s 文件名:%s\t方法名:%s\n%s(%d):\n",  __LINE__,__TIME__,[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__func__, [[NSString stringWithFormat:xx, ##__VA_ARGS__] UTF8String])
#define DDLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

//融云appKey（测试）
#define RC_APPKEY @"lmxuhwagxqfzd"
//趣拍（测试）
#define  kQPZhouYouLiveHttpHost  @"http://zhongyoutest01.s.qupai.me"
#define  kQPAppKey     @"20be31eb2ca1669"
#define  kQPAppSecret  @"ae7f1c0525644c7a85b7f9a844cfc0e7"

#else
#define ZYLog(FORMAT, ...) nil
#define DDLog(xx, ...) nil

//融云appKey（正式）
#define RC_APPKEY @"z3v5yqkbvp960"
// bugTags appKey
//趣拍（正式）
#define  kQPZhouYouLiveHttpHost  @"http://zhongyoulive.s.qupai.me"
#define  kQPAppKey     @"20a9a463ed1796c"
#define  kQPAppSecret  @"b39015e4f733445290c63b4de7b603cd"

#endif

#define kBugTagsAppKey @"d84d834d54831f523e30df3a7d050e21"
#define ZYString(name) [NSString stringWithFormat:@"%@",name]
#define ZYFloatString(name) [NSString stringWithFormat:@"%d",name]
#define ZYNumberString(name) [NSString stringWithFormat:@"%f",name]
#define ZYNSNotificationCenter [NSNotificationCenter defaultCenter]

//在documents中创建保存发众筹资源的文件
#define KMY_ZHONGCHOU_FILE  @"zcDraft"
//在documents中创建保存上传凭证文件
#define KVoucher_File_Path  @"VoucherResoure"
//用户头像名
#define KUSER_ICON  [NSString stringWithFormat:@"icon/%@.png",[ZYZCTool getTimeStamp]]

//本地凭证图片路径
#define KVoucher_ImageFile_Path(fileName) [NSString stringWithFormat:@"%@/VoucherResoure/png%02d.png",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0],fileName]
//发众筹资源文件路径
#define KMY_ZC_FILE_PATH(fileName) [NSString stringWithFormat:@"%@/zcDraft/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0],fileName]

//发众筹的oss文件连接
#define KHTTP_FILE_HEAD    @"http://zyzc-bucket01.oss-cn-hangzhou.aliyuncs.com"
//上传凭证的oss文件连接
#define KHTTP_VOUCHER_HEAD @"http://zyzc-voucher.oss-cn-hangzhou.aliyuncs.com"






//屏幕宽
#define KSCREEN_W [UIScreen mainScreen].bounds.size.width
//屏幕高
#define KSCREEN_H [UIScreen mainScreen].bounds.size.height

// globalization
#define ZYLocalizedString(x)   NSLocalizedString(x, nil)

//比例系数
#define KCOFFICIEMNT  (KSCREEN_W/320)

#define KTextMargin 5

//工具栏高度
#define KTABBAR_HEIGHT 49
//导航栏高度
#define KNAV_HEIGHT 64
#define KStatus_Height 20
//状态栏＋导航栏高度
#define KNAV_STATUS_HEIGHT 64
//展示16:10图片的高度
#define kHeadImageHeight (KSCREEN_W / 16.0 * 10)
//3,6,9标题的底部
#define kTacticTitleBottom 48
//3,6,9个view的高度
#define kTacticViewMapHeight(maxCount) (((KSCREEN_W - KEDGE_DISTANCE * 6) / 3.0 + KEDGE_DISTANCE) * (maxCount / 3) + kTacticTitleBottom)
//3,6,9个每个小view的高度
#define kTacticViewHeight ((KSCREEN_W - KEDGE_DISTANCE * 6) / 3.0)




#pragma mark --- 颜色
//导航栏颜色
#define kHome_navi_bgcolor(alpha) [[UIColor ZYZC_NavColor] colorWithAlphaComponent:alpha]
//RGBA
#define KCOLOR_RGBA(R,G,B,A)	[UIColor colorWithRed:(CGFloat)R/255.0 green:(CGFloat)G/255.0 blue:(CGFloat)B/255.0 alpha:A]
//RGB
#define KCOLOR_RGB(R,G,B)	[UIColor colorWithRed:(CGFloat)R/255.0 green:(CGFloat)G/255.0 blue:(CGFloat)B/255.0 alpha:1.0]

//边距设定
#define KEDGE_DISTANCE 10
//设置圆角弧度
#define KCORNERRADIUS  5

//tag值使用
#define KZYZC_CENTERCONTENT_BTN_TAG 20//tag取值范围20～25
#define KFZC_PERSON_BTN_TAG         30//tag取值范围30～36
#define KFZC_SAVE_TYPE              40//tag取值范围40～42
#define KFZC_MOREFZCTABLEVIEW_TYPE  50//tag取值范围50～53
#define KFZC_COURSE_TYPE            60//tag取值范围60～63
#define KFZC_CONTENTCOURSE_TYPE     70//tag取值范围70～72
#define KFZC_MOVIERECORDSAVE_TAG    80
#define KZC_DETAIL_BOTTOM_TYPE      90//tag取值范围90～92
#define KMineHeadViewChangeType     100//tag取值范围100～101
#define KZCDETAIL_CONTENTTYPE       110//tag取值范围110～102
#define KFZC_INPUTCONTENT_TYPE      120//tag取值范围120～122
#define KFZC_INPUTCONTENTVIEW_TYPE  130//tag取值范围130～132
#define KSUPPORTMONEY_TYPE          140//tag取值范围140～142
#define KPERSON_PRODUCT_TYPE        150//tag取值范围150～152
#define KTOUCH_PERSON_TYPE          160//tag取值范围160～161

#define KWebImage(urlImage) [[NSString stringWithFormat:@"http://zhongyou-hz.oss-cn-hangzhou.aliyuncs.com/%@",[urlImage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] //网络访问阿里云的图片

//NSUserDefaults-key使用
#define KMOREFZC_RETURN_SUPPORTTYPE  @"return_supportType"
//存储app的版本号
#define KAPP_VERSION                 @"version"
//记录当地城市
#define KMY_LOCALTION                @"myLocation"
//记录我的草稿的状态，@“yes”为保
#define KMY_ZC_DRAFT_SAVE            @"myDraftSave"
//记录地名库有没有存储下来@“yes”为保存
#define KVIEWSPOT_SAVE               @"viewSportSave"
//记录上传资源到oss时失败没，有，删除文件
#define KFAIL_UPLOAD_OSS             @"failUpload"
//存储用户聊天凭证
#define KCHAT_TOKEN                  @"chatToken"
//是否第一次上传行程
#define KFIRST_PUBLISH               @"firstPublish"
//是否开启声音提醒
#define KOPEN_SOUND_ALERT            @"openSoundAlert"
//是否开启震动提醒
#define KOPEN_SHAKE_ALERT            @"openShakeAlert"
//是否同意创建直播协议
#define CREATE_LIVE_AGREEMENT        @"createLiveAgreement"
//发布足迹成功
#define PUBLISH_FOOTPRINT_SUCCESS    @"piblishFootprintSuccess"
//删除足迹成功
#define DELETE_ONE_FOOTPRINT_SUCCESS @"deleteOneFootprintSuccess"
//纪录趣拍是否鉴权成功
#define Auth_QuPai_Result            @"authQupaiResult"

//图片拉伸
#define KPULLIMG(IMGNAME,TOP,LEFT,BOTTOM,RIGHT) [[UIImage imageNamed:IMGNAME]resizableImageWithCapInsets:UIEdgeInsetsMake(TOP, LEFT, BOTTOM, RIGHT) resizingMode:UIImageResizingModeStretch]


//登陆授权
#define kWechatAuthScope @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
#define kWechatAuthOpenID  @"0c806938e2413ce73eef92cc3"
#define kWechatAuthState   @"xxx"

#define kAppOpenid              @"wx4f5dad0f41bb5a7d"//微信的
#define KORDER_PAY_NOTIFICATION @"orderPay"//支付发布广播名
#define KCAN_SUPPORT_MONEY      @"canSupportMoney"//支持时发布的广播
#define KSAVE_SPOT_FINISH       @"saveSpotsFinish"//存储地名库结束发布的广播

// make weak object
#define fzweak(x, weakX) try{}@finally{}; __weak __typeof(x) weakX = x;
#define WEAKSELF typeof(self) __weak weakSelf = self;

#define STRONGSELF typeof(self) __strong strongSelf = self;

#define STRONGSELFFor(object) typeof(object) __strong strongSelf = object;

//appStore下载路径
#define APP_STORE_URL           @"http://itunes.apple.com/cn/app/id1128709311?mt=8"

#define ZY_Live_Clap @"ZYSendMessageClapStatus"
#define ZY_Live_Join @"ZYSendMessageJoinRoomStatus"
/**
 *  通知的宏定义
 */
// 获取支付结果通知
#define kGetPayResultNotification @"kGetPayResultNotification"
#define kPaySucceed @"打赏成功"
//钱包预备金选择通知
#define WalletYbjSelectNotification @"WalletYbjSelectNotification"
#endif /* DefineCommon_h */
