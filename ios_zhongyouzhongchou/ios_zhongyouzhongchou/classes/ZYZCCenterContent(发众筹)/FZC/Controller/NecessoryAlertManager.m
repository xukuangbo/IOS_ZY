//
//  NecessoryAlertManager.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/3.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "NecessoryAlertManager.h"
#import "MoreFZCDataManager.h"
#import "MBProgressHUD+MJ.h"
#import "NSDate+RMCalendarLogic.h"

@implementation NecessoryAlertManager

+ (NSInteger)showNecessoryAlertView01
{
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    if (manager.goal_goals.count<2) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_dest")];
        return 1;
    }
    if (!manager.productEndTime)
    {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_productEndTime")];
        return 1;
    }
    
    if (!manager.goal_startDate||
        !manager.goal_backDate||
        ([manager.goal_startDate isEqualToString:[NSDate stringFromDate:[[NSDate date] dayInTheFollowingDay:2]]]&&
         [manager.goal_backDate isEqualToString:manager.goal_startDate])) {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_travelTime")];
            return 1;
        }
    if (!manager.goal_travelTheme) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_travel_theme")];
        return 1;
    }
    if (!manager.goal_travelThemeImgUrl) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_travel_image")];
        return 1;
    }
    return 0;
}

+ (NSInteger)showNecessoryAlertView02
{
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    if (manager.goal_goals.count<2) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_dest")];
        return 1;
    }
    if (!manager.productEndTime)
    {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_productEndTime")];
        return 1;
    }
    if (!manager.goal_startDate||
        !manager.goal_backDate||
        ([manager.goal_startDate isEqualToString:[NSDate stringFromDate:[[NSDate date] dayInTheFollowingDay:2]]]&&
         [manager.goal_backDate isEqualToString:manager.goal_startDate])) {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_travelTime")];
            return 1;
        }
    if (!manager.goal_travelTheme) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_travel_theme")];
        return 1;
    }
    if (!manager.goal_travelThemeImgUrl) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_travel_image")];
        return 1;
    }
    if (!manager.raiseMoney_totalMoney||[manager.raiseMoney_totalMoney floatValue]<=0.0) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_spell_buy_price")];
        return 2;
    }
    if (!manager.raiseMoney_wordDes&&!manager.raiseMoney_voiceUrl&&!manager.raiseMoney_movieUrl) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_travelDesc")];
        return 2;
    }
    
    return 0;
    
}

+ (NSInteger)showNecessoryAlertView03
{
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    if (manager.goal_goals.count<2) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_dest")];
        return 1;
    }
    if (!manager.productEndTime)
    {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_productEndTime")];
        return 1;
    }
    if (!manager.goal_startDate||
        !manager.goal_backDate||
        ([manager.goal_startDate isEqualToString:[NSDate stringFromDate:[[NSDate date] dayInTheFollowingDay:2]]]&&
         [manager.goal_backDate isEqualToString:manager.goal_startDate])) {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_travelTime")];
            return 1;
        }
    if (!manager.goal_travelTheme) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_travel_theme")];
        return 1;
    }
    if (!manager.goal_travelThemeImgUrl) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_travel_image")];
        return 1;
    }
    if (!manager.raiseMoney_totalMoney||[manager.raiseMoney_totalMoney floatValue]<=0.0) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_spell_buy_price")];
        return 2;
    }
    if (!manager.raiseMoney_wordDes&&!manager.raiseMoney_voiceUrl&&!manager.raiseMoney_movieUrl) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_travelDesc")];
        return 2;
    }
    for (int i=0; i<manager.travelDetailDays.count; i++) {
        MoreFZCTravelOneDayDetailMdel *model=manager.travelDetailDays[i];
        if (!model.wordDes&&!model.voiceUrl&&!model.movieUrl) {
            NSDate *startDay=[NSDate dateFromString:manager.goal_startDate];
            NSDate *cellDate=[[NSDate alloc]init];
            cellDate=[cellDate dayInTheFollowingDay:i andDate:startDay];
            [MBProgressHUD showShortMessage:[NSString stringWithFormat:@"%@行程未填写",[NSDate stringFromDate:cellDate]]];
            return 3;
        }
    }
    return 0;
}

