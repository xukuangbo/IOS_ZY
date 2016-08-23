//
//  ZCDetailIntroFirstCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCDetailIntroFirstCell.h"
#import "TogetherSupportController.h"
#import "MBProgressHUD+MJ.h"
@implementation ZCDetailIntroFirstCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        
//    }
//    return self;
//}



-(void)configUI
{
    [super configUI];
    self.titleLab.text=@"众筹目的";
    self.titleLab.font=[UIFont boldSystemFontOfSize:17];
    
    _wsmView=[[ZCWSMView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, self.topLineView.bottom+KEDGE_DISTANCE, self.bgImg.width-2*KEDGE_DISTANCE, 0)];
    [self.bgImg addSubview:_wsmView];
    
    
    CGFloat btnWidth=self.bgImg.width;
   _supportTogther=[UIButton buttonWithType:UIButtonTypeCustom];
    _supportTogther.frame=CGRectMake(KEDGE_DISTANCE, _wsmView.bottom+KEDGE_DISTANCE, btnWidth, 40);
    [_supportTogther setTitle:@"报名一起去" forState:UIControlStateNormal];
    [_supportTogther setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _supportTogther.backgroundColor=[UIColor ZYZC_MainColor];
    _supportTogther.layer.cornerRadius=KCORNERRADIUS;
    _supportTogther.layer.masksToBounds=YES;
    [_supportTogther addTarget:self action:@selector(supportTogtherClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_supportTogther];
    _supportTogther.hidden=YES;
}

-(void)supportTogtherClick
{
    //支持一起游
    if ([_cellModel.mySelf isEqual:@1]) {
        [MBProgressHUD showError:@"此项不可操作"];
        return;
    }
    TogetherSupportController *togetherSupportController=[[TogetherSupportController alloc]init];
    togetherSupportController.productId=_cellModel.productId;
    [self.viewController.navigationController pushViewController:togetherSupportController animated:YES];
}

-(void)setCellModel:(ZCDetailProductModel *)cellModel
{
    _cellModel=cellModel;
    
//    cellModel.productVideo=@"http://zyzc-bucket01.oss-cn-hangzhou.aliyuncs.com/oulbuvldivtdyH01mEvBmkoX-xC0/20160507190655/20160507190526.mp4";
//    
//    cellModel.productVideoImg=@"http://zyzc-bucket01.oss-cn-hangzhou.aliyuncs.com/oulbuvldivtdyH01mEvBmkoX-xC0/20160507190655/20160507190526.png";
//    
//    cellModel.productVoice=@"tp://zyzc-bucket01.oss-cn-hangzhou.aliyuncs.com/oulbuvolvV8uHEyZwU7gAn8icJFw/20160512105904/20160512105843.caf";
    
    [_wsmView reloadDataByVideoImgUrl:cellModel.productVideoImg andPlayUrl:cellModel.productVideo andVoiceUrl:cellModel.productVoice andFaceImg:cellModel.user.faceImg andDesc:cellModel.desc andImgUrlStr:cellModel.descImgs];
    self.bgImg.height   = _wsmView.bottom+KEDGE_DISTANCE;
    cellModel.introFirstCellHeight= self.bgImg.height;
    if ([cellModel.mySelf isEqual:@0]) {
        _supportTogther.hidden=NO;
        _supportTogther.top = self.bgImg.height+KEDGE_DISTANCE;
        cellModel.introFirstCellHeight= _supportTogther.bottom;
    }
    else
    {
        [_supportTogther removeFromSuperview];
         cellModel.introFirstCellHeight= self.bgImg.height;
    }
}

@end

















