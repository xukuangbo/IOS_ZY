//
//  ZCDetailArrangeFirstCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCDetailArrangeFirstCell.h"
#import "NSDate+RMCalendarLogic.h"

@interface ZCDetailArrangeFirstCell ()
@property (nonatomic ,assign ) BOOL isFirstConfigView;
@property (nonatomic ,strong ) NSMutableArray *viewHeights;
@end

@implementation ZCDetailArrangeFirstCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)configUI
{
    [super configUI];
    _isFirstConfigView=YES;
    _wsmView=[[ZCWSMView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, self.topLineView.bottom+KEDGE_DISTANCE, self.bgImg.width-2*KEDGE_DISTANCE, 0)];
    _wsmView.showEmptyText=YES;
    [self.bgImg addSubview:_wsmView];
    
    //景点、交通、住宿、餐饮视图初始化高度数组
    _viewHeights=[NSMutableArray arrayWithArray:@[@0.0,@0.0,@0.0,@0.0]];
}

-(void)setOneDaydetailModel:(MoreFZCTravelOneDayDetailMdel *)oneDaydetailModel
{
    _oneDaydetailModel=oneDaydetailModel;
    
    [_wsmView reloadDataByVideoImgUrl:oneDaydetailModel.movieImg andPlayUrl:oneDaydetailModel.movieUrl andVoiceUrl:oneDaydetailModel.voiceUrl andVoiceLen:oneDaydetailModel.voiceLen andFaceImg:_faceImg andDesc:oneDaydetailModel.wordDes andImgUrlStr:oneDaydetailModel.imgUrlStr];
    
    self.bgImg.height=_wsmView.bottom+KEDGE_DISTANCE;

    NSDate *startDay=[NSDate dateFromString:_startDay];
    NSDate *cellDate=[[NSDate alloc]init];
    cellDate=[cellDate dayInTheFollowingDay:(int)([oneDaydetailModel.day intValue]-1) andDate:startDay];
    
    
    self.titleLab.text=[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"第%@天:",oneDaydetailModel.day],[NSDate stringFromDate:cellDate]];

    
//    CGFloat cellHeight=self.bgImg.height;
//
//    if (oneDaydetailModel.siteDes) {
//        self.hasSight=YES;
//    }
//    if (oneDaydetailModel.trafficDes) {
//        self.hasTrans=YES;
//    }
//    if (oneDaydetailModel.liveDes) {
//         self.hasLive =YES;
//    }
//    if (oneDaydetailModel.foodDes) {
//        self.hasFood =YES;
//    }
//    //添加景点、交通、住宿、餐饮描述
//    //是否有对应高度的判断数组
//    NSArray *hasViews=@[[NSNumber numberWithBool:self.hasSight],[NSNumber numberWithBool:self.hasTrans],[NSNumber numberWithBool:self.hasLive],[NSNumber numberWithBool:self.hasFood] ];
//
//    //对应视图标题名数组
//    NSArray *titleArr=@[@"景点:",@"交通:",@"住宿:",@"餐饮:"];
//    
//    NSString *sightText=oneDaydetailModel.siteDes.length>0?oneDaydetailModel.siteDes:@"";
//    NSString *transText=oneDaydetailModel.trafficDes.length>0?oneDaydetailModel.trafficDes:@"";
//    NSString *liveText=oneDaydetailModel.liveDes>0?oneDaydetailModel.liveDes:@"";
//    NSString *foodText=oneDaydetailModel.foodDes>0?oneDaydetailModel.foodDes:@"";
//    //对应视图文字描述数组
//    NSArray *textsArr=@[sightText,transText,liveText,foodText];
//    
////    NSMutableArray *sightImgs=[NSMutableArray arrayWithArray:@[@"",@"",@"",@""]];
////    NSMutableArray *transImgs=[NSMutableArray array];
////    NSMutableArray *liveImgs= [NSMutableArray array];
////    NSMutableArray *foodImgs= [NSMutableArray array];
////    对应视图图片数组
////    NSArray *imgsArr =@[sightImgs,transImgs,liveImgs,foodImgs];
//    
//    if (_isFirstConfigView) {
//        for (int i=0; i<4; i++) {
//            if ([hasViews[i] boolValue]) {
//                UIView *contentView=[self configViewByViewTop:self.bgImg.height+KEDGE_DISTANCE andtitle:titleArr[i] andText:textsArr[i] andImages:nil];
//                [self addSubview:contentView];
//                [_viewHeights replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:contentView.height]];
//            }
//        }
//    }
//    _isFirstConfigView=NO;
//    
//    self.bgImg.height=cellHeight+
//    self.hasSight*([_viewHeights[0] floatValue]+KEDGE_DISTANCE)+
//    self.hasTrans*([_viewHeights[1] floatValue]+KEDGE_DISTANCE)+
//    self.hasLive *([_viewHeights[2] floatValue]+KEDGE_DISTANCE)+
//    self.hasFood *([_viewHeights[3] floatValue]+KEDGE_DISTANCE)+KEDGE_DISTANCE;
    
    self.oneDaydetailModel.cellHeight=self.bgImg.height;
}

