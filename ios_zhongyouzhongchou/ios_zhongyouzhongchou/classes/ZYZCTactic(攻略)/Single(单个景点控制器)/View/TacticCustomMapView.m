//
//  TacticCustomMapView.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticCustomMapView.h"

@implementation TacticCustomMapView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat margin = 10;
        self.userInteractionEnabled = YES;
        self.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
        self.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        //创建绿线
        CGFloat lineHeight = 15;
        [self addSubview:[UIView lineViewWithFrame:CGRectMake(margin , margin, 2, lineHeight) andColor:[UIColor ZYZC_MainColor]]];
        //创建标题
        CGFloat titleLabelX = margin * 2;
        CGFloat titleLabelY = KEDGE_DISTANCE;
        CGFloat titleLabelW = self.width - titleLabelX * 2;
        CGFloat titleLabelH = lineHeight;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];    
//        titleLabel.backgroundColor = [UIColor redColor];
        titleLabel.textColor = [UIColor ZYZC_titleBlackColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        //创建向右的箭头
        CGFloat rightButtonW = 40;
        CGFloat rightButtonH = 15;
        CGFloat rightButtonX = self.width - margin - rightButtonW;
        CGFloat rightButtonY = margin;
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(rightButtonX, rightButtonY, rightButtonW, rightButtonH);
        [rightButton setImage:[UIImage imageNamed:@"btn_rig_mor"] forState:UIControlStateNormal];
        rightButton.hidden = YES;
        [rightButton setTitle:@"更多" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
        rightButton.titleLabel.font = descFont;
        self.moreButton = rightButton;
        
        //得出文字的宽度,交换两个的位置
        CGSize rightButtonTitleSize = [ZYZCTool calculateStrLengthByText:@"更多" andFont:descFont andMaxWidth:MAXFLOAT];
        CGFloat labelWidth = rightButtonTitleSize.width + 2;
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
        CGFloat imageWith = rightButton.currentImage.size.width + 2;
        rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, 0, imageWith);
        [rightButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
        //创建描述
//        CGFloat descLabelX = margin * 2;
//        CGFloat descLabelY = titleLabel.bottom + 4;
//        CGFloat descLabelW = 250;
//        CGFloat descLabelH = lineHeight;
//        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(descLabelX, descLabelY, descLabelW, descLabelH)];
//        descLabel.font = descFont;
//        descLabel.textColor = [UIColor ZYZC_TextGrayColor];
//        [self addSubview:descLabel];
//        self.descLabel = descLabel;
    }
    return self;
}


- (void)moreButtonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(pushToMoreVC:)]) {
        [self.delegate pushToMoreVC:button];
    }
    
}
@end
