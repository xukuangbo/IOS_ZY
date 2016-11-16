//
//  ZCProductDetailTableView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCProductDetailTableView.h"

#import "FXBlurView.h"
#import "ZCDetailFirstCell.h"
//介绍部分cells
#import "ZCDetailIntroFirstCell.h"
#import "ZCDetailIntroSecondCell.h"
#import "ZCDetailIntroThirdCell.h"
#import "ZCDetailIntroFourthCell.h"
#import "ZCDetailIntroFifthCell.h"
//行程部分cells
#import "ZCDetailArrangeFirstCell.h"
//回报部分cells
#import "ZYDetailReturnFirstCell.h"
//#import "ZCDetailReturnFirstCell.h"
#import "ZCDetailReturnSecondCell.h"
#import "ZCDetailReturnThridCell.h"
#import "ZCDetailReturnFourthCell.h"

#import "ZCCommentModel.h"
#import "ZCCommentViewController.h"
#import "ZYZCDataBase.h"

#import "ZCProductDetailController.h"
#import "AppDelegate.h"

#import "ZYDetailIUserInfoCell.h"

@interface ZCProductDetailTableView ()
 @property (nonatomic, strong) UIVisualEffectView   *blurView;     //毛玻璃
@property (nonatomic, strong) UILabel               *travelThemeLab;//主题名

@property (nonatomic, strong) UIImageView         *markImageView;
@property (nonatomic, strong) UILabel             *togtherNumLab;

@property (nonatomic, strong) ZCCommentList         *commentList;
@property (nonatomic, assign) ZCDetailContentType   contentType;

@property (nonatomic, assign) NSInteger            togtherNum;

@property (nonatomic, assign) BOOL hasCosponsor;//标记是否有联合发起人
//@property (nonatomic, assign) BOOL hasIntroGoal;//标记是否有众筹目的
@property (nonatomic, assign) BOOL hasTogtherSupport;//标记是否有一起游栏
@property (nonatomic, assign) BOOL hasReturnSupport;//标记是否有回报栏
@property (nonatomic, assign) BOOL hasIntroGeneral;//标记是否有目的地介绍
@property (nonatomic, assign) BOOL hasIntroMovie;//标记是否有动画攻略
@property (nonatomic, assign) BOOL hasSupportView;//标记是否有支持界面
@property (nonatomic, assign) BOOL hasHotComment;//标记是否有热门评论
@property (nonatomic, assign) BOOL hasInterestTravel;//标记是否有兴趣标签匹配的旅游

//@property (nonatomic, strong) ZCDetailReturnFirstCell  *returnFirstCell;

@end

@implementation ZCProductDetailTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self=[super initWithFrame:frame style:style]) {
        self.mj_header=nil;
        self.mj_footer=nil;
        _contentType=IntroType;
        _commentArr =[NSMutableArray array];
         self.contentInset=UIEdgeInsetsMake(BGIMAGEHEIGHT-64, 0, 0, 0);
        _topImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, -BGIMAGEHEIGHT,KSCREEN_W, BGIMAGEHEIGHT)];
        _topImgView.image = [UIImage imageNamed:@"image_placeholder"];
        _topImgView.contentMode = UIViewContentModeScaleAspectFill;
        _topImgView.layer.masksToBounds = YES;
        _topImgView.userInteractionEnabled = YES;
        [self addSubview:_topImgView];
        
         UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _blurView.frame = CGRectMake(0, BGIMAGEHEIGHT-BLURHEIGHT, KSCREEN_W, BLURHEIGHT);
        _blurView.alpha = 0.8;
        [_topImgView addSubview:_blurView];

        //创建旅行主题标签
        _travelThemeLab=[[UILabel alloc]initWithFrame:CGRectMake(20, BGIMAGEHEIGHT-BLURHEIGHT, KSCREEN_W-40, BLURHEIGHT)];
        _travelThemeLab.font=[UIFont boldSystemFontOfSize:20];
        _travelThemeLab.shadowOffset=CGSizeMake(1 , 1);
        _travelThemeLab.shadowColor=[UIColor ZYZC_TextBlackColor];
        _travelThemeLab.adjustsFontSizeToFitWidth=YES;
        _travelThemeLab.textColor=[UIColor whiteColor];
        [_topImgView addSubview:_travelThemeLab];
        
        //添加banner
        UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 64)];
        bgImg.image=[UIImage imageNamed:@"Background"];
        [_topImgView addSubview:bgImg];
        
        [_topImgView addSubview:self.markImageView];
        self.markImageView.hidden=YES;
        
        //支付结果通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPay) name:kGetPayResultNotification object:nil];

        //单独支付一起游0元时的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMySelfInStyle4) name:@"Support_Style4_ZeroYuan_Success" object:nil];
    }
    return self;
}

