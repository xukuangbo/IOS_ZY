//
//  FZCReplaceDataKeys.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "FZCReplaceDataKeys.h"
#import "MoreFZCDataManager.h"
#import "NSDate+RMCalendarLogic.h"
@interface FZCReplaceDataKeys()
@property (nonatomic, strong) NSString *myZhouChouMarkName;
@end

@implementation FZCReplaceDataKeys

MJCodingImplementation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _report=[NSMutableArray array];
    }
    return self;
}

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"schedule" : [ScheduleData class],
             @"report"   : [ReportData class],
             };
}

+ (Class)objectClassInArray:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"schedule"]) {
        return [ScheduleData class];
    }
    
    if ([propertyName isEqualToString:@"report"]) {
        return [ReportData class];
    }
    return nil;
}

-(void)replaceDataKeysBySubFileName:(NSString *)myZhouChouMarkName
{
    _myZhouChouMarkName=myZhouChouMarkName;
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    self.userId=[ZYZCAccountTool getUserId];
    self.status=@1;
    self.title=manager.goal_travelTheme;
    self.spell_buy_price=manager.raiseMoney_totalMoney?manager.raiseMoney_totalMoney:@"0.0";
    if (manager.goal_goals.count) {
        self.dest=manager.goal_goals;
    }
    self.start_time=manager.goal_startDate;
    self.end_time=manager.goal_backDate;
    self.spell_end_time=manager.productEndTime;
    self.cover=[self changeFileName:manager.goal_travelThemeImgUrl];
    self.desc=manager.raiseMoney_wordDes;
    self.voice=[self changeFileName:manager.raiseMoney_voiceUrl];
    self.voiceLen=manager.raiseMoney_voiceLen;
    self.video=[self changeFileName:manager.raiseMoney_movieUrl];
    self.videoImg = [self changeFileName:manager.raiseMoney_movieImg];
    if (manager.raiseMoney_imgUrlStr.length) {
        self.descImgs=[self changeImgUrlStr:manager.raiseMoney_imgUrlStr];
    }
    
    //行程安排
    NSMutableArray *mutArr=[NSMutableArray array];
    for (int i=0; i<manager.travelDetailDays.count; i++) {
        MoreFZCTravelOneDayDetailMdel *model=manager.travelDetailDays[i];
        ScheduleData *oneSchedule=[[ScheduleData alloc]init];
        oneSchedule.day=[NSString stringWithFormat:@"%@",model.day];
        oneSchedule.spot=model.siteDes;
        oneSchedule.spots=model.sites;
        oneSchedule.trans=model.trafficDes;
        oneSchedule.live=model.liveDes;
        oneSchedule.food=model.foodDes;
        oneSchedule.desc=model.wordDes;
        oneSchedule.voice=[self changeFileName:model.voiceUrl];
        oneSchedule.voiceLen=model.voiceLen;
        oneSchedule.video=[self changeFileName:model.movieUrl];
        oneSchedule.videoImg=[self changeFileName:model.movieImg];
        if (model.imgUrlStr.length) {
            oneSchedule.descImgs=[self changeImgUrlStr:model.imgUrlStr];
        }
//        if (oneSchedule.desc||oneSchedule.voice||oneSchedule.video) {
            [mutArr addObject:oneSchedule];
//        }
    }
    self.schedule=mutArr;
    
    //支持5元
    ReportData *report01=[[ReportData alloc]init];
    report01.style=@1;
    report01.price=@"5";
    [_report addObject:report01];
    //支持任意金额
    ReportData *report02=[[ReportData alloc]init];
    report02.style=@2;
    report02.price=@"0";
    [_report addObject:report02];
    //回报支持1
    if([manager.return_returnPeopleStatus isEqualToString:@"1"]){
        ReportData *report03=[[ReportData alloc]init];
        report03.style=@3;
        report03.price=manager.return_returnPeopleMoney;
        report03.people=(NSNumber *)manager.return_returnPeopleNumber;
        report03.desc=manager.return_wordDes;
        report03.voice=[self changeFileName:manager.return_voiceUrl];
        report03.voiceLen=manager.return_voiceLen;
        report03.video=[self changeFileName:manager.return_movieUrl];
        report03.videoUrl=[self changeFileName:manager.return_movieImg];
        if (manager.return_imgUrlStr.length) {
            report03.descImgs=[self changeImgUrlStr:manager.return_imgUrlStr];
        }
        [_report addObject:report03];
    }
    //一起游
    ReportData *report04=[[ReportData alloc]init];
    report04.style=@4;
    report04.people=[NSNumber numberWithInteger:[manager.goal_numberPeople integerValue]-1];
    report04.price=manager.return_togetherRateMoney;
    report04.desc=manager.return_togtherWordDes;
    report04.voice=[self changeFileName:manager.return_togtherVoice];
    report04.voiceLen=manager.return_togtherVoiceLen;
    report04.video=[self changeFileName:manager.return_togtherVideo];
    report04.videoUrl=[self changeFileName:manager.return_togtherVideoImg];
    if (manager.return_togtherImgUrlStr.length) {
        report04.descImgs=[self changeImgUrlStr:manager.return_togtherImgUrlStr];
    }
    [_report addObject:report04];
    //回报支持2
    if ([manager.return_returnPeopleStatus01 isEqualToString:@"1"]) {
        ReportData *report05=[[ReportData alloc]init];
        report05.style=@5;
        report05.price=manager.return_returnPeopleMoney01;
        report05.people=(NSNumber *)manager.return_returnPeopleNumber01;
        report05.desc=manager.return_wordDes01;
        report05.voice=[self changeFileName:manager.return_voiceUrl01];
        report05.voiceLen=manager.return_voiceLen01;
        report05.video=[self changeFileName:manager.return_movieUrl01];
        report05.videoUrl=[self changeFileName:manager.return_movieImg01];
        if (manager.return_imgUrlStr01.length) {
            report05.descImgs=[self changeImgUrlStr:manager.return_imgUrlStr01];
        }
        [_report addObject:report05];
    }
    if (manager.raiseMoney_sightMoney.floatValue>0) {
        //筹旅费景点花费
        ReportData *report06=[[ReportData alloc]init];
        report06.style=@6;
        report06.price=manager.raiseMoney_sightMoney;
        [_report addObject:report06];
    }
    if (manager.raiseMoney_transMoney.floatValue>0) {
        //筹旅费交通花费
        ReportData *report07=[[ReportData alloc]init];
        report07.style=@7;
        report07.price=manager.raiseMoney_transMoney;
        [_report addObject:report07];
    }
    
    if (manager.raiseMoney_liveMoney.floatValue>0) {
        //筹旅费住宿花费
        ReportData *report08=[[ReportData alloc]init];
        report08.style=@8;
        report08.price=manager.raiseMoney_liveMoney;
        [_report addObject:report08];
    }
    if (manager.raiseMoney_eatMoney.floatValue>0) {
        //筹旅费餐饮花费
        ReportData *report09=[[ReportData alloc]init];
        report09.style=@9;
        report09.price=manager.raiseMoney_eatMoney;
        [_report addObject:report09];
    }
}

