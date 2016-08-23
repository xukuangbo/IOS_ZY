//
//  NetFailView.m
//  断网界面与刷新
//
//  Created by liuliang on 16/2/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "NetFailView.h"
#define KFIRST_TEXT  @"你是不是离地球太远了～"
#define KSECOND_TEXT @"请检查您的网络"
#define KTHIRD_TEXT  @"重新加载吧"

#define KFIRST_TEXT_UnService      @"服务器断开,未能连接到服务器～"
#define KFIRST_TEXT_UnusualService @"服务器异常,未能连接到服务器～"
#define KFIRST_TEXT_Unknown        @"网络错误,未能连接到服务器～"

@implementation NetFailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.frame=CGRectMake(0, 0, KSCREEN_W, KSCREEN_H);
        [self configUI];
    }
    return self;
}

- (instancetype)initWithFailResult:(id)failResult
{
    self = [super init];
    if (self) {
        
        if ([failResult isKindOfClass:[NSString class]]) {
            
            if ([failResult isEqualToString:@"似乎已断开与互联网的连接。"]) {
                _failType=UnNetWork;
            }
            else if ([failResult isEqualToString:@"未能连接到服务器。"])
            {
                _failType=UnService;
            }
            else if ([failResult isEqualToString:@"未能读取数据，因为它的格式不正确。"])
            {
                _failType=UnusualService;
            }
            else
            {
                _failType=Unknown;
            }
        }
        
        self.backgroundColor=[UIColor whiteColor];
        self.frame=CGRectMake(0, 0, KSCREEN_W, KSCREEN_H);
        [self configUI];
    }
    return self;
}


-(void)configUI
{
    //添加banner
    UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 64)];
    bgImg.image=[UIImage imageNamed:@"Background"];
    [self addSubview:bgImg];

    
    CGFloat top=(KSCREEN_H-326)/2;
    CGFloat width=160;
    CGFloat height=111;
    UIImageView *faceView=[[UIImageView alloc]initWithFrame:CGRectMake((self.width-width)/2,top, width, height)];
    faceView.image=[UIImage imageNamed:@"WiFi断网"];
    [self addSubview:faceView];
    
    //文字部分
    UILabel *firstLab=[self createLabWithFrame:CGRectMake(0, faceView.bottom+50, self.width, 30) andTitle:nil andTextColor:[UIColor ZYZC_TextBlackColor]];
    [self addSubview:firstLab];
    
    UILabel *secondLab=[self createLabWithFrame:CGRectMake(0, firstLab.bottom+10, self.width, 20) andTitle:nil andTextColor:[UIColor ZYZC_TextGrayColor]];
    secondLab.font=[UIFont systemFontOfSize:15];
    [self addSubview:secondLab];
    
    UILabel *thirdLab=[self createLabWithFrame:CGRectMake(0, secondLab.bottom+5, self.width, 20) andTitle:nil andTextColor:[UIColor ZYZC_TextGrayColor]];
    thirdLab.font=[UIFont systemFontOfSize:15];
    [self addSubview:thirdLab];
    
    
    //重新加载按钮
    CGFloat btnWidth=100;
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake((self.width-btnWidth)/2, thirdLab.bottom+50, btnWidth, 30);
    [btn setTitle:@"重新加载" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(refreash) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius=KCORNERRADIUS;
    btn.layer.masksToBounds=YES;
    btn.layer.borderWidth=1;
    btn.layer.borderColor=[UIColor ZYZC_TextGrayColor].CGColor;
    [self addSubview:btn];
    
    if (_failType==UnNetWork) {
        firstLab.text=KFIRST_TEXT;
        secondLab.text=KSECOND_TEXT;
        thirdLab.text=KTHIRD_TEXT;
    }
    else if(_failType==UnService)
    {
        firstLab.text=KFIRST_TEXT_UnService;
        secondLab.text=nil;
        thirdLab.text=nil;
        btn.top=firstLab.bottom+50;
    }
    else if (_failType==UnusualService)
    {
        firstLab.text=KFIRST_TEXT_UnusualService;
        secondLab.text=nil;
        thirdLab.text=nil;
        btn.top=firstLab.bottom+50;
    }
    else if (_failType==Unknown)
    {
        firstLab.text=KFIRST_TEXT_Unknown;
        secondLab.text=nil;
        thirdLab.text=nil;
        btn.top=firstLab.bottom+50;
    }
}

#pragma mark --- 刷新
-(void)refreash
{
    if (self.reFrashBlock) {
        self.reFrashBlock();
    }
}

-(UILabel *)createLabWithFrame:(CGRect)frame andTitle:(NSString *)title andTextColor:(UIColor *)color
{
    UILabel  *lab=[[UILabel alloc]initWithFrame:frame];
    lab.text=title;
    lab.textColor=color;
    lab.textAlignment=NSTextAlignmentCenter;
    return lab;
}

-(void)dealloc
{
//    NSLog(@"dealloc:%@",self.class);
}

@end
