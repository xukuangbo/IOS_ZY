//
//  ZYOneFootprintView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFootprintListModel.h"

typedef void (^DeleteFootprint)(ZYFootprintListModel *oneFootprintModel);

typedef void (^SupportChangeBlock)(BOOL isAdd);

//点击评论按钮的不同操作
typedef NS_ENUM(NSInteger, CommentEnterType)
{
    enterCommentPage=1,
    enterCommentEdit
    
};

@interface ZYOneFootprintView : UIView

@property (nonatomic, strong) ZYFootprintListModel *footprintModel;
@property (nonatomic, assign) CommentEnterType     commentEnterType;
@property (nonatomic, assign) BOOL                 canOpenText;

@property (nonatomic, copy  ) DeleteFootprint     deleteFootprint;

@property (nonatomic, copy  ) SupportChangeBlock  supportChangeBlock;

@property (nonatomic, assign) NSInteger           commentNumber;//评论数
@property (nonatomic, assign) NSInteger           supportNumber;//点赞数

@end
