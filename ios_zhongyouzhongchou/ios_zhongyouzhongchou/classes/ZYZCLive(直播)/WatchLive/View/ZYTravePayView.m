//
//  ZYTravePayView.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 16/10/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYTravePayView.h"
#import "ZYTravePayView.h"
#import "ZYDownloadGiftImageModel.h"
@implementation ZYTravePayView

+ (instancetype)loadCustumView:(NSMutableArray *)giftImageArray {
    ZYTravePayView * view = nil;
    NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:@"ZYTravePayVIew" owner:self options:nil];
    view = (ZYTravePayView *)[nibs objectAtIndex:0];
    [view initMember:giftImageArray];
    
    return view;
}


- (void)initMember:(NSMutableArray *)giftImageArray {
    for (int i = 0; i < giftImageArray.count; i++) {
        UIView *tmpView = self.subviews[i];
        if(tmpView.userInteractionEnabled && [tmpView isMemberOfClass:[UIButton class]])
        {
            ZYDownloadGiftImageModel *model = giftImageArray[i];
            [tmpView.layer setMasksToBounds:YES];
            [tmpView.layer setBorderWidth:1];
            [tmpView.layer setCornerRadius:4];
            [tmpView.layer setBorderColor:[[UIColor colorWithHexString:@"#d6d6d6"] CGColor]];
            
            UIButton *btn = (UIButton *)tmpView;
            btn.tag = [model.price integerValue] / 10;
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.icon]];
            [btn setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
        }
    }

    self.contributionRecordButton.titleEdgeInsets = UIEdgeInsetsMake(0,-25, 0, 0);
    self.contributionRecordButton.imageEdgeInsets = UIEdgeInsetsMake(0,115, 0, 9);
    [self.contributionRecordButton setImage:[UIImage imageNamed:@"btn_rightin"] forState:UIControlStateNormal];
    
    self.journeyDetailButton.titleEdgeInsets = UIEdgeInsetsMake(0,-25, 0, 0);
    self.journeyDetailButton.imageEdgeInsets = UIEdgeInsetsMake(0,115, 0, 9);
    [self.journeyDetailButton setImage:[UIImage imageNamed:@"btn_rightin"] forState:UIControlStateNormal];
    
    self.frame = CGRectMake(10,[UIScreen mainScreen].bounds.size.height/2 - self.frame.size.width/2, [UIScreen mainScreen].bounds.size.width-20, self.frame.size.height);
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.9;
   /** for (UIView *tmpView in self.subviews)
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
                [btn setTitle:[NSString stringWithFormat:@"报名回报\n    %.1lf元", model.rewardMoney / 100.0] forState:UIControlStateNormal];
                btn.tag = model.rewardMoney / 10;
            } else if ([btn.currentTitle isEqualToString:@"报名一起去500元"]) {
                [tmpView.layer setMasksToBounds:YES];
                [tmpView.layer setBorderWidth:1];
                [tmpView.layer setCornerRadius:4];
                [tmpView.layer setBorderColor:[[UIColor colorWithHexString:@"#d6d6d6"] CGColor]];
                
                btn.titleLabel.numberOfLines = 2;
                btn.titleLabel.font = [UIFont systemFontOfSize:20.0];
                [btn setTitle:[NSString stringWithFormat:@"报名一起去\n     %.1lf元", model.togetherGoMoney / 100.0]  forState:UIControlStateNormal];
                btn.tag = model.togetherGoMoney / 10;
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
    */
}

- (IBAction)journeyDetailButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickJourneyDetailBtnUKey)]) {
        [self.delegate clickJourneyDetailBtnUKey];
    }
}

- (IBAction)onSelect:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickTravePayBtnUKey:style:)]) {
        [self.delegate clickTravePayBtnUKey:sender.tag style:kCommonLiveUserContributionStyle];
    }
}

- (IBAction)rewardButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickTravePayBtnUKey:style:)]) {
        [self.delegate clickTravePayBtnUKey:sender.tag style:kRewardLiveUserContributionStyle];
    }
}
- (IBAction)togetherGoButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickTravePayBtnUKey:style:)]) {
        [self.delegate clickTravePayBtnUKey:sender.tag style:kTogetherGoLiveUserContributionStyle];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