-(UIImageView *)markImageView
{
    if (!_markImageView) {
        _markImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.topImgView.height-45-30, 0, 30)];
        _markImageView.image=KPULLIMG(@"together_background", 0, 15, 0, 5);
        
        _togtherNumLab = [ZYZCTool createLabWithFrame:CGRectMake(10, 0, _markImageView.width-15, _markImageView.height) andFont:[UIFont systemFontOfSize:13.f] andTitleColor:[UIColor whiteColor]];
        [_markImageView addSubview:_togtherNumLab];
        
        [_markImageView addTarget:self action:@selector(scrollToTogther)];
    }
    return _markImageView;
}

#pragma mark --- 定位到一起去
- (void)scrollToTogther
{
    UIButton *btn=(UIButton *)[self.headView viewWithTag:IntroType];
    [self.headView getContent:btn];
    self.contentOffset=CGPointMake(0, 156);
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

-(void)setTogtherNum:(NSInteger)togtherNum
{
    _togtherNum=togtherNum;
    if (_togtherNum==0) {
        _markImageView.hidden=YES;
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"%ld 人报名一起去",_togtherNum];
        _togtherNumLab.attributedText=[self customStringByString:str andTargetStr:[NSString stringWithFormat:@"%ld",_togtherNum]];
         _markImageView.hidden=NO;
        
        CGFloat length01=[ZYZCTool calculateStrLengthByText:[NSString stringWithFormat:@"%ld",_togtherNum] andFont:[UIFont boldSystemFontOfSize:18.f] andMaxWidth:self.width].width;
        CGFloat length02=[ZYZCTool calculateStrLengthByText:@" 人报名一起去" andFont:[UIFont systemFontOfSize:13.f] andMaxWidth:self.width].width;
        _togtherNumLab.width=length01+length02;
        _markImageView.width=10+_togtherNumLab.width+10;
        _markImageView.left=self.width-_markImageView.width;
        _togtherNumLab.left=10;
    }
}


-(void)setDetailModel:(ZCDetailModel *)detailModel
{
    _detailModel=detailModel;
//    _hasIntroGoal=YES;
    _hasSupportView=YES;
    _hasInterestTravel=NO;
    if (!detailModel.detailProductModel.title) {
        _blurView.hidden=YES;
    }
    _travelThemeLab.text=detailModel.detailProductModel.title;
    
   
    //如果项目是浏览或草稿或自己的
    if (_detailProductType==SkimDetailProduct||
        _detailProductType==DraftDetailProduct||
        [detailModel.detailProductModel.mySelf isEqual:@1]) {
        _hasTogtherSupport=NO;
        _hasReturnSupport=NO;
    }
    else
    {
        _hasTogtherSupport = YES;
        for (NSInteger i=0; i< detailModel.detailProductModel.report.count; i++) {
            ReportModel *report = detailModel.detailProductModel.report[i];
            if ([report.style isEqual:@3]) {
                _hasReturnSupport=YES;
                break;
            }
        }
    }
    
    //获取一起去人数
    ReportModel *togtherReport=nil;
    for (NSInteger i=0; i<detailModel.detailProductModel.report.count; i++) {
        ReportModel *report=detailModel.detailProductModel.report[i];
        if ([report.style isEqual:@4]) {
            togtherReport = report;
            break;
        }
    }
    self.togtherNum=togtherReport.users.count;

    [self reloadData];
}

-(void)setDetailDays:(NSArray *)detailDays
{
    _detailDays=detailDays;
}

