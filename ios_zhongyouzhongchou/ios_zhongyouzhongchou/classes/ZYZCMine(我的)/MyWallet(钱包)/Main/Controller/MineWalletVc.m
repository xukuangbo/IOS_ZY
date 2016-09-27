//
//  MineWalletVc.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define home_navi_bgcolor(alpha) [[UIColor ZYZC_NavColor] colorWithAlphaComponent:alpha]
#import "MineWalletVc.h"
#import "ZYZCAccountTool.h"
#import "ZYZCAccountModel.h"
#import "MineWalletTableViewCell.h"
#import "MineWalletModel.h"
#import "MBProgressHUD+MJ.h"
#import "WalletMingXiVC.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface MineWalletVc ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  头视图
 */
@property (nonatomic, strong) UIView *headMapView;

/**
 *  金钱显示
 */
@property (nonatomic, strong) UILabel *moneyLabel;
/**
 *  提现
 */
@property (nonatomic, strong) UILabel *txTotalMoney;
/**
 *  累计提现标题
 */
@property (nonatomic, strong) UILabel *totalMoneyTitleLabel;
/**
 *  累计提现金额
 */
@property (nonatomic, strong) UILabel *totalMoneyLabel;

/**
 *  可提现列表
 */
@property (nonatomic, strong) NSArray *productArray;


@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MineWalletVc

#pragma mark - system方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
        [self configUI];
        
        [self.navigationController.navigationBar cnSetBackgroundColor:home_navi_bgcolor(1)];
        
        //请求数据
        [self requsetData];
        
        [self requestProductList];
        
//        [[ZYNSNotificationCenter rac_addObserverForName:@"refreshWalletData" object:nil] subscribeNext:^(NSNotification *notification) {
//            
//            [self requsetData];
//            
//            [self requestProductList];
//        }];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar cnSetBackgroundColor:home_navi_bgcolor(1)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = @"我的钱包";
    [self setBackItem];
}

#pragma mark - setUI方法
- (void)configUI
{
    self.view.backgroundColor = [UIColor ZYZC_BgGrayColor];
    
//    self.title = @"我的钱包";
    
    [self setBackItem];
    
    [self createHeadView];
    
    [self createTableView];
    
}


- (void)createHeadView
{
    _headMapView = [[UIView alloc] initWithFrame:CGRectMake(0, KNAV_STATUS_HEIGHT, KSCREEN_W, (KSCREEN_H - KNAV_STATUS_HEIGHT) / 2.0)];
    _headMapView.backgroundColor = [UIColor ZYZC_BgGrayColor];
    [self.view addSubview:_headMapView];
    //标题
    CGFloat titleLabelW = KSCREEN_W;
    CGFloat titleLabelH = 20;
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = KEDGE_DISTANCE;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"可提现旅费";
    titleLabel.textColor = [UIColor ZYZC_TextBlackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_headMapView addSubview:titleLabel];
    
    //金额
    CGFloat moneyLabelW = KSCREEN_W;
    CGFloat moneyLabelH = 60;
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.size = CGSizeMake(moneyLabelW, moneyLabelH);
    _moneyLabel.centerX = _headMapView.width * 0.5;
    _moneyLabel.bottom = _headMapView.height * 0.5;
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    NSString *ktxMoneyStr1 = [NSString stringWithFormat:@"￥0.00"];
    NSMutableAttributedString *ktxMoneyString1 = [[NSMutableAttributedString alloc] initWithString:@"￥0.00"];
    [ktxMoneyString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[ktxMoneyStr1 rangeOfString:@"￥"]];
    [ktxMoneyString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:[ktxMoneyStr1 rangeOfString:@"0.00"]];
    _moneyLabel.attributedText = ktxMoneyString1;
    
    [_headMapView addSubview:_moneyLabel];
    
    //累计提现旅费标题
    //标题
    CGFloat totalMoneyTitleLabelW = KSCREEN_W;
    CGFloat totalMoneyTitleLabelH = 20;
    CGFloat totalMoneyTitleLabelX = 0;
    CGFloat totalMoneyTitleLabelY = _moneyLabel.bottom + 50;
    _totalMoneyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(totalMoneyTitleLabelX, totalMoneyTitleLabelY, totalMoneyTitleLabelW, totalMoneyTitleLabelH)];
    _totalMoneyLabel.font = [UIFont systemFontOfSize:15];
    _totalMoneyTitleLabel.text = @"累计提现旅费";
    _totalMoneyTitleLabel.textColor = [UIColor ZYZC_TextBlackColor];
    _totalMoneyTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_headMapView addSubview:_totalMoneyTitleLabel];
    
    //金额
    CGFloat totalMoneyLabelW = KSCREEN_W;
    CGFloat totalMoneyLabelH = 22;
    _totalMoneyLabel = [[UILabel alloc] init];
    _totalMoneyLabel.size = CGSizeMake(totalMoneyLabelW, totalMoneyLabelH);
    _totalMoneyLabel.textColor = [UIColor ZYZC_TextBlackColor];
    _totalMoneyLabel.font = [UIFont systemFontOfSize:20];
    _totalMoneyLabel.centerX = _headMapView.width * 0.5;
    _totalMoneyLabel.top = _totalMoneyTitleLabel.bottom + KEDGE_DISTANCE;
    _totalMoneyLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *ktxMoneyStr2 = [NSString stringWithFormat:@"￥0.00"];
    NSMutableAttributedString *ktxMoneyString2 = [[NSMutableAttributedString alloc] initWithString:@"￥0.00"];
    [ktxMoneyString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[ktxMoneyStr2 rangeOfString:@"￥"]];
    [ktxMoneyString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:[ktxMoneyStr2 rangeOfString:@"0.00"]];
    
    _moneyLabel.attributedText = ktxMoneyString2;
    [_headMapView addSubview:_totalMoneyLabel];
    
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake( _headMapView.height, 0, 0, 0);
    [self.view insertSubview:_tableView atIndex:0];
}

