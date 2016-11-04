//
//  WalletUserYbjVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletUserYbjVC.h"
#import "WalletProductView.h"
#import "WalletUserYbjModel.h"
#import "RACEXTScope.h"
#import "Masonry.h"
#import "UIView+ZYLayer.h"
#import "MBProgressHUD+MJ.h"
#import "WalletYbjSelectXcVC.h"
@interface WalletUserYbjVC ()
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) WalletUserYbjModel *ybjModel;
/* 最近一次的项目 */
@property (nonatomic, strong) WalletProductView *productView;
/* 没有项目时候显示的label */
@property (nonatomic, strong) UILabel *entryLabel;
/* 预备金金额标题 */
@property (nonatomic, strong) UILabel *ybjTitleMonenLabel;
/* 预备金金额 */
@property (nonatomic, strong) UILabel *ybjMonenLabel;
/* 更改项目标题 */
@property (nonatomic, strong) UILabel *changeProductTitleLabel;
/* 项目这两个字 */
@property (nonatomic, strong) UILabel *changeProductTitleLeftLabel;
/* 更改项目按钮 */
@property (nonatomic, strong) UILabel *changeProductLabel;
/* 确定使用按钮 */
@property (nonatomic, strong) UILabel *userYbjLabel;

/* 预备金总金额 */
@property (nonatomic, assign) CGFloat totalMoney;
/* 项目id */
@property (nonatomic, copy) NSString *productId;
/* 已选中的预备金 */
@property (nonatomic, copy) NSString *selectString;
@end

@implementation WalletUserYbjVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)dealloc
{
    DDLog(@"%@被移除了",[self class]);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];

    [self requestData];
    
}

- (void)setUpViews
{
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self setBackItem];
    
    self.view.backgroundColor = [UIColor ZYZC_BgGrayColor];
    
    //1.预备金金额标题
    _ybjTitleMonenLabel = [[UILabel alloc] init];
    _ybjTitleMonenLabel.text = @"可使用预备金余额(元)";
    _ybjTitleMonenLabel.font = [UIFont systemFontOfSize:13];
    _ybjTitleMonenLabel.textColor = [UIColor ZYZC_TextGrayColor01];
    
    //2.预备金金额
    _ybjMonenLabel = [[UILabel alloc] init];
    _ybjMonenLabel.attributedText = [ZYZCTool getAttributesString:_totalMoney withRMBFont:30 withBigFont:45 withSmallFont:20 withTextColor:[UIColor ZYZC_titleBlackColor]];
    
    //3.项目显示
    _productView = [[[NSBundle mainBundle] loadNibNamed:@"WalletProductView" owner:nil options:nil] lastObject];
    
    //4.更改项目标题
    _changeProductTitleLabel = [[UILabel alloc] init];
    _changeProductTitleLabel.text = @"最近进行中的项目";
    _changeProductTitleLabel.font = [UIFont systemFontOfSize:17];
    _changeProductTitleLabel.textColor = [UIColor ZYZC_TextBlackColor];
    
    //5.项目这两个字
    _changeProductTitleLeftLabel = [[UILabel alloc] init];
    _changeProductTitleLeftLabel.text = @"项目";
    _changeProductTitleLeftLabel.font = [UIFont systemFontOfSize:17];
    _changeProductTitleLeftLabel.textColor = [UIColor ZYZC_TextBlackColor];
    
    //6.更改项目显示
    _changeProductLabel = [[UILabel alloc] init];
    _changeProductLabel.text = @"更换";
    _changeProductLabel.font = [UIFont systemFontOfSize:17];
    _changeProductLabel.textColor = [UIColor ZYZC_MainColor];
    [_changeProductLabel addTarget:self action:@selector(changeProductAction)];

    //7.确定使用按钮
    _userYbjLabel = [[UILabel alloc] init];
    _userYbjLabel.text = @"确认使用";
    _userYbjLabel.font = [UIFont systemFontOfSize:17];
    _userYbjLabel.textColor = [UIColor whiteColor];
    _userYbjLabel.backgroundColor = [UIColor ZYZC_MainColor];
    _userYbjLabel.layerCornerRadius = 5;
    _userYbjLabel.textAlignment = NSTextAlignmentCenter;
    [_userYbjLabel addTarget:self action:@selector(userYbjAction)];
    
    //8.没有项目时候显示的label
    _entryLabel = [[UILabel alloc] init];
    _entryLabel.text = @"没有众筹项目\n请去发起众筹后再选择";
    _entryLabel.font = [UIFont systemFontOfSize:25];
    _entryLabel.textColor = [UIColor ZYZC_TextGrayColor];
    _entryLabel.numberOfLines = 0;
    _entryLabel.textAlignment = NSTextAlignmentCenter;
    _entryLabel.hidden = YES;
    
    [self.view addSubview:_ybjTitleMonenLabel];
    [self.view addSubview:_ybjMonenLabel];
    [self.view addSubview:_productView];
    [self.view addSubview:_changeProductTitleLabel];
    [self.view addSubview:_changeProductLabel];
    [self.view addSubview:_changeProductTitleLeftLabel];
    [self.view addSubview:_userYbjLabel];
    [self.view addSubview:_entryLabel];
    
    [_ybjTitleMonenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(@(35 + KNAV_HEIGHT));
    }];
    
    [_ybjMonenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_ybjTitleMonenLabel).offset(60);
    }];
    
    [_productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@110);
        make.width.equalTo(@(KSCREEN_W - 2 * KEDGE_DISTANCE));
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    [_changeProductTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_productView.mas_bottom).offset(60);
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [_changeProductTitleLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productView.mas_bottom).offset(60);
        make.right.equalTo(_changeProductTitleLabel.mas_left).offset(-KEDGE_DISTANCE);
    }];
    
    [_changeProductLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productView.mas_bottom).offset(60);
        make.left.equalTo(_changeProductTitleLabel.mas_right).offset(KEDGE_DISTANCE);
    }];
    
    [_userYbjLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        make.width.equalTo(@(KSCREEN_W - 2 * KEDGE_DISTANCE));
        make.height.equalTo(@48);
    }];
    
    [_entryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    
}

