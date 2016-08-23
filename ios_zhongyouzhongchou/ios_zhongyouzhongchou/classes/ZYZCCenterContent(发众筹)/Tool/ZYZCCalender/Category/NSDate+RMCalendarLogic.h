//
//  NSDate+RMCalendarLogic.h
//  RMCalendar
//

#import <Foundation/Foundation.h>

@interface NSDate (RMCalendarLogic)

- (NSUInteger)numberOfDaysInCurrentMonth;

- (NSUInteger)numberOfWeeksInCurrentMonth;

- (NSUInteger)weeklyOrdinality;

- (NSDate *)firstDayOfCurrentMonth;

- (NSDate *)lastDayOfCurrentMonth;

- (NSDate *)dayInThePreviousMonth;

- (NSDate *)dayInTheFollowingMonth;

- (NSDate *)dayInTheFollowingMonth:(int)month;//获取当前日期之后的几个月

- (NSDate *)dayInTheFollowingDay:(int)day;//获取当前日期之后的几个天

- (NSDate *)dayInTheFollowingDay:(int)day andDate:(NSDate *)date;

- (NSDateComponents *)YMDComponents;

+ (NSDate *)dateFromString:(NSString *)dateString;//NSString转NSDate

+ (NSString *)stringFromDate:(NSDate *)date;//NSDate转NSString

+ (int)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday;

-(int)getWeekIntValueWithDate;

+(int)compareDate:(NSDate *)date1 withDate:(NSDate*)date2;//判断两个日期的大小



//判断日期是今天,明天,后天,周几
-(NSString *)compareIfTodayWithDate;
//通过数字返回星期几
+(NSString *)getWeekStringFromInteger:(int)week;

#pragma mark --- 获取两个日历间的所有日历
+ (NSArray *)getDatesBetweenDate:(NSDate *)startDate toDate:(NSDate *)endDate;

/**
 *  由生日得出年龄
 *
 *  @param birthday
 */
+(NSInteger )getAgeFromBirthday:(NSString *)birthday;
/**
 *  
 *
 */
+ (NSString *)changStrToDateStr:(NSString *)string;

@end
