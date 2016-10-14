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


- (void)createDetailWithAlignmentType:(detailType)alignmentType
{
    UIButton *seeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [seeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    seeButton.titleLabel.font = [UIFont systemFontOfSize:17];
    seeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    seeButton.layer.cornerRadius = 4;
    seeButton.layer.masksToBounds = YES;
    seeButton.backgroundColor = [UIColor colorWithHexString:@"0de4d7"];
    [seeButton setTitle:@"我知道了" forState:UIControlStateNormal];
    [self addSubview:seeButton];
    switch (alignmentType) {
        case startHomeType:
        {
            [seeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-20);
                make.top.equalTo(@186);
                make.width.equalTo(@100);
                make.height.equalTo(@35);
            }];
            break;
        }
        case voiceType:
        {
            [seeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-20);
                make.top.equalTo(@440);
                make.width.equalTo(@100);
                make.height.equalTo(@35);
            }];
            break;
        }
        case skipType:
        {
            [seeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-20);
                make.top.equalTo(@186);
                make.width.equalTo(@100);
                make.height.equalTo(@35);
            }];
            break;
        }
        case prevType:
        {
            [seeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-20);
                make.bottom.equalTo(@-42);
                make.width.equalTo(@100);
                make.height.equalTo(@35);
            }];
            break;
        }
        default:
            break;
    }
    
    
}


@end
