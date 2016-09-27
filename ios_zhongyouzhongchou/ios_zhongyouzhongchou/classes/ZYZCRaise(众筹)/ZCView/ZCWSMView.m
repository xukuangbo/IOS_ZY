//
//  ZCWSMView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCWSMView.h"
#import "ZYDescImage.h"
#import "HUPhotoBrowser.h"

#define EMPTY_TEXT  @"无论走到哪里，那都是我该去的地方。这里和那里并不遥远，我们走着，看着，听着，醉着，笑着，也就到了。"

@interface ZCWSMView ()

@property (nonatomic, strong)ZYZCCusomMovieImage *movieView;
@property (nonatomic, strong)ZYZCCustomVoiceView *voiceView;
@property (nonatomic, strong)UILabel             *textLab;
@property (nonatomic, strong)UIView              *imgsView;

@end
@implementation ZCWSMView

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
//        self.backgroundColor=[UIColor redColor];
    }
    return self;
}

-(void)configUI
{
    _movieView=[[ZYZCCusomMovieImage alloc]initWithFrame:CGRectMake(0, 0, self.width, 1)];
    _movieView.hidden=YES;
    [self addSubview:_movieView];
    
    _voiceView=[[ZYZCCustomVoiceView alloc]initWithFrame:CGRectMake(0, _movieView.bottom+KEDGE_DISTANCE, self.width, 1)];
    _voiceView.voiceLen=50;
    _voiceView.hidden=YES;
    [self addSubview:_voiceView];
    
    _textLab=[[UILabel alloc]initWithFrame:CGRectMake(0, _voiceView.bottom+KEDGE_DISTANCE, self.width, 1)];
    _textLab.font=[UIFont systemFontOfSize:14];
    _textLab.textColor=[UIColor ZYZC_TextBlackColor];
    _textLab.numberOfLines=0;
    _textLab.hidden=YES;
//    _textLab.backgroundColor=[UIColor orangeColor];
    [self addSubview:_textLab];
    
    _imgsView=[[UIView alloc]initWithFrame:CGRectMake(0, _textLab.bottom+KEDGE_DISTANCE, self.width, 1)];
    [self addSubview:_imgsView];
    
    self.height=1;
}

-(void)reloadDataByVideoImgUrl:(NSString *)videoImgUrl andPlayUrl:(NSString *)playUrl andVoiceUrl:(NSString *)voiceUrl andVoiceLen:(CGFloat)voiceLen  andFaceImg:(NSString *)faceImg andDesc:(NSString *)desc andImgUrlStr:(NSString *)imgUrlStr
{
    _imgUrlStr =imgUrlStr;
    BOOL hasMovie=NO,hasVoice=NO,hasWord=NO,hasImg=YES;
    _movieView.top=0;
    if (videoImgUrl.length) {
        _movieView.hidden=NO;
        hasMovie=YES;
        //区分是不是本地发众筹的数据
        NSRange range=[videoImgUrl rangeOfString:KMY_ZHONGCHOU_FILE];
        if (range.length) {
            _movieView.image=[UIImage imageWithContentsOfFile:videoImgUrl];
        }
        else{
            [_movieView sd_setImageWithURL:[NSURL URLWithString:videoImgUrl] placeholderImage:nil options: SDWebImageRetryFailed | SDWebImageLowPriority];
        }
        _movieView.height=self.width/8*5;
        _movieView.playUrl=playUrl;
        [_movieView changeFrame];
    }
    else
    {
        _movieView.hidden=YES;
        _movieView.height=0.1;
    }

    _voiceView.top=_movieView.bottom+hasMovie*KEDGE_DISTANCE;
    if (voiceUrl.length) {
        _voiceView.hidden=NO;
        hasVoice=YES;
        _voiceView.faceImg=faceImg;
        _voiceView.voiceUrl=voiceUrl;
        _voiceView.voiceLen=voiceLen?voiceLen:50;
        _voiceView.height=40;
    }
    else
    {
        _voiceView.height=0.1;
        _voiceView.hidden=YES;
    }
    
     _textLab.top=_voiceView.bottom+hasVoice*KEDGE_DISTANCE;
    if (desc.length) {
        _textLab.hidden=NO;
        hasWord=YES;
        CGFloat textHeight=[ZYZCTool calculateStrByLineSpace:10.0 andString:desc andFont:_textLab.font  andMaxWidth:self.textLab.width].height;
        _textLab.height=textHeight;
        _textLab.attributedText=[ZYZCTool setLineDistenceInText:desc];
    }
    else
    {
        _textLab.height=0.1;
        _textLab.hidden=YES;
        
        if (!(playUrl.length||voiceUrl.length||imgUrlStr.length)&&_showEmptyText) {
            _textLab.text=EMPTY_TEXT;
            _textLab.height=20;
            _textLab.hidden=NO;
        }
    }
    
    _imgsView.top=_textLab.bottom+hasWord*KEDGE_DISTANCE;
//    DDLog(@"_imgsView.top:%.2f",_imgsView.top);
    if (imgUrlStr.length) {
        CGFloat imgsHeight=0.0;
        _imgsView.hidden=NO;
         hasImg=YES;
        NSArray *views=[_imgsView subviews];
        for (NSInteger i=views.count-1; i>=0; i--) {
            if ([views[i] isKindOfClass:[ZYDescImage class]]) {
                [views[i] removeFromSuperview];
            }
        }
        
        NSArray *imgUrls=[imgUrlStr componentsSeparatedByString:@","];
        for (int i=0; i<imgUrls.count; i++) {
            ZYDescImage *img=[[ZYDescImage alloc]initWithFrame:CGRectMake(0, (self.width/8*5+KEDGE_DISTANCE)*i, self.width, self.width/8*5)];
            img.layer.cornerRadius=KCORNERRADIUS;
            img.layer.masksToBounds=YES;
            img.tag=i;
            [_imgsView addSubview:img];
            
            ZYDescImgModel *imgModel=[[ZYDescImgModel alloc]init];
            imgModel.maxUrl=imgUrls[i];
            img.imgModel=imgModel;
            
            imgsHeight=img.bottom;
            [img addTarget:self action:@selector(skimBigImage:)];
        }
        _imgsView.height=imgsHeight;
    }
    else
    {
        _imgsView.hidden=YES;
    }
    
     self.height=_imgsView.bottom;
}

-(void)skimBigImage:(UITapGestureRecognizer *)tap
{
    NSArray *imgUrls=[_imgUrlStr componentsSeparatedByString:@","];
    ZYDescImage *img=(ZYDescImage *)tap.view;
    [HUPhotoBrowser showFromImageView:img withImgURLs:imgUrls placeholderImage:[UIImage imageNamed:@"image_placeholder"] atIndex:img.tag dismiss:nil];
}

@end
