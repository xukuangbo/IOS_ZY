//
//  ZYZCEditProductView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define ALERT_DELETE_DRAFT_TAG           9
#define ALERT_DELETE_TAG                 10
#define ALERT_DELETE_MYJOINPRODUCT_TAG   11
#define ALERT_ACCEPT_TAG                 12
#define ALERT_GETRETURN_TAG              13
#define ALERT_SURE_END_TRAVEL_TAG        14
#define ALERT_DELAYTRAVEL_TAG            15

#import "ZYZCEditProductView.h"
#import "MoreFZCViewController.h"
#import "MoreFZCDataManager.h"
#import "MBProgressHUD+MJ.h"
#import "MyPartnerViewController.h"
#import "CommentUserViewController.h"
#import "CommentPersonListController.h"
#import "MyReturnViewController.h"
#import "UploadVoucherVC.h"
#import "MyProductController.h"
#import "NetWorkManager.h"
@interface ZYZCEditProductView()<UIAlertViewDelegate>
@property (nonatomic, strong) UIButton     *firstEditBtn;
@property (nonatomic, strong) UIButton     *secondEditBtn;
@property (nonatomic, strong) UIButton     *thirdEditBtn;

@property (nonatomic, strong) NSArray      *btnTitleArr;
@end
@implementation ZYZCEditProductView

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
        self.height=45;
        [self configUI];
    }
    return self;
}


