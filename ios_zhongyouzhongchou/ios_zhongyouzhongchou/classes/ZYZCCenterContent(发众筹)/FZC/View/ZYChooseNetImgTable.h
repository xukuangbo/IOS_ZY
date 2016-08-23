//
//  ZYChooseNetImgTable.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableView.h"
#import "ZYChooseNetImgCell.h"
typedef void (^ScrollUpBlock)(CGFloat contentY);
typedef void (^ScrollDownBlock)(CGFloat contentY);
typedef void (^ScrollEndBlock)(CGFloat contentY);
typedef void (^ChooseImgBlock)(ZYImageModel *imgMOdel);
@interface ZYChooseNetImgTable : ZYZCBaseTableView
@property (nonatomic, copy  ) ScrollUpBlock   scrollUpBlock;
@property (nonatomic, copy  ) ScrollDownBlock scrollDownBlock;
@property (nonatomic, copy  ) ScrollEndBlock scrollEndBlock;
@property (nonatomic, copy  ) ChooseImgBlock chooseImgBlock;
@end

