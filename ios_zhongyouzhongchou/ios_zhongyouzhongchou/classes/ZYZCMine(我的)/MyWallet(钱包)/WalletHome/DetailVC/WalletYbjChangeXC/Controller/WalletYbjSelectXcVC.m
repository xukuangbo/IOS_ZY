//
//  WalletYbjSelectXcVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/11/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletYbjSelectXcVC.h"
#import "WalletYbjSelectXcCell.h"
#import "WalletProductView.h"
#import "WalletUserYbjModel.h"
#import "RACEXTScope.h"
@interface WalletYbjSelectXcVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end
static NSString *cellId = @"WalletYbjSelectXcCell";
@implementation WalletYbjSelectXcVC

#define System Func
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackItem];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    [self.tableView reloadData];
}

- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    
}

#pragma mark - RequestData
//- (void)requestData{
//    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"productInfo_getMyLastProduct"];
//    @weakify(self);
//    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:url andParameters:nil andSuccessGetBlock:^(id result, BOOL isSuccess) {
//        //    data = {productTitle = Hehe, productId = 121},
//        @strongify(self);
//        self.dataArr = [WalletUserYbjModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
//        if (!self.dataArr) {
//            //显示空界面
//            
//        }else{
//            
//            [self.tableView reloadData];
//        }
//        
//    } andFailBlock:^(id failResult) {
//        
//    }];
//}

#pragma mark - UITableViewDataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WalletYbjSelectXcCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[WalletYbjSelectXcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.productView.ybjModel = self.dataArr[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WalletYbjSelectXcCellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didChangeProductBlock) {
        self.didChangeProductBlock(indexPath.row);
    }

    [self.navigationController popViewControllerAnimated:YES];
}
@end
