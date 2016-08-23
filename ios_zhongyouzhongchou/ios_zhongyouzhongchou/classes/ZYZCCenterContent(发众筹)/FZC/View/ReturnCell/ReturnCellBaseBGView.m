
//
//  ReturnCellBaseBGView.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ReturnCellBaseBGView.h"
#import "MoreFZCReturnTableView.h"
#import "UIView+GetSuperTableView.h"
#import "ReturnThirdCell.h"
#import "ReturnFourthCell.h"
@interface ReturnCellBaseBGView ()
@property (nonatomic, weak) UIView *shadowView;
@end

@implementation ReturnCellBaseBGView

+ (instancetype)viewWithRect:(CGRect)frame title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage desc:(NSString *)desc
{
    return [[self alloc] initWithRect:frame title:title image:image selectedImage:selectedImage desc:desc];
}

- (instancetype)initWithRect:(CGRect)frame title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage desc:(NSString *)desc
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        //间隙
        //创建图片btn
        UIButton *iconbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        iconbutton.frame = CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, 20, 20);
        [iconbutton setImage:image forState:UIControlStateNormal];
        [iconbutton setImage:selectedImage forState:UIControlStateSelected];
        [iconbutton addTarget:self action:@selector(bgEnabledAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:iconbutton];
        self.iconButton = iconbutton;
        
        //创建标题label
        CGFloat titleLabelX = iconbutton.right + KEDGE_DISTANCE;
        CGFloat titleLabelY = iconbutton.top;
        CGFloat titleLabelW = self.width - titleLabelX - KEDGE_DISTANCE;
        CGFloat titleLabelH = iconbutton.height;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX,titleLabelY,titleLabelW,titleLabelH)];
        [titleLabel addTarget:self action:@selector(bgEnabledAction)];
        titleLabel.text = title;
        titleLabel.numberOfLines = 3;
        titleLabel.textColor = [UIColor redColor];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        //创建一条虚线
        CGFloat lineViewX = iconbutton.left;
        CGFloat lineViewY = iconbutton.bottom + KEDGE_DISTANCE;
        CGFloat lineViewW = self.width - lineViewX * 2;
        CGFloat lineViewH = 1;
        UIView *lineView = [UIView lineViewWithFrame:CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH) andColor:[UIColor ZYZC_LineGrayColor]];
        [self addSubview:lineView];
        self.lineView = lineView;
        
//        NSLog(@"%f",lineView.bottom);
        
        
        
        //创建实体内容
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconbutton.left, lineView.bottom + KEDGE_DISTANCE, BgDescLabelWidth, BgDescLabelNormalHeight)];
        descLabel.font = BgDescLabelFont;
        descLabel.lineBreakMode = NSLineBreakByTruncatingTail | NSLineBreakByCharWrapping;
        descLabel.numberOfLines = 3;
        [descLabel addTarget:self action:@selector(descLabelClickAction)];
        descLabel.textColor = [UIColor ZYZC_TextBlackColor];
        descLabel.attributedText= [ZYZCTool setLineDistenceInText:desc];
//        descLabel.backgroundColor = [UIColor redColor];
        //    [descLabel sizeToFit];
        [self addSubview:descLabel];
        self.descLabel = descLabel;
       
        //计算高度
        self.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
        
        //创建一个向下的箭头
        CGFloat downButtonWH = 30;
        CGFloat downButtonY = self.height - KEDGE_DISTANCE - downButtonWH;
        CGFloat downButtonX = self.width - KEDGE_DISTANCE - downButtonWH;
        UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [downButton setImage:[UIImage imageNamed:@"btn_xxd"] forState:UIControlStateNormal];
        downButton.frame = CGRectMake(downButtonX, downButtonY, downButtonWH, downButtonWH);
        downButton.imageEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0);
//        downButton.right = 
        downButton.bottom = descLabel.bottom;
        [self addSubview:downButton];
        self.downButton = downButton;
        
    }
    
    
    return self;
}

/**
 *  左上角按钮的可点击事件
 */
- (void)bgEnabledAction
{
    
    if (self.index != 2 && self.index != 3) {
        return;
    }
    
    if (_iconButtonClickBlock) {
        _iconButtonClickBlock();
    }

}


- (void)descLabelClickAction
{
    if (self.descLabelClickBlock) {
        self.descLabelClickBlock();
    }
    
}

/**
 *  展开button 的点击动作
 */
- (void)downButtonAction:(UIButton *)button
{
    
    
    
}



@end