-(void)setViewSpots:(NSArray *)viewSpots
{
    _viewSpots=viewSpots;
    if (_viewSpots.count) {
        _hasIntroGeneral=YES;
        [self reloadData];
        _spotVideos=[NSMutableArray array];
        for(OneSpotModel *oneSportModel in _viewSpots){
            NSNumber *viewId=oneSportModel.ID;
            NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"viewSpot_getViewSpotVideo"];
            NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
            [parameter setValue:[NSString stringWithFormat:@"%@", viewId] forKey:@"viewId"];
            [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
                if (isSuccess) {
                    ZCSpotVideoModel *spotVideo=[[ZCSpotVideoModel alloc]mj_setKeyValues:result[@"data"]];
                    if (spotVideo.videoUrl.length) {
                        spotVideo.spotName=oneSportModel.name;
                        [_spotVideos addObject:spotVideo];
                    } ;
                    if (_spotVideos.count) {
                        _hasIntroMovie=YES;
                        [self reloadData];
                    }
                }
            } andFailBlock:^(id failResult) {
                
            }];
        }
    }
}


-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger days=_detailDays.count;
//    days=4;
    //第二组的cell数量
    NSInteger secondSectionCellNumber=
    (2+2*_hasTogtherSupport+2*_hasReturnSupport+2*_hasIntroGeneral+2*_hasIntroMovie*_spotVideos.count)*(self.contentType==IntroType?1:0)
    +2*days*(self.contentType==ArrangeType?1:0)
    +_hasSupportView*(2*_hasSupportView+2*_hasHotComment)*(self.contentType==ReturnType?1:0);
    
    if (section==0) {
        return 2 + 2*_hasCosponsor;
    }
    else
    {
        return  secondSectionCellNumber ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        //个人信息展示
        if(indexPath.row==1)
        {
            NSString *cellId01=@"cellId01";
            ZYDetailIUserInfoCell *userInfoCell=(ZYDetailIUserInfoCell *)[ZYDetailIUserInfoCell customTableView:tableView cellWithIdentifier:cellId01 andCellClass:[ZYDetailIUserInfoCell class]];
            userInfoCell.detailProductModel=_detailModel.detailProductModel;
            return userInfoCell;
        }
        //联和发起人(暂时没有)
        else if (indexPath.row == 1+_hasCosponsor*2&&indexPath.row!=1)
        {
            NSString *cellId02=@"detailFirstCell";
            ZCDetailFirstCell *detailFirstCell=(ZCDetailFirstCell *)[ZYZCBaseTableViewCell customTableView:tableView cellWithIdentifier:cellId02 andCellClass:[ZCDetailFirstCell class]];
            return detailFirstCell;
        }
        else
        {
            UITableViewCell *cell=[ZYZCBaseTableViewCell createNormalCell];
            return cell;
        }
    }
    //第二组内容 indexPath.section==1
    else if (indexPath.section==1)
    {
        ////查看介绍内容
        if (self.contentType==IntroType) {
            if(indexPath.row==0)
            {
                NSString *introFirstCellId=@"introFirstCell";
                ZCDetailIntroFirstCell *introFirstCell=(ZCDetailIntroFirstCell *)[ZYZCBaseTableViewCell customTableView:tableView cellWithIdentifier:introFirstCellId andCellClass:[ZCDetailIntroFirstCell class]];
                introFirstCell.cellModel=_detailModel.detailProductModel;
                return  introFirstCell;
            }
            else if (indexPath.row == 2&&_hasTogtherSupport)
            {
                NSString *introFourthCellId=@"introFourthCell";
                ZCDetailIntroFourthCell *introFourthCell=(ZCDetailIntroFourthCell *)[ZYZCBaseTableViewCell customTableView:tableView cellWithIdentifier:introFourthCellId andCellClass:[ZCDetailIntroFourthCell class]];
                introFourthCell.detailProductType=_detailProductType;
                introFourthCell.detailModel =_detailModel.detailProductModel;
                return  introFourthCell;
            }
            else if (indexPath.row == 2+2*_hasTogtherSupport && _hasReturnSupport)
            {
                NSString *introFifthCellId=@"introFifthCell";
                ZCDetailIntroFifthCell *introFifthCell=(ZCDetailIntroFifthCell *)[ZYZCBaseTableViewCell customTableView:tableView cellWithIdentifier:introFifthCellId andCellClass:[ZCDetailIntroFifthCell class]];
                introFifthCell.detailProductType=_detailProductType;
                introFifthCell.detailModel =_detailModel.detailProductModel;
                return  introFifthCell;
            }
            else if (indexPath.row == 2+2*_hasTogtherSupport+2*_hasReturnSupport && _hasIntroGeneral)
            {
                NSString *introSecondCellId=@"introSecondCell";
                ZCDetailIntroSecondCell *introSecondCell=(ZCDetailIntroSecondCell *)[ZYZCBaseTableViewCell customTableView:tableView cellWithIdentifier:introSecondCellId andCellClass:[ZCDetailIntroSecondCell class]];
                introSecondCell.goals=_viewSpots;
                return introSecondCell;
            }
            else if (indexPath.row >=2+2*_hasTogtherSupport+2*_hasReturnSupport +2*_hasIntroGeneral &&indexPath.row <=2+2*_hasTogtherSupport+2*_hasReturnSupport +2*_hasIntroGeneral+2*_hasIntroMovie*_spotVideos.count&&(indexPath.row-(2+2*_hasTogtherSupport+2*_hasReturnSupport +2*_hasIntroGeneral))%2==0&& _hasIntroMovie)
            {
                NSString *introThirdCellId=@"introThirdCell";
                ZCDetailIntroThirdCell *introThirdCell=(ZCDetailIntroThirdCell *)[ZYZCBaseTableViewCell customTableView:tableView cellWithIdentifier:introThirdCellId andCellClass:[ZCDetailIntroThirdCell class]];
                ZCSpotVideoModel *spotVideoModel=_spotVideos[(indexPath.row-2-2*_hasTogtherSupport-2*_hasReturnSupport -2*_hasIntroGeneral)/2];
                introThirdCell.spotVideoModel=spotVideoModel;
                introThirdCell.subDesLab.text=SUBDES_FORMOVIE(spotVideoModel.spotName);
                return introThirdCell;
                
            }
            else
            {
                UITableViewCell *cell=[ZYZCBaseTableViewCell createNormalCell];
                return cell;
            }
        }
        //查看行程内容
        else if (self.contentType == ArrangeType)
        {
            if (indexPath.row%2==0) {
                NSString *arrangeCellId=[NSString stringWithFormat:@"arrangeCell%ld",indexPath.row];
                ZCDetailArrangeFirstCell *arrangeCell=(ZCDetailArrangeFirstCell *)[ZYZCBaseTableViewCell customTableView:tableView cellWithIdentifier:arrangeCellId andCellClass:[ZCDetailArrangeFirstCell class]];
                arrangeCell.faceImg=_detailModel.detailProductModel.user.faceImg;
                arrangeCell.startDay=_detailModel.detailProductModel.start_time;
                arrangeCell.oneDaydetailModel=_detailDays[indexPath.row/2];
                return arrangeCell;
            }
            else{
                UITableViewCell *cell=[ZYZCBaseTableViewCell createNormalCell];
                return cell;
            }
        }
        //查看回报内容
        else
        {
            if (indexPath.row==0&&_hasSupportView) {
                NSString *returnFirstCellId=@"returnFirstCell";
                ZYDetailReturnFirstCell *returnFirstCell=(ZYDetailReturnFirstCell *)[ZYZCBaseTableViewCell customTableView:tableView cellWithIdentifier:returnFirstCellId andCellClass:[ZYDetailReturnFirstCell class]];
                returnFirstCell.detailProductType=_detailProductType;
                returnFirstCell.cellModel=_detailModel.detailProductModel;
                return returnFirstCell;
            }
            else if (indexPath.row==2*_hasHotComment &&indexPath.row !=0)
            {
                NSString *returnSecondCellId=@"returnSecondCell";
                ZCDetailReturnSecondCell *returnSecondCell=(ZCDetailReturnSecondCell *)[ZYZCBaseTableViewCell customTableView:tableView cellWithIdentifier:returnSecondCellId andCellClass:[ZCDetailReturnSecondCell class]];
                returnSecondCell.commentList=_commentList;
                return returnSecondCell;
            }
            UITableViewCell *cell=[ZYZCBaseTableViewCell createNormalCell];
            return cell;
        }
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        if (indexPath.row ==1)
        {
             return USER_INFO_CELL_HEIGHT;
        }
        else if (indexPath.row==1+_hasCosponsor*2&&indexPath.row!=1)
        {
            return ZCDETAIL_FIRSTCELL_HEIGHT;
        }
        else
        {
            return KEDGE_DISTANCE;
        }
    }
    else
    {
        //介绍部分cells高度
        if (self.contentType == IntroType) {
            if (indexPath.row==0) {
                return _detailModel.detailProductModel.introFirstCellHeight;
            }
            else if (indexPath.row == 2&&_hasTogtherSupport)
            {
                return  _detailModel.detailProductModel.introFourthCellHeight;
            }
            else if (indexPath.row == 2+2*_hasTogtherSupport&&_hasReturnSupport)
            {
                return _detailModel.detailProductModel.introFifthCellHeight;
            }
            else if (indexPath.row == 2+2*_hasTogtherSupport+2*_hasReturnSupport && _hasIntroGeneral)
            {
                return ZCDETAILINTRO_SECONDCELL_HEIGHT;
            }
            else if (_hasIntroMovie&&indexPath.row >=2+2*_hasTogtherSupport+2*_hasReturnSupport +2*_hasIntroGeneral &&indexPath.row <=2+2*_hasTogtherSupport+2*_hasReturnSupport +2*_hasIntroGeneral+2*_hasIntroMovie*_spotVideos.count&&(indexPath.row-(2+2*_hasTogtherSupport+2*_hasReturnSupport +2*_hasIntroGeneral))%2==0)
            {
                return ZCDETAILINTRO_THIRDCELL_HEIGHT;
            }
            else
            {
                return KEDGE_DISTANCE;
            }
        }
        //行程部分cells高度
        else if (self.contentType == ArrangeType)
        {
            if (indexPath.row%2==0) {
                MoreFZCTravelOneDayDetailMdel *oneDetailModel=_detailDays[indexPath.row/2];
                return oneDetailModel.cellHeight;
            }
            else{
                return KEDGE_DISTANCE;
            }
        }
        //回报部分cells高度
        else
        {
            if (indexPath.row ==0&&_hasSupportView) {
                return _detailModel.detailProductModel.returnFirtCellHeight;
            }
            else if (indexPath.row==2*_hasHotComment &&indexPath.row !=0)
            {
                return _commentList.listCommentHeight;
            }
            return KEDGE_DISTANCE;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        if(!_headView){
            _headView=[[ZCDetailTableHeadView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W,ZCDETAIL_SECONDSECTION_HEIGHT)];
        };
        __weak typeof (&*self)weakSelf=self;
        _headView.clickChangeContent=^(ZCDetailContentType contentType)
        {
            if (contentType==IntroType||contentType==ArrangeType) {
                
            }
            
            if (weakSelf.contentType!=contentType) {
                weakSelf.contentType=contentType;
                BOOL changeOffSet=NO;
                CGFloat offSetY=210+2*KEDGE_DISTANCE+weakSelf.hasCosponsor*ZCDETAIL_FIRSTCELL_HEIGHT-64;
                CGPoint offSet=weakSelf.contentOffset;
                if (offSet.y>offSetY) {
                    changeOffSet=YES;
                }
                if(contentType==ReturnType&&weakSelf.productId)
                {
                    [weakSelf getHotComment];
                }
                [weakSelf reloadData];
                
                if (changeOffSet) {
                    weakSelf.contentOffset=CGPointMake(0, offSetY);
                }
                else
                {
                    weakSelf.contentOffset=offSet;
                }
            }
        };
        
        return _headView;
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return ZCDETAIL_SECONDSECTION_HEIGHT;
    }
    return 0.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1&&self.contentType==ReturnType) {
        if (indexPath.row==2) {
            ZCCommentViewController *commentVC=[[ZCCommentViewController alloc]init];
            commentVC.productId=_productId;
            commentVC.user=_detailModel.detailProductModel.user;
            commentVC.title=@"评论";
            [self.viewController.navigationController pushViewController:commentVC animated:YES];
        }
    }
}

