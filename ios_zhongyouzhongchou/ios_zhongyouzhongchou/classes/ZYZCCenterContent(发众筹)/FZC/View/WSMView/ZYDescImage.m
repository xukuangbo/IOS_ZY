//
//  ZYDescImage.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYDescImage.h"

@implementation ZYDescImage

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
        self.contentMode=UIViewContentModeScaleAspectFill;
        self.layer.masksToBounds=YES;
    }
    return self;
}

-(void)configUI
{
    
}

-(void)setImgModel:(ZYDescImgModel *)imgModel
{
    _imgModel=imgModel;
    
    if (imgModel.isLocalImage) {
        
        self.image=imgModel.image;
    }
    else
    {
        NSRange range=[imgModel.maxUrl rangeOfString:KMY_ZHONGCHOU_FILE];
        if (range.length) {
            //加载本地图片
            self.image =[UIImage imageWithContentsOfFile:imgModel.maxUrl];
        }
        else{
            //加载网络图片
            [self sd_setImageWithURL:[NSURL URLWithString:imgModel.maxUrl]  placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
        }
    }
}

@end
