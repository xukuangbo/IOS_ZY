//
//  WalletKtxCell.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/26.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#import "WalletKtxCell.h"
#import "WalletKtxModel.h"
#import "UIView+ZYLayer.h"
#import "UploadVoucherVC.h"
@interface WalletKtxCell ()
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *txLabel;


//飞机四空间
@property (nonatomic, strong) UIImageView  *planeImg;
@property (nonatomic, strong) UILabel      *destLab;
@property (nonatomic, strong) UIScrollView *destScroll;
@property (nonatomic, strong) UIImageView  *destLayerImg;
@end

//btn_p  飞机
//xjj_fuc  绿色背景
@implementation WalletKtxCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    [self setUpViews];
    
}
- (void)setUpViews{
    _mapView.layerCornerRadius = 5;
    _bgImageView.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    
    
    _titleLabel.textColor = [UIColor ZYZC_TextBlackColor];
    //添加一个飞机图
    
    //添加底部视图
    _destLayerImg=[[UIImageView alloc]initWithFrame:CGRectMake(2, KEDGE_DISTANCE * 2, 50, 30)];
    _destLayerImg.image=KPULLIMG(@"xjj_fuc", 0, 10, 0, 10);
    _destLayerImg.alpha=0.7;
    [self.contentView  addSubview:_destLayerImg];
    //添加✈️
    _planeImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE + 5,_destLayerImg.top+9, 18, 17)];
    _planeImg.image=[UIImage imageNamed:@"btn_p"];
    [self.contentView addSubview:_planeImg];
    
    //给目的地添加滑动
    _destScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(_planeImg.right + 5, _destLayerImg.top + 4, 0, 27)];
    _destScroll.showsHorizontalScrollIndicator=NO;
    [self.contentView addSubview:_destScroll];
    
    //添加目的地
    _destLab=[self createLabWithFrame:CGRectMake(0, 0, 0, 29) andFont:[UIFont boldSystemFontOfSize:20] andTitleColor:[UIColor whiteColor]];
    [_destScroll addSubview:_destLab];
    
    //提现添加点击事件
    [_txLabel addTarget:self action:@selector(txLabelAction)];
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


- (void)setMineWalletModel:(WalletKtxModel *)mineWalletModel
{
    _mineWalletModel = mineWalletModel;
    
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
    
    if (mineWalletModel.headImage.length > 0) {
        [_faceImageView sd_setImageWithURL:[NSURL URLWithString:mineWalletModel.headImage] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:options];
    }
    
    //拿到目的地文字,计算长度,设置滚动宽度内容大小
    NSString *startDest=nil;//出发地
    if (mineWalletModel.productDest) {
        //计算目的地的文字长度
        NSMutableString *place=[NSMutableString string];
        //目的地为json数组，需要转换成数组再做字符串拼接
        NSArray *dest=[ZYZCTool turnJsonStrToArray:mineWalletModel.productDest];
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
        placeBgWidth=MIN(placeBgWidth, _mapView.width-40);
        
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
    
    
    if (mineWalletModel.txtotles) {
        _totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",mineWalletModel.txtotles / 100.0];
        _totalMoneyLabel.size = [ZYZCTool calculateStrLengthByText:_totalMoneyLabel.text andFont:_totalMoneyLabel.font andMaxWidth:MAXFLOAT];
    }
    if (mineWalletModel.txstatus == 0) {
        _txLabel.text = @"申请提现";
        _txLabel.size = CGSizeMake(80, 30);
        _txLabel.textAlignment = NSTextAlignmentCenter;
        _txLabel.layer.cornerRadius = 5;
        _txLabel.layer.masksToBounds = YES;
        _txLabel.userInteractionEnabled = YES;
        _txLabel.textColor = [UIColor whiteColor];
        _txLabel.backgroundColor = [UIColor ZYZC_MainColor];
        
        _totalMoneyLabel.textColor = [UIColor redColor];
        
    }else{
        if (mineWalletModel.txstatus == 1) {
            _txLabel.text = @"正在审核";
            _totalMoneyLabel.textColor = [UIColor ZYZC_MainColor];
        }else if (mineWalletModel.txstatus == 2){
            _txLabel.text = @"提现成功";
            
            _totalMoneyLabel.textColor = [UIColor ZYZC_TextGrayColor];
        }
        
        _txLabel.size = [ZYZCTool calculateStrLengthByText:_txLabel.text andFont:_txLabel.font andMaxWidth:MAXFLOAT];
        _txLabel.layer.cornerRadius = 0;
        _txLabel.userInteractionEnabled = NO;
        _txLabel.backgroundColor = [UIColor clearColor];
        _txLabel.textColor = [UIColor ZYZC_TextBlackColor];
//        _txLabel.bottom = .height - KEDGE_DISTANCE;
//        _txLabel.right = _mapView.width - KEDGE_DISTANCE;
        
        _totalMoneyLabel.textColor = [UIColor ZYZC_TextGrayColor];
    }
    if (mineWalletModel.productName.length > 0) {
        _titleLabel.text = mineWalletModel.productName;
        //        _productNameLabel.size = [ZYZCTool calculateStrLengthByText:_productNameLabel.text andFont:_productNameLabel.font andMaxWidth:MAXFLOAT];
    }
    
}

#pragma mark - 申请提现点击
- (void)txLabelAction{
    if (self.mineWalletModel.productId) {
        UploadVoucherVC *uploadVC = [[UploadVoucherVC alloc] init];
        uploadVC.productID = self.mineWalletModel.productId;
        [self.viewController.navigationController pushViewController:uploadVC animated:YES];
    }else{
        //        NSLog(@"没有项目id");
    }
}
@end
