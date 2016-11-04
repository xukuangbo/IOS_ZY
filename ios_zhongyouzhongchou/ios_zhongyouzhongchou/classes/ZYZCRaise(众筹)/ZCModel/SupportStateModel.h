//
//  SupportStyleModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/11/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupportStateModel : NSObject
@property (nonatomic, assign) BOOL     isMyself; //是否是用户自己
@property (nonatomic, assign) BOOL     productEnd;//项目是否截止
@property (nonatomic, assign) BOOL     canChoose;//是否可选
@property (nonatomic, assign) BOOL     isChoose; //是否被选择
@property (nonatomic, assign) BOOL     isOpenMoreDec; //描述文字是否展开
@property (nonatomic, assign) BOOL     isGetMax; //是否达到上限
@end
