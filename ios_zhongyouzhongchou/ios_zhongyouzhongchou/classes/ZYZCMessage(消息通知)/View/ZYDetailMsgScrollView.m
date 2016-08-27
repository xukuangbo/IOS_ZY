//
//  ZYDetailMsgScrollView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define LINE_GREEN_COLOR [UIColor colorWithRed:117.0/255.0 green:245.0/255.0 blue:207.0/255.0 alpha:1.0]
#import "ZYDetailMsgScrollView.h"

@interface ZYDetailMsgScrollView ()

@property (nonatomic, assign) CGFloat oneLineHeight;

@property (nonatomic, assign) CGFloat sumHeight;

@end

@implementation ZYDetailMsgScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame andDetailMsg:(MsgDetailModel *)msgDetailModel 
{
    self = [super initWithFrame:frame];
    if (self) {
        _oneLineHeight=10;
        [self configUIWithDetailMsg:msgDetailModel];
    }
    return self;
}


-(void)configUIWithDetailMsg:(MsgDetailModel *)msgDetailModel
{
    UILabel *titleLab=[self createLabWithFrame:CGRectMake(20, KEDGE_DISTANCE, self.width-40, 20) andFont:[UIFont boldSystemFontOfSize:17] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    titleLab.text=@"行程进度";
    [self addSubview:titleLab];
    
     _sumHeight=titleLab.bottom+10+_oneLineHeight;
    
    
    for (int i=0; i<msgDetailModel.steps.count; i++) {
       [self addSubview: [self createOneLineViewWithTop:_sumHeight andStepModel:msgDetailModel.steps[i]]];
    }
    
    if (_sumHeight>self.height) {
        self.contentSize=CGSizeMake(0, _sumHeight+20);
    }
}



#pragma mark --- 某一步骤
-(UIView *)createOneLineViewWithTop:(CGFloat)top andStepModel:(MsgStepModel *)msgStepModel
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, top, self.width, 0)];
    
    CGFloat line_width=2;
    UIImageView *lineImg=[[UIImageView alloc]initWithFrame:CGRectMake(40-(line_width/2.0), -(1+_oneLineHeight), line_width,_oneLineHeight)];
    lineImg.backgroundColor=msgStepModel.light?LINE_GREEN_COLOR:[UIColor ZYZC_TextGrayColor02];
    [view addSubview:lineImg];
    
    CGFloat stepImg_width=15;
    UIImageView *stepImg=[[UIImageView alloc]initWithFrame:CGRectMake(40-(stepImg_width/2.0), 0, stepImg_width, stepImg_width)];
    stepImg.image=msgStepModel.light?[UIImage imageNamed:@"right-point-0"]:[UIImage imageNamed:@"gray-point"];
    [view addSubview:stepImg];
    
    UILabel *titleLab=[self createLabWithFrame:CGRectMake(stepImg.right+KEDGE_DISTANCE, 0, view.width-stepImg.right-100, 20) andFont:[UIFont systemFontOfSize:15] andTitleColor:msgStepModel.light?[UIColor ZYZC_TextBlackColor]:[UIColor ZYZC_TextGrayColor]];
    titleLab.text=msgStepModel.node;
    CGFloat nodeTextHeight=[ZYZCTool calculateStrLengthByText:msgStepModel.node andFont:titleLab.font andMaxWidth:titleLab.width].height;
    titleLab.height=MAX(nodeTextHeight,titleLab.height);
    [view addSubview:titleLab];
    
    UILabel *subtitleLab=[self createLabWithFrame:CGRectMake(titleLab.left, titleLab.bottom+5, view.width-stepImg.right-20, 20) andFont:[UIFont systemFontOfSize:13] andTitleColor:msgStepModel.light?[UIColor ZYZC_TextBlackColor]:[UIColor ZYZC_TextGrayColor]];
    subtitleLab.text=msgStepModel.subnode;
    CGFloat subNodeTextHeight=[ZYZCTool calculateStrLengthByText:msgStepModel.subnode andFont:subtitleLab.font andMaxWidth:subtitleLab.width].height;
    subtitleLab.height=MAX(subNodeTextHeight,subtitleLab.height);
    [view addSubview:subtitleLab];
    
    if (msgStepModel.nodetime&&![msgStepModel.nodetime isEqualToString:@"null"]) {
        UILabel *timeLab=[self createLabWithFrame:CGRectMake(view.width-90, titleLab.top, 80, 20) andFont:[UIFont systemFontOfSize:12] andTitleColor:[UIColor ZYZC_TextGrayColor]];
        timeLab.text=msgStepModel.nodetime.length>5?[msgStepModel.nodetime substringFromIndex:5]:msgStepModel.nodetime;
        
        timeLab.textAlignment=NSTextAlignmentRight;
        [view addSubview:timeLab];
    }
    
    view.height=subtitleLab.bottom+20;
    
    _oneLineHeight=view.height-stepImg_width-2;
    
    _sumHeight=view.bottom;
    
    return view;
}

#pragma mark --- 创建lab
-(UILabel *)createLabWithFrame:(CGRect )frame andFont:(UIFont *)font andTitleColor:(UIColor *)color
{
    UILabel *lab=[[UILabel alloc]initWithFrame:frame];
    lab.font=font;
    lab.textColor=color;
    lab.numberOfLines=0;
    return lab;
}


@end
