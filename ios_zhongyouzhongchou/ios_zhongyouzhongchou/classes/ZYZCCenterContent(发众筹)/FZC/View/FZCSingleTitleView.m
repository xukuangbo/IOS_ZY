//
//  FZCSingleTitleView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/6/29.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "FZCSingleTitleView.h"

@implementation FZCSingleTitleView

- (instancetype)initWithTitle:(NSString *)title ContentView:(UIView *)contentView
{
    self = [super init];
    if (self) {
        //添加标题
        CGFloat titleLableX = 10;
        CGFloat titleLableY = 0;
        CGFloat titleLableW = contentView.frame.size.width;
        CGFloat titleLableH = 18;
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(titleLableX, titleLableY, titleLableW, titleLableH)];
        titleLable.font = [UIFont systemFontOfSize:15];
        titleLable.textColor = [UIColor ZYZC_titleBlackColor];
        titleLable.text = title;
        [self addSubview:titleLable];
        
        //lab旁加绿色的竖线
        UIImageView *vertical=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_bq"]];
        vertical.frame=CGRectMake(-10, 2.5, 2, titleLable.height-5);
        [titleLable addSubview:vertical];
        
        //添加一条灰色线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLable.bottom+KEDGE_DISTANCE, contentView.frame.size.width, 1)];
        lineView.backgroundColor = [UIColor ZYZC_LineGrayColor];
        [self addSubview:lineView];
        
        
        self.origin = CGPointMake(contentView.left, contentView.top);
        
        //添加内容的view
        CGFloat contentViewX = 0;
        CGFloat contentViewY = lineView.bottom ;
        contentView.left = contentViewX;
        contentView.top = contentViewY;
        [self addSubview:contentView];
        
        self.width = contentView.width;
        self.height = contentView.bottom;
    }
    return self;
}
@end
