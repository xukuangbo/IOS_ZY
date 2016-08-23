//
//  ZYChooseNetImgCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYChooseNetImgCell.h"
#import "ZYimageView.h"

@interface ZYChooseNetImgCell ()
@property (nonatomic, strong) ZYimageView *imgView;
@end

@implementation ZYChooseNetImgCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    _imgView=[[ZYimageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE,0,KSCREEN_W-2*KEDGE_DISTANCE,NET_IMG_CELL_HEIGHT)];
    _imgView.layer.cornerRadius=KCORNERRADIUS;
    _imgView.layer.masksToBounds=YES;
    _imgView.contentMode=UIViewContentModeScaleAspectFill;
    _imgView.image=[UIImage imageNamed:@"image_placeholder"];
    [self.contentView addSubview:_imgView];
}

-(void)setImageModel:(ZYImageModel *)imageModel
{
    _imageModel=imageModel;
     [_imgView sd_setImageWithURL:[NSURL URLWithString:imageModel.imgMin]  placeholderImage:[UIImage imageNamed:@"icon_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _imgView.hiddenMark=imageModel.markHidden;
}

@end
