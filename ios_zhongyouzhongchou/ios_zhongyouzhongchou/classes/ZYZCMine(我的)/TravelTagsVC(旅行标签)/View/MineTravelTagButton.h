//
//  MineTravelTagButton.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MineTravelTagBtnFont [UIFont systemFontOfSize:12]

typedef void(^ButtonClickBlock)();
@interface MineTravelTagButton : UIButton
@property (nonatomic, copy) NSString *textString;

@property (nonatomic, copy) ButtonClickBlock buttonClickBlock;
@end
