//
//  ZYOneFootprintView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define MAX_CONTENT_HEIGHT   120
#define PIC_WIDTH            (KSCREEN_W-85.0)/3.0

#import "ZYOneFootprintView.h"
#import "ZYZCCusomMovieImage.h"
#import "UIView+GetSuperTableView.h"
#import "HUImagePickerViewController.h"
#import "HUPhotoBrowser.h"
#import "MBProgressHUD+MJ.h"
#import "ZYCommentFootprintController.h"
@interface ZYOneFootprintView ()<UIAlertViewDelegate>
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
@property (nonatomic, strong) UILabel     *deleteLab;

@property (nonatomic, strong) UIButton    *commentBtn;//评论按钮
@property (nonatomic, strong) UIButton    *supportBtn;//点赞按钮

@property (nonatomic, assign) BOOL        textHasAddGesture;
@property (nonatomic, assign) BOOL        openContent;

@property (nonatomic, strong) NSArray     *imageUrls;

@end

@implementation ZYOneFootprintView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    //文字描述
    _contentLab=[ZYZCTool createLabWithFrame:CGRectMake(0, 0, self.width, 0.1) andFont:[UIFont systemFontOfSize:15] andTitleColor:[UIColor ZYZC_TextBlackColor]];
    _contentLab.numberOfLines=0;
