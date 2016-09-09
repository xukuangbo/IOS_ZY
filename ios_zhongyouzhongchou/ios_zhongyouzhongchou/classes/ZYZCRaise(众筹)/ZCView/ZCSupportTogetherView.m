//
//  ZCSupportTogetherView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCSupportTogetherView.h"

@implementation ZCSupportTogetherView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)configUI
{
    [super configUI];
     _wsmView=[[ZCWSMView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0)];
    self.otherViews.top=self.textLab.bottom+KEDGE_DISTANCE;
    [self.otherViews addSubview:_wsmView];
    [self changViewFrame];
}

-(void)reloadDataByVideoImgUrl:(NSString *)videoImgUrl andPlayUrl:(NSString *)playUrl andVoiceUrl:(NSString *)voiceUrl andFaceImg:(NSString *)faceImg andDesc:(NSString *)desc andImgUrlStr:(NSString *)imgUrlStr
{
    [_wsmView reloadDataByVideoImgUrl:videoImgUrl andPlayUrl:playUrl andVoiceUrl:voiceUrl andFaceImg:faceImg andDesc:desc andImgUrlStr:imgUrlStr];
    [self changViewFrame];
}


-(void)changViewFrame
{
    self.limitLab.frame=CGRectMake(0, _wsmView.bottom+KEDGE_DISTANCE, 80, 20);
    self.hasSupportLab.frame=CGRectMake(self.limitLab.right+30, self.limitLab.top, 80, 20) ;
    self.morePeopleBtn.frame=CGRectMake(self.width-80, self.hasSupportLab.top, 80, 30) ;
    self.otherViews.height=self.hasSupportLab.bottom;
    self.height=self.otherViews.bottom+KEDGE_DISTANCE;
    
}


-(void)supportMoney
{
    if( self.productEndTime)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:ZYLocalizedString(@"not_support_width_product_end_time") delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    if (!self.chooseSupport) {
        if (self.mySelf) {
            [MBProgressHUD showError:@"此选项不可参与"];
        }
        else{
            [MBProgressHUD showError:@"此选项只能支持一次"];
        }
        return;
    }
    [super supportMoney];
}


@end