#pragma mark --- tableView的滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"contentSize.height:%.2f",scrollView.contentSize.height);
    //图片拉伸效果
     CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"%.2f",offsetY);
    if (offsetY <= -BGIMAGEHEIGHT)
    {
        CGRect frame = _topImgView.frame;
        frame.origin.y = offsetY;
        frame.size.height = -offsetY;
        _topImgView.frame = frame;
        _blurView.top=_topImgView.height-BLURHEIGHT;
        _travelThemeLab.top=_blurView.top;
        
    }
    //改变table的contentInset
    if (offsetY>-64) {
        self.contentInset=UIEdgeInsetsMake(64, 0, 0, 0);
    }
    else
    {
        self.contentInset=UIEdgeInsetsMake(BGIMAGEHEIGHT, 0, 0, 0);
    }

    if (self.scrollDidScrollBlock) {
        self.scrollDidScrollBlock(offsetY);
    }
}

#pragma mark --- 获取热门评论
-(void)getHotComment
{
    
//    __weak typeof (&*self)weakSelf=self;
    NSDictionary  *parameters=@{@"userId":[ZYZCAccountTool getUserId],
                                @"productId":_productId,
                                @"pageNO":@1,
                                @"pageSize":@5
                                };
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"comment_listZhongchouComment"];
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        NSLog(@"%@",result);
        [_commentArr removeAllObjects];
        if (isSuccess) {
            self.commentList=[[ZCCommentList alloc]mj_setKeyValues:result];
            for(ZCCommentModel *commentModel in _commentList.commentList)
            {
                [_commentArr addObject:commentModel];
            }
            if ( _commentArr.count) {
                _hasHotComment=YES;
                [self reloadData];
            }
        }
    } andFailBlock:^(id failResult) {

    }];
}