//    _contentLab.backgroundColor=[UIColor orangeColor];
    [self addSubview:_contentLab];
    
    //详细时间
    _detailTimeLab=[ZYZCTool createLabWithFrame:CGRectMake(_contentLab.left, _contentLab.bottom+KEDGE_DISTANCE, _contentLab.width, 20) andFont:[UIFont systemFontOfSize:13] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    [self addSubview:_detailTimeLab];
    
    //存放图片
    _imagesView=[[UIView alloc]initWithFrame:CGRectMake(_contentLab.left, _detailTimeLab.bottom+KEDGE_DISTANCE, _contentLab.width, 0.1)];
    [self addSubview:_imagesView];
    
    //视频
    _video=[[ZYZCCusomMovieImage alloc]initWithFrame:CGRectMake(_contentLab.left, _imagesView.bottom, _contentLab.width, 0.1)];
    [self addSubview:_video];
    
    //位置
    _locationImg = [[UIImageView alloc]initWithFrame:CGRectMake(_contentLab.left, _video.bottom+KEDGE_DISTANCE, 15, 18)];
    _locationImg.image=[UIImage imageNamed:@"footprint-coordinate"];
    [self addSubview:_locationImg];
    
    _locationLab = [ZYZCTool createLabWithFrame:CGRectMake(_locationImg.right+5, _locationImg.top, 120, 20) andFont:[UIFont systemFontOfSize:12] andTitleColor:[UIColor ZYZC_MainColor]];
    [self addSubview:_locationLab];
    
    //点赞
    _supportImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.width-30-18-2, _locationImg.top+2, 18, 16)];
    _supportImg.image=[UIImage imageNamed:@"footprint-like"];
    [self addSubview:_supportImg];
    
    _supportCountLab=[ZYZCTool createLabWithFrame:CGRectMake(_supportImg.right+2, _locationImg.top, 30, 20) andFont:[UIFont systemFontOfSize:12] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    [self addSubview:_supportCountLab];
    
    //评论
    _commentCountLab = [ZYZCTool createLabWithFrame:CGRectMake(_supportImg.left-40, _locationImg.top, 30, 20) andFont:[UIFont systemFontOfSize:12] andTitleColor:[UIColor ZYZC_TextGrayColor]];
    [self addSubview:_commentCountLab];
    
    _commentImg = [[UIImageView alloc]initWithFrame:CGRectMake(_commentCountLab.left-18-2, _locationImg.top+2.5, 18, 15)];
    _commentImg.image=[UIImage imageNamed:@"footprint-comment"];
    [self addSubview:_commentImg];
    
    _locationLab.width=_commentImg.left-_locationLab.left-10;
    
    //评论按钮
    _commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _commentBtn.frame=CGRectMake(_commentImg.left, _locationImg.top, _commentCountLab.right-_commentImg.left, 20);
    _supportBtn.backgroundColor=[UIColor clearColor];
    [_commentBtn addTarget:self action:@selector(commentFootprint:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentBtn];
    
    //点赞按钮
    _supportBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _supportBtn.frame=CGRectMake(_supportImg.left, _locationImg.top, _supportCountLab.right-_supportImg.left, 20);
    _supportBtn.backgroundColor=[UIColor clearColor];
    [_supportBtn addTarget:self action:@selector(addOrCancelSupport:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_supportBtn];
    
    //删除键
    _deleteLab=[ZYZCTool createLabWithFrame:CGRectMake(self.width-60,0, 60, 30) andFont:[UIFont systemFontOfSize:15] andTitleColor:[UIColor ZYZC_RedTextColor]];
    _deleteLab.text=@"删除";
    _deleteLab.hidden=YES;
    _deleteLab.textAlignment=NSTextAlignmentRight;
    [_deleteLab addTarget:self  action:@selector(deleteOneFootprint)];
    [self addSubview:_deleteLab];
    
//    _deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    _deleteBtn.frame=_deleteLab.frame ;
//    [_deleteBtn addTarget:self action:@selector(deleteOneFootprint) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_deleteBtn];
}
#pragma mark --- 加载数据
- (void) setFootprintModel:(ZYFootprintListModel *)footprintModel
{
    _footprintModel =footprintModel;
    
    NSString *year =nil;
    NSString *month=nil;
    NSString *day  =nil;
    NSString *dayTime=nil;
    
    if (footprintModel.creattime.length) {
        NSString *time=[ZYZCTool turnTimeStampToDate:footprintModel.creattime];
        year  = [time substringToIndex:4];
        month = [time substringWithRange:NSMakeRange(5, 2)];
        day   = [time substringWithRange:NSMakeRange(8, 2)];
        dayTime=[time substringFromIndex:11];
    }
    
    _contentLab.top=0.0;
    _contentLab.height=0.1;
    _contentLab.text=nil;
    _contentLab.hidden=YES;
    CGFloat detailTimeLab_top=_contentLab.bottom;
    
    //文字内容
    if (footprintModel.content.length) {
        _contentLab.hidden=NO;
        _contentLab.text=footprintModel.content;
        CGFloat contentHeight = [ZYZCTool calculateStrLengthByText:footprintModel.content andFont:_contentLab.font andMaxWidth:_contentLab.width].height;
        _contentLab.height=contentHeight;
        if (_canOpenText) {
            if (contentHeight>MAX_CONTENT_HEIGHT) {
                if (!_textHasAddGesture) {
                    [_contentLab addTarget:self action:@selector(OpenOrCloseContent)];
                    _textHasAddGesture=YES;
                }
                _contentLab.top   = _openContent?6.0:0.0;
                _contentLab.height= _openContent?contentHeight:MAX_CONTENT_HEIGHT;
            }
        }
        detailTimeLab_top = _contentLab.bottom+KEDGE_DISTANCE;
    }
    
    //详细时间
    if (footprintModel.creattime.length) {
        _detailTimeLab.text=[NSString stringWithFormat:@"%@年%@月%@日  %@",year,month,day,dayTime];
        _detailTimeLab.top=detailTimeLab_top;
    }
    
    //删除键
    _deleteLab.hidden=(footprintModel.footprintListType!=MyFootprintList);
    _deleteLab.top = _detailTimeLab.top-5;
    
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
    if (footprintModel.pics.length) {
        _imageUrls=[footprintModel.pics componentsSeparatedByString:@","];
        [self getPics:_imageUrls];
        
        video_top=_imagesView.bottom+KEDGE_DISTANCE;
    }
    
    //视频
    _video.top=video_top;
    _video.hidden=YES;
    _video.height=0.1;
    CGFloat locationView_top=_video.bottom;
    if (footprintModel.video.length) {
        _video.hidden=NO;
        if(footprintModel.videoimgsize>0)
        {
            if (footprintModel.videoimgsize<=1.0) {
                if(_commentEnterType==enterCommentPage)
                {
                    _video.width = 2*PIC_WIDTH+10;
                }
                else if (_commentEnterType==enterCommentEdit)
                {
                    _video.width = self.width;
                }
                _video.height=_video.width*1.0/footprintModel.videoimgsize;
            }
            else
            {
                _video.width=self.width;
                _video.height=_video.width*1.0/footprintModel.videoimgsize;
            }
        }
        else
        {
           _video.height=_video.width*0.565;
        }
        
        [ _video sd_setImageWithURL:[NSURL URLWithString:footprintModel.videoimg] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
        _video.playUrl=footprintModel.video;
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
    _commentBtn.top=locationView_top;
    _supportBtn.top=locationView_top;
    _locationImg.hidden=YES;
    _locationLab.hidden=YES;
    if (footprintModel.gpsData.length) {
        _locationImg.hidden=NO;
        _locationLab.hidden=NO;
        NSDictionary *dic=[ZYZCTool turnJsonStrToDictionary:footprintModel.gpsData];
        NSString *GPS_Address=dic[@"GPS_Address"];
        if (GPS_Address) {
            _locationLab.text=GPS_Address;
        }
    }
    
    _supportImg.image=footprintModel.hasZan?[UIImage imageNamed:@"footprint-like-2"]:[UIImage imageNamed:@"footprint-like"];
    
    self.commentNumber=footprintModel.commentTotles;
    
    self.supportNumber=footprintModel.zanTotles;
    
    self.height=_locationImg.bottom;
}

#pragma mark --- 删除足迹
-(void)deleteOneFootprint
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"是否删除此足迹" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag=100;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100&&buttonIndex==0) {
        [MBProgressHUD showMessage:nil];
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"youji_deleteYouji"] andParameters:@{@"id":[NSNumber numberWithInteger:self.footprintModel.ID]} andSuccessGetBlock:^(id result, BOOL isSuccess)
         {
             [MBProgressHUD hideHUD];
             if (isSuccess) {
                 [MBProgressHUD showShortMessage:@"删除成功"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:DELETE_ONE_FOOTPRINT_SUCCESS object:[NSNumber numberWithInteger:self.footprintModel.ID]];
             }
             else
             {
                 [MBProgressHUD showShortMessage:@"删除失败"];
             }
             
         } andFailBlock:^(id failResult) {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showShortMessage:@"删除失败"];
         }];
    }
}


