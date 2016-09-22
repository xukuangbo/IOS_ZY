//
//  ZYOneFootprintView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFootprintListModel.h"

typedef NS_ENUM(NSInteger, CommentEnterType)
{
    enterCommentPage=1,
    enterCommentEdit
    
};

@interface ZYOneFootprintView : UIView

@property (nonatomic, strong) ZYFootprintListModel *footprintModel;
@property (nonatomic, assign) CommentEnterType     commentEnterType;
@property (nonatomic, assign) BOOL                 canOpenText;

@end
