//
//  AddDetailView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/25.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "AddDetailView.h"
#import "UIView+GetSuperTableView.h"
@implementation AddDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor=[UIColor ZYZC_BgGrayColor01];
        self.layer.cornerRadius=KCORNERRADIUS;
        self.layer.masksToBounds=YES;
        [self configUI];
    }
    return self;
}

#pragma mark --- 创建控件
-(void)configUI
{
    NSArray *titleArr=@[@"景点",@"交通",@"住宿",@"餐饮"];
    for (int i=0; i<titleArr.count; i++) {
        //创建切换按钮
        UIButton *btn=[self setButtonWithIndex:i withTitle:titleArr[i]];
        btn.tag = SceneType+i;
        [self addSubview:btn];
        //创建录入内容界面
        AddSceneView *typeView=[[AddSceneView alloc]initWithFrame:CGRectMake(0,40, self.width, self.height-40) andIndex:i];
        typeView.placeholdLab.text=[NSString stringWithFormat:@"编写%@描述",titleArr[i]];
        typeView.tag=SceneContentType+i;
        [self addSubview:typeView];
    }
    //第一次执行图文描述按钮
    UIButton *sceneBtn=(UIButton *)[self viewWithTag:SceneType];
    [self changeType:sceneBtn];
}


#pragma mark ---创建btn
- (UIButton *)setButtonWithIndex:(NSInteger)index withTitle:(NSString *)titleName
{
    CGFloat buttonY = 10;
    CGFloat buttonW = self.width/4;
    CGFloat buttonH = 20;
    CGFloat buttonX =index * buttonW;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [button setTitle:titleName forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:15];
    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    [button setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    if (index<3) {
        [button addSubview:[UIView lineViewWithFrame:CGRectMake(button.width-1, 1, 1, 18) andColor:[UIColor ZYZC_TextGrayColor]]];
    }
    return button;
}

#pragma mark --- btn点击事件
-(void)changeType:(UIButton *)button
{
    button.selected=YES;
    if (_preClickBtn&&_preClickBtn!=button) {
        _preClickBtn.selected=NO;
    }
    _preClickBtn=button;
    
    switch (button.tag) {
        case SceneType:
            [self bringSubviewToFront:[self viewWithTag:SceneContentType]];
            break;
        case TrafficType:
            [self bringSubviewToFront:[self viewWithTag:TrafficContentType]];
            break;
        case AccommodateType:
            [self bringSubviewToFront:[self viewWithTag:AccommodateContentType]];
            break;
        case FoodType:
            [self bringSubviewToFront:[self viewWithTag:FoodContentType]];
            break;
        default:
            break;
    }
}

@end




