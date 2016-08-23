//
//  ZCDetailBottomView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCDetailBottomView.h"
#import "MBProgressHUD+MJ.h"
#import "WXApiManager.h"
@implementation ZCDetailBottomView

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
        self.size=CGSizeMake(KSCREEN_W, 49);
        self.left=0;
        self.top=KSCREEN_H-self.height;
        self.backgroundColor=[UIColor ZYZC_TabBarGrayColor];
        [self addSubview:[UIView lineViewWithFrame:CGRectMake(0, 0, KSCREEN_W, 0.5) andColor:[UIColor lightGrayColor]]];
    }
    return self;
}


-(void)setDetailProductType:(DetailProductType)detailProductType
{
    _detailProductType=detailProductType;
     NSArray *titleArr=nil;
    if (detailProductType==PersonDetailProduct) {
        titleArr=@[@"评论",@"支持",@"推荐"];
    }
    else if(detailProductType==MineDetailProduct)
    {
        titleArr=@[@"补充说明",@"支持自己"];
    }
    if (!titleArr.count) {
        return;
    }
    CGFloat btn_edg  =KEDGE_DISTANCE;
    CGFloat btn_width=(KSCREEN_W-btn_edg*(titleArr.count+1))/titleArr.count;
    for (int i=0; i<titleArr.count; i++) {
        UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame=CGRectMake(btn_edg+(btn_edg+btn_width)*i, self.height/2-20, btn_width, 40);
        [sureBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
        sureBtn.titleLabel.font=[UIFont systemFontOfSize:20];
        sureBtn.layer.cornerRadius=KCORNERRADIUS;
        sureBtn.layer.masksToBounds=YES;
        [sureBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.tag=CommentType+i;
        [self addSubview:sureBtn];
        
        if (i==1) {
            sureBtn.backgroundColor=[UIColor ZYZC_MainColor];
            [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    if(!_productEndTime)
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSupportButton:) name:KCAN_SUPPORT_MONEY object:nil];
    }
}


#pragma mark --- 底部按钮点击事件
-(void)clickBtn:(UIButton *)sender
{
    
    if (_productEndTime&&sender.tag==SupportType) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:ZYLocalizedString(@"not_support_width_product_end_time") delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (_buttonClick) {
        _buttonClick(sender.tag);
    }
}

#pragma mark --- 如果可以支持，支持按钮变为支付
-(void)changeSupportButton:(NSNotification *)notify
{
    NSString *str=notify.object;
    
    __weak typeof (&*self)weakSelf=self;
    _payMoneyBlock=^(NSNumber *productId){
        NSMutableDictionary *mutDic=[NSMutableDictionary dictionaryWithDictionary:[ZYZCTool turnJsonStrToDictionary:notify.object]];
        [mutDic setObject:productId forKey:@"productId"];
        NSNumber *style2=mutDic[@"style2"];
        if ( style2&&[style2 isEqual:@0]) {
            [MBProgressHUD showShortMessage:@"任意金额不能为空"];
            return ;
        }
//        NSLog(@"mutDic:%@",mutDic);
        
         NSNumber *style4=mutDic[@"style4"];
        
        if (style4) {
        #pragma mark ----------- 
            //判断时间是否有冲突，如果有则不可支持
            [ZYZCHTTPTool getHttpDataByURL:JUDGE_TIME_CONFLICT([ZYZCAccountTool getUserId],productId) withSuccessGetBlock:^(id result, BOOL isSuccess)
            {
                //没有冲突
                if ([result[@"data"] isEqual:@1]) {
                    WXApiManager *wxManager=[WXApiManager sharedManager];
                    [wxManager payForWeChat:mutDic withSuccessBolck:nil andFailBlock:nil];
                }
                else if ([result[@"data"] isEqual:@0])
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"此行程与已有行程时间冲突,不可支持一起游" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
                }
            }
            andFailBlock:^(id failResult)
            {
                [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
            }];
        }
        else
        {
            WXApiManager *wxManager=[WXApiManager sharedManager];
            [wxManager payForWeChat:mutDic withSuccessBolck:nil andFailBlock:nil];
        }
        
        
//        if(mutDic[@"style1"]||mutDic[@"style3"]||mutDic[@"style4"])
//        {
//            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//            NSString *userId=[user objectForKey:KUSER_MARK];
//            [ZYZCHTTPTool getHttpDataByURL:GET_MY_STYLEPAY_STATUS(userId,productId) withSuccessGetBlock:^(id result, BOOL isSuccess) {
//                NSLog(@"%@",result);
//                if (isSuccess) {
//                    if ([result[@"style1"] boolValue]&&mutDic[@"style1"]) {
//                        [MBProgressHUD showError:@"支持5元只能操作一次"];
//                    }
//                    else if ([result[@"style3"] boolValue]&&mutDic[@"style3"]) {
//                        [MBProgressHUD showError:@"回报支持只能操作一次"];
//                    }
//                    else if ([result[@"style4"] boolValue]&&mutDic[@"style4"])
//                    {
//                        [MBProgressHUD showError:@"一起游支持只能操作一次"];
//                    }
//                    else
//                    {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            WXApiManager *wxManager=[WXApiManager sharedManager];
//                            [wxManager payForWeChat:mutDic];
//                        });
//                    }
//                }
//                else
//                {
//                    [MBProgressHUD showError:@"数据异常，操作失败!"];
//                }
//                
//            } andFailBlock:^(id failResult) {
//                NSLog(@"%@",failResult);
//                [MBProgressHUD showError:@"网络异常，操作失败!"];
//            }];
//        }
//        else
//        {
//            WXApiManager *wxManager=[WXApiManager sharedManager];
//            [wxManager payForWeChat:mutDic];
//        }
};
    
    UIButton *supportBtn=(UIButton *)[self viewWithTag:SupportType];
     if([str isEqualToString:@"hidden"])
    {
        _surePay=NO;
        [supportBtn setTitle: _detailProductType==PersonDetailProduct?@"支持":@"支持自己" forState:UIControlStateNormal];
        [supportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        supportBtn.backgroundColor=[UIColor ZYZC_MainColor];
    }
     else {
         _surePay=YES;
         [supportBtn setTitle:@"支付" forState:UIControlStateNormal];
         [supportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         supportBtn.backgroundColor=[UIColor ZYZC_MainColor];
     }

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KCAN_SUPPORT_MONEY object:nil];
}


@end
