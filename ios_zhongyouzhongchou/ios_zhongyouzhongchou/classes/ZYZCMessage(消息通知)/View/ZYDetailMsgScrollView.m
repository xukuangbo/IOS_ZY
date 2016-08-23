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

@property (nonatomic, strong) MsgDetailModel *msgDetailModel;

@property (nonatomic, assign) NSInteger  msgStyle;

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) NSArray *subtitleArr;

@property (nonatomic, strong) NSMutableArray *timeArr;


@end

@implementation ZYDetailMsgScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame andDetailMsg:(MsgDetailModel *)msgDetailModel andMsgStyle:(DetailMsgType )msgStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        _oneLineHeight=10;
        _msgDetailModel=msgDetailModel;
        self.msgStyle=msgStyle;
        [self configUIWithDetailMsg:msgDetailModel andMsgStyle:msgStyle];
    }
    return self;
}


-(void)setMsgStyle:(NSInteger)msgStyle
{
    _msgStyle=msgStyle;
    
    switch (msgStyle) {
            //我发布
        case MyProductMsg:
            
            _titleArr=@[@"行程发布",@"众筹成功",@"选择旅伴",@"旅行出发",@"兑现回报，旅伴确认",@"上传凭证、申请提现",@"旅费提现成功"];
            
            _subtitleArr=@[@"发起众筹行程",@"众筹旅费达到或超过100％",@"从报名者中选择旅伴",@"与旅伴启程去旅游",@"上传旅行凭证，申请旅费提现",@"上传旅行凭证，申请旅费提现",@"24h之内转入您的微信账户"];
            
            
            _timeArr=[NSMutableArray array];
            _msgDetailModel.pfbTime?[_timeArr addObject:_msgDetailModel.pfbTime]:[_timeArr addObject:@""];
            _msgDetailModel.pzcSuccessTime?[_timeArr addObject:_msgDetailModel.pzcSuccessTime]:[_timeArr addObject:@""];
            _msgDetailModel.pSelLbtime?[_timeArr addObject:_msgDetailModel.pSelLbtime]:[_timeArr addObject:@""];
            _msgDetailModel.pOutTime?[_timeArr addObject:_msgDetailModel.pOutTime]:[_timeArr addObject:@""];
            _msgDetailModel.pHbTime?[_timeArr addObject:_msgDetailModel.pHbTime]:[_timeArr addObject:@""];
           _msgDetailModel.pUppzTime?[_timeArr addObject:_msgDetailModel.pUppzTime]:[_timeArr addObject:@""];
           _msgDetailModel.pTxTime?[_timeArr addObject:_msgDetailModel.pTxTime]:[_timeArr addObject:@""];
            break;
            
            //我参与
        case MyJoinProductMsg:
             _titleArr=@[@"报名成功",@"被邀约",@"确认同行",@"行程结束"];
            _subtitleArr=@[@"您已支持该项目一起游",@"您已被发起人邀请一起游",@"您已确认与XXX同行",@"您的行程已结束，如果没有问题请及时点击行程结束按钮，方便发起人申请提现"];
            break;
            //我回报
        case MyReturnProductMsg:
            _titleArr   =@[@"回报支持成功",@"确认回报"];
            _subtitleArr=@[@"回报支持成功",@"你已经确认收货"];
            break;
            
        default:
            break;
    }
}



-(void)configUIWithDetailMsg:(MsgDetailModel *)msgDetailModel andMsgStyle:(DetailMsgType)msgStyle
{
    DDLog(@"%ld",msgStyle);
    UILabel *titleLab=[self createLabWithFrame:CGRectMake(20, KEDGE_DISTANCE, self.width-40, 20) andFont:[UIFont boldSystemFontOfSize:17] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    titleLab.text=@"行程进度";
    [self addSubview:titleLab];
    
     _sumHeight=titleLab.bottom+10+_oneLineHeight;
    
    
    for (int i=0; i<_titleArr.count; i++) {
       [self addSubview: [self createOneLineViewWithTop:_sumHeight andTitle:_titleArr[i] andSubtitle:_subtitleArr[i] andTime:i<_timeArr.count?_timeArr[i]:nil andFinish:i<_msgDetailModel.step]];
    }
    
    if (_sumHeight>self.height) {
        self.contentSize=CGSizeMake(0, _sumHeight+20);
    }
}



-(UIView *)createOneLineViewWithTop:(CGFloat)top andTitle:(NSString *)title andSubtitle:(NSString *)subtitle andTime:(NSString *)time andFinish:(BOOL)finish
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, top, self.width, 0)];
    
    CGFloat line_width=2;
    UIImageView *lineImg=[[UIImageView alloc]initWithFrame:CGRectMake(40-(line_width/2.0), -(1+_oneLineHeight), line_width,_oneLineHeight)];
    lineImg.backgroundColor=finish?LINE_GREEN_COLOR:[UIColor ZYZC_TextGrayColor02];
    [view addSubview:lineImg];
    
    CGFloat stepImg_width=15;
    UIImageView *stepImg=[[UIImageView alloc]initWithFrame:CGRectMake(40-(stepImg_width/2.0), 0, stepImg_width, stepImg_width)];
    stepImg.image=finish?[UIImage imageNamed:@"right-point-0"]:[UIImage imageNamed:@"gray-point"];
    [view addSubview:stepImg];
    
    UILabel *titleLab=[self createLabWithFrame:CGRectMake(stepImg.right+KEDGE_DISTANCE, 0, view.width-stepImg.right-100, 20) andFont:[UIFont systemFontOfSize:15] andTitleColor:finish?[UIColor ZYZC_TextBlackColor]:[UIColor ZYZC_TextGrayColor]];
    titleLab.text=title;
    [view addSubview:titleLab];
    
    UILabel *subtitleLab=[self createLabWithFrame:CGRectMake(titleLab.left, titleLab.bottom+5, view.width-stepImg.right-20, 20) andFont:[UIFont systemFontOfSize:13] andTitleColor:finish?[UIColor ZYZC_TextBlackColor]:[UIColor ZYZC_TextGrayColor]];
    subtitleLab.text=subtitle;
    [view addSubview:subtitleLab];
    
    if (time) {
        UILabel *timeLab=[self createLabWithFrame:CGRectMake(view.width-90, titleLab.top, 80, 20) andFont:[UIFont systemFontOfSize:12] andTitleColor:[UIColor ZYZC_TextGrayColor]];
        timeLab.text=time;
        
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
    return lab;
}


@end
