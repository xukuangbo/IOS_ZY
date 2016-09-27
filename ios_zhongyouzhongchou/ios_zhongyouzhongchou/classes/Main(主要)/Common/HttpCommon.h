//
//  HttpCommon.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#ifndef HttpCommon_h
#define HttpCommon_h


#pragma mark --- 基础网络接口
//正式
//#define BASE_URL @"http://www.sosona.com:8080/"
//测试
#define BASE_URL @"http://121.40.225.119:8080/"
//华子
//#define BASE_URL @"http://192.168.1.111:8086/"
//海外服务器
//#define BASE_URL @"http://47.88.148.201:8080/"
//#define BASE_URL @"http://192.168.1.59:8086/"

#define HTTPURL(APPEND_URL) [NSString stringWithFormat:@"%@%@.action?",BASE_URL,APPEND_URL]


#pragma mark --- 项目网络接口

#define GetNewVersion [NSString stringWithFormat:@"%@register/getAppVersion.action",BASE_URL]
//获取个人主页信息
#define GETUSERDETAIL      HTTPURL(@"u/getUserDetail")
//获取我关注的人
#define Get_UserFollowed_List(userId)  [NSString stringWithFormat:@"%@friends/listUserFollowed.action?userId=%@",BASE_URL,userId]
//获取个人信息（需带userId）
#define Get_SelfInfo(selfUserId,userId)  [NSString stringWithFormat:@"%@u/getUserDetail.action?selfUserId=%@&userId=%@",BASE_URL,selfUserId,userId]
//获取个人信息（带地址）
#define Get_UserInfo_AddressInfo(userId) [NSString stringWithFormat:@"%@register/getUserInfo.action?userId=%@",BASE_URL,userId]
//获取label信息
#define LISTLABLE          HTTPURL(@"user/listLabel")

//关注个人
#define FOLLOWUSER         HTTPURL(@"friends/followUser")
//取消关注个人
#define UNFOLLOWUSER       HTTPURL(@"friends/unfollowUser")
//收藏众筹
#define FOLLOWPRODUCT      HTTPURL(@"friends/followProduct")
//取消收藏
#define UNFOLLOWPRODUCT    HTTPURL(@"friends/unfollowProduct")
//获取用户信息
#define GETUSERINFO        HTTPURL(@"register/getUserInfo")
//注册微信用户信息
#define REGISTERWEICHAT    HTTPURL(@"register/saveWeixinInfo")
//注册个人信息（总）
#define Regist_UpdateUserInfo [NSString stringWithFormat:@"%@register/updateUserInfo.action",BASE_URL]
//收货地址
#define Regist_SaveContactInfo [NSString stringWithFormat:@"%@register/saveDeliveryAddress.action",BASE_URL]
//获取可提现总额
#define Get_MyTXTotles(userId) [NSString stringWithFormat:@"%@list/listMyTxProductsTotles.action?userId=%@",BASE_URL,userId]

//用户基本信息
#define BASEINFO           HTTPURL(@"register/saveBaseInfo")
//实名认证
#define AUTHINFO           HTTPURL(@"register/saveAuthInfo")
//联系信息
#define CONTACTINFO        HTTPURL(@"register/saveContactInfo")
//职业信息
#define CAREERINFO         HTTPURL(@"register/saveCareerInfo")
//教育信息
#define EDUINFO            HTTPURL(@"register/saveEduInfo")
//兴趣标签
#define TAGINFO            HTTPURL(@"register/saveTagInfo")
//收货地址
#define DELIVERYADDRESS    HTTPURL(@"register/saveDeliveryAddress")
//发布众筹
#define ADDPRODUCT         HTTPURL(@"product/addProduct")
//编辑众筹
#define UPDATEPRODUCT      HTTPURL(@"product/updateproduct")
//获取众筹内容
#define GETPRODUCTDETAIL   HTTPURL(@"productInfo/getProductDetail")
//评论
#define COMMENT_PRODUCT    HTTPURL(@"comment/addZhongchouComment")
//获取评论列表
#define GET_COMMENT        HTTPURL(@"comment/listZhongchouComment")
//获取我的钱包
#define GET_MYWALLET       HTTPURL(@"wallet/getMyWallet")

