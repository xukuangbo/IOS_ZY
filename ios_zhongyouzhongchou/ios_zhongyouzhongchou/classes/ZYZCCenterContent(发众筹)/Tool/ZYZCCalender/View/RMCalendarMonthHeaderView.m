//
//  RMCalendarMonthHeaderView.m
//  RMCalendar
//


#import "RMCalendarMonthHeaderView.h"

#define CATDayLabelWidth  ([UIScreen mainScreen].bounds.size.width/7)
#define CATDayLabelHeight 20.0f

@interface RMCalendarMonthHeaderView()

@end

@implementation RMCalendarMonthHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initWithHeader];
    }
    return self;
}

- (void)initWithHeader
{
    self.clipsToBounds = YES;
    //月份
    UILabel *masterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 12.0f, (int)((KSCREEN_W-40)/7)*7, 20.f)];
    [masterLabel setTextAlignment:NSTextAlignmentCenter];
    [masterLabel setFont:[UIFont  systemFontOfSize:17.0f]];
    self.masterLabel = masterLabel;
    self.masterLabel.textColor =[UIColor ZYZC_TextGrayColor01] ;
    [self addSubview:self.masterLabel];
}
@end