#pragma mark --- 评论足迹
-(void)commentFootprint:(UIButton *)sender
{
    //    sender.enabled=NO;
    //进入评论界面
    if (_commentEnterType==enterCommentPage) {
        ZYCommentFootprintController *commentFootprintController=[[ZYCommentFootprintController alloc]init];
        commentFootprintController.footprintModel=_footprintModel;
        commentFootprintController.hidesBottomBarWhenPushed=YES;
        [self.viewController.navigationController pushViewController:commentFootprintController animated:YES];
    }
    //点击评论编辑
    else if(_commentEnterType==enterCommentEdit)
    {
        ZYCommentFootprintController *commentController=(ZYCommentFootprintController *)self.viewController;
        if(commentController)
        {
            [commentController startEditComment];
        }
    }
}

#pragma mark --- 点赞或取消点赞
-(void)addOrCancelSupport:(UIButton *)sender
{
    sender.enabled=NO;
    [self.viewController.view endEditing:YES];
    //点赞
    if (!_footprintModel.hasZan) {
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"youji_addZan"] andParameters:@{@"pid":[NSNumber numberWithInteger:_footprintModel.ID]} andSuccessGetBlock:^(id result, BOOL isSuccess) {
            sender.enabled=YES;
            if (isSuccess) {
                _supportImg.image=[UIImage imageNamed:@"footprint-like-2"];
                _footprintModel.hasZan=YES;
                
                _footprintModel.zanTotles++;
                self.supportNumber++;
                if (_supportChangeBlock) {
                    _supportChangeBlock(YES);
                }
            }
        } andFailBlock:^(id failResult) {
            sender.enabled=YES;
            [MBProgressHUD showShortMessage:@"网络错误"];
        }];
    }
    //取消点赞
    else
    {
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"youji_delZan"] andParameters:@{@"pid":[NSNumber numberWithInteger:_footprintModel.ID]} andSuccessGetBlock:^(id result, BOOL isSuccess) {
            sender.enabled=YES;
            if (isSuccess) {
                _supportImg.image=[UIImage imageNamed:@"footprint-like"];
                _footprintModel.hasZan=NO;
                self.supportNumber--;
                if (_supportChangeBlock) {
                    _supportChangeBlock(NO);
                }

            }
        } andFailBlock:^(id failResult) {
            sender.enabled=YES;
            [MBProgressHUD showShortMessage:@"网络错误"];
        }];
        
    }
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
    if (self.getSuperTableView) {
        [self.getSuperTableView reloadData];
    }
}

-(void)setCommentNumber:(NSInteger)commentNumber
{
    _commentNumber=commentNumber;
    NSString *commentText=nil;
    if (commentNumber>0) {
        if (commentNumber<=99) {
            commentText = [NSString stringWithFormat:@"%ld",commentNumber];
        }
        else
        {
            commentText = @"99+";
        }
    }
    else
    {
        commentText = @"评论";
    }
    _commentCountLab.text=commentText;
    
    _footprintModel.commentTotles=commentNumber;
}

-(void)setSupportNumber:(NSInteger)supportNumber
{
    _supportNumber=supportNumber;
    NSString *supportText=nil;
    if (supportNumber>0) {
        if (supportNumber<=99) {
            supportText = [NSString stringWithFormat:@"%ld",supportNumber];
        }
        else
        {
            supportText = @"99+";
        }
    }
    else
    {
        supportText = @"点赞";
    }
    _supportCountLab.text=supportText;
    
    _footprintModel.zanTotles=supportNumber;
}

@end
