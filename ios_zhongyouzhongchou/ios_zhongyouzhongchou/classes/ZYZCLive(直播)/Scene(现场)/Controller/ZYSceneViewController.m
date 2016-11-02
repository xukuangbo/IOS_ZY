//
//  ZYSceneViewController.m
//  ios_zhongyouzhongchou
//
//  Created by 李灿 on 2016/10/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYSceneViewController.h"
#import "WaterFlowLayout.h"
#import "ZYFootprintListModel.h"
#import "ShopCell.h"
#import "MBProgressHUD+MJ.h"
#import "EntryPlaceholderView.h"
#import "ZYCommentFootprintController.h"
@interface ZYSceneViewController () <UICollectionViewDelegate, UICollectionViewDataSource,WaterFlowLayoutDelegate>
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
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor ZYZC_BgGrayColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(@64);
        make.bottom.equalTo(@49);
    }];
    layout.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopCell class]) bundle:nil] forCellWithReuseIdentifier:ShopID];

}
#pragma mark - network
- (void)requestListDataWithPage:(NSInteger )pageNO direction:(NSInteger )direction{
    
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"youji_getXCPageList"];
    NSDictionary *parameters = @{
                                 @"pageNo" : @(pageNO),
                                 @"pageSize" : @"10"
                                 };
    
    __weak typeof(&*self) weakSelf = self;
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        NSMutableArray *dataArray = [ZYFootprintListModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZYFootprintListModel *footprintModel = self.scenes[indexPath.item];
    ZYCommentFootprintController *commentFootprintVC = [[ZYCommentFootprintController alloc] init];
    commentFootprintVC.hidesBottomBarWhenPushed = YES;
    commentFootprintVC.footprintModel = footprintModel;
    commentFootprintVC.showWithKeyboard = NO;
    [self.navigationController pushViewController:commentFootprintVC animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    _collectionView.mj_footer.hidden = self.scenes.count == 0;
    return self.scenes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 4;

    cell.model = self.scenes[indexPath.row];
    
    return cell;
}


#pragma mark - WaterFlowLayoutDelegate
- (CGFloat)WaterFlowLayout:(WaterFlowLayout *)WaterFlowLayout heightForRowAtIndexPath:(NSInteger)index itemWidth:(CGFloat)itemWidth
{
    ZYFootprintListModel *model = self.scenes[index];
    
    if (model.videoimgsize >= 1 || model.videoimgsize == 0) {
        model.videoimgsize = 4 / 3.0;
    }
//    CGSize sceneSize = [ZYZCTool calculateStrLengthByText:shop.content andFont:[UIFont systemFontOfSize:12.0] andMaxWidth:KSCREEN_W / 2.0 - 10];
    CGFloat cellWidth = (KSCREEN_W - 30) / 2.0 - 20.0;
    CGSize sceneSize = [model.content boundingRectWithSize:CGSizeMake(cellWidth, 1000.0f)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}
                                                          context:nil].size;
    NSDictionary *dict = [ZYZCTool dictionaryWithJsonString:model.gpsData];
    if ([dict[@"GPS_Address"] length] == 0) {
        return itemWidth / model.videoimgsize + sceneSize.height + 50;
    }
    return itemWidth / model.videoimgsize + sceneSize.height + 80;
}



@end