//获取prepay_id
#define GET_ORDER          HTTPURL(@"weixinpay/generateAppOrder")

//获取所有众筹列表
//#define LISTALLPRODUCTS    HTTPURL(@"list/listAllProducts")
#define LISTALLPRODUCTS    HTTPURL(@"list/listAllProductsApp")
//获取我的众筹列表
#define LISTMYPRODUCTS     HTTPURL(@"list/listMyProducts")
//获取国家列表
#define LISTCOUNTRY        HTTPURL(@"user/listCountry")
//获取国家-省份-城市信息
#define GETVIEWSPOT        HTTPURL(@"viewSpot/getAllViews")
//获取我的行程安排时间表
#define GET_MY_OCCUPY_TIME HTTPURL(@"list/listMyProductsTime")
//获取单个景点的详细数据
#define GET_VIEWSPOT       HTTPURL(@"viewSpot/getViewSpot")
//获取景点视屏
#define GET_SPOT_VIDEO     HTTPURL(@"viewSpot/getViewSpotVideo")

//获取攻略首页数据
#define GET_TACTIC         [NSString stringWithFormat:@"%@viewSpot/getIndexHot.action",BASE_URL]
//获取单个景点的数据，一般，国家，城市
#define GET_TACTIC_VIEW(viewID) [NSString stringWithFormat:@"%@viewSpot/getViewSpot.action?viewId=%zd",BASE_URL,viewID]
//获取更多景点
#define GET_TACTIC_More_Cities [NSString stringWithFormat:@"%@admin_back/getViewList.action?viewType=2",BASE_URL]
//获取更多国家
#define GET_TACTIC_More_Countries [NSString stringWithFormat:@"%@admin_back/getViewList.action?viewType=1",BASE_URL]
//获取更多视频
#define GET_TACTIC_More_Videos [NSString stringWithFormat:@"%@admin_back/getViewVideoList.action?viewType=2",BASE_URL]

//获取主页视频（原来直播的内容）
#define GET_Tab_Videos [NSString stringWithFormat:@"%@admin_back/getViewVideoList2.action?viewType=2",BASE_URL]
//添加想去的目的地
#define Add_Tactic_WantGo(userId,viewId) [NSString stringWithFormat:@"%@viewSpot/addMySpot.action?userId=%@&viewId=%zd",BASE_URL,userId,viewId]
//删除想去的目的地
#define Del_Tactic__WantGo(userId,viewId) [NSString stringWithFormat:@"%@viewSpot/delMySpot.action?userId=%@&viewId=%zd",BASE_URL,userId,viewId]
//获取想去的目的地列表
#define Get_Tactic_List_WantGo(userId) [NSString stringWithFormat:@"%@viewSpot/getMySpots.action?userId=%@",BASE_URL,userId]
//获取目的地关注状态
#define Get_Tactic_Status_WantGo(userId,viewId) [NSString stringWithFormat:@"%@viewSpot/checkMySpotStatus.action?userId=%@&viewId=%zd",BASE_URL,userId,viewId]
//获取旅行标签列表
#define Get_TravelTag_List(tag) [NSString stringWithFormat:@"%@user/listLabel.action?tag=%zd",BASE_URL,tag]
//提交旅行标签
#define Post_TravelTag [NSString stringWithFormat:@"%@register/saveTagInfo.action",BASE_URL]

//通过userid获取用户基本信息
#define GET_USERINFO_BYUSERID    HTTPURL(@"u/getUserById")

//通过openid获取用户基本信息(改成userId了)
#define GET_USERINFO_BYOPENID(userId)  [NSString stringWithFormat:@"%@u/getUserByOpenId.action?userId=%@",BASE_URL,userId]