+ (NSInteger)showNecessoryAlertView04
{
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    if (manager.goal_goals.count<2) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_dest")];
        return 1;
    }
    if (!manager.productEndTime)
    {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_productEndTime")];
        return 1;
    }
    if (!manager.goal_startDate||
        !manager.goal_backDate||
        ([manager.goal_startDate isEqualToString:[NSDate stringFromDate:[[NSDate date] dayInTheFollowingDay:2]]]&&
         [manager.goal_backDate isEqualToString:manager.goal_startDate])) {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_travelTime")];
            return 1;
        }
    if (!manager.goal_travelTheme) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_travel_theme")];
        return 1;
    }
    if (!manager.goal_travelThemeImgUrl) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_travel_image")];
        return 1;
    }
    if (!manager.raiseMoney_totalMoney||[manager.raiseMoney_totalMoney floatValue]<=0.0) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_spell_buy_price")];
        return 2;
    }
    if (!manager.raiseMoney_wordDes&&!manager.raiseMoney_voiceUrl&&!manager.raiseMoney_movieUrl) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_travelDesc")];
        return 2;
    }
    for (int i=0; i<manager.travelDetailDays.count; i++) {
        MoreFZCTravelOneDayDetailMdel *model=manager.travelDetailDays[i];
        if (!model.wordDes&&!model.voiceUrl&&!model.movieUrl) {
            NSDate *startDay=[NSDate dateFromString:manager.goal_startDate];
            NSDate *cellDate=[[NSDate alloc]init];
            cellDate=[cellDate dayInTheFollowingDay:i andDate:startDay];
            [MBProgressHUD showShortMessage:[NSString stringWithFormat:@"%@行程未填写",[NSDate stringFromDate:cellDate]]];
            return 3;
        }
    }
    
    if ([manager.return_returnPeopleStatus isEqualToString:@"1"]) {
        if (!manager.return_returnPeopleNumber||[manager.return_returnPeopleNumber intValue]==0) {
            [MBProgressHUD showShortMessage:@"回报人数为空"];
            return 4;
        }
        if (!manager.return_returnPeopleMoney||[manager.return_returnPeopleMoney floatValue]==0.0) {
            [MBProgressHUD showShortMessage:@"回报金额为空"];
            return 4;
        }
        if (!manager.return_wordDes&&!manager.return_voiceUrl&&!manager.return_movieUrl) {
            [MBProgressHUD showShortMessage:@"回报描述内容为空"];
            return 4;
        }
    }
    if ([manager.return_returnPeopleStatus01 isEqualToString:@"1"]) {
        if (!manager.return_returnPeopleNumber01||!manager.return_returnPeopleMoney01) {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_return2")];
            return 4;
        }
        else
        {
            if (!manager.return_wordDes01&&!manager.return_voiceUrl01&&!manager.return_movieUrl01) {
                [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_return2")];
                return 4;
            }
        }
    }
    
    if (!manager.return_togetherRateMoney) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"error_no_togetherTravel_money_rate")];
        return 4;
    }
    return 0;
}



+ (NSInteger)showNecessoryAlertView
{
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    if (manager.goal_goals.count<2) {
        return 1;
    }
    if (!manager.productEndTime)
    {
        return 1;
    }
    if (!manager.goal_startDate||
        !manager.goal_backDate||
        ([manager.goal_startDate isEqualToString:[NSDate stringFromDate:[[NSDate date] dayInTheFollowingDay:2]]]&&
        [manager.goal_backDate isEqualToString:manager.goal_startDate])) {
        return 1;
    }
    if (!manager.goal_travelTheme) {
        return 1;
    }
    if (!manager.goal_travelThemeImgUrl) {
        return 1;
    }
    if (!manager.raiseMoney_totalMoney||[manager.raiseMoney_totalMoney floatValue]<=0.0) {
        return 2;
    }
    if (!manager.raiseMoney_wordDes&&!manager.raiseMoney_voiceUrl&&!manager.raiseMoney_movieUrl) {
        return 2;
    }
    for (int i=0; i<manager.travelDetailDays.count; i++) {
        MoreFZCTravelOneDayDetailMdel *model=manager.travelDetailDays[i];
        if (!model.wordDes&&!model.voiceUrl&&!model.movieUrl) {
            NSDate *startDay=[NSDate dateFromString:manager.goal_startDate];
            NSDate *cellDate=[[NSDate alloc]init];
            cellDate=[cellDate dayInTheFollowingDay:i andDate:startDay];
            return 3;
        }
    }
    
    if ([manager.return_returnPeopleStatus isEqualToString:@"1"]) {
        if (!manager.return_returnPeopleNumber||!manager.return_returnPeopleMoney) {
                return 4;
        }
        else
        {
            if (!manager.return_wordDes&&!manager.return_voiceUrl&&!manager.return_movieUrl) {
                return 4;
            }
        }
    }
    if ([manager.return_returnPeopleStatus01 isEqualToString:@"1"]) {
        if (!manager.return_returnPeopleNumber01||!manager.return_returnPeopleMoney01) {
            return 4;
        }
        else
        {
            if (!manager.return_wordDes01&&!manager.return_voiceUrl01&&!manager.return_movieUrl01) {
                return 4;
            }
        }
    }
    
    if (!manager.return_togetherRateMoney) {
        return 4;
    }
    return 0;
}

@end
