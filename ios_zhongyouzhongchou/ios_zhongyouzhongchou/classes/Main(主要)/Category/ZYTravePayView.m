//
//  ZYTravePayView.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/10/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYTravePayView.h"
#import "ZYTravePayView.h"
@implementation ZYTravePayView

+ (instancetype)loadCustumView {
    ZYTravePayView * view = nil;
    NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:@"ZYTravePayVIew" owner:self options:nil];
    view = (ZYTravePayView *)[nibs objectAtIndex:0];
    [view initMember];
    
    return view;
}


- (void)initMember {
    self.playTourRecordButton.titleEdgeInsets = UIEdgeInsetsMake(0,-15, 0, 0);
    self.playTourRecordButton.imageEdgeInsets = UIEdgeInsetsMake(0,115, 0, 9);
    [self.playTourRecordButton setImage:[UIImage imageNamed:@"btn_rightin"] forState:UIControlStateNormal];
    
    self.journeyDetailButton.titleEdgeInsets = UIEdgeInsetsMake(0,-15, 0, 0);
    self.journeyDetailButton.imageEdgeInsets = UIEdgeInsetsMake(0,115, 0, 9);
    [self.journeyDetailButton setImage:[UIImage imageNamed:@"btn_rightin"] forState:UIControlStateNormal];
    
    self.frame = CGRectMake(10,[UIScreen mainScreen].bounds.size.height/2 - self.frame.size.width/2, [UIScreen mainScreen].bounds.size.width-20, self.frame.size.height);
    for (UIView *tmpView in self.subviews)
    {
        if(tmpView.userInteractionEnabled && [tmpView isMemberOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)tmpView;
            if ([btn.currentTitle isEqualToString:@"报名回报50元"]) {
                [tmpView.layer setMasksToBounds:YES];
                [tmpView.layer setBorderWidth:1];
                [tmpView.layer setCornerRadius:4];
                [tmpView.layer setBorderColor:[[UIColor colorWithHexString:@"#d6d6d6"] CGColor]];
                
                btn.titleLabel.font = [UIFont systemFontOfSize:20.0];
                btn.titleLabel.numberOfLines = 2;
                [btn setTitle:@"报名回报\n    50元" forState:UIControlStateNormal];
            } else if ([btn.currentTitle isEqualToString:@"报名一起去500元"]) {
                [tmpView.layer setMasksToBounds:YES];
                [tmpView.layer setBorderWidth:1];
                [tmpView.layer setCornerRadius:4];
                [tmpView.layer setBorderColor:[[UIColor colorWithHexString:@"#d6d6d6"] CGColor]];
                
                btn.titleLabel.numberOfLines = 2;
                btn.titleLabel.font = [UIFont systemFontOfSize:20.0];
                [btn setTitle:@"报名一起去\n     500元" forState:UIControlStateNormal];
            } else if ([btn.currentTitle isEqualToString:@"我的打赏记录"]) {
                
            } else if ([btn.currentTitle isEqualToString:@"了解行程详情"]) {
                
            } else {
                [tmpView.layer setMasksToBounds:YES];
                [tmpView.layer setBorderWidth:1];
                [tmpView.layer setCornerRadius:4];
                [tmpView.layer setBorderColor:[[UIColor colorWithHexString:@"#d6d6d6"] CGColor]];
                
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:btn.currentTitle];
                [AttributedStr addAttribute:NSFontAttributeName
                                      value:[UIFont systemFontOfSize:24.0]
                                      range:NSMakeRange(0, [btn.currentTitle length] - 1)];
                btn.titleLabel.attributedText = AttributedStr;
            }
//            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"439cf4"] forState:UIControlStateSelected];
        }
    }
}
- (IBAction)playTourRecordButtonAction:(UIButton *)sender {
}
- (IBAction)journeyDetailButtonAction:(UIButton *)sender {
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