//获取聊天的token(正式)
//#define GET_CHAT_TOKEN(userId,name,headImg)   [NSString stringWithFormat:@"%@rongAPI/getToken.action?userId=%@&userName=%@&portraitUri=%@",BASE_URL,userId,name,headImg]

//获取聊天的token(测试)
#define GET_CHAT_TOKEN(userId,name,headImg)   [NSString stringWithFormat:@"%@rongAPI/getTokenTest.action?userId=%@&userName=%@&portraitUri=%@",BASE_URL,userId,name,headImg]

//生成微信支付订单
#define  GET_WX_ORDER          [NSString stringWithFormat:@"%@weixinpay/generateAppOrder.action",BASE_URL]

//获取微信token
#define  GET_WX_TOKEN(code)    [NSString stringWithFormat:@"%@wxAPI/getToken.action?code=%@",BASE_URL,code]

//删除众筹项目
#define  DELETE_PRODUCT       [NSString stringWithFormat:@"%@product/deleteProduct.action",BASE_URL]

//编辑项目
#define  UPDATA_PRODUCT       [NSString stringWithFormat:@"%@product/updateproduct.action",BASE_URL]

//判断项目时间是否有冲突
#define JUDGE_MY_PRODUCT_TIME(userId,startTime,endTime)  [NSString stringWithFormat:@"%@list/checkMyProductsTime.action?userId=%@&startTime=%@&endTime=%@",BASE_URL,userId,startTime,endTime]

//判断项目时间是否有冲突2
#define JUDGE_TIME_CONFLICT(userId,productId)  [NSString stringWithFormat:@"%@list/checkMyProductsTime.action?userId=%@&productId=%@",BASE_URL,userId,productId]

//获取已报名参加一起游的信息
#define TOGTHER_INFO(userId,productId)  [NSString stringWithFormat:@"%@productInfo/getStyle4Users.action?userId=%@&productId=%@",BASE_URL,userId,productId]

//加入一起游意向列表
#define ADD_TOGETHER_PARTNER(userId,productId,userIds)   [NSString stringWithFormat:@"%@productInfo/savaProductUserStatus.action?userId=%@&productId=%@&userIds=%@",BASE_URL,userId,productId,userIds]

//获取一起游意向列表/回报的人列表
#define GET_SELECTED_TOGETHER_PARTNERS(userId,productId,type)[NSString stringWithFormat:@"%@productInfo/getProductUserStatusList.action?userId=%@&productId=%@&type=%ld",BASE_URL,userId,productId,type]

//删除意向列表中的报名人
#define DELETE_TOGETHER_PARTNER(selfUserId,productId,userId)  [NSString stringWithFormat:@"%@productInfo/delProductUserStatus.action?selfUserId=%@&productId=%@&userId=%@",BASE_URL,selfUserId,productId,userId]

//发起邀约
#define SEND_INVITAION(selfUserId,productId,userId)  [NSString stringWithFormat:@"%@productInfo/sendInvitation.action?selfUserId=%@&productId=%@&userId=%@",BASE_URL,selfUserId,productId,userId]

//点击回报
#define SEND_BACKPAY(selfUserId,productId,userId) [NSString stringWithFormat:@"%@productInfo/sendBackpay.action?selfUserId=%@&productId=%@&userId=%@",BASE_URL,selfUserId,productId,userId]

//接受邀请(参与人操作)
#define ACCEPT_INVITATION(productId,userId)  [NSString stringWithFormat:@"%@productInfo/acceptInvitation.action?productId=%@&userId=%@",BASE_URL,productId,userId]

//确认收货
#define ACCEPT_RETURN(productId,userId)   [NSString stringWithFormat:@"%@productInfo/acceptBackpay.action?productId=%@&userId=%@",BASE_URL,productId,userId]

//删除我报名的项目
#define  DELETE_MYJOIN_PRODUCT(productId,userId)  [NSString stringWithFormat:@"%@productInfo/delMyStyle4.action?productId=%@&userId=%@",BASE_URL,productId,userId]

