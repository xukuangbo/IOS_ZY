//
//  MsgDetailModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/5.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MsgStepModel;

@interface MsgDetailModel : NSObject

@property (nonatomic, copy  ) NSArray  *steps;        //步骤
@property (nonatomic, copy  ) NSString *stepoption;   //下一步提示蚊子

@end

//userId	 用户
//productId	 众筹id
//step	  步骤
//light	 点亮？ 1是0否
//node	  节点
//subnode  子节点
//nodetime  节点时间
//type  类型1发起人 2一起游 3回报
@interface MsgStepModel : NSObject

@property (nonatomic, copy  ) NSString   *userId;
@property (nonatomic, strong) NSNumber   *productId;
@property (nonatomic, assign) NSInteger  step;
@property (nonatomic, assign) BOOL       light;
@property (nonatomic, copy  ) NSString   *node;
@property (nonatomic, copy  ) NSString   *subnode;
@property (nonatomic, copy  ) NSString   *nodetime;
@property (nonatomic, assign) NSInteger  type;

@end
