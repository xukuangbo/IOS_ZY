//
//  ZYCommentFootprintController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYCommentFootprintController.h"
#import "ZYFootprintCommentTable.h"
#import "MBProgressHUD+MJ.h"
#import "AddCommentView.h"
@interface ZYCommentFootprintController ()

@property (nonatomic, strong) ZYFootprintCommentTable     *commentTable;
@property (nonatomic, strong) NSMutableArray              *commentArr;
@property (nonatomic, assign) NSInteger                   pageNo;
@property (nonatomic, strong) AddCommentView              *addCommentView;

@end

@implementation ZYCommentFootprintController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"评论";
    _pageNo=1;
    _commentArr=[NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self setBackItem];
    [self configUI];
    [self getSupportData];
    [self getCommentData];
}

-(void)configUI
{
    _commentTable=[[ZYFootprintCommentTable alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain andFootprintModel:_footprintModel];
//    _commentTable.backgroundColor=[UIColor orangeColor];
    WEAKSELF;
    _commentTable.headerRefreshingBlock=^()
    {
        weakSelf.pageNo=1;
        [weakSelf getSupportData];
        [weakSelf getCommentData];
        
    };
    _commentTable.footerRefreshingBlock=^()
    {
        weakSelf.pageNo++;
        [weakSelf getCommentData];
    };
    
    [self.view addSubview:_commentTable];
    
    //添加评论
    _addCommentView=[[AddCommentView alloc]init];
    _addCommentView.top=KSCREEN_H;
    

    _addCommentView.commitComment=^(NSString *content)
    {
        [weakSelf commitCommentWithContent:content];
    };

    [self.view addSubview:_addCommentView];
    
}

#pragma mark --- 提交评论
-(void)commitCommentWithContent:(NSString *)content
{
//    pid游记id， comment 
    NSDictionary *parameters= @{
                                @"pid":[NSNumber numberWithInteger:_footprintModel.ID],
                                @"content":content
                                };
    WEAKSELF;
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:Footprint_AddComment andParameters:parameters andSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"comment_success")];
            weakSelf.addCommentView.top=KSCREEN_H;
            if (weakSelf.addCommentView.commentSuccess) {
                weakSelf.addCommentView.commentSuccess();
            }
            
            weakSelf.pageNo=1;
            [weakSelf getCommentData];
        }
        else
        {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"comment_fail")];
        }
        
    } andFailBlock:^(id failResult) {
        [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
    }];
}

#pragma mark --- 获取点赞的详细信息
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
        [_commentTable.mj_footer endRefreshing];
        
    } andFailBlock:^(id failResult) {
        [_commentTable.mj_header endRefreshing];
        [_commentTable.mj_footer endRefreshing];
    }];
}

-(void)getCommentData
{
    [MBProgressHUD showMessage:nil];
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:Footprint_GetCommentList andParameters:@{@"pid":[NSNumber numberWithInteger:_footprintModel.ID],
                        @"pageNo":[NSNumber numberWithInteger:_pageNo]}
        andSuccessGetBlock:^(id result, BOOL isSuccess) {
        DDLog(@"%@",result);
        [MBProgressHUD hideHUD];
        if (isSuccess) {
             MJRefreshAutoNormalFooter *autoFooter=(MJRefreshAutoNormalFooter *)_commentTable.mj_footer ;
            if (_pageNo==1&&_commentArr.count) {
                [_commentArr removeAllObjects];
                [autoFooter setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
            }
             ZYCommentListModel *commentListModel=[[ZYCommentListModel alloc]mj_setKeyValues:result];
            
            for(ZYOneCommentModel *oneModel in commentListModel.data)
            {
                [_commentArr addObject:oneModel];
            }
            
            if (commentListModel.data.count==0) {
                _pageNo--;
                [autoFooter setTitle:@"没有更多数据了" forState:MJRefreshStateRefreshing];
            }
            else
            {
                [autoFooter setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
            }
            _commentTable.dataArr=_commentArr;
            [_commentTable reloadData];

        }
        else
        {
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"unkonwn_error")];
        }
            
        [_commentTable.mj_header endRefreshing];
        [_commentTable.mj_footer endRefreshing];
            
    } andFailBlock:^(id failResult) {
        [MBProgressHUD hideHUD];
        [_commentTable.mj_header endRefreshing];
        [_commentTable.mj_footer endRefreshing];
        
        DDLog(@"%@",failResult);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
