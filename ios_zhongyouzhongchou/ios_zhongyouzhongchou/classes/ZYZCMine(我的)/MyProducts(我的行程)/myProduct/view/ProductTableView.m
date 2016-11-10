//
//  ProductTableView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/11/10.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ProductTableView.h"
#import "ZYZCOneProductCell.h"
#import "ZCProductDetailController.h"
#import "ZCNoneDataView.h"
#import "NetWorkManager.h"
#import "MBProgressHUD+MJ.h"
@interface ProductTableView ()

@property (nonatomic, assign) int            pageNo;

@property (nonatomic, strong) UIButton           *scrollTop;
@property (nonatomic, weak  ) ZCNoneDataView *noneDataView;

@end

@implementation ProductTableView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andMyProductType:(K_MyProductType ) myProductType
{
    if (self=[super initWithFrame:frame style:style]) {
        self.contentInset=UIEdgeInsetsMake(0, 0, 0, 0) ;
        _myProductType = myProductType;
        _pageNo = 1;
        [self addSubview:self.noneDataView];
        WEAKSELF
        self.headerRefreshingBlock=^(){
            weakSelf.getRefreash = YES;
            weakSelf.pageNo = 1;
            [weakSelf getHttpData];
        };
        self.footerRefreshingBlock=^()
        {
            [weakSelf getHttpData];
        };
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self=[super initWithFrame:frame style:style]) {
//        self.contentInset=UIEdgeInsetsMake(0, 0, 0, 0) ;
        _myProductType = K_MyPublishType;
        _pageNo = 1;
        [self addSubview:self.noneDataView];
        [self addSubview:self.scrollTop];
    }
    return self;
}

-(UIButton *)scrollTop
{
    if (!_scrollTop) {
        //添加置顶按钮
        _scrollTop=[UIButton buttonWithType:UIButtonTypeCustom];
        _scrollTop.layer.cornerRadius=KCORNERRADIUS;
        _scrollTop.layer.masksToBounds=YES;
        _scrollTop.frame=CGRectMake(self.left+self.width-60,self.height-60,50,50);
        [_scrollTop setImage:[UIImage imageNamed:@"回到顶部"] forState:UIControlStateNormal];
        [_scrollTop addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
        _scrollTop.hidden=YES;
        [self.superview addSubview:_scrollTop];
    }
    return _scrollTop;
}

#pragma mark --- 置顶
-(void)scrollToTop
{
    [self setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark --- 添加没数据状态的视图
-(ZCNoneDataView *)noneDataView
{
    if (!_noneDataView) {
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ZCNoneDataView" owner:nil options:nil];
        _noneDataView=[nibView objectAtIndex:0];
        _noneDataView.frame=CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, self.width-2*KEDGE_DISTANCE, self.height-2*KEDGE_DISTANCE);
        _noneDataView.layer.cornerRadius=KCORNERRADIUS;
        _noneDataView.layer.masksToBounds=YES;
        _noneDataView.hidden=YES;
    }
    return _noneDataView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count*2+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2==1) {
        ZYZCOneProductCell *productCell=(ZYZCOneProductCell *)[ZYZCOneProductCell customTableView:tableView cellWithIdentifier:@"myProductCell" andCellClass:[ZYZCOneProductCell class]];
        ZCOneModel *oneModel=self.dataArr[(indexPath.row-1)/2];
        if (_myProductType==K_MyRecommendType) {
            oneModel.productType=ZCListProduct;
        }
        else if (_myProductType==K_MyPublishType)
        {
            oneModel.productType=MyPublishProduct;
        }
        else if (_myProductType==K_MyJoinType)
        {
            oneModel.productType=MyJionProduct;
        }
        productCell.oneModel=oneModel;
        return productCell;
    }
    else
    {
        ZYZCOneProductCell *normalCell=(ZYZCOneProductCell *)[ZYZCOneProductCell createNormalCell];
        return normalCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2) {
        
        if (_myProductType==K_MyRecommendType) {
            return PRODUCT_CELL_HEIGHT;
        }
        else
        {
            return MY_ZC_CELL_HEIGHT;
        }
    }
    return KEDGE_DISTANCE;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2) {
        ZCProductDetailController *detailController=[[ZCProductDetailController alloc]init];
        detailController.hidesBottomBarWhenPushed=YES;
        ZCOneModel  *oneModel=self.dataArr[(indexPath.row-1)/2];
        detailController.oneModel=oneModel;
        detailController.productId=oneModel.product.productId;
        detailController.detailProductType=_myProductType==K_MyPublishType?MineDetailProduct:PersonDetailProduct;
        detailController.fromProductType=oneModel.productType;
        [self.viewController.navigationController pushViewController:detailController animated:YES];
    }
    
}

