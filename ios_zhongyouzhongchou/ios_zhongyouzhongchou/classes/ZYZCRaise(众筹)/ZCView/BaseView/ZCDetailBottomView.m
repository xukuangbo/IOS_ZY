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

@interface ZCDetailBottomView ()
@property (nonatomic, strong) NSMutableDictionary *styleDic;
@end

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
        _styleDic=[NSMutableDictionary dictionary];
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
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSupportState:) name:KCAN_SUPPORT_MONEY object:nil];

    }
}


#pragma mark --- 底部按钮点击事件
-(void)clickBtn:(UIButton *)sender
{
    sender.enabled=NO;
    if (_productEndTime&&sender.tag==SupportType) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:ZYLocalizedString(@"not_support_width_product_end_time") delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if (_buttonClick) {
            _buttonClick(sender.tag);
        }
    }
    sender.enabled=YES;
}

#pragma mark --- 响应支持方式变动
-(void) getSupportState:(NSNotification *)notify
{
    NSDictionary *dataDic=notify.object;
    [_styleDic addEntriesFromDictionary:dataDic];
    
    NSMutableDictionary *supportDic=[NSMutableDictionary dictionary];
    _getPay=NO;
    for (NSInteger i=1; i<5; i++) {
        NSString *key=[NSString stringWithFormat:@"style%ld",i];
        NSNumber *money=_styleDic[key];
        if (money) {
            if ([money floatValue]>=0) {
                _getPay=YES;
                [supportDic setObject:money forKey:key];
            }
        }
    }
    DDLog(@"supportDic:%@",supportDic);
    if (supportDic.count>0) {
        [self setPayBlockWithSupportData:supportDic];
    }
  
    //支持按钮发生改变
    UIButton *supportBtn=(UIButton *)[self viewWithTag:SupportType];
    if (_getPay) {
        [supportBtn setTitle:@"支付" forState:UIControlStateNormal];
        [supportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        supportBtn.backgroundColor=[UIColor ZYZC_MainColor];
    }
    else
    {
        [supportBtn setTitle: _detailProductType==PersonDetailProduct?@"支持":@"支持自己" forState:UIControlStateNormal];
        [supportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        supportBtn.backgroundColor=[UIColor ZYZC_MainColor];
    }
}

-(void) setPayBlockWithSupportData:(NSMutableDictionary *)dataDic
{
    WEAKSELF
    _payMoneyBlock=^(NSNumber *productId){
        
        [dataDic setObject:productId forKey:@"productId"];
        NSNumber *style2=dataDic[@"style2"];
        if ( style2&&[style2 floatValue]==0) {
            [MBProgressHUD showShortMessage:@"任意金额不能为空"];
            return ;
        }
        NSNumber *style4=dataDic[@"style4"];
        if (style4) {
#pragma mark -----------
            //判断时间是否有冲突，如果有则不可支持
            NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"list_checkMyProductsTime"];
            NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
            [parameter setValue:[ZYZCAccountTool getUserId] forKey:@"userId"];
            [parameter setValue:[NSString stringWithFormat:@"%@", productId] forKey:@"productId"];
            [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
                //没有冲突
                if ([result[@"data"] isEqual:@1]) {
                    WXApiManager *wxManager=[WXApiManager sharedManager];
                    [wxManager payForWeChat:dataDic payUrl:[[ZYZCAPIGenerate sharedInstance] API:@"weixinpay_generateAppOrder"] payType:1 withSuccessBolck:nil andFailBlock:nil];
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
            } andFailBlock:^(id failResult) {
                [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
            }];
        } else {
            WXApiManager *wxManager=[WXApiManager sharedManager];
            [wxManager payForWeChat:dataDic payUrl:[[ZYZCAPIGenerate sharedInstance] API:@"weixinpay_generateAppOrder"] payType:1
                   withSuccessBolck:nil andFailBlock:nil];
        }
    };
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