-(void)configUI
{
    UIView *headLineView=[UIView lineViewWithFrame:CGRectMake(0, 0, self.width, 1) andColor:nil];
    [self addSubview:headLineView];
    
    CGFloat btnWidth=self.width/3;
    CGFloat btnHeight=self.height;
    
    _firstEditBtn=[self createBtnWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
    [self addSubview:_firstEditBtn];
     [_firstEditBtn addSubview:[UIView lineViewWithFrame:CGRectMake(_firstEditBtn.width,0, 1, _firstEditBtn.height) andColor:nil]];
    [_firstEditBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _secondEditBtn=[self createBtnWithFrame:CGRectMake(_firstEditBtn.right, 0, btnWidth, btnHeight)];
    [self addSubview:_secondEditBtn];
     [_secondEditBtn addSubview:[UIView lineViewWithFrame:CGRectMake( _secondEditBtn.width,0, 1, _secondEditBtn.height) andColor:nil]];
     [_secondEditBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _thirdEditBtn=[self createBtnWithFrame:CGRectMake(_secondEditBtn.right, 0, btnWidth, btnHeight)];
    [self addSubview:_thirdEditBtn];
    [_thirdEditBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark --- 项目类型
-(void)setProductType:(ProductType)productType
{
    _productType=productType;
    if (_productType==ZCListProduct||
        _productType==ZCDetailProduct) {
        self.hidden=YES;
    }
    //我的行程
    if(_productType==MyPublishProduct)
    {
        self.hidden=NO;
        //众筹中
        if ([_productState isEqual:@1]) {
//            self.btnTitleArr=@[@"选择旅伴",@"取消行程",@"上传游记"];
            self.btnTitleArr=@[@"选择旅伴",@"取消行程",@""];
        }
        //众筹失败
        else if([_productState isEqual:@2])
        {
            self.btnTitleArr=@[@"",@"删除行程",@"众筹失败"];
        }
        //众筹成功
        else if ([_productState isEqual:@3])
        {
            if (_successBeforeTravel) {
//                if ([_godelaystatus isEqual:@1]) {
//                      self.btnTitleArr=@[@"选择旅伴",@"已延时",@"上传游记"];
//                }
//                else{
                // self.btnTitleArr=@[@"选择旅伴",@"延迟出发",@"上传游记"]；
                    self.btnTitleArr=@[@"选择旅伴",@"延迟出发",@""];
//                }
            }
            else
            {
//                self.btnTitleArr=@[@"选择旅伴",@"取消行程",@"上传游记"];
                    self.btnTitleArr=@[@"选择旅伴",@"取消行程",@""];
            }
        }
        //旅行中
        else if ([_productState isEqual:@4])
        {
            if ([_godelaystatus isEqual:@1]) {
//                 self.btnTitleArr=@[@"回报",@"已延时",@"上传游记"];
                 self.btnTitleArr=@[@"回报",@"已延时",@""];
            }
            else{
//                self.btnTitleArr=@[@"回报",@"延迟出发",@"上传游记"];
                 self.btnTitleArr=@[@"回报",@"延时出发",@""];

            }
        }
        //旅行结束
        else if ([_productState isEqual:@5])
        {
            if ([_endstatus isEqual:@1]) {
                if ([_txstatus isEqual:@0])
                {
//                     self.btnTitleArr=@[@"评价",@"申请提现",@"上传游记"];
                     self.btnTitleArr=@[@"评价",@"申请提现",@""];
                }
                else if ([_txstatus isEqual:@1])
                {
//                    self.btnTitleArr=@[@"评价",@"审核中",@"上传游记"];
                     self.btnTitleArr=@[@"评价",@"审核中",@""];
                }
                else if ([_txstatus isEqual:@2])
                {
//                    self.btnTitleArr=@[@"评价",@"已提现",@"上传游记"];
                    self.btnTitleArr=@[@"评价",@"已提现",@""];
                }
            }
            else{
//                  self.btnTitleArr=@[@"评价",@"行程结束",@"上传游记"];
                    self.btnTitleArr=@[@"评价",@"行程结束",@""];
            }
        }
    }
    //我的参与
    else if(_productType==MyJionProduct)
    {
        self.hidden=NO;
        //等待确认
        if ([_joinProductState isEqual:@0]) {
            self.btnTitleArr=@[@"等待确认",@"取消行程",@"评价"];
        }
        //被邀约
        else if ([_joinProductState isEqual:@1])
        {
            self.btnTitleArr=@[@"确认同行",@"取消行程",@"评价"];
        }
        //众筹失败
        else if ([_joinProductState isEqual:@2])
        {
            self.btnTitleArr=@[@"",@"删除行程",@"众筹失败"];
        }
        //确认同游
        else if ([_joinProductState isEqual:@3])
        {
            if ([_commentStatus isEqual:@1]) {
                if(_myJionProductEnd)
                {
//                    self.btnTitleArr=@[@"已评价",@"行程结束",@"上传游记"];
                    self.btnTitleArr=@[@"已评价",@"行程结束",@""];
                }
                else
                {
//                    self.btnTitleArr=@[@"已评价",@"延时出发",@"上传游记"];
                    self.btnTitleArr=@[@"已评价",@"延时出发",@""];
                }
            }
            else
            {
                if(_myJionProductEnd)
                {
//                    self.btnTitleArr=@[@"评价",@"行程结束",@"上传游记"];
                    self.btnTitleArr=@[@"评价",@"行程结束",@""];
                }
                else
                {
//                    self.btnTitleArr=@[@"评价",@"延时出发",@"上传游记"];
                    self.btnTitleArr=@[@"评价",@"延时出发",@""];
                }
            }
        }
        //未同游
        else if ([_joinProductState isEqual:@4])
        {
            if ([_myPaybackstatus isEqual:@0]) {
                 self.btnTitleArr=@[@"等待确认",@"等待退款",@"评价"];
            }
            else if ([_myPaybackstatus isEqual:@1])
            {
                 self.btnTitleArr=@[@"等待确认",@"正在退款",@"评价"];
            }
            else if([_myPaybackstatus isEqual:@2])
            {
                 self.btnTitleArr=@[@"等待确认",@"已退款",@"评价"];
            }
        }
    }
    //我的回报
    else if (_productType==MyReturnProduct)
    {
        self.hidden=NO;
        //等待回报
        if ([_returnProductState isEqual:@0]) {
            if ([_commentStatus isEqual:@1])
            {
                self.btnTitleArr=@[@"",@"等待发货",@"已评价"];
            }
            else
            {
                self.btnTitleArr=@[@"",@"等待发货",@"评价"];
            }
        }
        //等待收货
        else if ([_returnProductState isEqual:@1])
        {
            if ([_commentStatus isEqual:@1]) {
                 self.btnTitleArr=@[@"",@"确认收货",@"已评价"];
            }
            else{
                self.btnTitleArr=@[@"",@"确认收货",@"评价"];
            }
        }
        //众筹失败
        else if ([_returnProductState isEqual:@2])
        {
            self.btnTitleArr=@[@"",@"等待退款",@"评价"];
        }
        //对方收货
        else if ([_returnProductState isEqual:@3])
        {
            if ([_commentStatus isEqual:@1])
            {
                self.btnTitleArr=@[@"",@"已收货",@"已评价"];
            }
            else
            {
                self.btnTitleArr=@[@"",@"已收货",@"评价"];
            }
        }
    }
    //我的草稿
    else if (_productType==MyDraftProduct)
    {
        self.hidden=NO;
        self.btnTitleArr=@[@"继续编辑",@"删除草稿",@"未发布"];
    }
}

#pragma mark --- 按钮文字展示
-(void)setBtnTitleArr:(NSArray *)btnTitleArr
{
    _btnTitleArr=btnTitleArr;
    if (btnTitleArr.count==3) {
        NSArray *btnArr=@[_firstEditBtn,_secondEditBtn,_thirdEditBtn];
        for (int i=0; i<btnArr.count; i++) {
            UIButton *btn=(UIButton *)btnArr[i];
            [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        }
        //我的行程
        if(_productType==MyPublishProduct)
        {
            //众筹中
            if ([_productState isEqual:@1]) {
                [_firstEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
                [_secondEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
            }
            //众筹失败
            else if([_productState isEqual:@2])
            {
                [_secondEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
            }
            //众筹成功
            else if ([_productState isEqual:@3])
            {
                [_firstEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                //已延时
                if ([_godelaystatus isEqual:@1]) {
                    [_secondEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
                }
                //取消行程／延时出发
                else
                {
                     [_secondEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                }
                [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
            }
            //旅行中
            else if ([_productState isEqual:@4])
            {
                if ([_hasReturn isEqual:@0]) {
                    [_firstEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
                }
                else 
                {
                     [_firstEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                }
                //已延时
                if([_godelaystatus isEqual:@1])
                {
                    [_secondEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
                }
                //延时出发
                else
                {
                    [_secondEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                }
                
                [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
            }
            //旅行结束
            else if ([_productState isEqual:@5])
            {
                [_firstEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                if([_txstatus isEqual:@1]||[_txstatus isEqual:@2])
                {
                    [_secondEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
                }
                else
                {
                     [_secondEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                }
                
                [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
            }
        }
        //我参与的行程
        else if (_productType==MyJionProduct)
        {
            //等待确认
            if ([_joinProductState isEqual:@0]) {
                [_firstEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
                 [_secondEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
            }
            //被邀请
            else if ([_joinProductState isEqual:@1])
            {
                [_firstEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                [_secondEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
            }
            //众筹失败
            else if ([_joinProductState isEqual:@2])
            {
                [_secondEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
            }
            //确认同游
            else if ([_joinProductState isEqual:@3])
            {
                //评价
                if ([_commentStatus isEqual:@0]) {
                   [_firstEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                }
                else
                {
                    [_firstEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
                }
                //“延时出发”／“行程结束”
                if ([_myGodelaystatus isEqual:@1]||[_myEndstatus isEqual:@1]) {
                    //已确认“延时出发”／“行程结束”
                    [_secondEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                }
                else
                {
                      [_secondEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                }
                
                //上传游记
                [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
            }
            //未同游
            else if ([_joinProductState isEqual:@4])
            {
                [_firstEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
                [_secondEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
                [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
            }
        }
        //我的回报
        else if (_productType==MyReturnProduct)
        {
            //等待发货
            if ([_returnProductState isEqual:@0]) {
                [_secondEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
                
                if ([_commentStatus isEqual:@1]) {
                    [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
                }
                else
                {
                    [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                }
            }
            //确认收货
            else if ([_returnProductState isEqual:@1])
            {
                [_secondEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                if ([_commentStatus isEqual:@1]) {
                    [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
                }
                else
                {
                     [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                }
            }
            //众筹失败
            else if ([_returnProductState isEqual:@2])
            {
                [_secondEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
                [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
            }
            //已收货
            else if ([_returnProductState isEqual:@3])
            {
                [_secondEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
                if ([_commentStatus isEqual:@1]) {
                    [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
                }
                else
                {
                    [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
                }
            }
        }
        //我的草稿
        else if (_productType==MyDraftProduct) {
            [_thirdEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark ---按钮点击事件
-(void)btnClick:(UIButton *)button
{
    //我的行程
    if(_productType==MyPublishProduct)
    {
        //众筹中
        if ([_productState isEqual:@1]) {
            //选择
            if (button==_firstEditBtn) {
                
            }
            //取消行程
            else if (button==_secondEditBtn) {
                [self deleteProduct];
            }
        }
        //众筹失败
        else if([_productState isEqual:@2])
        {
            //取消行程
            if (button==_secondEditBtn) {
                [self deleteProduct];
            }
        }
        //众筹成功
        else if ([_productState isEqual:@3])
        {
            //选择旅伴
            if (button==_firstEditBtn) {
                [self choosePartner];
            }
            //取消行程/延时出发
            if(button==_secondEditBtn)
            {
                //延时出发
                if (_successBeforeTravel) {
                    if (![_godelaystatus isEqual:@1]) {
                        [self delayTravel];
                    }
                }
                //取消行程
                else
                {
                    [self deleteProduct];
                }
            }
        }
        //旅行中
        else if ([_productState isEqual:@4])
        {
            //回报
            if(button==_firstEditBtn)
            {
                if ([_hasReturn isEqual:@1]) {
                    [self returnToOther];
                }
            }
            //延时出发
            else if (button==_secondEditBtn)
            {
                if(![_godelaystatus isEqual:@1])
                {
                    [self delayTravel];
                }
            }
            //上传游记
            else if (button==_thirdEditBtn)
            {
                [self uploadTravelBlog];
            }
        }
        //旅行结束
        else if ([_productState isEqual:@5])
        {
            //评论
            if (button==_firstEditBtn) {
                //评价同游者，回报者
                [self commentMyProductPerson];
            }
            //申请提现
            else if(button==_secondEditBtn)
            {
               //确认行程结束后
                if ([_endstatus isEqual:@1]) {
                    //申请提现
                    if([_txstatus isEqual:@0])
                    {
                        [self  applyMoney];
                    }
                }
                //未确认行程结束
                else
                {
                    [self sureEndTravel];
                }
            }
            //上传游记
            else if(button==_thirdEditBtn)
            {
                [self uploadTravelBlog];
            }
        }
    }
    //我的参与
    else if(_productType==MyJionProduct)
    {
        //等待确认
        if ([_joinProductState isEqual:@0]) {
            //取消参与的行程
            if (button==_secondEditBtn) {
                [self deleteMyJoinProduct];
            }
        }
        //被邀约
        else if ([_joinProductState isEqual:@1])
        {
            //确认同游
            if(button==_firstEditBtn)
            {
                [self acceptInvitation];
            }
            //取消参与的行程
            else if (button==_secondEditBtn)
            {
                [self deleteMyJoinProduct];
            }
        }
        //众筹失败
        else if ([_joinProductState isEqual:@2])
        {
            //取消行程
            if (button==_secondEditBtn)
            {
                [self deleteMyJoinProduct];
            }
        }
        //确认同游
        else if ([_joinProductState isEqual:@3])
        {
            //评价发起者
            if(button==_firstEditBtn)
            {
                [self commentProductPersonWithType:CommentProductPerson];
            }
            //延迟出发／旅行结束
            else if (button==_secondEditBtn)
            {
                //确认行程结束
                if (_myJionProductEnd&&[_myEndstatus isEqual:@0]) {
                    [self sureEndTravel];
                }
                //确认延时出发
                else if (!_myJionProductEnd&&[_myGodelaystatus isEqual:@0])
                {
                    [self delayTravel];
                }
            }
            //上传游记
            else if (button==_thirdEditBtn)
            {
                [self uploadTravelBlog];
            }
        }
        //未同游
        else if ([_joinProductState isEqual:@4])
        {
            
        }
    }
    //我的回报
    else if (_productType==MyReturnProduct)
    {
        //等待发货
        if ([_returnProductState isEqual:@0]) {
            if (button==_thirdEditBtn) {
                [self commentProductPersonWithType:CommentMyReturnProduct];
            }
        }
        //确认收货
        else if ([_returnProductState isEqual:@1])
        {
            //确认收货
            if (button==_secondEditBtn) {
                [self getMyReturn];
            }
            if (button==_thirdEditBtn) {
                [self commentProductPersonWithType:CommentMyReturnProduct];
            }
        }
        //众筹失败
        else if ([_returnProductState isEqual:@2])
        {
        }
        //评价
        else if ([_returnProductState isEqual:@3])
        {
            //评价发货者
            if (button==_thirdEditBtn) {
                [self commentProductPersonWithType:CommentMyReturnProduct];
            }
        }
    }
    //我的草稿
    else if (_productType==MyDraftProduct)
    {
        //继续编辑
        if (button==_firstEditBtn) {
            [self editDraft];
        }
        //取消行程
        else if (button==_secondEditBtn)
        {
            [self deleteDraftProduct];
        }
    }
}

#pragma mark --- 编辑草稿
-(void)editDraft
{
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"productInfo_getProductDetail"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:_productId forKey:@"productId"];
    [parameter setValue:[ZYZCAccountTool getUserId] forKey:@"userId"];
    WEAKSELF
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.viewController.view];
        DDLog(@"draft:%@",result);
        if (isSuccess) {
            ZCDetailModel *detailModel=[[ZCDetailModel alloc]mj_setKeyValues:result];
            MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
            
            [manager getDataFromDraft:detailModel andDoFinish:^{
                MoreFZCViewController *fzcViewController=[[MoreFZCViewController alloc]init];
                fzcViewController.editFromDraft=YES;
                fzcViewController.productId=weakSelf.productId;
                [weakSelf.viewController.navigationController pushViewController:fzcViewController animated:YES];
            }];
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

#pragma mark --- 删除草稿
-(void)deleteDraftProduct
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"是否删除该草稿" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alertView.tag=ALERT_DELETE_DRAFT_TAG;
    [alertView show];
}

#pragma mark --- 删除项目
-(void)deleteProduct
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"是否取消该行程" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alertView.tag=ALERT_DELETE_TAG;
    [alertView show];
}
#pragma mark --- 删除我参与的行程
-(void)deleteMyJoinProduct
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"是否取消该行程" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alertView.tag=ALERT_DELETE_MYJOINPRODUCT_TAG;
    [alertView show];
}

#pragma mark --- 选择旅伴
-(void)choosePartner
{
    MyPartnerViewController *partnerViewController=[[MyPartnerViewController alloc]init];
    partnerViewController.myPartnerType=TogtherPartner;
    partnerViewController.productId=_productId;
    [self.viewController.navigationController pushViewController:partnerViewController animated:YES];
}

#pragma mark --- 回报他人
-(void)returnToOther
{
    MyPartnerViewController *partnerViewController=[[MyPartnerViewController alloc]init];
    partnerViewController.myPartnerType=ReturnPartner;
    partnerViewController.productId=_productId;
    partnerViewController.fromMyReturn=YES;
    [self.viewController.navigationController pushViewController:partnerViewController animated:YES];
}

#pragma mark ---延时出发
-(void)delayTravel
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"确认延时出发" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag=ALERT_DELAYTRAVEL_TAG;
    [alert show];
}

#pragma mark ---上传游记
-(void)uploadTravelBlog
{
//    UploadVoucherVC *uploadVC = [[UploadVoucherVC alloc] init];
//    [self.viewController.navigationController pushViewController:uploadVC animated:YES];
}

#pragma mark --- 评价我项目中的人（一起游的人和回报的人）
-(void)commentMyProductPerson
{
    CommentPersonListController *personListController=[[CommentPersonListController alloc]init];
    personListController.productId=_productId;
    //是否有回报的人
    personListController.hasReturnPerson=[_hasReturn isEqual:@1];
    [self.viewController.navigationController pushViewController:personListController animated:YES];
}

#pragma mark ---评价我参与的项目的发起者或者是回报我的人
-(void)commentProductPersonWithType:(NSInteger)commentType
{
    CommentUserViewController *commentViewController=[[CommentUserViewController alloc]init];
    commentViewController.userModel=_userModel;
    commentViewController.productId=_productId;
    commentViewController.commentType=commentType;
    //是否评价过
    commentViewController.hasComment=[_commentStatus isEqual:@1];
//    commentViewController.hasComplain=[_myTsStatus isEqual:@1];
    __weak typeof(&*self)weakSelf=self;
    commentViewController.finishComent=^()
    {
        //更改成已评价状态
        if (commentType==CommentProductPerson) {
            weakSelf.commentStatus = @1;
            [weakSelf.firstEditBtn setTitle:@"已评价" forState:UIControlStateNormal];
            [weakSelf.firstEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
        }
        
        if (commentType==CommentMyReturnProduct) {
            weakSelf.commentStatus = @1;
            [weakSelf.thirdEditBtn setTitle:@"已评价" forState:UIControlStateNormal];
            [weakSelf.thirdEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
        }
    };
    
    [self.viewController.navigationController pushViewController:commentViewController animated:YES];
    
}
#pragma mark --- 申请提现
-(void)applyMoney
{
    //上传凭证
    UploadVoucherVC *uploadVoucherVC=[[UploadVoucherVC alloc]init];
    uploadVoucherVC.productID=_productId;
    __weak typeof (&*self)weakSelf=self;
    uploadVoucherVC.uploadVoucherSuccess=^()
    {
        weakSelf.txstatus = @1;
        [weakSelf.secondEditBtn setTitle:@"审核中" forState:UIControlStateNormal];
        [weakSelf.secondEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    };
    [self.viewController.navigationController pushViewController:uploadVoucherVC animated:YES];
}

#pragma mark --- 确认同游
-(void)acceptInvitation
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"是否确认同游" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag=ALERT_ACCEPT_TAG;
    [alert show];
}



#pragma mark --- 确认收货
-(void)getMyReturn
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"是否已收货" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag=ALERT_GETRETURN_TAG;
    [alert show];
}

#pragma mark --- 确认行程结束
-(void)sureEndTravel
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"确认行程结束" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag=ALERT_SURE_END_TRAVEL_TAG;
    [alert show];
}

#pragma mark --- alert代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *userId=[ZYZCAccountTool getUserId];
    
    if (alertView.tag==ALERT_DELETE_DRAFT_TAG&&buttonIndex==1) {
        //删除草稿
        NSDictionary *param=@
        {
        @"userId":[ZYZCAccountTool getUserId],
        @"productId":_productId
        };
        [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];;
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"product_deleteProduct"] andParameters:param andSuccessGetBlock:^(id result, BOOL isSuccess) {
            [MBProgressHUD hideHUDForView:self.viewController.view];
//            NSLog(@"%@",result);
            if (isSuccess) {
                [MBProgressHUD showSuccess:@"删除成功!"];
                //界面上删除该项目
                MyReturnViewController *draftController=(MyReturnViewController *)self.viewController;
                [draftController deleteProductFromProductId:_productId];
            }
            else{
               [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
            }
        } andFailBlock:^(id failResult) {
//            NSLog(@"%@",failResult);
            [MBProgressHUD hideHUDForView:self.viewController.view];
            [NetWorkManager showMBWithFailResult:failResult];
        }];
    }
    //删除我发起的项目
    else if (alertView.tag==ALERT_DELETE_TAG&&buttonIndex==1) {
        NSDictionary *param=@{
                            @"userId":[ZYZCAccountTool getUserId],
                            @"productId":_productId
                            };
        [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"product_deleteProduct"] andParameters:param andSuccessGetBlock:^(id result, BOOL isSuccess) {
            [MBProgressHUD hideHUDForView:self.viewController.view];
//            NSLog(@"%@",result);
            if (isSuccess) {
                [MBProgressHUD showSuccess:@"取消成功!"];
                MyProductController *myProductController=(MyProductController *)self.viewController;
                [myProductController removeDataByProductId:_productId withMyProductType:K_MyPublishType];
            }
            else{
                [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
            }
        } andFailBlock:^(id failResult) {
//            NSLog(@"%@",failResult);
            [MBProgressHUD hideHUDForView:self.viewController.view];
            [NetWorkManager showMBWithFailResult:failResult];
        }];
    }
    //取消我参与的行程
    else if (alertView.tag==ALERT_DELETE_MYJOINPRODUCT_TAG&&buttonIndex==1)
    {
        [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
        NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"productInfo_delMyStyle4"];
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        [parameter setValue:[NSString stringWithFormat:@"%@", _productId] forKey:@"productId"];
        [parameter setValue:userId forKey:@"userId"];
        WEAKSELF
        [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
            [MBProgressHUD hideHUDForView:self.viewController.view];
            //            NSLog(@"%@",result);
            if (isSuccess) {
                [MBProgressHUD showSuccess:@"取消成功!"];
                weakSelf.joinProductState=@4;
                weakSelf.myPaybackstatus=@0;
                weakSelf.btnTitleArr=@[@"等待确认",@"等待退款",@"评价"];
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
    //确认同游
    else if (alertView.tag==ALERT_ACCEPT_TAG&&buttonIndex==1)
    {
        //判断时间是否有冲突
        
        [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
        //判断时间是否有冲突，如果有则不可支持
        NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"list_checkMyProductsTime"];
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        [parameter setValue:[ZYZCAccountTool getUserId] forKey:@"userId"];
        [parameter setValue:[NSString stringWithFormat:@"%@", _productId] forKey:@"productId"];
        [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
            if ([result[@"data"] isEqual:@0]) {
                
                [MBProgressHUD hideHUDForView:self.viewController.view];
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"此行程与已有行程时间有冲突,确认失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                //求情确认同游
                NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"productInfo_acceptInvitation"];
                NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
                [parameter setValue:[NSString stringWithFormat:@"%@", _productId] forKey:@"productId"];
                [parameter setValue:userId forKey:@"userId"];
                WEAKSELF
                [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
                    if(isSuccess)
                    {
                        [MBProgressHUD showSuccess:@"确认成功"];
                        weakSelf.joinProductState=@3;
                        weakSelf.btnTitleArr=@[@"评价",@"延时出发",@""];
                        weakSelf.commentStatus =@0;//未评论
                        //延时出发状态
                        //上传凭证状态
                    } else {
                        [MBProgressHUD showShortMessage:result[@"errorMsg"]];
                        weakSelf.joinProductState=@0;
                        weakSelf.btnTitleArr=@[@"等待确认",@"取消行程",@"评价"];
                    }
                } andFailBlock:^(id failResult) {
                    [MBProgressHUD hideHUDForView:weakSelf.viewController.view];
                    [NetWorkManager showMBWithFailResult:failResult];
                }];
            }
        } andFailBlock:^(id failResult) {
            [MBProgressHUD hideHUDForView:self.viewController.view];
            [NetWorkManager showMBWithFailResult:failResult];
        }];
    }
    //确认收货
    else if (alertView.tag==ALERT_GETRETURN_TAG&&buttonIndex==1)
    {
        [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
        NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"productInfo_acceptBackpay"];
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        [parameter setValue:[NSString stringWithFormat:@"%@", _productId] forKey:@"productId"];
        [parameter setValue:userId forKey:@"userId"];
        WEAKSELF
        [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
            [MBProgressHUD hideHUDForView:self.viewController.view];
            //            NSLog(@"%@",result);
            if (isSuccess) {
                weakSelf.returnProductState=@3;
                [weakSelf.secondEditBtn setTitle:@"已收货" forState:UIControlStateNormal];
                [weakSelf.secondEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
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
    //确认旅行结束
    else if(alertView.tag==ALERT_SURE_END_TRAVEL_TAG&&buttonIndex==1)
    {
        NSDictionary *param=@{
                              @"userId":[ZYZCAccountTool getUserId],
                              @"productId":_productId
                              };
         //确认行程结束
//        NSString *httpUrl = [NSString stringWithFormat:@"%@product/endTravelProduct.action",BASE_URL]
        NSString *httpUrl = [[ZYZCAPIGenerate sharedInstance] API:@"end_travel_product"];
        
        [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:httpUrl andParameters:param andSuccessGetBlock:^(id result, BOOL isSuccess)
         {
             [MBProgressHUD hideHUDForView:self.viewController.view];
             //我发布的行程
             if(_productType==MyPublishProduct)
             {
                 _endstatus = @1;
                 _txstatus  = @0;
                 [_secondEditBtn setTitle:@"申请提现" forState:UIControlStateNormal];
                 [_secondEditBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
             }
             //我参与的行程
             else if (_productType==MyJionProduct)
             {
                 _myEndstatus = @1;
                [_secondEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
             }
        }
         andFailBlock:^(id failResult)
         {
            [MBProgressHUD hideHUDForView:self.viewController.view];
             [NetWorkManager showMBWithFailResult:failResult];
//            NSLog(@"%@",failResult);
         }];
    }
    //确认延时出发
    else if(alertView.tag==ALERT_DELAYTRAVEL_TAG&&buttonIndex==1)
    {
        NSDictionary *param=@{@"userId":[ZYZCAccountTool getUserId],
                              @"productId":_productId
                              };
//        NSLog(@"param:%@",param);
//        NSString *httpUrl=[NSString stringWithFormat:@"%@product/godelayProduct.action",BASE_URL];
//
        NSString *httpUrl = [[ZYZCAPIGenerate sharedInstance] API:@"delay_product"];
        [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:httpUrl andParameters:param andSuccessGetBlock:^(id result, BOOL isSuccess)
         {
             [MBProgressHUD hideHUDForView:self.viewController.view];
//             NSLog(@"%@",result);
             //我发布的行程
             if(_productType==MyPublishProduct)
             {
                 _godelaystatus=@1;
                 [_secondEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
             }
             //我参与的行程
             else if (_productType==MyJionProduct)
             {
                 _myGodelaystatus=@1;
                [_secondEditBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
             }
        }
          andFailBlock:^(id failResult)
         {
             [MBProgressHUD hideHUDForView:self.viewController.view];
             [NetWorkManager showMBWithFailResult:failResult];
//             NSLog(@"%@",failResult);
         }];
    }
}


-(UIButton *)createBtnWithFrame:(CGRect)frame
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:15];
    return btn;
}

@end
