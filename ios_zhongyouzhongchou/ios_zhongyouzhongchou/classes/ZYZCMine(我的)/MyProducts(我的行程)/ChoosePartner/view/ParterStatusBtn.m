//
//  ParterStatusBtn.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define ALERT_SEND_INVITAYION_TAG   20
#define ALERT_RETURN_TAG            21

#import "ParterStatusBtn.h"
#import "MBProgressHUD+MJ.h"
#import "NetWorkManager.h"
@implementation ParterStatusBtn

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
        self.frame=frame;
        self.titleLabel.font=[UIFont systemFontOfSize:15];
        [self addTarget:self action:@selector(statusClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma maek --- 旅伴状态
-(void)setStatus:(NSNumber *)status
{
    _status=status;
    
    if ([_status isEqual:@0]) {
        self.layer.cornerRadius=KCORNERRADIUS;
        self.layer.masksToBounds=YES;
        self.layer.borderWidth=1.5;
        self.layer.borderColor=[UIColor ZYZC_MainColor].CGColor;
        [self setTitle:@"邀约" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    }
    else if ([_status isEqual:@1])
    {
        self.layer.cornerRadius=0;
        self.layer.masksToBounds=NO;
        self.layer.borderWidth=0;
        self.layer.borderColor=[UIColor ZYZC_MainColor].CGColor;
        [self setTitle:@"等待确认" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    }
    else if ([_status isEqual:@3])
    {
        self.layer.cornerRadius=0;
        self.layer.masksToBounds=NO;
        self.layer.borderWidth=0;
        self.layer.borderColor=[UIColor ZYZC_MainColor].CGColor;
        [self setTitle:@"对方确认" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
    }
    else if ([_status isEqual:@4])
    {
        self.layer.cornerRadius=0;
        self.layer.masksToBounds=NO;
        self.layer.borderWidth=0;
        self.layer.borderColor=[UIColor ZYZC_MainColor].CGColor;
        [self setTitle:@"对方取消" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

#pragma mark --- 回报状态
-(void)setReturnState:(NSNumber *)returnState
{
    _returnState=returnState;
    
    if ([_returnState isEqual:@0])
    {
        self.layer.cornerRadius=KCORNERRADIUS;
        self.layer.masksToBounds=YES;
        self.layer.borderWidth=1.5;
        self.layer.borderColor=[UIColor ZYZC_MainColor].CGColor;
        [self setTitle:@"确认回报" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];

    }
    else if ([_returnState isEqual:@1])
    {
        self.layer.cornerRadius=0;
        self.layer.masksToBounds=NO;
        self.layer.borderWidth=0;
        self.layer.borderColor=[UIColor ZYZC_MainColor].CGColor;
        [self setTitle:@"等待收货" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    }
    else if ([_returnState isEqual:@3])
    {
        self.layer.cornerRadius=0;
        self.layer.masksToBounds=NO;
        self.layer.borderWidth=0;
        self.layer.borderColor=[UIColor ZYZC_MainColor].CGColor;
        [self setTitle:@"对方收货" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
    }

}

#pragma mark --- 评价状态
-(void)setComentStatus:(NSNumber *)comentStatus
{
    _comentStatus=comentStatus;
    //未评价
    if ([comentStatus isEqual:@0]) {
        self.layer.cornerRadius=KCORNERRADIUS;
        self.layer.masksToBounds=YES;
        self.layer.borderWidth=1.5;
        self.layer.borderColor=[UIColor ZYZC_MainColor].CGColor;
        [self setTitle:@"评价" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    }
    //已评价
    else if ([comentStatus isEqual:@1])
    {
        self.layer.cornerRadius=0;
        self.layer.masksToBounds=NO;
        self.layer.borderWidth=0;
        self.layer.borderColor=[UIColor ZYZC_MainColor].CGColor;
        [self setTitle:@"已评价" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
    }
}

#pragma mark --- 点击事件
-(void)statusClick
{
    self.enabled=NO;
    if (_myPartnerType==TogtherPartner) {
        //旅伴
        if (_status&&[_status isEqual:@0]) {
            //邀约
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"是否向对方发起邀约" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            alert.tag=ALERT_SEND_INVITAYION_TAG;
            [alert show];
            return;
        }
    }
    else if(_myPartnerType==ReturnPartner){
        //回报
        if (_returnState&&[_returnState isEqual:@0]) {
            //回报
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"是否已履行了回报承诺" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            alert.tag=ALERT_RETURN_TAG;
            [alert show];
            return;
        }
    }
    
    //评价
    if(_comentStatus)
    {
        [self commentPerson];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //邀约
    if (alertView.tag==ALERT_SEND_INVITAYION_TAG) {
        if (buttonIndex==1) {
            NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"productInfo_sendInvitation"];
            NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
            [parameter setValue:[ZYZCAccountTool getUserId] forKey:@"selfUserId"];
            [parameter setValue:[NSString stringWithFormat:@"%@", _userModel.userId] forKey:@"userId"];
            [parameter setValue:[NSString stringWithFormat:@"%@", _productId] forKey:@"productId"];

            WEAKSELF
            [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
                if (isSuccess) {
                    [MBProgressHUD showSuccess:@"邀约成功!"];
                    weakSelf.status=@1;
                }
                else
                {
                    [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
                }
            } andFailBlock:^(id failResult) {
                [NetWorkManager showMBWithFailResult:failResult];

            }];
        }
    }
    else if (alertView.tag==ALERT_RETURN_TAG)
    {
        if (buttonIndex==1) {
            //已确认回报
//            NSString *httpUrl=SEND_BACKPAY([ZYZCAccountTool getUserId],_productId,_userModel.userId);
            NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"productInfo_sendBackpay"];
            NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
            [parameter setValue:[ZYZCAccountTool getUserId] forKey:@"selfUserId"];
            [parameter setValue:[NSString stringWithFormat:@"%@", _userModel.userId] forKey:@"userId"];
            [parameter setValue:[NSString stringWithFormat:@"%@", _productId] forKey:@"productId"];
            WEAKSELF
            [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
            [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
                [MBProgressHUD hideHUDForView:self.viewController.view];
                //                 NSLog(@"%@",result);
                if (isSuccess) {
                    weakSelf.returnState=@1;
                }
                else
                {
                    [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
                }
            } andFailBlock:^(id failResult) {
                [MBProgressHUD hideHUDForView:self.viewController.view];
                [NetWorkManager showMBWithFailResult:failResult];
            }];
        }
    }
    self.enabled=YES;
}

#pragma mark --- 评价
-(void)commentPerson
{
    CommentUserViewController *commentViewController=[[CommentUserViewController alloc]init];
    commentViewController.userModel=_userModel;
    commentViewController.productId=_productId;
    commentViewController.commentType=_commentType;
    commentViewController.hasComment=[_comentStatus isEqual:@1];
//    commentViewController.hasComplain=_hasComplain;
    __weak typeof (&*self)weakSelf=self;
    commentViewController.finishComent=^(){
        weakSelf.comentStatus=@1;
    };
    [self.viewController.navigationController pushViewController:commentViewController animated:YES];
    self.enabled=YES;
}


@end
