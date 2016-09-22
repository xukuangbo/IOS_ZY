//
//  FZCSaveDraftData.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/25.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "FZCSaveDraftData.h"
#import "MoreFZCDataManager.h"
#import "NSDate+RMCalendarLogic.h"
@implementation FZCSaveDraftData

+ (void)saveDraftDataInOneModel:(ZCOneModel *)oneModel andDetailProductModel:(ZCDetailProductModel *)detailProductModel andDoBlock:(DoBlock )doBlock
{
    MoreFZCDataManager *dataManager= [MoreFZCDataManager sharedMoreFZCDataManager];
    
    oneModel.productType=ZCDetailProduct;
    ZCProductModel *productModel=[[ZCProductModel alloc]init];
    productModel.productPrice= [NSNumber numberWithFloat:[dataManager.raiseMoney_totalMoney floatValue]*100.0] ;
    productModel.travelstartTime=dataManager.goal_startDate;
    productModel.productEndTime=dataManager.goal_backDate;
    productModel.productName=dataManager.goal_travelTheme;
    if (dataManager.goal_goals.count) {
        productModel.productDest=[ZYZCTool turnJson:dataManager.goal_goals];
    }
    NSDate *date=[[NSDate dateFromString:dataManager.goal_startDate] dayInTheFollowingDay:-15];
    productModel.productEndTime=[NSDate stringFromDate:date];
    productModel.headImage=dataManager.goal_travelThemeImgUrl;
    oneModel.product=productModel;
    
    detailProductModel.cover=dataManager.goal_travelThemeImgUrl;
    detailProductModel.title=dataManager.goal_travelTheme;
    detailProductModel.desc=dataManager.raiseMoney_wordDes;
    detailProductModel.productVoice=dataManager.raiseMoney_voiceUrl;
    detailProductModel.productVoiceLen=dataManager.raiseMoney_voiceLen;
    detailProductModel.productVideo=dataManager.raiseMoney_movieUrl;
    detailProductModel.productVideoImg=dataManager.raiseMoney_movieImg;
    detailProductModel.descImgs=dataManager.raiseMoney_imgUrlStr;
    detailProductModel.spell_buy_price=[NSString stringWithFormat:@"%.2f",[dataManager.raiseMoney_totalMoney floatValue]*100.0];
    
    NSMutableArray *reportArr=[NSMutableArray array];
    ReportModel *reportModel01=[[ReportModel alloc]init];
    reportModel01.people = 0;
    reportModel01.style = @1;
    reportModel01.sumPeople = 0;
    reportModel01.sumPrice = 0;
    [reportArr addObject:reportModel01];
    
    ReportModel *reportModel02=[[ReportModel alloc]init];
    reportModel02.people = 0;
    reportModel02.style = @2;
    reportModel02.sumPeople = 0;
    reportModel02.sumPrice = 0;
    [reportArr addObject:reportModel02];
    
    if (dataManager.return_returnPeopleStatus) {
        ReportModel *reportModel03=[[ReportModel alloc]init];
        reportModel03.desc = dataManager.return_wordDes;
        reportModel03.spellVoice    = dataManager.return_voiceUrl;
        reportModel03.spellVoiceLen = dataManager.return_voiceLen;
        reportModel03.spellVideo    = dataManager.return_movieUrl;
        reportModel03.spellVideoImg = dataManager.return_movieImg;
        reportModel03.descImgs=dataManager.return_imgUrlStr;
        reportModel03.price =[NSNumber numberWithFloat:[dataManager.return_returnPeopleMoney floatValue]*100.0] ;
        reportModel03.style = @3;
        reportModel03.sumPeople = (NSNumber *)dataManager.return_returnPeopleNumber;
        reportModel03.sumPrice =0;
        [reportArr addObject: reportModel03];
    }
    
    ReportModel *reportModel04=[[ReportModel alloc]init];
    reportModel04.people = [NSNumber numberWithInt:[dataManager.goal_numberPeople intValue]-1];
    reportModel04.style = @4;
    reportModel04.sumPeople = [NSNumber numberWithInt:[dataManager.goal_numberPeople intValue]-1];
    reportModel04.sumPrice = 0;
    reportModel04.price=[NSNumber numberWithFloat:([dataManager.return_togetherRateMoney floatValue ]*100.0)];
    reportModel04.desc = dataManager.return_togtherWordDes;
    reportModel04.spellVoice = dataManager.return_togtherVoice;
    reportModel04.spellVoiceLen = dataManager.return_togtherVoiceLen;
    reportModel04.spellVideo = dataManager.return_togtherVideo;
    reportModel04.spellVideoImg=dataManager.return_togtherVideoImg;
    reportModel04.descImgs=dataManager.return_togtherImgUrlStr;

    [reportArr addObject:reportModel04];
    
    if (dataManager.return_returnPeopleMoney01) {
        ReportModel *reportModel05=[[ReportModel alloc]init];
        reportModel05.desc = dataManager.return_wordDes;
        reportModel05.descImgs=dataManager.return_imgUrlStr01;
        reportModel05.spellVoice = dataManager.return_voiceUrl01;
        reportModel05.spellVoiceLen = dataManager.return_voiceLen01;
        reportModel05.spellVideo = dataManager.return_movieUrl01;
        reportModel05.spellVideoImg=dataManager.return_movieImg01;
        reportModel05.people =(NSNumber *)dataManager.return_returnPeopleNumber01;
        reportModel05.price =[NSNumber numberWithFloat:[dataManager.return_returnPeopleMoney01 floatValue]*100.0] ;
        reportModel05.style = @5;
        reportModel05.sumPeople = 0;
        reportModel05.sumPrice =0;
        [reportArr addObject:reportModel05];
    }
    
    detailProductModel.report=reportArr;
    
    detailProductModel.schedule=dataManager.travelDetailDays;
    
    [ZYZCHTTPTool getHttpDataByURL:[NSString stringWithFormat:@"%@userId=%@",GETUSERINFO,[ZYZCAccountTool getUserId]] withSuccessGetBlock:^(id result, BOOL isSuccess)
     {
         if (isSuccess) {
             UserModel *user=[[UserModel alloc]mj_setKeyValues:result[@"data"][@"user"]];
             oneModel.user=user;
             detailProductModel.user=user;
             if (doBlock) {
                 doBlock();
             }
         }
    }
      andFailBlock:^(id failResult)
     {
         
     }];
}



@end
