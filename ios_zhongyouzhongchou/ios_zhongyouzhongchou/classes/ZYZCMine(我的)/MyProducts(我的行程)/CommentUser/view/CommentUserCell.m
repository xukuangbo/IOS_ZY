//
//  CommentUserCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/27.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define FIRST_STAR_TAG    30
#define PLACEHOLDER_TEXT  @"使用文字描述ta吧～"

#import "CommentUserCell.h"
#import "ZCDetailCustomButton.h"
#import "WordEditViewController.h"
@interface CommentUserCell ()<UITextViewDelegate>
@property (nonatomic, strong) UIImageView           *bgImg;
@property (nonatomic, strong) ZCDetailCustomButton  *iconImg;
@property (nonatomic, strong) UILabel               *nameLab;
@property (nonatomic, strong) UIImageView           *sexImg;
@property (nonatomic, strong) UILabel               *jobLab;
@property (nonatomic, strong) UILabel               *starLab;
@property (nonatomic, strong) UITextView           *textView;
@property (nonatomic, strong) UILabel        *placeHolderLab;
@property (nonatomic, strong) NSMutableArray        *starArr;
@end

@implementation CommentUserCell

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
    _bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, KSCREEN_W-2*KEDGE_DISTANCE, COMMENT_CELL_HEIGHT)];
    _bgImg.image=KPULLIMG(@"tab_bg_boss0", 10, 0, 10, 0);
    _bgImg.userInteractionEnabled=YES;
    [self.contentView addSubview:_bgImg];
    
    //头像
    CGFloat iconImgWidth=60;
    _iconImg =[[ZCDetailCustomButton alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, iconImgWidth, iconImgWidth)];
    _iconImg.layer.cornerRadius=KCORNERRADIUS;
    _iconImg.layer.masksToBounds=YES;
    _iconImg.layer.borderWidth=1;
    _iconImg.layer.borderColor=[UIColor ZYZC_MainColor].CGColor;
    [_bgImg addSubview:_iconImg];
    
    //名字
    _nameLab =[[UILabel alloc] initWithFrame:CGRectMake(_iconImg.right+20, 15, 0, 20)];
    _nameLab.textColor=[UIColor ZYZC_TextBlackColor];
    _nameLab.font=[UIFont systemFontOfSize:17];
    [_bgImg addSubview:_nameLab];
    
    //性别
    _sexImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, _nameLab.top, 20, 20)];
    [_bgImg addSubview:_sexImg];
    
    //职业
    _jobLab=[[UILabel alloc]initWithFrame:CGRectMake(_iconImg.right+20, _nameLab.bottom+KEDGE_DISTANCE, 100, 20)];
    _jobLab.textColor=[UIColor ZYZC_TextGrayColor];
    _jobLab.font=[UIFont systemFontOfSize:16];
    [_bgImg addSubview:_jobLab];
    
    //评价星星
    CGFloat starWidth=30.0;
    CGFloat edg=10.0;
    CGFloat left=30.0;
    CGFloat lastBtn_Y=0.0;
    _starArr=[NSMutableArray array];
    for (int i=0; i<5; i++) {
        UIButton *star=[UIButton buttonWithType:UIButtonTypeCustom];
        star.frame=CGRectMake(left+(starWidth+edg)*i, _iconImg.bottom+20, starWidth, starWidth) ;
        star.tag=FIRST_STAR_TAG+i;
        [star setImage:[UIImage imageNamed:@"star-gray"] forState:UIControlStateNormal];
        [star addTarget:self action:@selector(chooseStar:) forControlEvents:UIControlEventTouchUpInside];
        [_bgImg addSubview:star];
        [_starArr addObject:star];
        lastBtn_Y=star.right;
    }
    
    //星级文字
    _starLab=[[UILabel alloc]initWithFrame:CGRectMake(lastBtn_Y+20, _iconImg.bottom+20, _bgImg.width-lastBtn_Y-20, 30)];
    _starLab.font=[UIFont systemFontOfSize:15];
    _starLab.textColor=[UIColor ZYZC_TextBlackColor];
    [_bgImg addSubview:_starLab];
    
    //填写文字
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, _starLab.bottom+20, _bgImg.width-2*KEDGE_DISTANCE, _bgImg.height-(_starLab.bottom+20)-KEDGE_DISTANCE)];
     _textView.editable=NO;
    _textView.delegate=self;
    _textView.font=[UIFont systemFontOfSize:15];
    _textView.layer.cornerRadius=KCORNERRADIUS;
    _textView.layer.masksToBounds=YES;
    _textView.backgroundColor= [UIColor ZYZC_BgGrayColor01];
    _textView.contentInset = UIEdgeInsetsMake(-8, 0, 8, 0);
    [_bgImg addSubview:_textView];
    
    _placeHolderLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 8, self.width, 20)];
    _placeHolderLab.text=PLACEHOLDER_TEXT;
    _placeHolderLab.font=[UIFont systemFontOfSize:15];
    _placeHolderLab.textColor=[UIColor ZYZC_TextGrayColor02];
    [_textView addSubview:_placeHolderLab];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHappen:)];
    [_textView addGestureRecognizer:tap];
    
}

