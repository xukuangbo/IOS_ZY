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
#import "ZYZCPlayViewController.h"
#import "ZYStartFootprintBtn.h"
#import "HUPhotoBrowser.h"
@interface ZYSceneViewController () <UICollectionViewDelegate, UICollectionViewDataSource,WaterFlowLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *scenes;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) EntryPlaceholderView *entryView;

@property (nonatomic, strong) ZYStartFootprintBtn    *navRightBtn;//发起

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
     self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    _navRightBtn.hidden=NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _navRightBtn.hidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"全球现场";
    UILabel *titleLab=[ZYZCTool createLabWithFrame:CGRectMake(0, 0, 80, 20) andFont:[UIFont boldSystemFontOfSize:20.f] andTitleColor:[UIColor whiteColor]];
    titleLab.text = @"全球现场";
    self.navigationItem.titleView=titleLab;
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
    ZYStartFootprintBtn *navRightBtn=[[ZYStartFootprintBtn alloc]initWithFrame:CGRectMake(self.view.width-60, 4, 60, 30)];
    [navRightBtn setTitle:@"发起" forState:UIControlStateNormal];
    navRightBtn.titleLabel.font=[UIFont systemFontOfSize:15.f];
    [self.navigationController.navigationBar addSubview:navRightBtn];
    _navRightBtn=navRightBtn;

    
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
//        make.top.equalTo(@0);
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
    
    WEAKSELF
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        NSMutableArray *dataArray = [ZYFootprintListModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        
        if (direction == 1) {//说明是下拉
            [weakSelf.scenes removeAllObjects];
            if (dataArray.count > 0) {
                
                weakSelf.entryView.hidden = YES;
                weakSelf.scenes = dataArray;
                weakSelf.pageNo++;
                [weakSelf.collectionView reloadData];
                
                [MBProgressHUD hideHUD];
            }else{
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
    ShopCell *cell = (ShopCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ShopID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 6;
    
    cell.model = self.scenes[indexPath.row];
    __block ZYFootprintListModel *model = self.scenes[indexPath.row];
    __weak ShopCell *weakSelfCell = cell;

    WEAKSELF
    cell.playBlock = ^(void) {
        if (model.footprintType == 1) {
            NSArray * imageUrlArray = [model.pics componentsSeparatedByString:@","];
             [HUPhotoBrowser showFromImageView:weakSelfCell.imageView withImgURLs:imageUrlArray placeholderImage:[UIImage imageNamed:@"image_placeholder"] atIndex:0 dismiss:nil];
        } else if (model.footprintType == 2) {
            ZYZCPlayViewController *playVC = [[ZYZCPlayViewController alloc] init];
            playVC.urlString = [weakSelf.scenes[indexPath.row] video];
            [weakSelf presentViewController:playVC animated:YES completion:nil];
        }
    };
    cell.commentBlock = ^(void) {
        ZYFootprintListModel *footprintModel = weakSelf.scenes[indexPath.item];
        ZYCommentFootprintController *commentFootprintVC = [[ZYCommentFootprintController alloc] init];
        commentFootprintVC.hidesBottomBarWhenPushed = YES;
        commentFootprintVC.footprintModel = footprintModel;
        commentFootprintVC.showWithKeyboard = YES;
        [weakSelf.navigationController pushViewController:commentFootprintVC animated:YES];
    };
    cell.praiseBlock = ^(UIButton *praiseButton) {
//        ZYFootprintListModel *footprintModel = weakSelf.scenes[indexPath.item];
//        ZYCommentFootprintController *commentFootprintVC = [[ZYCommentFootprintController alloc] init];
//        commentFootprintVC.hidesBottomBarWhenPushed = YES;
//        commentFootprintVC.footprintModel = footprintModel;
//        commentFootprintVC.showWithKeyboard = YES;
//        [weakSelf.navigationController pushViewController:commentFootprintVC animated:YES];
        [weakSelf clickPraiseButtonAction:praiseButton model:model indexPath:indexPath];
    };
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

#pragma mark - event
- (void)clickPraiseButtonAction:(UIButton *)sender model:(ZYFootprintListModel *)model indexPath:(NSIndexPath *)indexPath
{
    sender.userInteractionEnabled=NO;

    //点赞
    if (!model.hasZan) {
        [sender setImage:[UIImage imageNamed:@"footprint-like-2"] forState:UIControlStateNormal];
        model.hasZan=YES;
        model.zanTotles++;
        [UIView performWithoutAnimation:^{
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }];
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"youji_addZan"] andParameters:@{@"pid":[NSNumber numberWithInteger:model.ID]} andSuccessGetBlock:^(id result, BOOL isSuccess) {
            sender.userInteractionEnabled=YES;

        } andFailBlock:^(id failResult) {
            sender.userInteractionEnabled=YES;

        }];
    }
    //取消点赞
    else
    {
        [sender setImage:[UIImage imageNamed:@"footprint-like"] forState:UIControlStateNormal];
        model.hasZan=NO;
        model.zanTotles--;
        [UIView performWithoutAnimation:^{
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }];
        [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"youji_delZan"] andParameters:@{@"pid":[NSNumber numberWithInteger:model.ID]} andSuccessGetBlock:^(id result, BOOL isSuccess) {
            sender.userInteractionEnabled=YES;
        } andFailBlock:^(id failResult) {
            sender.userInteractionEnabled=YES;
        }];
        
    }
}

#pragma mark --- 发起
-(void)clickRightNavBtn
{
    
}


@end
