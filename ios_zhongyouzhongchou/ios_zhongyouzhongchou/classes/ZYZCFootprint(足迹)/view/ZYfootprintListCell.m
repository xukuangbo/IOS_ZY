//
//  ZYfootprintListCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define MAX_CONTENT_HEIGHT   120
#define PIC_WIDTH            (KSCREEN_W-75.0)/3.0

#import "ZYfootprintListCell.h"
#import "ZYZCCusomMovieImage.h"
#import "UIView+GetSuperTableView.h"
#import "HUImagePickerViewController.h"
#import "HUPhotoBrowser.h"
@interface ZYfootprintListCell ()
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UILabel     *timeLab;
@property (nonatomic, strong) UILabel     *contentLab;
@property (nonatomic, strong) UILabel     *detailTimeLab;
@property (nonatomic, strong) UIView      *imagesView;
@property (nonatomic, strong) ZYZCCusomMovieImage *video;
@property (nonatomic, strong) UIImageView *locationImg;
@property (nonatomic, strong) UILabel     *locationLab;
@property (nonatomic, strong) UIImageView *commentImg;
@property (nonatomic, strong) UILabel     *commentCountLab;
@property (nonatomic, strong) UIImageView *supportImg;
@property (nonatomic, strong) UILabel     *supportCountLab;
@property (nonatomic, strong) UIView      *lineView;
@property (nonatomic, strong) UIImageView *dotImageView;

@property (nonatomic, assign) BOOL        openContent;
@property (nonatomic, assign) BOOL        hasAddGesture;