#pragma mark --- 添加景点，交通，住宿，餐饮
-(UIView *)configViewByViewTop:(CGFloat)top  andtitle:(NSString *)title andText:(NSString *)text andImages:(NSArray *)images
{
    //创建视图
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(2*KEDGE_DISTANCE, top,  KSCREEN_W-4*KEDGE_DISTANCE, 0)];
    view.backgroundColor=[UIColor whiteColor];
    //添加横线
    [view addSubview:[UIView lineViewWithFrame:CGRectMake(0, 0, view.width, 1) andColor:nil]];
    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, KEDGE_DISTANCE, view.width, 20)];
    titleLab.text=title;
    titleLab.font=[UIFont boldSystemFontOfSize:15];
    [view addSubview:titleLab];
    //文字内容
    BOOL hasTextLab=(text!=nil && ![text isEqualToString:@""])?YES:NO;
    CGFloat textHeight=0.0;
    if (hasTextLab) {
        CGFloat labHeight= [ZYZCTool calculateStrByLineSpace:10.0 andString:text andFont:[UIFont systemFontOfSize:15] andMaxWidth:view.width].height;
        CGFloat labWidth =view.width;
        UILabel *textLab= [[UILabel alloc]initWithFrame:CGRectMake(0, titleLab.bottom, labWidth, labHeight+10)];
        textLab.numberOfLines=0;
        textLab.attributedText=[ZYZCTool setLineDistenceInText:text];
        textLab.font=[UIFont systemFontOfSize:15];
        textLab.layer.cornerRadius=KCORNERRADIUS;
        textLab.layer.masksToBounds=YES;
        textLab.textColor=[UIColor ZYZC_TextBlackColor];
        [view addSubview:textLab];
        textHeight=textLab.height;
    }
    //图片内容
    BOOL hasImages=images.count>0?YES:NO;
    CGFloat imagesHeight=0.0;
    if (hasImages) {
        CGFloat imgWidth=63;
        CGFloat imgHeight=imgWidth;
        CGFloat imgX=0;
        CGFloat imgY=KEDGE_DISTANCE;
        CGFloat imgEdg=5*KCOFFICIEMNT;
        
        UIView *imgsView=[[UIView alloc]initWithFrame:CGRectMake(0, titleLab.bottom+hasTextLab*textHeight, view.width, imgHeight)];
        [view addSubview:imgsView];
        imagesHeight=imgsView.height;
        
        for (int i = 0;i<images.count; i++) {
            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(imgX+(imgWidth+imgEdg)*i, imgY, imgWidth, imgHeight)];
            img.image=[UIImage imageNamed:@"jd_f"];
            img.layer.cornerRadius=KCORNERRADIUS;
            img.layer.masksToBounds=YES;
            [imgsView addSubview:img];
        }
    }
    //计算视图高度
    view.height=titleLab.bottom+hasTextLab*textHeight+hasImages*(imagesHeight+KEDGE_DISTANCE);
    //对背景卡片高度重赋值
    self.bgImg.height=view.bottom;

    return view;
}


@end
