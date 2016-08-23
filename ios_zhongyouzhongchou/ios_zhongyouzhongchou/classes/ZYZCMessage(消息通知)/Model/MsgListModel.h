//
//  MsgListModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  MsgDataModel;

@interface MsgDataModel : NSObject

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy  ) NSString *errorMsg;

@end

@interface MsgListModel : NSObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSNumber  *userId;
@property (nonatomic, strong) NSNumber  *productId;
@property (nonatomic, assign) NSInteger msgType;//消息属性：1:群发消息；2定向消息
@property (nonatomic, copy  ) NSString  *icon;
@property (nonatomic, copy  ) NSString  *title;
@property (nonatomic, copy  ) NSString  *subtitle;
@property (nonatomic, copy  ) NSString  *msgtime;
@property (nonatomic, assign) NSInteger msgStyle;//消息类型 :1:我发起，2我参与，3、我回报
@property (nonatomic, assign) BOOL     readstatus;//是否已读
@property (nonatomic, copy  ) NSString *sendto;//通知到：app，wechar，mobile（暂不处理，预留字段）
@property (nonatomic, strong) NSString *sound; //声音（暂不处理，预留字段）
@property (nonatomic, strong) NSString *extra; //消息扩展（暂不处理，预留字段）
@property (nonatomic, strong) NSString *readtime;//阅读时间

@end
