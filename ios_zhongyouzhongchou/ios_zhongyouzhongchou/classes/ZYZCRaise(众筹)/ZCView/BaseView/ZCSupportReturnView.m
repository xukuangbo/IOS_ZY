//
//  ZCSupportReturnView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCSupportReturnView.h"

@implementation ZCSupportReturnView

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
//    self.textLab.height=0.001;
    self.otherViews.top=self.textLab.bottom+KEDGE_DISTANCE;
    [self.otherViews addSubview:_wsmView];
}

-(void)reloadDataByVideoImgUrl:(NSString *)videoImgUrl andPlayUrl:(NSString *)playUrl andVoiceUrl:(NSString *)voiceUrl andVoiceLen:(CGFloat)voiceLen  andFaceImg:(NSString *)faceImg andDesc:(NSString *)desc andImgUrlStr:(NSString *)imgUrlStr
{
    [_wsmView reloadDataByVideoImgUrl:videoImgUrl andPlayUrl:playUrl andVoiceUrl:voiceUrl andVoiceLen:voiceLen andFaceImg:faceImg andDesc:desc andImgUrlStr:imgUrlStr];
    [self changViewFrame];
}

-(void)changViewFrame
{
    self.limitLab.top = _wsmView.bottom+KEDGE_DISTANCE;
    self.hasSupportLab.top = self.limitLab.top;
    self.morePeopleBtn.top = self.limitLab.top;
    self.separateView.top=self.limitLab.top+2.5;
    self.otherViews.height=self.hasSupportLab.bottom;
    self.height=self.otherViews.bottom+KEDGE_DISTANCE;
}

-(void)supportMoney
{
    if(self.productEndTime)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:ZYLocalizedString(@"not_support_width_product_end_time") delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (_getLimit) {
       [MBProgressHUD showError:@"不可参与回报支持,人数已达上限"];
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
