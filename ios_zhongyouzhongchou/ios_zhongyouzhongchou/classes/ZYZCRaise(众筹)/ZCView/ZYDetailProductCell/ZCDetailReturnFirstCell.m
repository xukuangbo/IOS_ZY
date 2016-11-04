//
//  ZCDetailReturnFirstCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/25.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define HASSUPPORTPEOPLE(numberPeople) [NSString stringWithFormat:@"已支持:%d位",numberPeople]
#define RETURNSUPPORT01(money) [NSString stringWithFormat:@"回报支持:%.2f元",money]
#define RETURNSUPPORT02(money) [NSString stringWithFormat:@"回报支持二:%.2f元",money]

#define TOGETHERSUPPORT(rate,money) [NSString stringWithFormat:@"一起去:支持%d％旅费(%.2f)元",rate,money]

//获取项目中支持各项的人
#define GET_STYLE_USERS(productId) [NSString stringWithFormat:@"%@productInfo/getStyleUsers.action?productId=%@",BASE_URL,productId]

#import "ZCDetailReturnFirstCell.h"
#import "StylesUserModel.h"
#import "NSDate+RMCalendarLogic.h"
@interface ZCDetailReturnFirstCell ()
@property (nonatomic, strong) NSMutableArray *mySubViews;
@property(nonatomic,  strong) NSNumber *supportOneMoney;
@property(nonatomic,  strong) NSNumber *supportAnyMoney;
@property (nonatomic, strong) NSNumber *returnMoney01;
@property (nonatomic, strong) NSNumber *returnMoney02;
@property (nonatomic, strong) NSNumber *togetherMoney;

@property (nonatomic, assign) BOOL    hasSupportOneYuan;
@property (nonatomic, assign) BOOL    hasSupportAnyYuan;
@property (nonatomic, assign) BOOL    hasSupportReturn;
@property (nonatomic, assign) BOOL    hasSupportTogther;

//@property (nonatomic, strong) StylesUserModel *stylesUserModel;
@end

@implementation ZCDetailReturnFirstCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)configUI{
    [super configUI];
    [self.topLineView removeFromSuperview];
    [self.titleLab  removeFromSuperview];
    
    NSString *text01=ZYLocalizedString(@"skim_support_one_yuan");
    NSString *text02=ZYLocalizedString(@"skim_supoort_any_yuan");
    NSString *text03=ZYLocalizedString(@"skim_support_return"  );
    NSString *text04=ZYLocalizedString(@"skim_support_together");
    
    _mySubViews=[NSMutableArray array];
    
    //一起游
    _togetherView =[[ZCSupportTogetherView alloc]initSupportViewByTop:0 andTitle:TOGETHERSUPPORT(0,0.00) andText:text04 ];
    [self.contentView addSubview:_togetherView];
    [_mySubViews addObject:_togetherView];
    
    //回报
    _returnSupportView01 =[[ZCSupportReturnView alloc]initSupportViewByTop:_togetherView.bottom andTitle:RETURNSUPPORT01(0.00) andText:text03];
    [self.contentView addSubview:_returnSupportView01];
    [_mySubViews addObject:_returnSupportView01];
    
    //支持5元
    _supportOneYuanView =[[ZCSupportOneYuanView alloc]initSupportViewByTop:_returnSupportView01.bottom andTitle:@"支持5元" andText:text01 ];
    [self.contentView addSubview:_supportOneYuanView];
    [_mySubViews addObject:_supportOneYuanView];
    
    //支持任意金额
    _supportAnyYuanView =[[ZCSupportAnyYuanView alloc]initSupportViewByTop:_supportOneYuanView.bottom andTitle:@"支持任意金额:" andText:text02];
    [self.contentView addSubview:_supportAnyYuanView];
    [_mySubViews addObject:_supportAnyYuanView];
//    _supportAnyYuanView.chooseSupport=NO;
    
    
//    _returnSupportView02 =[[ZCSupportReturnView alloc]initSupportViewByTop:_returnSupportView01.bottom andTitle:RETURNSUPPORT02(0.00) andText:text03];
//    [self.contentView addSubview:_returnSupportView02];
//    [_mySubViews addObject:_returnSupportView02];
    
   
     [self supportCode];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPayResult:) name:@"getPayResult" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanSupportUI) name:@"Support_Style4_ZeroYuan_Success" object:nil];

 }