//评价我参与行程的发起人
#define  COMMENT_MYJOIN_PRODUCT   [NSString stringWithFormat:@"%@productInfo/savaProductComment11.action",BASE_URL]

//评价回报我的人
#define  COMMENT_MYRETURN_PRODUCT  [NSString stringWithFormat:@"%@productInfo/savaProductComment12.action",BASE_URL]

//评价参与我一起游的人
#define  COMMENT_TOGETHER   [NSString stringWithFormat:@"%@productInfo/savaProductComment21.action",BASE_URL]

//评价我回报的人
#define  COMMENT_RETURN   [NSString stringWithFormat:@"%@productInfo/savaProductComment22.action",BASE_URL]

//上传凭证
#define Upload_Voucher [NSString stringWithFormat:@"%@productInfo/productVoucher.action",BASE_URL]

//获取我一起游的人或回报的人（评价用）
#define GET_MY_COMMENTER(userId,productId,type)  [NSString stringWithFormat:@"%@productInfo/getCanCommonUserStatusList.action?userId=%@&productId=%@&type=%ld",BASE_URL,userId,productId,type]
//投诉
#define COMPLAIN  [NSString stringWithFormat:@"%@productInfo/productComplaint.action",BASE_URL]

//判断某项目是否有支持的记录
#define GET_MY_STYLEPAY_STATUS(userId,productId)  [NSString stringWithFormat:@"%@productInfo/getMyStylePayStatus.action?userId=%@&productId=%@",BASE_URL,userId,productId]

//判断是否支付成功
#define GET_ORDERPAY_STATUS(userId,outTradeNo)   [NSString stringWithFormat:@"%@productInfo/getOrderPayStatus.action?userId=%@&outTradeNo=%@",BASE_URL,userId,outTradeNo]

//攻略目的地详情添加众筹项目详情
#define Get_Dest_ZhongChou_List(pageNo,dest) [NSString stringWithFormat:@"%@list/listAllProducts.action?cache=false&orderType=4&pageNo=%ld&status_not=0,2&pageSize=10&dest=%@",BASE_URL,pageNo,dest]
//国家级目的地详情添加众筹项目详情
#define Get_Country_ZhongChou_List(pageNo,countryName) [NSString stringWithFormat:@"%@list/listAllProducts.action?cache=false&orderType=4&pageNo=%d&&status_not=0,2&pageSize=10&countryName=%@",BASE_URL,pageNo,countryName]
//发众筹时判断用户信息是否完善
#define CHECK_USERINFO [NSString stringWithFormat:@"%@register/checkUserInfoIntegrality.action",BASE_URL]

//获取我的提现众筹列表
#define Get_MyTxProducts_List [NSString stringWithFormat:@"%@list/listMyTxProducts.action",BASE_URL]

//判断是否发布过众筹
#define Get_Judge_HadFZC(userId) [NSString stringWithFormat:@"%@productInfo/checkMyProduct.action?userId=%@",BASE_URL,userId]

//获取该众筹金额明细
#define Get_RecordDetail(userId,productId,pageNo) [NSString stringWithFormat:@"%@list/recordDetail.action?userId=%@&productId=%@&pageNo=%zd&pageSize=10",BASE_URL,userId,productId,pageNo]

//提交建议
#define Post_Jianyi [NSString stringWithFormat:@"%@register/saveAdvice.action",BASE_URL]

//获取协议，（待废除）
//#define Get_Xieyi [NSString stringWithFormat:@"%@register/getXieyi.action",BASE_URL]
//获取协议
#define Get_Xieyi [NSString stringWithFormat:@"%@xieyi.jsp",BASE_URL]

//获取隐私政策
#define Get_Yinsi_ZhengChe [NSString stringWithFormat:@"%@privacy_statement.jsp",BASE_URL]

//获取关于我们
#define Get_About_Us [NSString stringWithFormat:@"%@about_us.jsp",BASE_URL]

