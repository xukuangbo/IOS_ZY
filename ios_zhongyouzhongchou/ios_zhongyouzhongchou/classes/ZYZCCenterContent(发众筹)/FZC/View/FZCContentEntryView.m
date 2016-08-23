//
//  FZCContent FZCContentEntryView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/25.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "FZCContentEntryView.h"

@implementation FZCContentEntryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.size=CGSizeMake(KSCREEN_W-4*KEDGE_DISTANCE, CONTENTHEIGHT);
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    //创建跟随按钮移动的下划线
    _selectLineView=[[UIView alloc]init];
    _selectLineView.size=CGSizeMake(60, 1);
    _selectLineView.top=35;
    _selectLineView.backgroundColor=[UIColor ZYZC_MainColor];
    [self addSubview:_selectLineView];

    NSArray *titleArr=@[@"文字描述",@"语音录入",@"上传视频"];
    NSArray *classArr=@[[WordView class],[SoundView class],[MovieView class]];
    for (int i=0; i<titleArr.count; i++) {
        //创建切换按钮
        UIButton *btn=[self setButtonWithIndex:i withTitle:titleArr[i]];
        btn.tag = WordType+i;
        [self addSubview:btn];
        //创建录入内容界面
        WSMBaseView *typeView=[[classArr[i] alloc]initWithFrame:CGRectMake(0, 45, self.width, self.height-45)];
        typeView.tag=WordViewType+i;
        [self addSubview:typeView];
    }
//    //第一次执行图文描述按钮
//    UIButton *wordBtn=(UIButton *)[self viewWithTag:WordType];
//    [self changeType:wordBtn];
    
     //第一次执行语音按钮
    UIButton *soundBtn=(UIButton *)[self viewWithTag:SoundType];
    [self changeType:soundBtn];
}

#pragma mark ---创建btn
- (UIButton *)setButtonWithIndex:(NSInteger)index withTitle:(NSString *)titleName
{
    CGFloat buttonY = 10;
    CGFloat buttonW = self.width/3;
    CGFloat buttonH = 20;
    CGFloat buttonX =index * buttonW;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [button setTitle:titleName forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:15];
    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    [button setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    if (index<2) {
         [button addSubview:[UIView lineViewWithFrame:CGRectMake(button.width-1, 2.5, 1, 15) andColor:nil]];
    }
    return button;
}

#pragma mark --- btn点击事件
-(void)changeType:(UIButton *)button
{
    button.selected = YES;
    [UIView animateWithDuration:0.1 animations:^{
        _selectLineView.left=button.left+(button.width-60)/2;
    }];
    if (_preClickBtn&&_preClickBtn!=button) {
        self.preClickBtn.selected = NO;
    }
    _preClickBtn=button;
    
    switch (button.tag) {
        case WordType:
            [self bringSubviewToFront:[self viewWithTag:WordViewType]];
            break;
        case SoundType:
            [self bringSubviewToFront:[self viewWithTag:SoundViewType]];
            break;
        case MovieType:
            [self bringSubviewToFront:[self viewWithTag:MovieViewType]];
            break;
        default:
            break;
    }
}

#pragma mark --- 记录FZCContentEntryView的来源模块：（筹旅费，行程，回报）
-(void)setContentBelong:(NSString *)contentBelong
{
    _contentBelong=contentBelong;
    for (int i=0; i<3; i++) {
        WSMBaseView *typeView=(WSMBaseView *)[self viewWithTag:WordViewType+i];
        typeView.contentBelong=contentBelong;
    }
}


-(void)reloadDataByWord:(NSString *)word andImgUrlStr:(NSString *)imgUrlStr andVoiceUrl:(NSString *)voiceUrl andVideoUrl:(NSString *)videoUrl andVideoImg:(NSString *)videoImg
{
    WordView *wordView=(WordView *)[self viewWithTag:WordViewType];
    if (word.length) {
        wordView.textView.text=word;
        wordView.hiddenPlaceHolder=YES;
        wordView.imageUrlStr=imgUrlStr;
    }
    
    SoundView *soundView=(SoundView *)[self viewWithTag:SoundViewType];
    if (voiceUrl.length) {
        soundView.soundFileName=voiceUrl;
        soundView.soundProgress=0;
    }
    
    MovieView *movieView=(MovieView *)[self viewWithTag:MovieViewType];
    if (videoImg.length) {
        NSRange range=[videoImg rangeOfString:KMY_ZHONGCHOU_FILE];
        //本地图片
        if (range.length)
        {
            movieView.movieImg.image=[UIImage imageWithContentsOfFile:videoImg];
        }
        //网络图片
        else
        {
            [movieView.movieImg sd_setImageWithURL:[NSURL URLWithString:videoImg] placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
        }
        movieView.movieImgFileName=videoImg;
        movieView.movieFileName=videoUrl;
        movieView.turnImageView.hidden=NO;
    }

}

-(void)setPlaceHolderText:(NSString *)placeHolderText
{
    _placeHolderText=placeHolderText;
    
    WordView *wordView=(WordView *)[self viewWithTag:WordViewType];
    wordView.placeHolderText=placeHolderText;
}

-(void)setVideoAlertText:(NSString *)videoAlertText
{
    _videoAlertText=videoAlertText;
    MovieView *movieView=(MovieView *)[self viewWithTag:MovieViewType];
    movieView.videoAlertText=videoAlertText;
}

@end
