//
//  RaiseMoneySecondCellView.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "RaiseMoneySecondCellView.h"

@implementation RaiseMoneySecondCellView

- (instancetype)initWithName:(InitNameType)initNameType WithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (initNameType == InitNameTypeWord) {//语言
            [self createWordView];
            self.flag = InitNameTypeWord;
        }else if (initNameType == InitNameTypeSound){//声音
            [self createSoundView];
            self.flag = InitNameTypeSound;
        }else{//视频
            [self createMovieView];
            self.flag = InitNameTypeMovie;
        }
    }
    
    return self;
}

/**
 *  创建文字view
 */
- (void)createWordView
{
    self.backgroundColor = [UIColor redColor];
}
/**
 *  创建声音view
 */
- (void)createSoundView
{
    self.backgroundColor = [UIColor yellowColor];
    
    //在这里创建录音的内容
    //首先创建1个label
    //    UILabel *timeLabel = [UILabel alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
}

/**
 *  创建视频view
 */
- (void)createMovieView
{
    self.backgroundColor = [UIColor blueColor];
}


@end