//获取投诉建议
#define Get_Tousu [NSString stringWithFormat:@"%@complaint_notes.jsp",BASE_URL]



//获取拉黑名单列表的个人数据
#define Get_LaHei_List_Info(userIds) [NSString stringWithFormat:@"%@u/getUserBaseInfo.action?userIds=%@",BASE_URL,userIds]

//传入用户id,获取用户列表
#define Get_UserInfo_List(userIds) [NSString stringWithFormat:@"%@u/getUserBaseInfo.action?userIds=%@",BASE_URL,userIds]

//未读消息数
#define Post_UnRead_Msg  [NSString stringWithFormat:@"%@systemMsg/unReadTotles.action",BASE_URL]

//通知列表
#define Post_List_Msg    [NSString stringWithFormat:@"%@systemMsg/getMsgList.action",BASE_URL]

//删除通知
#define Post_Delete_Msg  [NSString stringWithFormat:@"%@systemMsg/deleteMsg.action",BASE_URL]

//通知详情
#define Post_Detail_Msg  [NSString stringWithFormat:@"%@systemMsg/viewMsg.action",BASE_URL]

//获取网络图片库
#define Post_GetNetImg [NSString stringWithFormat:@"%@admin/viewSpotManage/getViewSpotImages.action",BASE_URL]


//获取在线直播列表
#define Post_Live_List [NSString stringWithFormat:@"%@zhibo/onlineList.action",BASE_URL]

//创建直播
#define Post_Create_Live [NSString stringWithFormat:@"%@zhibo/creatZhibo.action",BASE_URL]
// 点赞
#define Post_Clap_Live [NSString stringWithFormat:@"%@zhibo/zanZhibo.action",BASE_URL]
// 直播打赏
#define Post_Flower_Live [NSString stringWithFormat:@"%@weixinpay/zhiboAppOrder.action",BASE_URL]
//直播总金额
#define Post_TotalMoney_Live [NSString stringWithFormat:@"%@zhibo/zhiboOrderTotle.action",BASE_URL]
//发足迹
#define Publish_Footprint [NSString stringWithFormat:@"%@youji/addYouji.action",BASE_URL]

//游记列表
#define List_Footprint [NSString stringWithFormat:@"%@youji/getPageList.action",BASE_URL]

//点赞
#define Footprint_AddSupport [NSString stringWithFormat:@"%@youji/addZan.action",BASE_URL]

//取消点赞
#define Footprint_DeleteSupport [NSString stringWithFormat:@"%@youji/delZan.action",BASE_URL]

//评论列表
#define Footprint_GetCommentList [NSString stringWithFormat:@"%@youji/getCommentPageList.action",BASE_URL]

//评论足迹
#define Footprint_AddComment [NSString stringWithFormat:@"%@youji/addComment.action",BASE_URL]

//删除足迹评论
#define Footprint_deleteComment  [NSString stringWithFormat:@"%@youji/delComment.action",BASE_URL]

//点赞详情
#define Footprint_GetZanList [NSString stringWithFormat:@"%@youji/getZanList.action",BASE_URL]

//删除足迹
#define Footprint_DeleteFootprint [NSString stringWithFormat:@"%@youji/deleteYouji.action",BASE_URL]


//判断直播是否打赏成功
#define GET_LIVE_PAY_STATUS   [NSString stringWithFormat:@"%@zhibo/getOrderPayStatus.action",BASE_URL]

// 设置消息已读 (参数ID)
#define SYSTEM_MSG_READ  [NSString stringWithFormat:@"%@systemMsg/msgSetRead.action",BASE_URL]
// 拉取直播内容 (参数 spaceName，streamName)
#define GET_LIVE_CONTENT   [NSString stringWithFormat:@"%@zhibo/getZHibo.action",BASE_URL]
// 获取最近的一次直播关联行程内容
#define Get_Live_FaqiXC   [NSString stringWithFormat:@"%@productInfo/getMyLastProduct.action",BASE_URL]

#endif /* HttpCommon_h */
