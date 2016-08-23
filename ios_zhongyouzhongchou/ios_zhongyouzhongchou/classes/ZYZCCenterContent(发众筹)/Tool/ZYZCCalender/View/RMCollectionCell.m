//
//  RMCollectionCell.m
//  RMCalendar
//

#import "RMCollectionCell.h"
#import "UIView+CustomFrame.h"
#import "RMCalendarModel.h"


#define COLOR_HIGHLIGHT ([UIColor redColor])
#define COLOR_NOAML ([UIColor colorWithRed:26/256.0  green:168/256.0 blue:186/256.0 alpha:1])

@interface RMCollectionCell()

/**
 *  显示日期
 */
@property (nonatomic, weak) UILabel *dayLabel;
/**
 *  显示农历
 */
//@property (nonatomic, weak) UILabel *chineseCalendar;
/**
 *  选中的背景图片
 */
@property (nonatomic, weak) UIImageView *selectImageView;
/**
 *  已安排时间图标
 */
@property (nonatomic, weak) UIImageView *occupyFlag;

@end

@implementation RMCollectionCell

- (nonnull instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self initCellView];
    return self;
}

- (void)initCellView {
    
    //选中时显示的图片
    UIImageView *selectImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    selectImageView.image=[UIImage imageNamed:@"bg_t_o"];
    self.selectImageView = selectImageView;
    [self addSubview:selectImageView];
    
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width )];
    dayLabel.font = [UIFont boldSystemFontOfSize:15];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel = dayLabel;
    [self addSubview:dayLabel];
    
    UIImageView *occupyFlag=[[UIImageView alloc]initWithFrame:CGRectMake((self.bounds.size.width-5)/2,self.bounds.size.height*0.7 , 5, 5)];
    occupyFlag.image=[UIImage imageNamed:@"btn_xdd"];
    occupyFlag.layer.cornerRadius=occupyFlag.width/2;
    occupyFlag.layer.masksToBounds=YES;
    self.occupyFlag=occupyFlag;
    [self addSubview:occupyFlag];
}

- (void)setModel:(RMCalendarModel *)model {
    _model = model;
    
    switch (model.style) {
        case CellDayTypeEmpty:
            self.dayLabel.hidden = YES;
            self.selectImageView.hidden = YES;
            self.occupyFlag.hidden=YES;
            self.backgroundColor = [UIColor whiteColor];
            break;
        case CellDayTypePast:
            self.dayLabel.hidden = NO;
            self.selectImageView.hidden = YES;
            self.occupyFlag.hidden=YES;
            self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            self.dayLabel.textColor = [UIColor ZYZC_TextGrayColor02];
//            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarDisableDate"]];
            break;
        case CellDayTypeFutur:
            self.dayLabel.hidden = NO;
            self.selectImageView.hidden = YES;
            self.occupyFlag.hidden=YES;
            self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            self.dayLabel.textColor = [UIColor ZYZC_TextGrayColor];
//            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarNormalDate"]];
            break;
        case CellDayTypeWeek:
            self.dayLabel.hidden = NO;
            self.selectImageView.hidden = YES;
            self.occupyFlag.hidden=YES;
            self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            self.dayLabel.textColor = [UIColor ZYZC_TextGrayColor];
//            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarNormalDate"]];
            //            day_title.text = model.Chinese_calendar;
            break;
        case CellDayTypeClick:
            self.dayLabel.hidden = NO;
            self.selectImageView.hidden = NO;
            self.occupyFlag.hidden=YES;
//            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarNormalDate"]];
            self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            self.dayLabel.textColor = [UIColor whiteColor];
            break;
        case CellDayTypeNoPassOccupy:
            self.dayLabel.hidden = NO;
            self.selectImageView.hidden = YES;
            self.occupyFlag.hidden=NO;
            self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            self.dayLabel.textColor = [UIColor ZYZC_TextGrayColor];
//            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarNormalDate"]];
            break;
        case CellDayTypePassOccupy:
            self.dayLabel.hidden = NO;
            self.selectImageView.hidden = YES;
            self.occupyFlag.hidden=NO;
            self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            self.dayLabel.textColor = [UIColor ZYZC_TextGrayColor];
//            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarDisableDate"]];
            self.occupyFlag.image=nil;
            self.occupyFlag.backgroundColor=[UIColor grayColor];
            break;

        default:
            break;
    }
}

@end