-(void)setCellModel:(ZCDetailProductModel *)cellModel
{
    BOOL hasReturn01=NO,hasReturn02=NO;
    
    NSString *myUserId=[ZYZCAccountTool getUserId];
    
    _cellModel=cellModel;
    NSArray *report=cellModel.report;
    CGFloat totalMoney=cellModel.spell_buy_price?[cellModel.spell_buy_price floatValue]:0.0;
    for (ReportModel *reportModel in report) {
//        if ([reportModel.style intValue]==0) {
//            if (reportModel.price) {
//                 totalMoney=[reportModel.price floatValue];
//            }
//        }
        //支持一元
         if ([reportModel.style intValue]==1) {
            _supportOneYuanView.users=reportModel.users;
//            _hasSupportOneYuan=NO;
//            for (UserModel *user in _supportOneYuanView.users) {
//                if ([myUserId isEqual:user.userId]) {
//                    _hasSupportOneYuan=YES;
//                    break;
//                }
//            }
//            if (_hasSupportOneYuan) {
//                _supportOneYuanView.chooseSupport=NO;
//            }
        }
        //支持任意金额
        else if ([reportModel.style intValue]==2)
        {
            _supportAnyYuanView.users=reportModel.users;
            _hasSupportAnyYuan=NO;
            for (UserModel *user in _supportAnyYuanView.users) {
                if ([myUserId isEqual:[user.userId stringValue]]) {
                    _hasSupportAnyYuan=YES;
                    break;
                }
            }
        }
        //回报支持
        else if ([reportModel.style intValue]==3)
        {
            hasReturn01=YES;
            _returnSupportView01.limitNumber=[reportModel.sumPeople intValue];
            CGFloat money=[reportModel.price floatValue]/100;
            _returnMoney01=[NSNumber numberWithFloat:money];
            _returnSupportView01.titleLab.text=RETURNSUPPORT01(money);
            _returnSupportView01.titleLab.width=[ZYZCTool calculateStrLengthByText:RETURNSUPPORT01(money) andFont:[UIFont systemFontOfSize:15] andMaxWidth:KSCREEN_W].width;
            
            [_returnSupportView01 reloadDataByVideoImgUrl:reportModel.spellVideoImg andPlayUrl:reportModel.spellVideo andVoiceUrl:reportModel.spellVoice andVoiceLen:reportModel.spellVoiceLen andFaceImg:cellModel.user.faceImg andDesc:reportModel.desc andImgUrlStr:reportModel.descImgs];
            
            _returnSupportView01.users=reportModel.users;
            _hasSupportReturn=NO;
            for (UserModel *user in _returnSupportView01.users) {
                if ([myUserId isEqual:[user.userId stringValue]]) {
                    _hasSupportReturn=YES;
                    break;
                }
            }
            if ([reportModel.sumPeople integerValue]<=reportModel.users.count) {
                _returnSupportView01.getLimit=YES;
            }
            if ([_cellModel.mySelf isEqual:@1]||_hasSupportReturn) {
                _returnSupportView01.chooseSupport=NO;
            }
        }
        //一起游
        else if ([reportModel.style intValue]==4)
        {
            _togetherView.limitNumber=[reportModel.people intValue];
            CGFloat money=[reportModel.price floatValue]/100;
            _togetherMoney=[NSNumber numberWithFloat:money];
            int  rate=0;
            if (totalMoney>0) {
                rate=(int)([reportModel.price floatValue]/totalMoney*100+0.5);
            }
            _togetherView.titleLab.text=TOGETHERSUPPORT(rate,money);
            CGFloat titleWidth=[ZYZCTool calculateStrLengthByText:TOGETHERSUPPORT(rate,money) andFont:[UIFont systemFontOfSize:15] andMaxWidth:KSCREEN_W].width;
            _togetherView.titleLab.width=MIN(titleWidth, _togetherView.width-50);
            
             [_togetherView reloadDataByVideoImgUrl:reportModel.spellVideoImg andPlayUrl:reportModel.spellVideo andVoiceUrl:reportModel.spellVoice andVoiceLen:reportModel.spellVoiceLen andFaceImg:cellModel.user.faceImg andDesc:reportModel.desc andImgUrlStr:reportModel.descImgs];
            
             _togetherView.users=reportModel.users;
            _hasSupportTogther=NO;
            
            for (UserModel *user in _togetherView.users) {
                if ([myUserId  isEqual:[user.userId stringValue]]) {
                    _hasSupportTogther=YES;
                    break;
                }
            }
            if ([_cellModel.mySelf isEqual:@1]||_hasSupportTogther) {
                _togetherView.chooseSupport=NO;
            }
        }
        else if ([reportModel.style intValue]==5)
        {
            hasReturn02=YES;
            _returnSupportView02.limitNumber=[reportModel.sumPeople intValue];
            CGFloat money=[reportModel.price floatValue]/100;
            _returnMoney02=[NSNumber numberWithFloat:money];
            _returnSupportView02.titleLab.text=RETURNSUPPORT02(money);
            _returnSupportView02.titleLab.width=[ZYZCTool calculateStrLengthByText:RETURNSUPPORT02(money) andFont:[UIFont systemFontOfSize:15] andMaxWidth:KSCREEN_W].width;
             [_returnSupportView02 reloadDataByVideoImgUrl:reportModel.spellVideoImg andPlayUrl:reportModel.spellVideo andVoiceUrl:reportModel.spellVoice andVoiceLen:reportModel.spellVoiceLen andFaceImg:cellModel.user.faceImg andDesc:reportModel.desc andImgUrlStr:reportModel.descImgs];
             _returnSupportView02.users=reportModel.users;
            BOOL hasSupportReturnMoney=NO;
            for (UserModel *user in _returnSupportView02.users) {
                if ([myUserId isEqual:[user.userId stringValue]]) {
                    hasSupportReturnMoney=YES;
                    break;
                }
            }
            if ([reportModel.sumPeople integerValue]<=reportModel.users.count||[_cellModel.mySelf isEqual:@1]||hasSupportReturnMoney) {
                _returnSupportView02.chooseSupport=NO;
            }
        }
    }
    
    _returnSupportView01.mySelf=_togetherView.mySelf
    =_returnSupportView02.mySelf=[_cellModel.mySelf isEqual:@1];
    
//    _supportAnyYuanView.top=_supportOneYuanView.bottom;
//    hasReturn01? _returnSupportView01.top =_supportAnyYuanView.bottom:[_returnSupportView01 removeFromSuperview];
//    hasReturn02?_returnSupportView02.top =_supportAnyYuanView.bottom+_returnSupportView01.height*hasReturn01:[_returnSupportView02 removeFromSuperview];
//    _togetherView.top =_supportAnyYuanView.bottom+_returnSupportView01.height*hasReturn01+_returnSupportView02.height*hasReturn02;
//    self.bgImg.height=_togetherView.bottom;
    
    
    _returnSupportView01.top=_togetherView.bottom;
    
    if (!hasReturn01) {
        _returnSupportView01.hidden=YES;
        _returnSupportView01.height=0.1;
    }
    
    _supportOneYuanView.top=_returnSupportView01.bottom;
    
    _supportAnyYuanView.top=_supportOneYuanView.bottom;
    
    self.bgImg.height=_supportAnyYuanView.bottom;
    
    cellModel.returnFirtCellHeight=self.bgImg.height;
    
    //判断项目众筹是否已截止
    //剩余天数
    int leftDays=0;
    if (cellModel.spell_end_time.length>8) {
        NSString *productEndStr=[NSDate changStrToDateStr:cellModel.spell_end_time];
        NSDate *productEndDate=[NSDate dateFromString:productEndStr];
        leftDays=[NSDate getDayNumbertoDay:[NSDate date] beforDay:productEndDate]+1;
        if (leftDays<0) {
            leftDays=0;
        }
    }
    if (leftDays==0) {
        _supportOneYuanView.productEndTime=_supportAnyYuanView.productEndTime=_returnSupportView01.productEndTime=_returnSupportView02.productEndTime=_togetherView.productEndTime=YES;
    }
    
    //如果是草稿,支持按钮不可点
    if(_detailProductType==SkimDetailProduct||_detailProductType==DraftDetailProduct)
    {
        _supportOneYuanView.supportBtn.enabled=_supportAnyYuanView.supportBtn.enabled=_returnSupportView01.supportBtn.enabled=_returnSupportView02.supportBtn.enabled=_togetherView.supportBtn.enabled=NO;
    }

}


