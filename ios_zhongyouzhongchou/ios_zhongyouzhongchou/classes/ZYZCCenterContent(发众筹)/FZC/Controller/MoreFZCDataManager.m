//
//  MoreFZCDataManager.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCDataManager.h"
#import "NSDate+RMCalendarLogic.h"
@implementation MoreFZCDataManager

MJCodingImplementation

// 用来保存唯一的单例对象
static id _instace;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)sharedMoreFZCDataManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instace;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        //这里写要初始化的东西！！！
        _travelDetailDays=[NSMutableArray array];
        _productEndTime=[NSDate stringFromDate:[[NSDate date] dayInTheFollowingDay:1]];
        _goal_startDate=[NSDate stringFromDate:[[NSDate date] dayInTheFollowingDay:2]];
        _goal_backDate=_goal_startDate;
        _goal_TotalTravelDay=@"1";
        _return_returnPeopleStatus = @"0";
        //默认一起游金额百分比为5%
        _return_togetherMoneyPercent=@"5";
        
        //默认目的地栏（出发地：当地）
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *myLocation=[user objectForKey:KMY_LOCALTION];
        _goal_goals=myLocation?[NSMutableArray arrayWithObject:myLocation]:[NSMutableArray arrayWithObject:ZYLocalizedString(@"default_location")];
    }
    return self;
}


+ (NSDictionary *)objectClassInArray
{
    return @{
             @"travelDetailDays" : [MoreFZCTravelOneDayDetailMdel class],
            };
}

+ (Class)objectClassInArray:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"travelDetailArr"]) {
        return [MoreFZCTravelOneDayDetailMdel class];
    }
    return nil;
}

-(void)initAllProperties
{

    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *myLocation=[user objectForKey:KMY_LOCALTION];
    self.goal_goals=myLocation?[NSMutableArray arrayWithObject:myLocation]:[NSMutableArray arrayWithObject:ZYLocalizedString(@"default_location")];
    self.productEndTime=[NSDate stringFromDate:[[NSDate date] dayInTheFollowingDay:1]];
    self.goal_startDate=[NSDate stringFromDate:[[NSDate date] dayInTheFollowingDay:2]];
    self.goal_backDate=self.goal_startDate;
    self.goal_TotalTravelDay=@"1";
    self.goal_numberPeople=@"4";
    self.goal_travelTheme=nil;
    self.goal_travelThemeImgUrl=nil;
    self.raiseMoney_sightMoney=nil;
    self.raiseMoney_transMoney=nil;
    self.raiseMoney_liveMoney=nil;
    self.raiseMoney_eatMoney=nil;
    self.raiseMoney_totalMoney=nil;
    self.raiseMoney_wordDes=nil;
    self.raiseMoney_imgsDes=nil;
    self.raiseMoney_voiceUrl=nil;
    self.raiseMoney_movieUrl=nil;
    self.raiseMoney_movieImg=nil;
    self.travelDetailDays=[NSMutableArray array];
    self.return_returnPeopleStatus=nil;
    self.return_returnPeopleMoney=nil;
    self.return_returnPeopleNumber=nil;
    self.return_wordDes=nil;
    self.return_imgsDes=nil;
    self.return_voiceUrl=nil;
    self.return_movieUrl=nil;
    self.return_movieImg=nil;
    self.return_wordDes=nil;
    self.return_imgsDes=nil;
    self.return_voiceUrl=nil;
    self.return_movieUrl=nil;
    self.return_movieImg=nil;
    self.return_returnPeopleStatus01=nil;
    self.return_returnPeopleMoney01=nil;
    self.return_returnPeopleNumber01=nil;
    self.return_wordDes01=nil;
    self.return_imgsDes01=nil;
    self.return_voiceUrl01=nil;
    self.return_movieUrl01=nil;
    self.return_movieImg01=nil;
    self.return_togetherPeopleStatus=nil;
    self.return_togetherPeopleNumber=nil;
    self.return_togetherMoneyPercent=@"5";
    self.return_togetherRateMoney=nil;
    //8.18新添加
    self.raiseMoney_imgUrlStr=nil;
    self.return_imgUrlStr=nil;
    self.return_imgUrlStr01=nil;
    self.return_togtherWordDes=nil;
    self.return_togtherVoice=nil;
    self.return_togtherVideo=nil;
    self.return_togtherVideoImg=nil;
    self.return_togtherImgUrlStr=nil;
}

