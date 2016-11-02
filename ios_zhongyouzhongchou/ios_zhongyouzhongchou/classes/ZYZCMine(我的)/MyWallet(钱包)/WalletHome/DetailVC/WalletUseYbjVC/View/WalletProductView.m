//
//  WalletProductView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define productFont(size) [UIFont systemFontOfSize:size]
#define productBoldFont(size) [UIFont boldSystemFontOfSize:size]
#import "WalletProductView.h"
#import "WalletUserYbjModel.h"
@interface WalletProductView ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuchouTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuchouLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *yichouTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yichouLabel;


//飞机四空间
@property (nonatomic, strong) UIImageView  *planeImg;
@property (nonatomic, strong) UILabel      *destLab;
@property (nonatomic, strong) UIScrollView *destScroll;
@property (nonatomic, strong) UIImageView  *destLayerImg;
@end

@implementation WalletProductView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _yuchouTitleLabel.font = [UIFont systemFontOfSize:15];
    _yichouTitleLabel.font = [UIFont systemFontOfSize:15];
    _yichouLabel.font = [UIFont boldSystemFontOfSize:17];
    _yuchouLabel.font = [UIFont boldSystemFontOfSize:17];
    
    _yichouTitleLabel.textColor = [UIColor ZYZC_TextGrayColor];
    _yuchouTitleLabel.textColor = [UIColor ZYZC_TextGrayColor];
    _titleLabel.textColor = [UIColor ZYZC_titleBlackColor];
    _yuchouLabel.textColor = [UIColor ZYZC_titleBlackColor];
    _yichouLabel.textColor = [UIColor ZYZC_titleBlackColor];
    _endTimeLabel.textColor = [UIColor ZYZC_TextGrayColor];
    _bgImageView.backgroundColor = [UIColor clearColor];
    
    _titleLabel.text = @"标题";
    _yichouLabel.text = @"0";
    _yuchouLabel.text = @"0";
    _endTimeLabel.text = @"结束时间";
    
    [self setUpViews];
}

- (void)setUpViews{
    //添加一个飞机图
    _bgImageView.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    
    //添加底部视图
    _destLayerImg=[[UIImageView alloc]initWithFrame:CGRectMake(2 - KEDGE_DISTANCE, KEDGE_DISTANCE, 50, 30)];
    _destLayerImg.image=KPULLIMG(@"xjj_fuc", 0, 10, 0, 10);
    _destLayerImg.alpha=0.7;
    [self addSubview:_destLayerImg];
    //添加✈️
    _planeImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE + 5 - KEDGE_DISTANCE,_destLayerImg.top+9, 18, 17)];
    _planeImg.image=[UIImage imageNamed:@"btn_p"];
    [self addSubview:_planeImg];
    
    //给目的地添加滑动
    _destScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(_planeImg.right + 5, _destLayerImg.top + 4, 0, 27)];
    _destScroll.showsHorizontalScrollIndicator=NO;
    [self addSubview:_destScroll];
    
    //添加目的地
    _destLab=[self createLabWithFrame:CGRectMake(0, 0, 0, 29) andFont:[UIFont boldSystemFontOfSize:20] andTitleColor:[UIColor whiteColor]];
    [_destScroll addSubview:_destLab];

}

#pragma mark --- 创建lab
-(UILabel *)createLabWithFrame:(CGRect )frame andFont:(UIFont *)font andTitleColor:(UIColor *)color
{
    UILabel *lab=[[UILabel alloc]initWithFrame:frame];
    lab.font=font;
    lab.textColor=color;
    return lab;
}
#pragma mark --- 文字长度计算
+(CGSize)calculateStrLengthByText:(NSString *)text andFont:(UIFont *)font andMaxWidth:(CGFloat )maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)setYbjModel:(WalletUserYbjModel *)ybjModel
{
    _ybjModel = ybjModel;
    
    //拿到目的地文字,计算长度,设置滚动宽度内容大小
    NSString *startDest=nil;//出发地
    if (_ybjModel.productDest) {
        //计算目的地的文字长度
        NSMutableString *place=[NSMutableString string];
        //目的地为json数组，需要转换成数组再做字符串拼接
        NSArray *dest=[ZYZCTool turnJsonStrToArray:_ybjModel.productDest];
        startDest=[dest firstObject];
        NSInteger destNumber=dest.count;
        for (NSInteger i=1; i<destNumber;i++) {
            if (i==1) {
                [place appendString:dest[i]];
            }
            else
            {
                [place appendString:[NSString stringWithFormat:@"—%@",dest[i]]];
            }
        }
        //目的地文字长度
        CGFloat placeStrWidth=[ZYZCTool calculateStrLengthByText:place andFont:_destLab.font andMaxWidth:CGFLOAT_MAX].width;
        CGFloat placeBgWidth=placeStrWidth;
        placeBgWidth= MIN(placeBgWidth, _bgImageView.width-40);
        
        //改变目的地展示标签的长度
        _destLab.width=placeStrWidth;
        //改变目的地滑动条
        _destScroll.width=placeBgWidth;
        _destScroll.contentSize=CGSizeMake(placeStrWidth, 0);
        _destLab.text=place;
        //        _destLab.backgroundColor=[UIColor purpleColor];
        //改变目的地背景条长度
        _destLayerImg.width=placeBgWidth+40;
    }
    
    //标题
    _titleLabel.text = ybjModel.productTitle;
    _yuchouLabel.text = [NSString stringWithFormat:@"%zd",ybjModel.productPrice / 100];
    _yichouLabel.text = [NSString stringWithFormat:@"%zd",ybjModel.productTotles / 100];
    _endTimeLabel.text = ybjModel.productEndTime;
    
}
@end
