//
//  ChatUserModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatUserModel : NSObject

@property (nonatomic, copy  ) NSString *userId;
@property (nonatomic, copy  ) NSString *name;
@property (nonatomic, copy  ) NSString *portraitUri;
@property (nonatomic, copy  ) NSString *token;

@end