#pragma mark --- 支付回调
-(void)getOrderPay{
    
     AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (appDelegate.orderModel.orderType!=1) {
        return;
    }
    
    ZCProductDetailController *detailController=(ZCProductDetailController *)self.viewController;
    [detailController reloadPartInfo];
    
    NSString *userId=[ZYZCAccountTool getUserId];
    
    //判断支付是否成功
//    NSString *httpUrl=GET_ORDERPAY_STATUS(userId, appDelegate.out_trade_no);
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"productInfo_getOrderPayStatus"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:appDelegate.orderModel.out_trade_no forKey:@"outTradeNo"];
    [parameter setValue:userId forKey:@"userId"];
    WEAKSELF
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        DDLog(@"+++++++++%@",result);
        NSArray *arr=result[@"data"];
        NSDictionary *dic=nil;
        if (arr.count) {
            dic=[arr firstObject];
        }
        BOOL payResult=[[dic objectForKey:@"buyStatus"] boolValue];
        if (appDelegate.orderModel.payResult==YES) {
            payResult=YES;
        }
        //支付成功
        if(payResult){
//            [MBProgressHUD showSuccess:@"支付成功!"];
            [weakSelf addMyselfInStyles:arr];
        }
        else{
//            [MBProgressHUD showError:@"支付失败!"];
        }
        //发出支付结果的通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getPayResult" object:[NSNumber numberWithBool:payResult]];
        
        //还原订单状态
        [appDelegate.orderModel initOrderState];
        
    } andFailBlock:^(id failResult) {
//        [MBProgressHUD showError:@"网络出错,支付失败!"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getPayResult" object:[NSNumber numberWithBool:NO]];
    }];
}

