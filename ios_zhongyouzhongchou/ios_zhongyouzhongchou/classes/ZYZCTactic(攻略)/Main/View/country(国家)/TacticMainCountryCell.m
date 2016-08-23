//
//  TacticMainCountryCell.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticMainCountryCell.h"
#import "TacticMainCountryCustomView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TacticMainVC.h"
#import "TacticMainViewModel.h"
#import "TacticMainImageView.h"
#import "TacticSingleModel.h"
@interface TacticMainCountryCell ()

@property (nonatomic, assign) NSInteger maxViewCount;


@property (nonatomic, strong) NSMutableArray *viewArray;

@end

@implementation TacticMainCountryCell

+ (instancetype)cellWithTableView:(UITableView *)tableView maxViewCount:(NSInteger )maxViewCount;
{
    
    TacticMainCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
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
        TacticMainCountryCustomView *mapView = [TacticMainCountryCustomView viewWithMaxCount:maxViewCount];
        mapView.titleLabel.text = @"热门国家";
        [self.contentView addSubview:mapView];
        
        //先让自己的数组拥有9个view，是否显示要看以后
        CGFloat buttonWH = kTacticViewHeight;
        int totalRow = 3;
        for (int i = 0; i < maxViewCount; i++) {
            
            int row = i / totalRow;//行数
            int col = i % totalRow;//列数
            CGFloat buttonX = col * (KEDGE_DISTANCE + buttonWH) + KEDGE_DISTANCE * 2;
            CGFloat buttonY = kTacticTitleBottom + row * (KEDGE_DISTANCE + buttonWH);
            
            TacticMainImageView *button = [[TacticMainImageView alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonWH, buttonWH)];
            
            [self.viewArray addObject:button];
            
        }
        
    }
    return self;
}


- (void)setCountryArray:(NSArray *)countryArray
{
    _countryArray = countryArray;
    
    SDWebImageOptions option = SDWebImageRetryFailed | SDWebImageLowPriority;
    for (int i = 0; i < _maxViewCount; i++) {
        TacticSingleModel *singleModel = countryArray[i];
        TacticMainImageView *button = self.viewArray[i];
        button.viewid = @(singleModel.ID);
        button.nameLabel.text = singleModel.name;
        [button sd_setImageWithURL:[NSURL URLWithString:KWebImage(singleModel.min_viewImg)] forState:UIControlStateNormal placeholderImage:nil options:option];
      
        [button addTarget:self action:@selector(pushToCountryController:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
    }
}

- (void)pushToCountryController:(TacticMainImageView *)button;
{
    TacticMainVC *mainVC = (TacticMainVC *)self.viewController;
    
    [mainVC.viewModel pushCountryVCWithViewid:button.viewid WithViewController:mainVC];
}


@end
