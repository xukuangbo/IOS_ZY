//
//  ZYfootprintListCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYfootprintListCell.h"
#import "ZYOneFootprintView.h"

@interface ZYfootprintListCell ()
@property (nonatomic, strong) UIImageView        *bgImage;
@property (nonatomic, strong) UILabel            *timeLab;
@property (nonatomic, strong) ZYOneFootprintView *oneFootprintView;
@property (nonatomic, strong) UIView             *lineView;
@property (nonatomic, strong) UIImageView        *dotImageView;

@end

@implementation ZYfootprintListCell

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
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    //背景卡片
    _bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, KSCREEN_W-2*KEDGE_DISTANCE, 0.1)];
    _bgImage.userInteractionEnabled=YES;
    [self.contentView addSubview:_bgImage];
    
    //日期
    _timeLab = [ZYZCTool createLabWithFrame:CGRectMake(20, KEDGE_DISTANCE, _bgImage.width-30, 0.1) andFont:[UIFont systemFontOfSize:20] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    [_bgImage addSubview:_timeLab];
    
   //足迹内容
    _oneFootprintView=[[ZYOneFootprintView alloc]initWithFrame:CGRectMake(35, 0, _bgImage.width-45, 0.1)];
    _oneFootprintView.canOpenText=YES;
    _oneFootprintView.commentEnterType=enterCommentPage;
    [_bgImage addSubview:_oneFootprintView];
    
    //轴线
    _lineView=[UIView lineViewWithFrame:CGRectMake(KEDGE_DISTANCE, 0, 0.5, 0.1) andColor:[UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0]];
    [_bgImage addSubview:_lineView];
    
    //节点
    _dotImageView=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE-5, 0, 10, 10)];
    _dotImageView.image=[UIImage imageNamed:@"footprint-point"];
    [_bgImage addSubview:_dotImageView];
    
}

-(void)setListModel:(ZYFootprintListModel *)listModel
{
    _listModel =listModel;

    CGFloat content_top=10.0;
    
    NSString *year =nil;
    NSString *month=nil;
    NSString *day  =nil;
    NSString *dayTime=nil;
    
    //日期
    _timeLab.height=0.1;
    if (listModel.creattime.length) {
        NSString *time=[ZYZCTool turnTimeStampToDate:listModel.creattime];
        year  = [time substringToIndex:4];
        month = [time substringWithRange:NSMakeRange(5, 2)];
        day   = [time substringWithRange:NSMakeRange(8, 2)];
        dayTime=[time substringFromIndex:11];
    }

    _timeLab.hidden=YES;
    _dotImageView.hidden=YES;
    if (listModel.showDate) {
        _timeLab.hidden=NO;
        NSString *timeStr=[NSString stringWithFormat:@"%@年%@月",year,month];
        _timeLab.text=timeStr;
        _timeLab.height=25;
        content_top=_timeLab.bottom+20.0;
        _dotImageView.hidden=NO;
        _dotImageView.centerY=_timeLab.centerY;
    }
    
    _oneFootprintView.top=content_top;
    _oneFootprintView.height=0.1;
    
    _oneFootprintView.footprintModel=listModel;
    
    //背景卡片
    _bgImage.height=_oneFootprintView.bottom+KEDGE_DISTANCE;
    
    if (listModel.cellType==CompleteCell) {
         _bgImage.image=KPULLIMG(@"tab_bg_boss0",5, 0, 5, 0);
        _lineView.top=KEDGE_DISTANCE;
        _lineView.height=_bgImage.height-2*KEDGE_DISTANCE;
    }
    else if (listModel.cellType==HeadCell)
    {
        _bgImage.image=KPULLIMG(@"background-1",5, 0, 5, 0);
        _lineView.top=KEDGE_DISTANCE;
        _lineView.height=_bgImage.height-KEDGE_DISTANCE;
    }
    else if (listModel.cellType==BodyCell)
    {
         _bgImage.image=KPULLIMG(@"background-2",5, 0, 5, 0);
        _lineView.top=0;
        _lineView.height=_bgImage.height;

    }
    else if (listModel.cellType==FootCell)
    {
        _bgImage.image=KPULLIMG(@"background-3",5, 0, 5, 0);
        _lineView.top=0;
        _lineView.height=_bgImage.height-KEDGE_DISTANCE;
    }

    _listModel.cellHeight=_bgImage.bottom;
}

@end