#pragma mark --- 置顶按钮状态变化
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==self) {
        CGFloat offSetY=scrollView.contentOffset.y;
        if (offSetY>=1000.0) {
            self.scrollTop.hidden=NO;
        }
        else
        {
            self.scrollTop.hidden=YES;
        }
    }
}

#pragma mark --- 获取我的众筹列表
-(void)getHttpData
{
    NSString *httpUrl = [[ZYZCAPIGenerate sharedInstance] API:@"list_listMyProducts"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"false" forKey:@"cache"];
    [parameter setValue:[ZYZCAccountTool getUserId] forKey:@"userId"];
    [parameter setValue:[NSString stringWithFormat:@"%ld", _myProductType] forKey:@"self"];
    [parameter setValue:[NSString stringWithFormat:@"%d", _pageNo] forKey:@"pageNo"];
    [parameter setValue:@"0" forKey:@"status_not"];
    [parameter setValue:@"10" forKey:@"pageSize"];
    WEAKSELF
    STRONGSELF
    [ZYZCHTTPTool GET:httpUrl parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        DDLog(@"+++++%@",result);
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        if (isSuccess) {
            MJRefreshAutoNormalFooter *autoFooter=(MJRefreshAutoNormalFooter *)self.mj_footer ;
            if (weakSelf.pageNo==1 && weakSelf.dataArr.count) {
                [weakSelf.dataArr removeAllObjects];
                [autoFooter setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
            }
            ZCListModel *listModel=[[ZCListModel alloc]mj_setKeyValues:result];
            for(ZCOneModel *oneModel in listModel.data)
            {
                [weakSelf.dataArr addObject:oneModel];
            }
            
            if (!listModel.data.count&&weakSelf.pageNo>1) {
                weakSelf.pageNo--;
                [autoFooter setTitle:@"没有更多数据了" forState:MJRefreshStateRefreshing];
            }
            else
            {
                [autoFooter setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
            }
            
            //没有数据，展示数据为空界面提示
            if (!weakSelf.dataArr.count) {
                weakSelf.noneDataView.hidden=NO;
                weakSelf.noneDataView.myZCType=weakSelf.myProductType-K_MyPublishType;
            }
            else
            {
                weakSelf.noneDataView.hidden=YES;
            }
            [weakSelf reloadData];
            weakSelf.pageNo++;
        }
    } andFailBlock:^(id failResult) {
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        [NetWorkManager hideFailViewForView:self];
        [NetWorkManager showMBWithFailResult:failResult];
        [NetWorkManager getFailViewForView:weakSelf andFailResult:failResult andReFrashBlock:^{
            [strongSelf getHttpData];
        }];
    }];
}

-(void) setHiddenScrollBtn:(BOOL)hiddenScrollBtn
{
    _hiddenScrollBtn=hiddenScrollBtn;
    self.scrollTop.hidden=hiddenScrollBtn;
}

- (void) setHiddenNoneDataView:(BOOL)hiddenNoneDataView
{
    _hiddenNoneDataView=hiddenNoneDataView;
    self.noneDataView.hidden=hiddenNoneDataView;
}

@end
