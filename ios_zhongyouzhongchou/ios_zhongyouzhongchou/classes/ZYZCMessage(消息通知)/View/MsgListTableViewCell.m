//
//  MsgListTableViewCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MsgListTableViewCell.h"

@interface MsgListTableViewCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel     *titleLab;
@property (nonatomic, strong) UILabel     *subTitleLab;
@property (nonatomic, strong) UILabel     *timeLab;
@property (nonatomic, strong) UIImageView *markImg;

@property (nonatomic, strong) UIImageView *beingLiveImage;

@end

@implementation MsgListTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor= [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    //icon
    CGFloat  icon_width=60;
    _icon= [[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, icon_width, icon_width)];
    _icon.layer.cornerRadius=KCORNERRADIUS;
    _icon.layer.masksToBounds=YES;
    [self.contentView addSubview:_icon];
    
    //title
    _titleLab=[self createLabWithFrame:CGRectMake(_icon.right+KEDGE_DISTANCE, KEDGE_DISTANCE, KSCREEN_W-_icon.right-20, 20) andFont:[UIFont systemFontOfSize:15] andTitleColor:[UIColor ZYZC_TextBlackColor]];
//    _titleLab.backgroundColor=[UIColor greenColor];
    [self.contentView addSubview:_titleLab];
    
    //subTitle;
    _subTitleLab=[self createLabWithFrame:CGRectMake(_titleLab.left, _titleLab.bottom+20, KSCREEN_W-_icon.right-20, 20) andFont:[UIFont systemFontOfSize:13] andTitleColor:[UIColor ZYZC_TextGrayColor]];
//    _subTitleLab.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:_subTitleLab];
    
    //time
    _timeLab=[self createLabWithFrame:CGRectMake(KSCREEN_W-150, 30, 130, 20) andFont:[UIFont systemFontOfSize:12] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    _timeLab.textAlignment=NSTextAlignmentRight;
//    _timeLab.backgroundColor=[UIColor orangeColor];
    [self.contentView addSubview:_timeLab];
    
    //readStatus
    CGFloat mark_width=8;
    _markImg=[[UIImageView alloc]initWithFrame:CGRectMake(KSCREEN_W-10-mark_width, 10, mark_width, mark_width)];
    _markImg.image=[UIImage imageNamed:@"icn_status"];
    [self.contentView addSubview:_markImg];
    _markImg.hidden=YES;
    
    _beingLiveImage=[[UIImageView alloc]initWithFrame:CGRectMake(KSCREEN_W-10-mark_width, 10, mark_width, mark_width)];
    _beingLiveImage.image=[UIImage imageNamed:@"being_live"];
    _beingLiveImage.hidden=YES;
    [self.contentView addSubview:_beingLiveImage];
    [_beingLiveImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.icon.mas_right).offset(-5);
        make.bottom.equalTo(self.icon.mas_bottom).offset(-5);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(30);
    }];
}

-(void)setMsgListModel:(MsgListModel *)msgListModel
{
    _msgListModel=msgListModel;
    //判断有没有图标，没有展示本地图标
    if (msgListModel.icon) {
        [_icon sd_setImageWithURL:[NSURL URLWithString:msgListModel.icon] placeholderImage:[UIImage imageNamed:@"众筹ICON"]];
    }
    else
    {
        if (_msgListModel.msgStyle==99) {
            _icon.image=[UIImage imageNamed:@"Share_iocn"];
        } else if (_msgListModel.msgStyle == 10) {
//            _beingLiveImage.hidden = NO;
            [_icon sd_setImageWithURL:[NSURL URLWithString:msgListModel.icon] placeholderImage:[UIImage imageNamed:@"众筹ICON"]];
        } else {
             _icon.image=[UIImage imageNamed:@"众筹ICON"];
        }
    }
    _titleLab.text=msgListModel.title;
    _subTitleLab.text=msgListModel.subtitle;
    if (msgListModel.msgtime) {
       _timeLab.text=[ZYZCTool turnTimeStampToDate:msgListModel.msgtime];
    }
    
    //是否已读
    _markImg.hidden=msgListModel.readstatus;
    
}

#pragma mark --- 创建lab
-(UILabel *)createLabWithFrame:(CGRect )frame andFont:(UIFont *)font andTitleColor:(UIColor *)color
{
    UILabel *lab=[[UILabel alloc]initWithFrame:frame];
    lab.font=font;
    lab.textColor=color;
    return lab;
}





@end