@property (nonatomic, strong) NSArray     *imageUrls;


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
    
    //文字描述
    _contentLab=[ZYZCTool createLabWithFrame:CGRectMake(35, 0, _bgImage.width-45, 0.1) andFont:[UIFont systemFontOfSize:15] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    _contentLab.numberOfLines=0;
    [_bgImage addSubview:_contentLab];
    
    //详细时间
    _detailTimeLab=[ZYZCTool createLabWithFrame:CGRectMake(_contentLab.left, _contentLab.bottom+KEDGE_DISTANCE, _contentLab.width, 20) andFont:[UIFont systemFontOfSize:13] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    [_bgImage addSubview:_detailTimeLab];
    
    //存放图片
    _imagesView=[[UIView alloc]initWithFrame:CGRectMake(_contentLab.left, _detailTimeLab.bottom+KEDGE_DISTANCE, _contentLab.width, 0.1)];
    [_bgImage addSubview:_imagesView];
    
    //视频
    _video=[[ZYZCCusomMovieImage alloc]initWithFrame:CGRectMake(_contentLab.left, _imagesView.bottom, _contentLab.width, 0.1)];
    [_bgImage addSubview:_video];
    
    //位置
    _locationImg = [[UIImageView alloc]initWithFrame:CGRectMake(_contentLab.left, _video.bottom+KEDGE_DISTANCE, 15, 18)];
    _locationImg.image=[UIImage imageNamed:@"footprint-coordinate"];
    [_bgImage addSubview:_locationImg];
    
    _locationLab = [ZYZCTool createLabWithFrame:CGRectMake(_locationImg.right+5, _locationImg.top, 120, 20) andFont:[UIFont systemFontOfSize:12] andTitleColor:[UIColor ZYZC_MainColor]];
    [_bgImage addSubview:_locationLab];
    
    //点赞
    _supportImg = [[UIImageView alloc]initWithFrame:CGRectMake(_bgImage.width-30-18-2, _locationImg.top+2, 18, 16)];
    _supportImg.image=[UIImage imageNamed:@"footprint-like"];
    [_bgImage addSubview:_supportImg];
    
    _supportCountLab=[ZYZCTool createLabWithFrame:CGRectMake(_supportImg.right+2, _locationImg.top, 30, 20) andFont:[UIFont systemFontOfSize:12] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    [_bgImage addSubview:_supportCountLab];
    
    //评论
    _commentCountLab = [ZYZCTool createLabWithFrame:CGRectMake(_supportImg.left-40, _locationImg.top, 30, 20) andFont:[UIFont systemFontOfSize:12] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    [_bgImage addSubview:_commentCountLab];
    
    _commentImg = [[UIImageView alloc]initWithFrame:CGRectMake(_commentCountLab.left-18-2, _locationImg.top+2.5, 18, 15)];
    _commentImg.image=[UIImage imageNamed:@"footprint-comment"];
    [_bgImage addSubview:_commentImg];
    
    _locationLab.width=_commentImg.left-_locationLab.left-10;
    
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
    
    _contentLab.top=content_top;
    _contentLab.height=0.1;
    CGFloat detailTimeLab_top=_contentLab.bottom;
    
    //文字内容
    if (listModel.content.length) {
        _contentLab.text=listModel.content;
        CGFloat contentHeight = [ZYZCTool calculateStrLengthByText:listModel.content andFont:_contentLab.font andMaxWidth:_contentLab.width].height;
        _contentLab.height=contentHeight;
        if (contentHeight>MAX_CONTENT_HEIGHT) {
            if (!_hasAddGesture) {
                [_contentLab addTarget:self action:@selector(OpenOrCloseContent)];
                _hasAddGesture=YES;
            }
            _contentLab.height= (!_openContent)?MAX_CONTENT_HEIGHT:contentHeight;
        }
        detailTimeLab_top = _contentLab.bottom+KEDGE_DISTANCE;
    }
    
    //详细时间
    if (listModel.creattime.length) {
        _detailTimeLab.text=[NSString stringWithFormat:@"%@年%@月%@日  %@",year,month,day,dayTime];
        _detailTimeLab.top=detailTimeLab_top;
    }

    //图片
    NSArray *views=[_imagesView subviews];
    for (NSInteger i=views.count-1; i>=0; i-- ) {
        if ([views[i] isKindOfClass:[UIImageView class]]) {
            [views[i] removeFromSuperview];
        }
    }
    _imagesView.top = _detailTimeLab.bottom+KEDGE_DISTANCE;
    _imagesView.height=0.1;
    CGFloat video_top=_imagesView.bottom;
    if (listModel.pics.length) {
        _imageUrls=[listModel.pics componentsSeparatedByString:@","];
        [self getPics:_imageUrls];
        
        video_top=_imagesView.bottom+KEDGE_DISTANCE;
    }

    //视频
    _video.top=video_top;
    _video.hidden=YES;
    _video.height=0.1;
    CGFloat locationView_top=_video.bottom;
    if (listModel.video.length) {
        _video.hidden=NO;
        _video.height=_video.width*0.565;
        [ _video sd_setImageWithURL:[NSURL URLWithString:listModel.videoimg] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
        _video.playUrl=listModel.video;
        [_video changeFrame];
        locationView_top=_video.bottom+KEDGE_DISTANCE;
    }
    
    //位置
    _locationImg.top = locationView_top;
    _locationLab.top = locationView_top;
    _commentImg.top=locationView_top+2.5;
    _commentCountLab.top=locationView_top;
    _supportImg.top=locationView_top;
    _supportCountLab.top=locationView_top;
    _locationImg.hidden=YES;
    _locationLab.hidden=YES;
    if (listModel.gpsData.length) {
        _locationImg.hidden=NO;
        _locationLab.hidden=NO;
        NSDictionary *dic=[ZYZCTool turnJsonStrToDictionary:listModel.gpsData];
        NSString *GPS_Address=dic[@"GPS_Address"];
        if (GPS_Address) {
            _locationLab.text=GPS_Address;
        }
    }
    
    _commentCountLab.text=@"评论";
    _supportCountLab.text=@"点赞";
    
    //背景卡片
    _bgImage.height=_locationImg.bottom+KEDGE_DISTANCE;
    
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

#pragma mark --- 加载图片
- (void)getPics:(NSArray *)imageUrls
{
     CGFloat lastBottom=0.0;
    
    if (imageUrls.count==1) {
        UIImageView *pic=[self createUrlImageWithFrame:CGRectMake(0,0, 2*PIC_WIDTH+10, 2*PIC_WIDTH+10) andUrl:imageUrls[0]];
        [_imagesView addSubview:pic];
        lastBottom=pic.bottom;
    }
    
    else if (imageUrls.count==4) {
        for (NSInteger i=0; i<imageUrls.count; i++) {
            UIImageView *pic=[self createUrlImageWithFrame:CGRectMake((i%2)*(PIC_WIDTH+10), (i/2)*(PIC_WIDTH+10), PIC_WIDTH, PIC_WIDTH) andUrl:imageUrls[i]];
            pic.tag=i;
            [_imagesView addSubview:pic];
            lastBottom=pic.bottom;
        }
    }
    else
    {
        for (NSInteger i=0; i<imageUrls.count; i++) {
            UIImageView *pic=[self createUrlImageWithFrame:CGRectMake((i%3)*(PIC_WIDTH+10), (i/3)*(PIC_WIDTH+10), PIC_WIDTH, PIC_WIDTH) andUrl:imageUrls[i]];
            pic.tag=i;
            [_imagesView addSubview:pic];
            lastBottom=pic.bottom;
        }
    }
    _imagesView.height=lastBottom;

}

#pragma mark --- 创建网络图片
-(UIImageView *)createUrlImageWithFrame:(CGRect)frame andUrl:(NSString *)imageUrl
{
    UIImageView *pic=[[UIImageView alloc]initWithFrame:frame];
    [ pic sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority ];
    pic.contentMode=UIViewContentModeScaleAspectFill;
    pic.layer.masksToBounds=YES;
    [pic addTarget:self action:@selector(skimPics:)];
    return pic;
}

#pragma mark --- 图片浏览
- (void)skimPics:(UITapGestureRecognizer *)tap
{
    UIImageView *pic=(UIImageView *)tap.view;
    [HUPhotoBrowser showFromImageView:pic withImgURLs:_imageUrls placeholderImage:[UIImage imageNamed:@"image_placeholder"] atIndex:pic.tag dismiss:nil];

}

#pragma mark --- 文字是否展开
-(void)OpenOrCloseContent
{
    _openContent=!_openContent;
    [self.getSuperTableView reloadData];
}





@end