#pragma mark --- 支持后添加个人头像到对应支持栏中
-(void)addMyselfInStyles:(NSArray *)styles
{
    ZYZCAccountModel *accountModel=[ZYZCAccountTool account];
    UserModel *mySelf=[UserModel new];
    mySelf.userId=accountModel.userId;
    mySelf.faceImg=accountModel.faceImg;
    mySelf.faceImg64=accountModel.faceImg64;
    mySelf.faceImg132=accountModel.faceImg132;
    mySelf.faceImg640=accountModel.faceImg640;
    for (int i=0; i<styles.count; i++) {
        NSDictionary *dic=styles[i];
        for (ReportModel *reportModel in _detailModel.detailProductModel.report) {
            if ([reportModel.style isEqual:dic[@"style"]]) {
                BOOL hasMyUser=NO;
                for (UserModel *user in reportModel.users) {
                    if ([mySelf.userId isEqual:user.userId]) {
                        hasMyUser=YES;
                        break;
                    }
                }
                if (!hasMyUser) {
                    NSMutableArray *mutArr=[NSMutableArray arrayWithArray:reportModel.users];
                    [mutArr addObject:mySelf];
                    reportModel.users=mutArr;
                }
            }
        }
    }
    [self reloadData];

//    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
//    //获取用户的user
//    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"u_getUserByOpenId"];
//    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    [parameter setValue:[ZYZCAccountTool getUserId] forKey:@"userId"];
//    
//    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
//        [MBProgressHUD hideHUDForView:self.viewController.view];
//        //         NSLog(@"%@",result);
//        if (isSuccess) {
//            UserModel *myUser=[[UserModel alloc]mj_setKeyValues:result[@"data"]];
//            
//            for (int i=0; i<styles.count; i++) {
//                NSDictionary *dic=styles[i];
//                for (ReportModel *reportModel in _detailModel.detailProductModel.report) {
//                    if ([reportModel.style isEqual:dic[@"style"]]) {
//                        BOOL hasMyUser=NO;
//                        for (UserModel *user in reportModel.users) {
//                            if ([myUser.userId isEqual:user.userId]) {
//                                hasMyUser=YES;
//                                break;
//                            }
//                        }
//                        if (!hasMyUser) {
//                            NSMutableArray *mutArr=[NSMutableArray arrayWithArray:reportModel.users];
//                            [mutArr addObject:myUser];
//                            reportModel.users=mutArr;
//                        }
//                    }
//                }
//            }
//            [self reloadData];
//        }
//    } andFailBlock:^(id failResult) {
//        [MBProgressHUD hideHUDForView:self.viewController.view];
//    }];
}

