//
//  ZYCommentFootprintController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYCommentFootprintController.h"
#import "ZYFootprintCommentTable.h"
@interface ZYCommentFootprintController ()

@property (nonatomic, strong) ZYFootprintCommentTable *commentTable;

@end

@implementation ZYCommentFootprintController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"评论";
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self setBackItem];
    [self configUI];
    [self getHttpData];
}

-(void)configUI
{
    _commentTable=[[ZYFootprintCommentTable alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain andFootprintModel:_footprintModel];
    WEAKSELF;
    _commentTable.headerRefreshingBlock=^()
    {
        [weakSelf getHttpData];
        
    };
    [self.view addSubview:_commentTable];
}

#pragma mark --- 获取评论和点赞的详细信息
-(void)getHttpData
{
    [_commentTable.mj_header endRefreshing];
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
