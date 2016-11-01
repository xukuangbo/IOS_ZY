//
//  TacticMoreVideosController.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/3.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "TacticMoreVideosController.h"
#import "TacticMoreCollectionViewCell.h"
#import "TacticSingleModel.h"
#import "TacticVideoModel.h"
#import "TacticSingleFoodModel.h"
#import "TacticImageView.h"
#import "TacticMoreCitiesModel.h"
#define home_navi_bgcolor(alpha) [[UIColor ZYZC_NavColor] colorWithAlphaComponent:alpha]
#define naviHeight 64
@interface TacticMoreVideosController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *moreCitiesModelArray;
@end
static NSString *const ID = @"MoreCollectioncell";
@implementation TacticMoreVideosController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
}

- (void)configUI
{
    [self setBackItem];
    
    self.view.backgroundColor = [UIColor ZYZC_BgGrayColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_W, KSCREEN_H - 49) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor ZYZC_BgGrayColor];
    [collectionView registerClass:[TacticMoreCollectionViewCell class] forCellWithReuseIdentifier:ID];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.moreArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TacticMoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if ([self.moreArray[indexPath.item] isKindOfClass:[TacticVideoModel class]]) {//视频
         TacticVideoModel *model = self.moreArray[indexPath.item];
        cell.imageView.tacticVideoModel = model;
    }else if ([self.moreArray[indexPath.item] isKindOfClass:[TacticSingleModel class]]){
        //判断是否国家城市一般景点
        TacticSingleModel *model = self.moreArray[indexPath.item];
        if (model.viewType == 1) {
            cell.imageView.pushType = threeMapViewTypeCountryView;
            
        }else if (model.viewType == 2){
            cell.imageView.pushType = threeMapViewTypeCityView;
        }else if (model.viewType == 3){
            cell.imageView.pushType = threeMapViewTypeSingleView;
        }
        cell.imageView.tacticSingleModel = model;
    }else if ([self.moreArray[indexPath.item] isKindOfClass:[TacticSingleFoodModel class]]){
        TacticSingleFoodModel *model = self.moreArray[indexPath.item];
        cell.imageView.pushType = threeMapViewTypeFood;
        cell.imageView.tacticSingleFoodModel = model;
    }else if ([self.moreArray[indexPath.item] isKindOfClass:[TacticMoreCitiesModel class]]){
        TacticMoreCitiesModel *model = self.moreArray[indexPath.item];
        cell.imageView.pushType = threeMapViewTypeCityView;
        cell.imageView.tacticMoreCitiesModel = model;
    }else{
//        NSLog(@"mgviews种类不定");
    }

    return cell;
}



#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ((collectionView.width - 5 * KEDGE_DISTANCE) / 3);
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor ZYZC_NavColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
@end
