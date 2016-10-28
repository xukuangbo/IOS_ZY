//
//  TacticMoreCitiesVC.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/4.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define home_navi_bgcolor(alpha) [[UIColor ZYZC_NavColor] colorWithAlphaComponent:alpha]
#define naviHeight 64

#import "TacticMoreCitiesVC.h"
//#import "TacticMoreCitiesModel.h"
#import "TacticMoreCollectionViewCell.h"
#import "TacticThreeMapView.h"
#import "TacticImageView.h"
//#import "TacticSingleModel.h"
#import "TacticMoreCitiesModel.h"

@interface TacticMoreCitiesVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *moreCitiesModelArray;
@end

@implementation TacticMoreCitiesVC
- (instancetype)initWithViewType:(NSInteger)viewType
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _viewType = viewType;
    }
    return self;
}

static NSString *const ID = @"TacticMoreCitiesCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
    [self requestData];
}

- (void)configUI
{
    [self setBackItem];
//    self.title = @"更多热门目的地";
    self.view.backgroundColor = [UIColor ZYZC_BgGrayColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_W, KSCREEN_H) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor ZYZC_BgGrayColor];
    [collectionView registerClass:[TacticMoreCollectionViewCell class] forCellWithReuseIdentifier:ID];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)requestData
{
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"adminback_getViewList"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    if (_viewType == 1) {
        [parameter setValue:@"1" forKey:@"viewType"];
    }else if (_viewType == 2){
        [parameter setValue:@"2" forKey:@"viewType"];
    }
    WEAKSELF
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            //请求成功，转化为数组
            weakSelf.moreCitiesModelArray = [TacticMoreCitiesModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            [weakSelf.collectionView reloadData];
        }
    } andFailBlock:^(id failResult) {
        
    }];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.moreCitiesModelArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TacticMoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    TacticMoreCitiesModel *moreModel = self.moreCitiesModelArray[indexPath.item];
    
    cell.imageView.pushType = threeMapViewTypeCityView;
    
//    TacticSingleModel *tacticSingleModel = [[TacticSingleModel alloc] init];
//    tacticSingleModel.viewType = _viewType;
//    tacticSingleModel.min_viewImg = moreModel.min_viewImg;
//    tacticSingleModel.ID = moreModel.ID;
//    tacticSingleModel.name = moreModel.name;
    
    cell.imageView.tacticMoreCitiesModel = moreModel;
    
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
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor ZYZC_NavColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = @"更多热门目的地";
    [self setBackItem];
}
@end
