//
//  detailGuideView.m
//  Pods
//
//  Created by patty on 15/12/15.
//
//

#import "ZYDetailGuideView.h"

#define LABELHEIGHT 20

@implementation ZYDetailGuideView


- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        
    }
    return self;
}


- (void)createDetailTitle:(NSString *)title withAlignmentType:(AlignmentType)alignmentType
{
    NSMutableString *mutableString = [NSMutableString stringWithString:title];
    NSString *text = title;
    if([title rangeOfString:@"\n"].location != NSNotFound){
        text = [mutableString componentsSeparatedByString:@"\n"][0];
    }
    
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLabel.text = text;
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.font = [UIFont systemFontOfSize:17.0f];
    [detailLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:detailLabel];
    
    UIButton *seeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [seeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    seeButton.titleLabel.font = [UIFont systemFontOfSize:17];
    seeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    seeButton.layer.cornerRadius = 4;
    seeButton.layer.masksToBounds = YES;
    seeButton.backgroundColor = [UIColor colorWithHexString:@"439cf4"];
    [seeButton setTitle:@"我知道了" forState:UIControlStateNormal];
    [self addSubview:seeButton];

    if(![text isEqualToString:title]){
        
        UILabel *detailSecondLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        detailLabel.text = [mutableString componentsSeparatedByString:@"\n"][1];
        detailLabel.textColor = [UIColor whiteColor];
        detailLabel.font = [UIFont systemFontOfSize:17.0f];
        [detailLabel setTextAlignment:NSTextAlignmentRight];

        [self addSubview:detailSecondLabel];
        
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.bottom.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.height.equalTo(@LABELHEIGHT);
        }];

        [detailSecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(detailLabel.mas_right);
            make.top.equalTo(detailLabel.mas_bottom).offset(5);
            make.left.equalTo(self.mas_left);
            make.height.equalTo(@LABELHEIGHT);
        }];
    
        [seeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(detailSecondLabel.mas_bottom).offset(25);
            make.width.equalTo(@100);
            make.height.equalTo(@44);
        }];
        
    }else{
        switch (alignmentType) {
            case commonType:
            {
                detailLabel.textAlignment = NSTextAlignmentRight;
                [seeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.mas_right).offset(-15);
                    make.bottom.equalTo(self.mas_bottom);
                    make.width.equalTo(@100);
                    make.height.equalTo(@44);
                }];
                [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(seeButton.mas_right).offset(10);
                    make.bottom.equalTo(seeButton.mas_top).offset(-25);
                    make.left.equalTo(self.mas_left);
                    make.height.equalTo(@LABELHEIGHT);
                }];
                break;
            }
            case leftType:
            {
                detailLabel.textAlignment = NSTextAlignmentLeft;
                [seeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.mas_centerX).offset(-70);
                    make.bottom.equalTo(self.mas_bottom);
                    make.width.equalTo(@100);
                    make.height.equalTo(@44);
                }];
                [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(seeButton.mas_left);
                    make.bottom.equalTo(seeButton.mas_top).offset(-25);
                    make.height.equalTo(@LABELHEIGHT);
                }];
            }
                break;
            case centerType:
            {
                detailLabel.textAlignment = NSTextAlignmentCenter;
                [seeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.mas_centerX);
                    make.bottom.equalTo(self.mas_bottom);
                    make.width.equalTo(@100);
                    make.height.equalTo(@44);
                }];
                [detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.mas_right);
                    make.bottom.equalTo(seeButton.mas_top).offset(-25);
                    make.left.equalTo(self.mas_left);
                    make.height.equalTo(@LABELHEIGHT);
                }];
                break;
            }
            case rightType:
            {
                detailLabel.textAlignment = NSTextAlignmentRight;
                [seeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.mas_centerX).offset(70+30);
                    make.bottom.equalTo(self.mas_bottom);
                    make.width.equalTo(@100);
                    make.height.equalTo(@44);
                }];
                [detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(seeButton.mas_right);
                    make.bottom.equalTo(seeButton.mas_top).offset(-25);
                    make.left.equalTo(self.mas_left);
                    make.height.equalTo(@LABELHEIGHT);
                }];
            }
            default:
                break;
        }
        
     
    }
    
    
}