#pragma mark --- 选择星级
-(void)chooseStar:(UIButton *)button
{
    for (UIButton *star in _starArr) {
        if (star.tag<=button.tag) {
            [star setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        }
        else
        {
            [star setImage:[UIImage imageNamed:@"star-gray"] forState:UIControlStateNormal];
        }
    }
}

-(void)setPartnerModel:(UserModel *)partnerModel
{
    _partnerModel=partnerModel;
    //加载头像
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:partnerModel.faceImg] forState:UIControlStateNormal];
    _iconImg.userId=partnerModel.userId;
    
    //名字
    _nameLab.text=partnerModel.realName?partnerModel.realName:partnerModel.userName;
    
    CGFloat nameWidth=[ZYZCTool calculateStrLengthByText:_nameLab.text andFont:_nameLab.font andMaxWidth:KSCREEN_W].width;
    if (nameWidth>_bgImg.width-220) {
        nameWidth=_bgImg.width-200;
    }
    _nameLab.width=nameWidth;
    
    //性别
    if ([partnerModel.sex isEqualToString:@"1"]) {
        _sexImg.image=[UIImage imageNamed:@"btn_sex_mal"];
    }
    else if ([partnerModel.sex isEqualToString:@"2"])
    {
        _sexImg.image= [UIImage imageNamed:@"btn_sex_fem"];
    }
    _sexImg.left=_nameLab.right;
    
    //职业
    _jobLab.text=partnerModel.department;
    //职位
    NSString *jobStr=nil;
    if ([partnerModel.company isEqualToString:@"无"]||[partnerModel.title isEqualToString:@"无"]) {
        jobStr= partnerModel.school?[NSString stringWithFormat:@"%@  %@",partnerModel.school,partnerModel.department]:partnerModel.department;
    }
    else
    {
        jobStr=partnerModel.company?[NSString stringWithFormat:@"%@  %@",partnerModel.company,partnerModel.title]:partnerModel.title;
    }
    
    _jobLab.text=jobStr;
    
}

#pragma mark --- tap点击事件
-(void)tapHappen:(UITapGestureRecognizer *)tap
{
    WordEditViewController *wordEditVC=[[WordEditViewController alloc]init];
    wordEditVC.myTitle=@"文字描述";
    wordEditVC.preText=_textView.text;
    __weak typeof (&*self)weakSelf=self;
    wordEditVC.textBlock=^(NSString *textStr)
    {
        if (textStr.length) {
            weakSelf.placeHolderLab.hidden=YES;
        }
        else
        {
            weakSelf.placeHolderLab.hidden=NO;
            textStr=nil;
        }
        weakSelf.textView.text=textStr;
    };
    
    [self.viewController presentViewController:wordEditVC animated:YES completion:nil];
}

@end