#pragma mark --- 本地路径名改成网络数据链接名(如果本身是网络连接，不用转换)
-(NSString *)changeFileName:(NSString *)fileName
{
    NSString *subFileName=nil;
    NSRange strRange=[fileName rangeOfString:KMY_ZHONGCHOU_FILE];
    if (strRange.length) {
        subFileName=[fileName substringFromIndex:(strRange.location+strRange.length+1)];
        return [NSString stringWithFormat:@"%@/%@/%@/%@",KHTTP_FILE_HEAD,[ZYZCAccountTool getUserId],_myZhouChouMarkName,subFileName];
    }
    else
    {
        return fileName;
    }
}

#pragma mark ---  修改imgUrlStr
-(NSString *)changeImgUrlStr:(NSString *)imgUrlStr
{
    NSArray *imgUrlArr=[imgUrlStr componentsSeparatedByString:@","];
    NSMutableArray *mutArr=[NSMutableArray array];
    for (NSInteger i=0; i<imgUrlArr.count; i++) {
        [mutArr addObject:[self changeFileName:imgUrlArr[i]]];
    }
    NSString *newStr=[mutArr componentsJoinedByString:@","];
    return newStr;
}

@end

@implementation ScheduleData

MJCodingImplementation

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end

@implementation ReportData

MJCodingImplementation

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end