#pragma ark --- 支持
-(void)supportCode
{
    __weak typeof (&*self)weakSelf=self;
    _supportOneYuanView.supportBlock=_supportAnyYuanView.supportBlock=_returnSupportView01.supportBlock=_returnSupportView02.supportBlock=_togetherView.supportBlock=^()
    {
        BOOL showSupport=NO;
        for (ZCSupportBaseView *view in weakSelf.mySubViews) {
            if (view.sureSupport) {
                
                showSupport=YES;
            }
        }
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        if (weakSelf.supportOneYuanView.sureSupport) {
            [dic setObject:@5 forKey:@"style1"];
        }
        if (weakSelf.supportAnyYuanView.sureSupport) {
            NSNumber *anyMoney=nil;
            if (!weakSelf.supportAnyYuanView.textField.text.length) {
                anyMoney=@0;
            }
            else
            {
                CGFloat money=[weakSelf.supportAnyYuanView.textField.text floatValue];
                anyMoney=[NSNumber numberWithFloat:money];
            }
            [dic setObject:anyMoney forKey:@"style2"];
        }
        if (weakSelf.returnSupportView01.sureSupport) {
            [dic setObject:weakSelf.returnMoney01 forKey:@"style3"];
        }
        if (weakSelf.returnSupportView02.sureSupport) {
            [dic setObject:weakSelf.returnMoney02 forKey:@"style5"];
        }
        if (weakSelf.togetherView.sureSupport) {
            [dic setObject:weakSelf.togetherMoney forKey:@"style4"];
        }
        NSData *data = [NSJSONSerialization dataWithJSONObject :dic options : NSJSONWritingPrettyPrinted error:NULL];
        NSString *jsonStr = [[ NSString alloc ] initWithData :data encoding : NSUTF8StringEncoding];
        if (showSupport) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KCAN_SUPPORT_MONEY object:jsonStr];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:KCAN_SUPPORT_MONEY object:@"hidden"];
        }
    };
}

