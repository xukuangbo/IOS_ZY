//
//  RMCalendarLogic.h
//  RMCalendar
//

#import <Foundation/Foundation.h>
#import "RMCalendarModel.h"
#import "NSDate+RMCalendarLogic.h"

/**
 *  日历显示的月数
 */
typedef NS_ENUM(NSInteger, CalendarShowType){
    /**
     *  只显示当月
     */
    CalendarShowTypeSingle,
    /**
     *  显示多个月数
     */
    CalendarShowTypeMultiple
};

@interface RMCalendarLogic : NSObject

-(NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)selectDate occupyDates:(NSArray *)occupyDays needDays:(int)days showType:(CalendarShowType)type isEnable:(BOOL)isEnable priceModelArr:(NSArray *)arr;

- (NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)selectDate occupyDates:(NSArray *)occupyDays needDays:(int)days showType:(CalendarShowType)type priceModelArr:(NSArray *)arr;


- (NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)selectDate occupyDates:(NSArray *)occupyDays needDays:(int)days showType:(CalendarShowType)type;
- (void)selectLogic:(RMCalendarModel *)dayModel PreStyle:(CellDayType)preStyle;
-(void)changeStateToCellDayTypeClick:(RMCalendarModel *)dayModel;

@end
