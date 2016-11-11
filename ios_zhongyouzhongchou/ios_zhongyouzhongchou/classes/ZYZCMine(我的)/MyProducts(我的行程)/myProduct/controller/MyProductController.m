//
//  MyProductController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/11/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MyProductController.h"
#import "ZCListModel.h"
@interface MyProductController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UISegmentedControl *segmentedView;
@property (nonatomic, strong) UIScrollView       *scrollView;
@property (nonatomic, strong) NSMutableArray     *tableArr;
@end

@implementation MyProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.title=@"我的行程";
    _tableArr=[NSMutableArray array];
     [self setBackItem];
     [self configUI];
}

- (void) configUI
{
    //创建头部选择器
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, KNAV_STATUS_HEIGHT, KSCREEN_W, 44)];
    headView.backgroundColor=[UIColor ZYZC_NavColor];
    [self.view addSubview:headView];
    
    NSArray *titleArr=@[@"我发起",@"我报名",@"我推荐"];
    _segmentedView = [[UISegmentedControl alloc]initWithItems:titleArr];
    _segmentedView.frame = CGRectMake(KEDGE_DISTANCE, 0, headView.width-2*KEDGE_DISTANCE, headView.height-KEDGE_DISTANCE);
    _segmentedView.selectedSegmentIndex = 0 ;
    _segmentedView.backgroundColor=[UIColor ZYZC_MainColor];
    _segmentedView.tintColor = [UIColor whiteColor];
    _segmentedView.layer.cornerRadius=4;
    _segmentedView.layer.masksToBounds=YES;
    [_segmentedView addTarget:self action:@selector(changeSegmented:) forControlEvents:UIControlEventValueChanged];
    [headView addSubview:_segmentedView];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, headView.bottom, self.view.width, self.view.height-headView.bottom)];
    _scrollView.contentSize = CGSizeMake(self.view.width*3, 0);
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    for (NSInteger i=0; i<3; i++) {
        ProductTableView *productTable=[[ProductTableView alloc]initWithFrame:CGRectMake(_scrollView.width*i, 0, _scrollView.width, _scrollView.height) style:UITableViewStylePlain andMyProductType:K_MyPublishType+i];
        [_tableArr addObject:productTable];
        [_scrollView addSubview:productTable];
    }

    ProductTableView *firstTable=[_tableArr firstObject];
    [firstTable.mj_header beginRefreshing];
}

#pragma mark --- 切换我的行程内容
-(void)changeSegmented:(UISegmentedControl *)segemented
{
    NSInteger num=segemented.selectedSegmentIndex;
    
    ProductTableView *productTable=_tableArr[num];
    if (!productTable.getRefreash) {
        [productTable.mj_header beginRefreshing];
    }
    WEAKSELF
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.scrollView.contentOffset=CGPointMake(_scrollView.width*num, 0);
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat contentX=scrollView.contentOffset.x;
    NSInteger num = (NSInteger)((contentX+scrollView.width/2.0)/scrollView.width);
    _segmentedView.selectedSegmentIndex=num;
    
    ProductTableView *productTable=_tableArr[num];
    if (!productTable.getRefreash) {
        [productTable.mj_header beginRefreshing];
    }
}

-(void)removeDataByProductId:(NSNumber *)productId withMyProductType:(K_MyProductType)myProductType
{
    ProductTableView *productTable=(ProductTableView *)_tableArr[myProductType-K_MyPublishType];
    NSMutableArray *listArr=productTable.dataArr;
    for (NSInteger i=0; i<listArr.count; i++) {
        ZCOneModel *oneModel=listArr[i];
        if ([oneModel.product.productId isEqual:productId] ) {
            [listArr removeObject:oneModel];
            [productTable reloadData];
            //删到没有数据时
            if (!listArr.count) {
                productTable.hiddenNoneDataView=NO;
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor ZYZC_NavColor]];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
