//
//  ZYLiveListModel.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYLiveListModel : NSObject
//onLiveNum = 0,
//img = http://cc.cocimg.com/api/uploads/20150610/1433903549371622.jpg,
//id = 1,
//realName = 啦啦虫,
//faceImg = http://wx.qlogo.cn/mmopen/picy7icL23MertniaSO8qWf9LSqr18KGC3bIRVVzMgSfIoUHU3DfYl1Icrh744ovexKSkicjvEIGyM6puggmNKJPGKv3ecTOtNs6/0,
//spaceName = zhongyoulive,
//userName = 柳亮,
//ip = 127.0.0.1,
//streamName = zhongyoulive-1TRLK

/**封面 */
@property (nonatomic, copy) NSString *img;
/**状态 */
@property (nonatomic, copy) NSString *event;
/**头像 */
@property (nonatomic, copy) NSString *faceImg;
/**名字 */
@property (nonatomic, copy) NSString *realName;
/**标题 */
@property (nonatomic, copy) NSString *title;
/**人数 */
@property (nonatomic, assign) NSInteger onLiveNum;

@property (nonatomic, strong) NSNumber *userId;
/**直播用户的唯一标识 */
@property (nonatomic, copy) NSString *streamName;
/**直播的存储 */
@property (nonatomic, copy) NSString *spaceName;
/**拉流地址 */
@property (nonatomic, copy) NSString *pullUrl;
/** 直播列表 */
@property (nonatomic, copy) NSString *chatRoomId;
/** 性别 */
@property (nonatomic, copy) NSString *sex;

/** 关联行程的id */
@property (nonatomic, copy) NSString *productId;
/** 关联行程的标题 */
@property (nonatomic, copy) NSString *productTitle;
@end
