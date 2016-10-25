//
//  ChooseThumbController.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/10/25.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"

typedef void(^ImageBlock)(UIImage *);

@interface ChooseThumbController : ZYZCBaseViewController

- (instancetype)initWithVideoPath:(NSString *)videoPath andImgSizeRate:(CGFloat)sizeRate WHScale:(CGFloat)WHScale;

@property (nonatomic, copy  ) NSString *videoPath;//视频路径

@property (nonatomic, assign) CGFloat   img_rate; //图片长宽比

@property (nonatomic, copy)  ImageBlock imageBlock;
@property (nonatomic, strong)  UIImage *selectImage;
@property (nonatomic, assign) CGFloat WHScale;

@end