- (void)createTeacherGuideTitle:(NSString *)title withAlignmentType:(AlignmentType)alignmentType
{
    NSMutableString *mutableString = [NSMutableString stringWithString:title];
    NSString *text = title;
    if([title rangeOfString:@"\n"].location != NSNotFound){
        text = [mutableString componentsSeparatedByString:@"\n"][0];
    }
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLabel.text = text;
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.font = [UIFont systemFontOfSize:17.0f];
    [detailLabel setTextAlignment:NSTextAlignmentRight];

    [self addSubview:detailLabel];
   
    if(![text isEqualToString:title]){
        
        UIView *horizontalView = [[UIView alloc] initWithFrame:CGRectZero];
        horizontalView.backgroundColor = [UIColor whiteColor];
        [self addSubview:horizontalView];
        
        UIView *verticalView = [[UIView alloc] initWithFrame:CGRectZero];
        verticalView.backgroundColor = [UIColor whiteColor];
        [self addSubview:verticalView];
        
        
        switch (alignmentType) {
            case flashLessonType:
            {
                detailLabel.textAlignment = NSTextAlignmentLeft;
                UILabel *detailSecondLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                detailLabel.text = [mutableString componentsSeparatedByString:@"\n"][1];
                detailLabel.textColor = [UIColor whiteColor];
                detailLabel.font = [UIFont systemFontOfSize:17.0f];
                [detailLabel setTextAlignment:NSTextAlignmentLeft];
                [self addSubview:detailSecondLabel];
                
                [verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@1);
                    make.height.equalTo(@50);
                    make.left.equalTo(self.mas_left).offset(30);
                    make.bottom.equalTo(self.mas_bottom);
                }];
                
                [horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@1);
                    make.width.equalTo(@250);
                    make.left.equalTo(self.mas_left).offset(6);
                    make.bottom.equalTo(verticalView.mas_top);
                }];
                
                [detailSecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(detailLabel.mas_right);
                    make.bottom.equalTo(horizontalView.mas_top).offset(-20);
                    make.left.equalTo(horizontalView.mas_left);
                    make.height.equalTo(@LABELHEIGHT);
                }];
                
                [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(detailSecondLabel.mas_left);
                    make.bottom.equalTo(detailSecondLabel.mas_top).offset(-5);
                    make.left.equalTo(detailSecondLabel.mas_left);
                    make.height.equalTo(@LABELHEIGHT);
                }];
                
            }
                break;
            default:
            {
                detailLabel.textAlignment = NSTextAlignmentCenter;
                UILabel *detailSecondLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                detailLabel.textAlignment = NSTextAlignmentLeft;
                detailLabel.text = [mutableString componentsSeparatedByString:@"\n"][1];
                detailLabel.textColor = [UIColor whiteColor];
                detailLabel.font = [UIFont systemFontOfSize:17.0f];
                [detailLabel setTextAlignment:NSTextAlignmentCenter];
                [self addSubview:detailSecondLabel];
                
                [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.mas_right).offset(-10);
                    make.bottom.equalTo(self.mas_top);
                    make.left.equalTo(self.mas_left);
                    make.height.equalTo(@LABELHEIGHT);
                }];
                
                [detailSecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(detailLabel.mas_right);
                    make.top.equalTo(detailLabel.mas_bottom).offset(5);
                    make.left.equalTo(self.mas_left);
                    make.height.equalTo(@LABELHEIGHT);
                }];
                
                [horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@1);
                    make.width.equalTo(@100);
                    make.centerX.equalTo(self.mas_centerX);
                    make.top.equalTo(@35);
                }];
                
                [verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@1);
                    make.height.equalTo(@50);
                    make.centerX.equalTo(self.mas_centerX);
                    make.top.equalTo(horizontalView.mas_bottom);
                }];

            }
                break;
        }
        
    }else{
        switch (alignmentType) {
            case commonType:
            {
                detailLabel.textAlignment = NSTextAlignmentRight;
                
            }
                break;
            case leftType:
            {
                detailLabel.textAlignment = NSTextAlignmentLeft;
                
                UIView *verticalView = [[UIView alloc] initWithFrame:CGRectZero];
                verticalView.backgroundColor = [UIColor whiteColor];
                [self addSubview:verticalView];
                
                [verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@1);
                    make.height.equalTo(@40);
                    make.left.equalTo(self.mas_left).offset(15+18);
                    make.top.equalTo(self.mas_top);
                }];
                [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.mas_right).offset(-10);
                    make.top.equalTo(verticalView.mas_bottom).offset(10);
                    make.left.equalTo(self.mas_left).offset(15);
                    make.height.equalTo(@LABELHEIGHT);
                }];
                
            }
                break;
            case rightType:
            {
                detailLabel.textAlignment = NSTextAlignmentRight;
                
                UIView *horizontalView = [[UIView alloc] initWithFrame:CGRectZero];
                horizontalView.backgroundColor = [UIColor whiteColor];
                [self addSubview:horizontalView];
                

                [horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@1);
                    make.width.equalTo(@25);
                    make.right.equalTo(self.mas_right).offset(-65);
                    make.centerY.equalTo(self.mas_centerY);
                }];
                
                [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(horizontalView.mas_left).offset(-2);
                    make.centerY.equalTo(horizontalView.mas_centerY);
                    make.left.equalTo(self.mas_left);
                    make.height.equalTo(@LABELHEIGHT);
                }];
                
            }
                break;
            case brushType:
            {
                detailLabel.textAlignment = NSTextAlignmentCenter;
                
                UIView *verticalView = [[UIView alloc] initWithFrame:CGRectZero];
                verticalView.backgroundColor = [UIColor whiteColor];
                [self addSubview:verticalView];
                
                UIView *horizontalView = [[UIView alloc] initWithFrame:CGRectZero];
                horizontalView.backgroundColor = [UIColor whiteColor];
                [self addSubview:horizontalView];
                
                [verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@1);
                    make.height.equalTo(@40);
                    make.centerX.equalTo(self.mas_centerX).offset(-70);
                    make.bottom.equalTo(self.mas_bottom).offset(-54);
                }];
                
                [horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@1);
                    make.width.equalTo(@180);
                    make.centerX.equalTo(self.mas_centerX).offset(-65);
                    make.bottom.equalTo(verticalView.mas_top);
                }];
                
                [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(horizontalView.mas_top).offset(-20);
                    make.height.equalTo(@LABELHEIGHT);
                    make.centerX.equalTo(horizontalView.mas_centerX);
                }];
            }
                break;
            case DodoodleType:
            {
                detailLabel.textAlignment = NSTextAlignmentCenter;
                
                UIView *verticalView = [[UIView alloc] initWithFrame:CGRectZero];
                verticalView.backgroundColor = [UIColor whiteColor];
                [self addSubview:verticalView];
                
                UIView *horizontalView = [[UIView alloc] initWithFrame:CGRectZero];
                horizontalView.backgroundColor = [UIColor whiteColor];
                [self addSubview:horizontalView];
                
                [verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@1);
                    make.height.equalTo(@40);
                    make.centerX.equalTo(self.mas_centerX);
                    make.bottom.equalTo(self.mas_bottom).offset(-54);
                }];
                
                [horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@1);
                    make.width.equalTo(@50);
                    make.centerX.equalTo(self.mas_centerX);
                    make.bottom.equalTo(verticalView.mas_top);
                }];
                
                [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(horizontalView.mas_top).offset(-20);
                    make.height.equalTo(@LABELHEIGHT);
                    make.centerX.equalTo(horizontalView.mas_centerX);
                }];

            }
                break;
            case cleanDoodleType:
            {
                detailLabel.textAlignment = NSTextAlignmentCenter;
                
                UIView *verticalView = [[UIView alloc] initWithFrame:CGRectZero];
                verticalView.backgroundColor = [UIColor whiteColor];
                [self addSubview:verticalView];
                
                UIView *horizontalView = [[UIView alloc] initWithFrame:CGRectZero];
                horizontalView.backgroundColor = [UIColor whiteColor];
                [self addSubview:horizontalView];
                
                [verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@1);
                    make.height.equalTo(@40);
                    make.centerX.equalTo(self.mas_centerX).offset(70);
                    make.bottom.equalTo(self.mas_bottom).offset(-54);
                }];
                
                [horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@1);
                    make.width.equalTo(@130);
                    make.centerX.equalTo(self.mas_centerX).offset(65);
                    make.bottom.equalTo(verticalView.mas_top);
                }];
                
                [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(horizontalView.mas_top).offset(-20);
                    make.height.equalTo(@LABELHEIGHT);
                    make.centerX.equalTo(horizontalView.mas_centerX);
                }];

            }
                break;
            case openFlashType:
            {
                detailLabel.textAlignment = NSTextAlignmentRight;
                
                UIView *verticalView = [[UIView alloc] initWithFrame:CGRectZero];
                verticalView.backgroundColor = [UIColor whiteColor];
                [self addSubview:verticalView];
                
                
                [verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@1);
                    make.height.equalTo(@40);
                    make.right.equalTo(self.mas_right).offset(-80);
                    make.top.equalTo(self.mas_top);
                }];
                
                [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(verticalView.mas_bottom).offset(20);
                    make.height.equalTo(@LABELHEIGHT);
                    make.right.equalTo(verticalView.mas_right).offset(10);
                }];
            }
                break;
          
            default:
                break;
        }
        
        
    }
    
    
}


@end
