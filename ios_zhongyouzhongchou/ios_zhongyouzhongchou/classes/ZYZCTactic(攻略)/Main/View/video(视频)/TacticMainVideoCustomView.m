//
//  TacticMainVideoCustomView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticMainVideoCustomView.h"
#import "TacticMainVC.h"
#import "TacticMainViewModel.h"
@implementation TacticMainVideoCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.moreButton.hidden = NO;
        
    }
    return self;
}


- (void)moreButtonAction:(UIButton *)button
{
    TacticMainVC *mainVC = (TacticMainVC *)self.viewController;
    [mainVC.viewModel pushMoreVideosWithViewController:mainVC];
}
@end
