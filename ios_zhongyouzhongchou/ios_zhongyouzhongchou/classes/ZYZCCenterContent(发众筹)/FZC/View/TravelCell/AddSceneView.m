//
//  AddSceneView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define SITEIMG_WIDTH 63
#define SITEIMG_EDG   5*KCOFFICIEMNT

#import "AddSceneView.h"
#import "ChooseSiteImgController.h"
#import "WordEditViewController.h"
@implementation AddSceneView
-(instancetype)initWithFrame:(CGRect)frame andIndex:(NSInteger )index
{
    if (self=[super initWithFrame:frame]) {
        _siteArr=[NSMutableArray array];
        _siteTagArr=[NSMutableArray array];
        _index=index;
        self.backgroundColor=[UIColor ZYZC_BgGrayColor01];
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    _textView=[[UITextView alloc]init];
    _textView.editable=NO;
    _textView.font=[UIFont systemFontOfSize:15];
    _textView.layer.cornerRadius=KCORNERRADIUS;
    _textView.layer.masksToBounds=YES;
    _textView.contentInset = UIEdgeInsetsMake(-8, 0, 8, 0);
    _textView.textColor=[UIColor ZYZC_TextBlackColor];
//    if (_index==0) {
//        //添加addBtn
//        _addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        _addBtn.frame=CGRectMake(5, self.height-SITEIMG_WIDTH-KEDGE_DISTANCE ,SITEIMG_WIDTH ,SITEIMG_WIDTH );
//        [_addBtn setBackgroundImage:[UIImage imageNamed:@"btn_jjd"] forState:UIControlStateNormal];
//        [_addBtn addTarget:self action:@selector(addSceneImg) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_addBtn];
//        
//        _textView.frame=CGRectMake(KEDGE_DISTANCE, 0, self.width-2*KEDGE_DISTANCE, TEXTMAXHEIGHT);
//    }
//    else   
//    {
        _textView.frame=CGRectMake(KEDGE_DISTANCE, 0, self.width-2*KEDGE_DISTANCE,self.height-KEDGE_DISTANCE);
//    }
    [self addSubview:_textView];
    
    //添加_placeholdLab到_textView
    _placeholdLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 8, _textView.width, 20)];
    _placeholdLab.font=[UIFont systemFontOfSize:15];
    _placeholdLab.textColor=[UIColor ZYZC_TextGrayColor02];
    [_textView addSubview:_placeholdLab];
    
    //给_placeholdLab添加点击手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self   action:@selector(tapToEditText:)];
    [_textView addGestureRecognizer:tap];
}

#pragma mark --- 添加图片
-(void)addSceneImg
{
//    ChooseSiteImgController *chooseSiteImgVC=[[ChooseSiteImgController alloc]init];
//    __weak typeof (&*self)weakSelf=self;
//    __block UIImageView *siteImg=[[UIImageView alloc]init];
//    chooseSiteImgVC.confirmBlock=^()
//    {
//        UIImageView *siteImg=[[UIImageView alloc]initWithFrame:weakSelf.addBtn.frame];
//        siteImg.backgroundColor=[UIColor redColor];
//        [weakSelf addSubview:siteImg];
//        weakSelf.addBtn.left+=width+KEDGE_DISTANCE;
//    };
//    [self.viewController.navigationController pushViewController:chooseSiteImgVC animated:YES];
    
    NSArray *imgArr=@[@"jd_f",@"jd_o",@"jd_t",@"jd_th"];
    if (_siteNumber<4) {
        //创建景点按钮
        UIButton *siteImg=[UIButton buttonWithType:UIButtonTypeCustom];
        siteImg.frame=self.addBtn.frame;
        siteImg.tag=_siteNumber;
        [siteImg setBackgroundImage:[UIImage imageNamed:imgArr[_siteNumber]] forState:UIControlStateNormal];
        [siteImg addTarget:self action:@selector(removeSite:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:siteImg];
        [_siteArr addObject:siteImg];
//        //保存该图片的唯一标识符
//        [_siteTagArr addObject:imgArr[_siteNumber]];
        //添加删除标记
        UIImageView *deleteImg=[[UIImageView alloc]initWithFrame:CGRectMake(SITEIMG_WIDTH-7.5, -7.5, 15, 15)];
        deleteImg.image=[UIImage imageNamed:@"icn_xxcc"];
        [siteImg addSubview:deleteImg];
        //添加按钮向后平移一个位置
        self.addBtn.left+=SITEIMG_WIDTH+SITEIMG_EDG;
        if (_siteNumber==3) {
            self.addBtn.hidden=YES;
        }
        _siteNumber++;
    }
}
#pragma mark --- 删除某个景点
-(void)removeSite:(UIButton *)sender
{
    _siteNumber--;
    [sender removeFromSuperview];
    [_siteArr removeObject:sender];
    //从数组中删除该图片的唯一标识符
    //已有景点重新排序
    for (int i=0; i<_siteArr.count; i++) {
        UIButton *btn=_siteArr[i];
        btn.left=5+(SITEIMG_WIDTH+SITEIMG_EDG)*i;
    }
    //添加按钮向前平移一个位置
    self.addBtn.left-=SITEIMG_WIDTH+SITEIMG_EDG;
    self.addBtn.hidden=NO;
}

#pragma mark --- 进入编辑纯文字页面
-(void)tapToEditText:(UITapGestureRecognizer *)tap
{
    WordEditViewController *wordEditVC=[[WordEditViewController alloc]init];
    //给wordEditVC添加标题
    wordEditVC.myTitle=[_placeholdLab.text substringFromIndex:2];
    //将_textView中的文字赋值给wordEditVC.preText属性，继续进行编辑
    wordEditVC.preText=_textView.text;
    __weak typeof (&*self)weakSelf=self;
    wordEditVC.textBlock=^(NSString *textStr)
    {
        if (textStr.length) {
            weakSelf.placeholdLab.hidden=YES;
        }
        else
        {
            weakSelf.placeholdLab.hidden=NO;
        }
        weakSelf.textView.text=textStr;
    };
    [self.viewController presentViewController:wordEditVC animated:YES completion:nil];
}

@end
