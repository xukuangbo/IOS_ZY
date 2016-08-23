//
//  UserIconButton.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/24.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "UserIconButton.h"
@interface UserIconButton ()
@property (nonatomic, strong) UIView *coverView;

@end

@implementation UserIconButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    self.layer.cornerRadius=3;
    self.layer.masksToBounds=YES;
    [self setBackgroundImage:[UIImage imageNamed:@"icon_placeholder"] forState:UIControlStateNormal];
    _coverView=[[UIView alloc]initWithFrame:self.bounds];
    _coverView.backgroundColor=[UIColor blackColor];
    _coverView.alpha=0.3;
    _coverView.userInteractionEnabled=NO;
    [self addSubview:_coverView];
    
}

#pragma mark --- 更新数据
-(void)setPartnerModel:(UserModel *)partnerModel
{
    _partnerModel=partnerModel;
    [self sd_setImageWithURL:[NSURL URLWithString:partnerModel.faceImg] forState:UIControlStateNormal];
    
}

#pragma mark ---选择或者取消选择
-(void)setIsChoose:(BOOL)isChoose
{
    _isChoose=isChoose;
    
    if (_isChoose) {
        self.layer.borderWidth=2;
        self.layer.borderColor=[UIColor ZYZC_MainColor].CGColor;
        _coverView.hidden=YES;
    }
    else
    {
        self.layer.borderWidth=0;
        _coverView.hidden=NO;
    }
    
}





@end
