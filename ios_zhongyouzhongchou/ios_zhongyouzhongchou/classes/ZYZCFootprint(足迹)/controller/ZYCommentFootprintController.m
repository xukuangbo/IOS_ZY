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
#import "ZYCommentFootprintController.h"
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
//    self.title=@"评论";
    _pageNo=1;
    _commentArr=[NSMutableArray array];
//    self.automaticallyAdjustsScrollViewInsets=NO;
    [self setBackItem];
    [self configUI];
    [self getSupportData];
    [self getCommentData];
    if(_showWithKeyboard)
    {
        [_addCommentView textFieldBecomeFirstResponse];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title=@"评论";
    [self setBackItem];
}

-(void)configUI
{
    _commentTable=[[ZYFootprintCommentTable alloc]initWithFrame:CGRectMake(0, KEDGE_DISTANCE, KSCREEN_W, KSCREEN_H-49-KEDGE_DISTANCE) style:UITableViewStylePlain andFootprintModel:_footprintModel];
    WEAKSELF;
    _commentTable.mj_header=nil;
    _commentTable.mj_footer=nil;
    
    _commentTable.scrollWillBeginDecelerating=^()
    {
        if(!weakSelf.addCommentView.editFieldView.text.length)
        {
            weakSelf.commentTable.replyUserId=nil;
            weakSelf.commentTable.replyUserName=nil;
            weakSelf.addCommentView.commentTargetType=CommentProductType;
        }
        [weakSelf.addCommentView textFieldRegisterFirstResponse];
    };

       
    [self.view addSubview:_commentTable];
    
    //添加评论
    _addCommentView=[[AddCommentView alloc]init];
    _addCommentView.top=KSCREEN_H-_addCommentView.height;
    

    _addCommentView.commitComment=^(NSString *content)
    {
        [weakSelf commitCommentWithContent:content];
    };

    [self.view addSubview:_addCommentView];
    
}

#pragma mark --- 评论编辑
-(void)startEditComment
{
    if (_commentTable.replyUserId) {
        _addCommentView.commentUserName=_commentTable.replyUserName;
        _addCommentView.commentTargetType=CommentUserType;
    }
    [_addCommentView textFieldBecomeFirstResponse];
}

#pragma mark --- 提交评论
-(void)commitCommentWithContent:(NSString *)content
{
//    pid游记id， comment
    NSDictionary *parameters= @{
                                @"pid":[NSNumber numberWithInteger:_footprintModel.ID],
                                @"content":content
                                };
    
    NSMutableDictionary *newParms=[NSMutableDictionary dictionaryWithDictionary:parameters];
    if (_commentTable.replyUserId) {
        [newParms setObject:_commentTable.replyUserId forKey:@"replyUserId"];
    }
//    if (_commentTable.replyUserId&&![_commentTable.replyUserId isEqual:[ZYZCAccountTool getUserId]]) {
//        [newParms setObject:_commentTable.replyUserId forKey:@"replyUserId"];
//    }

    WEAKSELF;
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"youji_addComment"] andParameters:newParms andSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        DDLog(@"%@",result);
        if (isSuccess) {
            ZYZCAccountModel *accountModel=[ZYZCAccountTool account];
            [MBProgressHUD showShortMessage:ZYLocalizedString(@"comment_success")];
            ZYOneCommentModel *oneCommentModel=[[ZYOneCommentModel alloc]mj_setKeyValues:result[@"data"]];
            oneCommentModel.userName  = accountModel.userName;
            oneCommentModel.realName  = accountModel.realName;
            oneCommentModel.faceImg64 = accountModel.faceImg64;
            oneCommentModel.faceImg132= accountModel.faceImg132;
            oneCommentModel.faceImg640= accountModel.faceImg640;
            oneCommentModel.faceImg   = accountModel.faceImg;
            oneCommentModel.replyUserId=_commentTable.replyUserId;
            oneCommentModel.replyUserName=_commentTable.replyUserName;
            [_commentArr addObject:oneCommentModel];
            
            _commentTable.dataArr=_commentArr;
            [_commentTable reloadData];
            
            if (weakSelf.addCommentView.commentSuccess) {
                weakSelf.addCommentView.commentSuccess();
            }
            
            if (_commentTable.commentNumberChangeBlock) {
                _commentTable.commentNumberChangeBlock(_commentArr.count);
            }
            weakSelf.addCommentView.top=KSCREEN_H-weakSelf.addCommentView.height;
            _commentTable.replyUserId=nil;
            _commentTable.replyUserName=nil;
            _addCommentView.commentTargetType=CommentProductType;
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
    
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"youji_getZanList"] andParameters:@{@"pid":[NSNumber numberWithInteger:_footprintModel.ID]} andSuccessGetBlock:^(id result, BOOL isSuccess) {
        DDLog(@"%@",result);
        if (isSuccess) {
            ZYSupportListModel *supportListModel=[[ZYSupportListModel alloc]mj_setKeyValues:result];
            
            _commentTable.supportUsersModel=supportListModel;
        }
    } andFailBlock:^(id failResult) {
    }];
}

-(void)getCommentData
{
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"youji_getCommentPageList"] andParameters:@{@"pid":[NSNumber numberWithInteger:_footprintModel.ID],
                        @"pageNo":[NSNumber numberWithInteger:_pageNo]}
        andSuccessGetBlock:^(id result, BOOL isSuccess) {
        DDLog(@"%@",result);
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
            
    } andFailBlock:^(id failResult) {
        
        DDLog(@"%@",failResult);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor ZYZC_NavColor]];
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