#pragma mark --- 获取项目中支持各项的人（暂时没用到）
-(void)getOrderFailWithMaxStyle3
{
//    NSLog(@"+++++++%@",GET_STYLE_USERS(_cellModel.productId));
        [ZYZCHTTPTool getHttpDataByURL:GET_STYLE_USERS(_cellModel.productId) withSuccessGetBlock:^(id result, BOOL isSuccess)
        {
//            NSLog(@"++++%@",result);
            if (isSuccess) {
             StylesUserModel *stylesUserModel=[[StylesUserModel alloc]mj_setKeyValues:result[@"data"]];
                if (stylesUserModel.style1.count) {
                    _supportOneYuanView.users=stylesUserModel.style1;
                    for (ReportModel *reportModel in _cellModel.report)
                    {
                        if ([reportModel.style isEqual:@1]) {
                            reportModel.users=stylesUserModel.style1;
                        }
                    }
                }
                else if (stylesUserModel.style2.count)
                {
                    _supportAnyYuanView.users=stylesUserModel.style2;
                    for (ReportModel *reportModel in _cellModel.report)
                    {
                        if ([reportModel.style isEqual:@2]) {
                            reportModel.users=stylesUserModel.style2;
                        }
                    }

                }
                else if (stylesUserModel.style3.count)
                {
                    _returnSupportView01.users=stylesUserModel.style3;
                    for (ReportModel *reportModel in _cellModel.report)
                    {
                        if ([reportModel.style isEqual:@3]) {
                            reportModel.users=stylesUserModel.style3;
                        }
                    }

                }
                else if (stylesUserModel.style4.count)
                {
                    _togetherView.users=stylesUserModel.style4;
                    for (ReportModel *reportModel in _cellModel.report)
                    {
                        if ([reportModel.style isEqual:@4]) {
                            reportModel.users=stylesUserModel.style4;
                        }
                    }
                }
                [self.getSuperTableView reloadData];
            }
    
        } andFailBlock:^(id failResult) {
//            NSLog(@"%@",failResult);
        }];

}

#pragma mark --- 获取支付结果的通知
-(void)getPayResult:(NSNotification *)notify
{
    [self cleanSupportUI];
}

-(void)cleanSupportUI
{
    _supportOneYuanView.sureSupport=NO;
    _supportAnyYuanView.sureSupport=NO;
    _supportAnyYuanView.textField.text=nil;
    _returnSupportView01.sureSupport=NO;
    _togetherView.sureSupport=NO;
}

-(void)dealloc
{
//    NSLog(@"dealloc:%@",self.class);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end








