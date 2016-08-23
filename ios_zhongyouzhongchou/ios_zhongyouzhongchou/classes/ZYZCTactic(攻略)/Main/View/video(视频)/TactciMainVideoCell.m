//
//  TactciMainVideoCell.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TactciMainVideoCell.h"
#import "TacticBaseCustomView.h"
#import "TacticMainVideoView.h"
#import "TacticVideoModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TacticMainVC.h"
#import "ZCWebViewController.h"
#import "ZYZCPlayViewController.h"
#import "TacticMainViewModel.h"
#import "TacticMainVideoCustomView.h"
@interface TactciMainVideoCell ()

@property (nonatomic, assign) NSInteger maxViewCount;


@property (nonatomic, strong) NSMutableArray *viewArray;

@end


@implementation TactciMainVideoCell
+ (instancetype)cellWithTableView:(UITableView *)tableView maxViewCount:(NSInteger )maxViewCount;
{
    
    TactciMainVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class]) maxViewCount:maxViewCount];
    }
    return cell;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier maxViewCount:(NSInteger )maxViewCount;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.maxViewCount = maxViewCount;
        self.viewArray = [NSMutableArray array];
//        白色背景图
        TacticMainVideoCustomView *mapView = [TacticMainVideoCustomView viewWithMaxCount:maxViewCount];
        mapView.titleLabel.text = @"视频攻略";
        [self.contentView addSubview:mapView];
        
        //先让自己的数组拥有9个view，是否显示要看以后
        CGFloat buttonWH = kTacticViewHeight;
        int totalRow = 3;
        for (int i = 0; i < maxViewCount; i++) {
            
            int row = i / totalRow;//行数
            int col = i % totalRow;//列数
            CGFloat buttonX = col * (KEDGE_DISTANCE + buttonWH) + KEDGE_DISTANCE * 2;
            CGFloat buttonY = kTacticTitleBottom + row * (KEDGE_DISTANCE + buttonWH);
            
            TacticMainVideoView *button = [[TacticMainVideoView alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonWH, buttonWH)];
            
            [self.viewArray addObject:button];
            
        }
        
    }
    return self;
}


- (void)setVideoArray:(NSArray *)videoArray
{
    _videoArray = videoArray;
    
    SDWebImageOptions option = SDWebImageRetryFailed | SDWebImageLowPriority;
    for (int i = 0; i < _maxViewCount; i++) {
        TacticVideoModel *videoModel = videoArray[i];
        TacticMainVideoView *button = self.viewArray[i];
        button.nameLabel.text = videoModel.name;
        button.playURL = videoModel.videoUrl;
        [button sd_setImageWithURL:[NSURL URLWithString:KWebImage(videoModel.min_viewImg)] forState:UIControlStateNormal placeholderImage:nil options:option];
        //点击事件的方法
//        [[button rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
//            
//            DDLog(@"轻松打打工");
//        }];
        [button addTarget:self action:@selector(pushToVideoController:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
    }
}

- (void)pushToVideoController:(TacticMainVideoView *)button;
{
    TacticMainVC *mainVC = (TacticMainVC *)self.viewController;
    [mainVC.viewModel pushVideoVCWithURLString:button.playURL WithViewController:mainVC];
}


@end
