//
//  ZYSceneViewController.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 2016/10/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYSceneViewController.h"
#import "WaterFlowLayout.h"
#import "ZYLiveSceneModel.h"
#import "ShopCell.h"
#import "MBProgressHUD+MJ.h"
#import "EntryPlaceholderView.h"
@interface ZYSceneViewController () <UICollectionViewDataSource,WaterFlowLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *scenes;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) EntryPlaceholderView *entryView;

@end

@implementation ZYSceneViewController

static NSString *const ShopID = @"ShopCell";
- (NSMutableArray *)scenes
{
    if (!_scenes) {
        _scenes = [NSMutableArray array];
    }
    return _scenes;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    _navRightBtn.hidden=NO;
    //    self.tabBarController.tabBar.hidden = NO;
    //    self.navigationController.navigationBar.hidden = NO;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.pageNo = 1;
//        [self requestListDataWithPage:self.pageNo direction:1];
//    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self setupRefresh];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setupRefresh
{
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewscenes)];
    [_collectionView.mj_header beginRefreshing];
    
    _collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMorescenes)];
    _collectionView.mj_footer.hidden = YES;
}

- (void)loadNewscenes
{
    self.pageNo = 1;
    [self requestListDataWithPage:self.pageNo direction:1];
}



- (void)loadMorescenes
{
    [self requestListDataWithPage:self.pageNo direction:2];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    WaterFlowLayout *layout = [[WaterFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    layout.delegate = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopCell class]) bundle:nil] forCellWithReuseIdentifier:ShopID];

}
#pragma mark - network
- (void)requestListDataWithPage:(NSInteger )pageNO direction:(NSInteger )direction{
    
    NSString *url = Post_Scene_List;
    NSDictionary *parameters = @{
                                 @"pageNo" : @(pageNO),
                                 @"pageSize" : @"10"
                                 };
    
    __weak typeof(&*self) weakSelf = self;
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        NSMutableArray *dataArray = [ZYLiveSceneModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        
        if (direction == 1) {//说明是下拉
            if (dataArray.count > 0) {
                
                weakSelf.entryView.hidden = YES;
                weakSelf.scenes = dataArray;
                weakSelf.pageNo++;
                [weakSelf.collectionView reloadData];
                
                [MBProgressHUD hideHUD];
            }else{
                weakSelf.scenes = nil;
                weakSelf.entryView.hidden = NO;
                [weakSelf.collectionView reloadData];
                
                [MBProgressHUD hideHUD];
            }
        }else{//上啦
            if (dataArray.count > 0) {
                
                [weakSelf.scenes addObjectsFromArray:dataArray];
                weakSelf.pageNo++;
                [weakSelf.collectionView reloadData];
                
                
                [MBProgressHUD hideHUD];
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showShortMessage:@"没有更多数据"];
            }
        }
        
        //结束刷新
        [weakSelf.collectionView.mj_footer endRefreshing];
        [weakSelf.collectionView.mj_header endRefreshing];
    } andFailBlock:^(id failResult) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showShortMessage:@"连接服务器失败,请检查你的网络"];
        
        //结束刷新
        [weakSelf.collectionView.mj_footer endRefreshing];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    _collectionView.mj_footer.hidden = self.scenes.count == 0;
    return self.scenes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopID forIndexPath:indexPath];
    
    cell.model = self.scenes[indexPath.item];
    
    return cell;
}

- (CGFloat)WaterFlowLayout:(WaterFlowLayout *)WaterFlowLayout heightForRowAtIndexPath:(NSInteger )index itemWidth:(CGFloat)itemWidth
{
    ZYLiveSceneModel *shop = self.scenes[index];
    
//    return itemWidth * shop.h / shop.w;
    if (shop.videoimgsize == 0) {
        shop.videoimgsize = 1;
    }
    return itemWidth / shop.videoimgsize;
}

@end
