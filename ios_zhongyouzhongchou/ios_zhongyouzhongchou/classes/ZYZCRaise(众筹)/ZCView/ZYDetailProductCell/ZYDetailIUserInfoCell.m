//
//  ZYDetailIUserInfoCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/10/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYDetailIUserInfoCell.h"
#import "ZYDetailUserInfoView.h"

#define KRAISE_MONEY(money)  [NSString stringWithFormat:@"预筹¥%.2f",money]
#define KSTART_TIME(time)     [NSString stringWithFormat:@"%@出发",time]

@interface ZYDetailIUserInfoCell ()

@property (nonatomic, strong) UIImageView  *bgImg;

@end

@implementation ZYDetailIUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    _bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, KSCREEN_W-2*KEDGE_DISTANCE, USER_INFO_CELL_HEIGHT)];
    _bgImg.image=KPULLIMG(@"tab_bg_boss0", 10, 0, 10, 0);
    _bgImg.userInteractionEnabled=YES;
    [self.contentView addSubview:_bgImg];
    
    ZYDetailUserInfoView *infoView= [[[NSBundle mainBundle] loadNibNamed:@"ZYDetailUserInfoView" owner:nil options:nil] objectAtIndex:0];
    [_bgImg addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgImg).offset(0);
        make.left.equalTo(_bgImg).offset(10);
        make.right.equalTo(_bgImg).offset(-10);
        make.height.mas_equalTo(210);
    }];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
