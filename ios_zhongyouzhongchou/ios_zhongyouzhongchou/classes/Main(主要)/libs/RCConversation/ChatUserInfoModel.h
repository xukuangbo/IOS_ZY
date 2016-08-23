//
//  ChatUserInfoModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatUserInfoModel : NSObject
/**
 *  远程推送显示的内容。自带的消息会有默认显示，如果您使用的是自定义消息，需要在发送时设置。对应于 iOS 发送消息接口中的 pushContent。
 */
@property (nonatomic, copy  ) NSString *body;
/**
 *  会话类型。PR 指单聊、 DS 指讨论组、 GRP 指群组、 CS 指客服、SYS 指系统会话、 MC 指应用内公众服务、 MP 指跨应用公众服务。
 */
@property (nonatomic, copy  ) NSString *cType;
/**
 *  消息发送者的用户 ID。
 */
@property (nonatomic, copy  ) NSString *fId;
/**
 *
 */
@property (nonatomic, copy  ) NSString *mId;
/**
 *  消息类型，参考融云消息类型表.消息标志；可自定义消息类型。
 */
@property (nonatomic, copy  ) NSString *oName;
/**
 *  Target ID。
 */
@property (nonatomic, copy  ) NSString *tId;

/**
 *  远程推送的附加信息，对应于 iOS 发送消息接口中的 ushData。

 */
@property (nonatomic, copy  ) NSString *appData;

@end
