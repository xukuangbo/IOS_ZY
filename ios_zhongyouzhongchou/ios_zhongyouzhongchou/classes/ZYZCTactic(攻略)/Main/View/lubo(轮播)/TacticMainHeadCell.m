//
//  TacticMainHeadCell.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/3.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticMainHeadCell.h"
#import "SDCycleScrollView.h"
#import "TacticIndexImgModel.h"
#import "TacticMainVC.h"
#import "TacticMainViewModel.h"
@interface TacticMainHeadCell ()<SDCycleScrollViewDelegate>


@property (nonatomic, strong) NSArray *headURLArray;

@property (nonatomic, weak) SDCycleScrollView *headView;
@end


@implementation TacticMainHeadCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    TacticMainHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //创建一个轮播图对象
        // 网络加载 --- 创建带标题的图片轮播器
        SDCycleScrollView *headView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KSCREEN_W, kHeadImageHeight) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        //添加渐变条
        UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 64)];
        bgImg.image=[UIImage imageNamed:@"Background"];
        [headView addSubview:bgImg];
        
        headView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        headView.pageDotColor = [UIColor whiteColor];
        headView.autoScrollTimeInterval = 5;//轮播时长
        headView.currentPageDotColor = [UIColor ZYZC_MainColor]; // 自定义分页控件小圆标颜色
        
        [self.contentView addSubview:headView];
        _headView = headView;
    }
    return self;
}



- (void)setScrollImageArray:(NSArray *)scrollImageArray
{
    _scrollImageArray = scrollImageArray;
    
    
    NSMutableArray *headImgArray = [NSMutableArray array];
    //        NSMutableArray *headTitleArray = [NSMutableArray array];
    NSMutableArray *headURLArray = [NSMutableArray array];
    for (TacticIndexImgModel *indexImgModel in scrollImageArray) {
        if (indexImgModel.status == 0) {//有效
            NSString *headImgString = [NSString stringWithFormat:@"%@%@",BASE_URL,indexImgModel.proImg];
            [headImgArray addObject:headImgString];
            //                [headTitleArray addObject:indexImgModel.title];
            [headURLArray addObject:indexImgModel.proUrl];
        }else{
            
        }
    }
    self.headURLArray = headURLArray;
    _headView.imageURLStringsGroup = headImgArray;
    
}

#pragma mark ---SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    TacticMainVC *mainVC = (TacticMainVC *)self.viewController;
    [mainVC.viewModel pushWebVCWithURLString:self.headURLArray[index] WithViewController:mainVC];
    
}
@end
