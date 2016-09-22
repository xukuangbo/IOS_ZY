//
//  ZYCommentFootprintController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYCommentFootprintController.h"
#import "ZYFootprintCommentTable.h"
#import "ZYFootprintCommentListTable.h"
@interface ZYCommentFootprintController ()

@property (nonatomic, strong) ZYFootprintCommentTable     *commentTable;
@property (nonatomic, strong) ZYFootprintCommentListTable *commentListTable;
@property (nonatomic, strong) NSMutableArray              *commentArr;
@property (nonatomic, assign) NSInteger                   pageNo;

@end

@implementation ZYCommentFootprintController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"评论";
    _pageNo=1;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self setBackItem];
    [self configUI];
    [self getSupportData];
    [self getCommentData];
}

-(void)configUI
{
    _commentTable=[[ZYFootprintCommentTable alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain andFootprintModel:_footprintModel];
    _commentTable.backgroundColor=[UIColor orangeColor];
    WEAKSELF;
    _commentTable.headerRefreshingBlock=^()
    {
        [weakSelf getSupportData];
        
    };
    [self.view addSubview:_commentTable];
    
    _commentListTable=[[ZYFootprintCommentListTable alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 300) style:UITableViewStylePlain];
    
    
}

#pragma mark --- 获取评论和点赞的详细信息
-(void)getSupportData
{
    
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:Footprint_GetZanList andParameters:@{@"pid":[NSNumber numberWithInteger:_footprintModel.ID]} andSuccessGetBlock:^(id result, BOOL isSuccess) {
        DDLog(@"%@",result);
        if (isSuccess) {
            ZYSupportListModel *supportListModel=[[ZYSupportListModel alloc]mj_setKeyValues:result];
            
            _commentTable.supportUsersModel=supportListModel;
        }
        else
        {
            
        }
        [_commentTable.mj_header endRefreshing];
        
    } andFailBlock:^(id failResult) {
        
        [_commentTable.mj_header endRefreshing];
        
    }];
}

-(void)getCommentData
{
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:Footprint_GetCommentList andParameters:@{@"pid":[NSNumber numberWithInteger:_footprintModel.ID],
                        @"pageNo":[NSNumber numberWithInteger:_pageNo]}
        andSuccessGetBlock:^(id result, BOOL isSuccess) {
        DDLog(@"%@",result);
                            
                            
        } andFailBlock:^(id failResult) {
            
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
