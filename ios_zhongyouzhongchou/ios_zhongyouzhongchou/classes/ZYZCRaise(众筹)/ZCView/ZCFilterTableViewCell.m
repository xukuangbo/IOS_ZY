//
//  ZCFilterTableViewCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCFilterTableViewCell.h"
@interface ZCFilterTableViewCell ()
{
    UILabel *lab;
    UIImageView *img;
}
@end
@implementation ZCFilterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor=[UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        if (indexPath.row<2) {
           [self configCustomUI];
        }
        else
        {
            [self configUI];
        }
        if (indexPath.row!=2) {
            [self addSubview:[UIView lineViewWithFrame:CGRectMake(17, self.frame.size.height-6, 125-34, 1) andColor:[UIColor whiteColor]]];
        }

    }
    return self;
}

-(void)configUI
{
    self.textLabel.textAlignment=NSTextAlignmentCenter;
    self.textLabel.textColor=[UIColor whiteColor];
    self.textLabel.font=[UIFont systemFontOfSize:17];
}

-(void)configCustomUI
{
    lab=[[UILabel alloc]initWithFrame:CGRectMake(27, 10, 54, 20)];
    lab.font=[UIFont systemFontOfSize:17];
    lab.textColor=[UIColor whiteColor];
    [self.contentView addSubview:lab];
    
    img=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame)-3, 10, 20, 20)];
    [self.contentView addSubview:img];
    
}

-(void)setModel:(ZCFilterModel *)model
{
    _model=model;
    lab.text=model.title;
    img.image=[UIImage imageNamed:model.imgName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
