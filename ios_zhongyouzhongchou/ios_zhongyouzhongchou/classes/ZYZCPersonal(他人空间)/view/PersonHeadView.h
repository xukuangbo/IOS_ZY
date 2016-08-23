//
//  PersonHeadView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/3.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define HEAD_VIEW_HEIGHT  234+80*KCOFFICIEMNT
#define MY_HEAD_VIEW_HEIGHT  154+80*KCOFFICIEMNT
//typedef void (^ScrollTable)(CGFloat offSetY);

typedef NS_ENUM(NSInteger, PersonProductType)
{
    PublishType=KPERSON_PRODUCT_TYPE,
    JoinType,
    RecommendType
};

typedef NS_ENUM(NSInteger, TouchPersonType)
{
    AddInterest=KTOUCH_PERSON_TYPE,
    ChatType
};

typedef void (^ChangeProduct)(PersonProductType productType) ;

#import <UIKit/UIKit.h>
#import "UserModel.h"
@interface PersonHeadView : UIView
@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, assign) BOOL      friendship;
@property (nonatomic, strong) NSNumber  *meGzAll;
@property (nonatomic, strong) NSNumber  *gzMeAll;
@property (nonatomic, assign) CGFloat   tableOffSetY;
@property (nonatomic, strong) UIColor   *blurColor;

@property (nonatomic, assign) BOOL      isMineView;

@property (nonatomic, assign) BOOL      hiddenLoginBtn;
//改变众筹项目类型
@property (nonatomic, copy  ) ChangeProduct changeProduct;

- (instancetype)initWithType:(BOOL)isMineView;



/**
 *  清除数据
 */
-(void)cleanUI;

@end
