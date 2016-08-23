//
//  WordView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WSMBaseView.h"
@interface WordView : WSMBaseView

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy  ) NSString   *placeHolderText;
@property (nonatomic, assign) BOOL       hiddenPlaceHolder;

@property (nonatomic, assign) NSInteger  maxImgNumber;//添加图片最大值(默认3)

@property (nonatomic, copy  ) NSString    *imageUrlStr;//已有图片Url

@end
