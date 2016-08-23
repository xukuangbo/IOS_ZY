//
//  MovieView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/5.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WSMBaseView.h"

@interface MovieView : WSMBaseView<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIImageView *movieImg;
@property (nonatomic, copy  ) NSString    *movieFileName;
@property (nonatomic, copy  ) NSString    *movieImgFileName;
@property (nonatomic, strong) UIImageView *turnImageView;

@property (nonatomic, copy  ) NSString    *videoAlertText;

@end
