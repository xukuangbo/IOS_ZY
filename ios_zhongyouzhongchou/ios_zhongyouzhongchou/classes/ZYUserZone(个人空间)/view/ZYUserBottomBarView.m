//
//  ZYUserBottomBarView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/26.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define first_btn_tag    1000

#import "ZYUserBottomBarView.h"
#import "MBProgressHUD+MJ.h"
#import "ZYZCRCManager.h"

@interface ZYUserBottomBarView ()
@property (nonatomic, strong) UIButton  *friendShipBtn;//关注
@property (nonatomic, strong) UIButton  *chatBtn;      //私信
@property (nonatomic, strong) UIButton  *infoBtn;      //ta的资料
@property (nonatomic, strong) ZYZCRCManager *RCManager;

@end

@implementation ZYUserBottomBarView

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
        self.height=49;
        self.backgroundColor=[UIColor ZYZC_BgGrayColor];
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    CGFloat btn_width=self.width/2.0;
    NSArray *titleArr=@[@"关注",@"私信"];
    for (int i=0; i<titleArr.count; i++) {
        UIButton *btn=[ZYZCTool createBtnWithFrame:CGRectMake(btn_width*i, 0, btn_width, self.height) andNormalTitle:titleArr[i] andNormalTitleColor:[UIColor ZYZC_TextGrayColor] andTarget:self andAction:@selector(doSomething:)];
        btn.tag=i+first_btn_tag;
        [self addSubview:btn];
        
        if (i==0) {
            _friendShipBtn=btn;
        }
        
        if (i<1) {
            [btn addSubview:[UIView lineViewWithFrame:CGRectMake(btn.width-0.5, (btn.height-30)/2.0, 0.5, 30) andColor:[UIColor lightGrayColor]]];
        }
    }
    
    UIView *lineView=[UIView lineViewWithFrame:CGRectMake(0, 0, self.width, 0.5) andColor:[UIColor lightGrayColor]];
    [self addSubview:lineView];
}

-(void)doSomething:(UIButton *)sender
{
    switch (sender.tag) {
            //关注／取消关注
        case first_btn_tag:
            [self changeFriendShip];
            break;
            //私信
        case first_btn_tag+1:
            [self enterChat];
            break;
            //ta的资料
        case first_btn_tag+2:
            [self getUserInfo];
            break;
        default:
            break;
    }
}

#pragma mark --- 关注／取消关注
-(void)changeFriendShip
{
    _friendShipBtn.enabled=NO;
    
    NSString *selfUserId=[ZYZCAccountTool getUserId];
    if (!_friendID||!selfUserId) {
        return;
    }
    
    NSDictionary *params=@{@"userId":selfUserId,@"friendsId":_friendID};
    if (_friendship) {
        //取消关注
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:UNFOLLOWUSER andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess)
         {
            _friendShipBtn.enabled=YES;
             if (isSuccess) {
                 [MBProgressHUD showShortMessage:@"取消成功"];
            
                 self.friendship=!_friendship;
             }
             else
             {
                 [MBProgressHUD showShortMessage:@"取消失败"];
             }
         }
        andFailBlock:^(id failResult) {
                _friendShipBtn.enabled=YES;
               [MBProgressHUD showShortMessage:@"取消失败"];
        }];
        
    }
    //添加关注
    else
    {
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:FOLLOWUSER andParameters:params andSuccessGetBlock:^(id result, BOOL isSuccess) {
            _friendShipBtn.enabled=YES;
            if (isSuccess) {
                [MBProgressHUD showShortMessage:@"关注成功"];
                self.friendship=!_friendship;
            }
            else
            {
                [MBProgressHUD showShortMessage:@"关注失败"];
            }
            
        } andFailBlock:^(id failResult) {
            _friendShipBtn.enabled=YES;
            [MBProgressHUD showShortMessage:@"关注失败"];
        }];
    }
}

#pragma mark --- 私信
-(void)enterChat
{
    if(!_friendID)
    {
        return;
    }
    _RCManager=[ZYZCRCManager defaultManager];
    [_RCManager connectTarget:[NSString stringWithFormat:@"%@",_friendID] andTitle:_friendName  andSuperViewController:self.viewController];
}

#pragma mark --- ta的资料
-(void)getUserInfo
{
    
}

-(void)setFriendship:(BOOL)friendship
{
    _friendship=friendship;

   [_friendShipBtn setTitle:_friendship?@"取消关注":@"关注" forState:UIControlStateNormal];
    
    if(friendship)
    {
        self.fansNumber++;
    }
    else
    {
        self.fansNumber--;
    }
    
    if (self.changeFansNumber) {
        self.changeFansNumber(self.fansNumber);
    }
}



@end
