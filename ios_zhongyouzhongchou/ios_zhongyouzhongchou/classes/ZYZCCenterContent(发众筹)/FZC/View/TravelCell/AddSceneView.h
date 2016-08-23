//
//  AddSceneView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TEXTMAXHEIGHT  70

@interface AddSceneView : UIView<UITextViewDelegate>

@property (nonatomic, strong) UITextView     *textView;

@property (nonatomic, strong) UILabel        *placeholdLab;
/**
 *  添加景点按钮
 */
@property (nonatomic, strong) UIButton       *addBtn;
/**
 *  景点数量，最多为4
 */
@property (nonatomic, assign) NSInteger      siteNumber; 
/**
 *  景点视图数组
 */
@property (nonatomic, strong) NSMutableArray *siteArr;
/**
 *  景点标记数组
 */
@property (nonatomic, strong) NSMutableArray *siteTagArr;
/**
 *  景点，交通，住宿，餐饮的标记符
 */
@property (nonatomic, assign) NSInteger      index;


-(instancetype)initWithFrame:(CGRect)frame andIndex:(NSInteger )index;

@end