#pragma mark --- (一起游为零元)支持一起游成功
-(void)addMySelfInStyle4
{
    ZYZCAccountModel *accountModel=[ZYZCAccountTool account];
    UserModel *mySelf=[UserModel new];
    mySelf.userId=accountModel.userId;
    mySelf.img=accountModel.faceImg;
    mySelf.faceImg=accountModel.faceImg;
    mySelf.faceImg64=accountModel.faceImg64;
    mySelf.faceImg132=accountModel.faceImg132;
    mySelf.faceImg640=accountModel.faceImg640;
    for (ReportModel *reportModel in _detailModel.detailProductModel.report) {
        if ([reportModel.style isEqual:@4]) {
            BOOL hasMyUser=NO;
            for (UserModel *user in reportModel.users) {
                if ([mySelf.userId isEqual:user.userId]) {
                    hasMyUser=YES;
                    break;
                }
            }
            if (!hasMyUser) {
                NSMutableArray *mutArr=[NSMutableArray arrayWithArray:reportModel.users];
                [mutArr addObject:mySelf];
                reportModel.users=mutArr;
            }
        }
    }
    [self reloadData];

//    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
//    //获取用户的user
//    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"u_getUserByOpenId"];
//    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    [parameter setValue:[ZYZCAccountTool getUserId] forKey:@"userId"];
//    
//    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
//        [MBProgressHUD hideHUDForView:self.viewController.view];
//        [MBProgressHUD hideHUDForView:self.viewController.view];
//        //         NSLog(@"%@",result);
//        if (isSuccess) {
//            UserModel *myUser=[[UserModel alloc]mj_setKeyValues:result[@"data"]];
//            
//            for (ReportModel *reportModel in _detailModel.detailProductModel.report) {
//                if ([reportModel.style isEqual:@4]) {
//                    BOOL hasMyUser=NO;
//                    for (UserModel *user in reportModel.users) {
//                        if ([myUser.userId isEqual:user.userId]) {
//                            hasMyUser=YES;
//                            break;
//                        }
//                    }
//                    if (!hasMyUser) {
//                        NSMutableArray *mutArr=[NSMutableArray arrayWithArray:reportModel.users];
//                        [mutArr addObject:myUser];
//                        reportModel.users=mutArr;
//                        [self reloadData];
//                    }
//                }
//            }
//        }
//    } andFailBlock:^(id failResult) {
//        [MBProgressHUD hideHUDForView:self.viewController.view];
//    }];
}

#pragma mark --- 改变文字样式
-(NSAttributedString *)customStringByString:(NSString *)str andTargetStr:(NSString *)targetStr
{
    NSMutableAttributedString *attrStr=[[NSMutableAttributedString alloc]initWithString:str];
    NSRange range=[str rangeOfString:targetStr];
    if (str.length) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18.f] range:range];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
    }
    return  attrStr;
}


-(void)dealloc
{
//    NSLog(@"dealloc:%@",self.class);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
