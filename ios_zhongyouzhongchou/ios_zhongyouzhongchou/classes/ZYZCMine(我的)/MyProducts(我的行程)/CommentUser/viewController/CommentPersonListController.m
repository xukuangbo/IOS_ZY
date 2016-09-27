//
//  CommentPersonListController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "CommentPersonListController.h"
#import "CommentListTableView.h"
#import "TogetherUersModel.h"
#import "MBProgressHUD+MJ.h"
#import "NetWorkManager.h"
@interface CommentPersonListController ()
@property (nonatomic, strong) CommentListTableView    *table;
@property (nonatomic, strong) UIButton        *addPartnerBtn;
@end

@implementation CommentPersonListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"评价";
    [self configUI];
    [self getToghterData];
    [self setBackItem];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setBackItem];
}

-(void)configUI
{
    //创建table
    _table=[[CommentListTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _table.productId=_productId;
    [self.view addSubview:_table];
    _table.mj_header=nil;
    _table.mj_footer=nil;
}

-(void)getToghterData
{
    //一起游的人
    NSInteger type=1;
    NSString *httpUrl01=GET_MY_COMMENTER([ZYZCAccountTool getUserId], _productId, type);
//    NSLog(@"%@",httpUrl01);
    __weak typeof(&*self)weakSelf=self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZYZCHTTPTool getHttpDataByURL:httpUrl01 withSuccessGetBlock:^(id result, BOOL isSuccess) {
        [NetWorkManager hideFailViewForView:self.view];
        DDLog(@"一起游：%@",result);
        if (isSuccess) {
            TogetherUersModel *togetherUersModel=[[TogetherUersModel alloc]mj_setKeyValues:result[@"data"]];
              weakSelf.table.myTogetherList=togetherUersModel.users;
            [weakSelf  getReturnData];
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }
        
    } andFailBlock:^(id failResult) {
        //NSLog(@"%@",failResult);
        [MBProgressHUD hideHUDForView:self.view];
        [NetWorkManager hideFailViewForView:self.view];
        [NetWorkManager showMBWithFailResult:failResult];
        __weak typeof (&*self)weakSelf=self;
        [NetWorkManager getFailViewForView:weakSelf.view andFailResult:failResult andReFrashBlock:^{
            [weakSelf getToghterData];
        }];
    }];
}

-(void)getReturnData
{
    if (!_hasReturnPerson) {
        [MBProgressHUD hideHUDForView:self.view];
        [_table reloadData];
        return;
    }
    //回报的人
    NSInteger type=2;
    NSString *httpUrl02=GET_MY_COMMENTER([ZYZCAccountTool getUserId], _productId, type);
//    NSLog(@"%@",httpUrl02);
    [ZYZCHTTPTool getHttpDataByURL:httpUrl02 withSuccessGetBlock:^(id result, BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.view];
        DDLog(@"回报：%@",result);
        if (isSuccess) {
            TogetherUersModel *togetherUersModel=[[TogetherUersModel alloc]mj_setKeyValues:result[@"data"]];
            _table.myReturnList=togetherUersModel.users;
        }
        else
        {
             [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }
        
        [_table reloadData];
        
    } andFailBlock:^(id failResult) {
        [MBProgressHUD hideHUDForView:self.view];
        [NetWorkManager showMBWithFailResult:failResult];
//        NSLog(@"%@",failResult);
    }];
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
