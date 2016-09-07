//
//  ZYDetailMsgScrollView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgDetailModel.h"
typedef NS_ENUM(NSInteger, DetailMsgType)
{
    MyProductMsg=1,
    MyJoinProductMsg,
    MyReturnProductMsg
};

@interface ZYDetailMsgScrollView : UIScrollView

@property (nonatomic, assign) DetailMsgType detailMsgType;

- (instancetype)initWithFrame:(CGRect)frame andDetailMsg:(MsgDetailModel *)msgDetailModel ;

@end
