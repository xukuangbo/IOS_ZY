//
//  SelectImageViewController.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYZCBaseViewController.h"

typedef void(^ImageBlock)(UIImage *);
@interface SelectImageViewController : ZYZCBaseViewController


- (instancetype)initWithImage:(UIImage *)image;
@property (nonatomic, copy)  ImageBlock imageBlock; 
@property (nonatomic, strong)  UIImage *selectImage;
@end