#pragma mark - requestData
- (void)requestData
{
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"productInfo_getMyLastProduct"];
    [MBProgressHUD showMessage:@"正在加载众筹项目" toView:self.view];
    @weakify(self);
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:nil andSuccessGetBlock:^(id result, BOOL isSuccess) {
        //    data = {productTitle = Hehe, productId = 121},
        [MBProgressHUD hideHUDForView:self.view];
        @strongify(self);
        self.dataArray = [WalletUserYbjModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        if (self.dataArray.count <= 0) {
            //显示空界面
            self.entryLabel.hidden = NO;
            self.changeProductTitleLabel.text = @"最近进行中的项目";
            self.productView.hidden = self.changeProductTitleLeftLabel.hidden = self.changeProductTitleLabel.hidden = self.changeProductLabel.hidden = self.userYbjLabel.hidden = YES;
        }else{
            
            self.ybjModel = self.dataArray[0];
            @weakify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                self.entryLabel.hidden = YES;
                self.changeProductTitleLabel.text = [NSString stringWithFormat:@"\"%@\"",self.ybjModel.productTitle];
                self.productView.hidden = self.changeProductTitleLeftLabel.hidden = self.changeProductTitleLabel.hidden = self.changeProductLabel.hidden = self.userYbjLabel.hidden = NO;
                self.productView.ybjModel = self.ybjModel;
                self.productId = [NSString stringWithFormat:@"%zd",self.ybjModel.productId];
            });
        }
    } andFailBlock:^(id failResult) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    CGFloat totalMoney = 0;
    NSArray *moneyArray = [dic allValues];
    for (NSString *string in moneyArray) {
        totalMoney += [string floatValue];
    }
    _totalMoney = totalMoney;
    
    NSArray *ybjIdArray = [dic allKeys];
    NSString *tempString;
    for (int i = 0; i < ybjIdArray.count; i++) {
        if (i == 0) {
            tempString = ybjIdArray[i];
        }else{
            tempString = [NSString stringWithFormat:@"%@,%@",tempString,ybjIdArray[i]];
        }
    }
    _selectString = tempString;
}

#pragma mark - ClickAction
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeProductAction{
    WalletYbjSelectXcVC *walletYbjSelectXcVC = [[WalletYbjSelectXcVC alloc] init];
    @weakify(self);
    walletYbjSelectXcVC.didChangeProductBlock = ^(NSInteger row){
        @strongify(self);
        
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            self.ybjModel = self.dataArray[row];
            self.productView.ybjModel = self.ybjModel;
            self.changeProductTitleLabel.text = [NSString stringWithFormat:@"\"%@\"",self.ybjModel.productTitle];
            self.productId = [NSString stringWithFormat:@"%zd",self.ybjModel.productId];
        });
        
    };
    walletYbjSelectXcVC.dataArr = self.dataArray;
    [self.navigationController pushViewController:walletYbjSelectXcVC animated:YES];
}

- (void)userYbjAction
{
    if(!self.productId || !self.totalMoney || !self.selectString){
        return ;
    }
    
    //参数： productId（众筹id），reserveIds（旅行预备金的Id）,totles(总金额，单位 分)post请求
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"zhibo_userReserve.action"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:self.productId forKey:@"productId"];
    [parameter setValue:self.selectString forKey:@"reserveIds"];
    [parameter setValue:[NSString stringWithFormat:@"%zd",(NSInteger)(self.totalMoney * 100)] forKey:@"totles"];
    [MBProgressHUD showMessage:@"正在提交使用.." toView:self.view];
    @weakify(self);
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:parameter andSuccessGetBlock:^(id result, BOOL isSuccess) {
        @strongify(self);
        if (isSuccess) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"使用成功" toView:self.view];
            [ZYNSNotificationCenter postNotificationName:WalletUseYbjSuccessNoti object:nil];
        }else{
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"使用失败" toView:self.view];
            [ZYNSNotificationCenter postNotificationName:WalletUseYbjFailNoti object:nil];
        }
        
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } andFailBlock:^(id failResult) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showSuccess:@"使用失败" toView:self.view];
        
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

@end
