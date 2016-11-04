//
//  ZYDetailReturnFirstCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/11/3.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYDetailReturnFirstCell.h"
#import "NSDate+RMCalendarLogic.h"
@interface ZYDetailReturnFirstCell ()
@property (nonatomic, strong) NSMutableArray *viewStateArr;
@end

@implementation ZYDetailReturnFirstCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)configUI{
    _viewStateArr=[NSMutableArray array];
    [super configUI];
    [self.topLineView removeFromSuperview];
    [self.titleLab    removeFromSuperview];
}

-(void)setCellModel:(ZCDetailProductModel *)cellModel
{
    _cellModel=cellModel;
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
    
    NSArray *views=[self.bgImg subviews];
    for (UIView *view in views) {
        [view removeFromSuperview];
    }
    NSArray *reportArr=cellModel.report;
    //支持方式重新排序
    //一起游放在第一个
    NSMutableArray *newReportArr=[NSMutableArray array];
    for (NSInteger i=0; i<reportArr.count; i++) {
        ReportModel *reportModel=reportArr[i];
        if ([reportModel.style isEqual:@4]) {
            [newReportArr addObject:reportModel];
            break;
        }
    }
    //回报放在第二个
    for (NSInteger i=0; i<reportArr.count; i++) {
        ReportModel *reportModel=reportArr[i];
        if ([reportModel.style isEqual:@3]) {
            [newReportArr addObject:reportModel];
            break;
        }
    }
    //其他
    for (NSInteger i=0; i<reportArr.count; i++) {
        ReportModel *reportModel=reportArr[i];
        if (![reportModel.style isEqual:@0]&&![reportModel.style isEqual:@3]&&![reportModel.style isEqual:@4]) {
            [newReportArr addObject:reportModel];
        }
    }
    
    CGFloat viewTop=0.0;
    for (NSInteger i=0; i<newReportArr.count; i++) {
        ReportModel *reportModel=newReportArr[i];
            ZCSupportMoneyView *supportMoneyView = [[ZCSupportMoneyView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE,viewTop, self.bgImg.width-2*KEDGE_DISTANCE, 0) andProductDetailModel:cellModel];
            if (i==0) {
                supportMoneyView.lineView.hidden=YES;
            }
            SupportStateModel *stateModel=[SupportStateModel new];
            //判断项目是否是浏览或草稿
            if ((_detailProductType==SkimDetailProduct)||(_detailProductType==
                DraftDetailProduct)) {
                stateModel.canChoose=NO;
            }
            //判断是否是用户自己项目,如果是则回报支持和一起游不可支持
            if ([cellModel.mySelf isEqual:@1]) {
                stateModel.isMyself=YES;
                if ([reportModel.style isEqual:@3]||[reportModel.style isEqual:@4]) {
                    stateModel.canChoose=NO;
                }
            }
            //判断项目是否截止
            if (leftDays==0) {
                stateModel.productEnd=YES;
            }
        
            //如果是回报支持，人数是否达到上限
            if ([reportModel.style isEqual:@3]&&[reportModel.people integerValue]-reportModel.users.count<=0) {
                stateModel.isGetMax=YES;
            }
            //如果是一起游或回报支持，如果已支持过则不能再次支持
            if ([reportModel.style isEqual:@3]||[reportModel.style isEqual:@4]) {
                for (NSInteger i=0; i<reportModel.users.count; i++) {
                    UserModel *user=reportModel.users[i];
                    if ([user.userId integerValue] == [[ZYZCAccountTool getUserId] integerValue]) {
                        stateModel.canChoose=NO;
                        break;
                    }
                }
            }
            if (_viewStateArr.count>=i+1) {
                stateModel=_viewStateArr[i];
            }
            else
            {
                [_viewStateArr addObject:stateModel];
            }
            supportMoneyView.supportStateModel=stateModel;
            supportMoneyView.reportModel=reportModel;
            [self.bgImg addSubview:supportMoneyView];
            viewTop=supportMoneyView.bottom;
    }
    self.bgImg.height=viewTop;
    cellModel.returnFirtCellHeight=self.bgImg.height;
}

-(void)dealloc
{
    DDLog(@"dealloc:%@",[self class]);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