#pragma mark - requsetData方法
- (void)requsetData
{
    NSString *url = Get_MyTXTotles([ZYZCAccountTool getUserId]);
    __weak typeof(&*self) weakSelf = self;
//    NSLog(@"%@",url);
    
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        [weakSelf changeMoneyByMoney:result];
        
    } andFailBlock:^(id failResult) {
        
    }];
    
}

#pragma mark ---请求提现列表数据数据
- (void)requestProductList
{
    __weak typeof(&*self) weakSelf = self;
    [MBProgressHUD showMessage:@"正在加载"];
    NSString *userId = [ZYZCAccountTool getUserId];
    NSString *txProducts_Url = [NSString stringWithFormat:@"%@?userId=%@&cache=fause&pageNo=%d&pageSize=%d",Get_MyTxProducts_List,userId,1,10000];
    
    [ZYZCHTTPTool getHttpDataByURL:txProducts_Url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        weakSelf.productArray = [MineWalletModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        
        [weakSelf.tableView reloadData];
        
        [MBProgressHUD hideHUD];
    } andFailBlock:^(id failResult) {
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showError:ZYLocalizedString(@"no_netwrk")];
            
    }];
}

#pragma mark - set方法
- (void)changeMoneyByMoney:(NSDictionary *)result
{
    NSString *ktxMoney = [NSString stringWithFormat:@"%.2f",[result[@"data"][@"dtx"] floatValue] / 100];
    NSString *ktxMoneyStr = [NSString stringWithFormat:@"￥%@",ktxMoney];
    NSMutableAttributedString *ktxMoneyString = [[NSMutableAttributedString alloc] initWithString:ktxMoneyStr];
    [ktxMoneyString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[ktxMoneyStr rangeOfString:@"￥"]];
    [ktxMoneyString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:[ktxMoneyStr rangeOfString:ktxMoney]];
    
    _moneyLabel.attributedText = ktxMoneyString;
    
    
    NSString *txMoney = [NSString stringWithFormat:@"%.2f",[result[@"data"][@"ytx"] floatValue] / 100];
    //全部文字
    NSString *txMoneyStr = [NSString stringWithFormat:@"￥%@",txMoney];
    //属性文字
    NSMutableAttributedString *txMoneyString = [[NSMutableAttributedString alloc] initWithString:txMoneyStr];
    [txMoneyString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[txMoneyStr rangeOfString:@"￥"]];
    [txMoneyString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[txMoneyStr rangeOfString:txMoney]];
    
    _totalMoneyLabel.attributedText = txMoneyString;
}

#pragma mark - button点击方法
- (void)checkMoneyButtonAction:(UIButton *)button
{
//    NSLog(@"提现啦！！！");
}

- (void)descLabelAction
{
//    NSLog(@"提现说明");
}

#pragma mark - delegate方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_productArray.count == 0) {
        _tableView.hidden = YES;
    }else{
        _tableView.hidden = NO;
    }
    return _productArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = @"MineWalletTableViewCell";
    MineWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MineWalletTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.mineWalletModel = _productArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WalletCellRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineWalletModel *model = _productArray[indexPath.row];
    WalletMingXiVC *mxVC = [[WalletMingXiVC alloc] initWIthProductId:model.productId];
    [self.navigationController pushViewController:mxVC animated:YES];
}
@end