-(void)getDataFromDraft:(ZCDetailModel *)detailModel andDoFinish:(GetDraftDataFinish )getDraftDataFinish
{
//    self.raiseMoney_sightMoney=nil;
//    self.raiseMoney_transMoney=nil;
//    self.raiseMoney_liveMoney=nil;
//    self.raiseMoney_eatMoney=nil;
//
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *myLocation=[user objectForKey:KMY_LOCALTION];
    self.goal_goals=detailModel.detailProductModel.dest?[NSMutableArray arrayWithArray:[ZYZCTool turnJsonStrToArray:detailModel.detailProductModel.dest]]:(myLocation?[NSMutableArray arrayWithObject:myLocation]:[NSMutableArray arrayWithObject:ZYLocalizedString(@"default_location")]);
    self.goal_startDate=detailModel.detailProductModel.start_time?detailModel.detailProductModel.start_time:[NSDate stringFromDate:[[NSDate date] dayInTheFollowingDay:2]];
    self.goal_backDate=detailModel.detailProductModel.end_time?detailModel.detailProductModel.end_time:[NSDate stringFromDate:[[NSDate date] dayInTheFollowingDay:2]];
    self.productEndTime=detailModel.detailProductModel.spell_end_time;
    NSDate *startDate=[NSDate dateFromString:detailModel.detailProductModel.start_time];
    NSDate *endDate=[NSDate dateFromString:detailModel.detailProductModel.end_time];
    self.goal_TotalTravelDay=[NSString stringWithFormat:@"%d",[NSDate getDayNumbertoDay:startDate beforDay:endDate]+1];
    
    self.goal_travelTheme=detailModel.detailProductModel.title;
    self.goal_travelThemeImgUrl=detailModel.detailProductModel.cover;
    self.raiseMoney_totalMoney=[NSString stringWithFormat:@"%.2f",[detailModel.detailProductModel.spell_buy_price floatValue]/100.0];
    
    self.raiseMoney_wordDes=detailModel.detailProductModel.desc;
//    self.raiseMoney_imgsDes
    self.raiseMoney_voiceUrl=detailModel.detailProductModel.productVoice;
    self.raiseMoney_movieUrl=detailModel.detailProductModel.productVideo;
    self.raiseMoney_movieImg=detailModel.detailProductModel.productVideoImg;
    
    if (detailModel.detailProductModel.schedule.count) {
        NSArray *detailDays=detailModel.detailProductModel.schedule;
        for (NSString *jsonStr in detailDays) {
            NSDictionary *dict=[ZYZCTool turnJsonStrToDictionary:jsonStr];
            MoreFZCTravelOneDayDetailMdel *oneSchedule=[MoreFZCTravelOneDayDetailMdel mj_objectWithKeyValues:dict];
            [self.travelDetailDays addObject:oneSchedule];
        }
    }
//    self.goal_TotalTravelDay=self.travelDetailDays.count?[NSString stringWithFormat:@"%ld",self.travelDetailDays.count]:@"1";
    
    if (detailModel.detailProductModel.report.count) {
        for (ReportModel *reportModel in detailModel.detailProductModel.report) {
            if ([reportModel.style isEqual:@0]) {
//                self.raiseMoney_totalMoney=[NSString stringWithFormat:@"%.2f",[reportModel.price floatValue]/100.0];
//                self.goal_numberPeople=reportModel.people>0?[NSString stringWithFormat:@"%@",reportModel.people]:nil;
            }
           else if ([reportModel.style isEqual:@3]) {
                self.return_returnPeopleStatus=@"1";
                self.return_returnPeopleMoney=[NSString stringWithFormat:@"%.2f",[reportModel.price floatValue]/100.0];
                self.return_returnPeopleNumber=[NSString stringWithFormat:@"%@",reportModel.sumPeople];
                self.return_wordDes=reportModel.desc;
                self.return_voiceUrl=reportModel.spellVoice;
                self.return_movieUrl=reportModel.spellVideo;
                self.return_movieImg=reportModel.spellVideoImg;
            }
            else if ([reportModel.style isEqual:@4])
            {
                self.return_togetherPeopleStatus=@"1";
                self.return_togetherPeopleNumber=[NSString stringWithFormat:@"%@",reportModel.sumPeople];
                self.return_togetherRateMoney=[NSString stringWithFormat:@"%.2f",[reportModel.price floatValue]/100.0];
                NSInteger rate=[self.raiseMoney_totalMoney floatValue]>0?[self.return_togetherRateMoney floatValue]/[self.raiseMoney_totalMoney floatValue]*100:0;
                self.return_togetherMoneyPercent=[NSString stringWithFormat:@"%ld",rate];
                self.goal_numberPeople=[NSString stringWithFormat:@"%ld",[reportModel.sumPeople integerValue]+1];
            }
        }
    }
    
    if (getDraftDataFinish) {
        getDraftDataFinish();
    }
}

@end
