//
//  MineWantGoVC.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/5.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define home_navi_bgcolor(alpha) [[UIColor ZYZC_NavColor] colorWithAlphaComponent:alpha]
#define naviHeight 64
#import "MineWantGoVC.h"
#import "ZYZCAccountModel.h"
#import "ZYZCAccountTool.h"
#import "TacticMoreCollectionViewCell.h"
#import "MineWantGoModel.h"
#import "TacticImageView.h"
#import "TacticThreeMapView.h"

#import "MBProgressHUD+MJ.h"
#import "NetWorkManager.h"
#import "EntryPlaceholderView.h"
@interface MineWantGoVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *mineWantGoModelArray;
@end

@implementation MineWantGoVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

static NSString *const ID = @"MineWantGoCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI
{
    [self setBackItem];
    
//    self.title = @"我想去的目的地";
    
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
    
    NSString *userId = [ZYZCAccountTool getUserId];
//    NSString *url = Get_Tactic_List_WantGo(userId);
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"viewSpot_getMySpots"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:userId forKey:@"userId"];
    WEAKSELF
    //访问网络
    [MBProgressHUD showMessage:nil];
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        [NetWorkManager hideFailViewForView:self.view];
        if (isSuccess) {
            //请求成功，转化为数组
            weakSelf.mineWantGoModelArray = [MineWantGoModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            //            [weakSelf.collectionView reloadData];
            if (weakSelf.mineWantGoModelArray.count <= 0) {//没有数据，就显示占位图
                [EntryPlaceholderView viewWithSuperView:weakSelf.view type:EntryTypeXiangquDest];
            }else{//如果有数据，就刷新
                [weakSelf.collectionView reloadData];
            }
        }
        [MBProgressHUD hideHUD];
    } andFailBlock:^(id failResult) {
        [MBProgressHUD hideHUD];
        [NetWorkManager showMBWithFailResult:failResult];
        [NetWorkManager hideFailViewForView:self.view];
        __weak typeof (&*self)weakSelf=self;
        [NetWorkManager getFailViewForView:weakSelf.view andFailResult:failResult andReFrashBlock:^{
            [weakSelf requestData];
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor ZYZC_NavColor]];
    
    [self requestData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = @"我想去的目的地";

    [self setBackItem];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mineWantGoModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TacticMoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    MineWantGoModel *wantGoModel = self.mineWantGoModelArray[indexPath.item];
    
    if (wantGoModel.viewType == 1) {
        cell.imageView.pushType = threeMapViewTypeCountryView;
    }else if(wantGoModel.viewType == 2){
        cell.imageView.pushType = threeMapViewTypeCityView;
    }
    
    cell.imageView.mineWantGoModel = wantGoModel;
    
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

@end
