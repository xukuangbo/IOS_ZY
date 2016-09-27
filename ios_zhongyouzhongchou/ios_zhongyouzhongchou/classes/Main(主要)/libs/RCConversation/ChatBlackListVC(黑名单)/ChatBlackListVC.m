//
//  ChatBlackListVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ChatBlackListVC.h"
#import "RCIM.h"
#import "ChatBlackListModel.h"
#import "ChatBlackListCell.h"
#import "MBProgressHUD+MJ.h"
@interface ChatBlackListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ChatBlackListVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self requestRCData];
        
        [self configUI];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setBackItem];
}

- (void)configUI
{
    [self setBackItem];
    
    self.title = @"黑名单";
    
    [self createTableView];
}


- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //    _tableView.backgroundColor = [UIColor redColor];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
}
#pragma mark ---请求黑名单数据
- (void)requestRCData
{
    __weak typeof(&*self) weakSelf = self;
    [[RCIMClient sharedRCIMClient] getBlacklist:^(NSArray *blockUserIds) {
//        NSLog(@"%@",blockUserIds);
        
        NSString *tempString = [NSString string];
        for (NSString *userid in blockUserIds) {
            if (tempString.length <= 0) {
                tempString = [tempString stringByAppendingString:userid];
            }else{
                tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@",%@",userid]];
            }
        }
        
        [weakSelf requestBlackListUserData:tempString];
    } error:^(RCErrorCode status) {
        [MBProgressHUD showError:@"请求数据失败"];
    }];
}

- (void)requestBlackListUserData:(NSString *)blockUserIds
{
    NSString *url = Get_LaHei_List_Info(blockUserIds);
    [ZYZCHTTPTool getHttpDataByURL:url withSuccessGetBlock:^(id result, BOOL isSuccess) {
        
        _dataArray = [ChatBlackListModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        
        
        [_tableView reloadData];
    } andFailBlock:^(id failResult) {
    
        [MBProgressHUD showError:@"请求数据失败"];
    }];
}



#pragma mark ---tableview的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDWebImageOptions option = SDWebImageRetryFailed | SDWebImageLowPriority;
    ChatBlackListModel *listModel = self.dataArray[indexPath.row];
    
    ChatBlackListCell *cell = [ChatBlackListCell cellWithTableView:tableView];
    
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:listModel.faceImg] placeholderImage:nil options:option];
    
    cell.nameLabel.text = listModel.realName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}




- (void)dealloc
{
//    NSLog(@"黑名单控制器被销毁了");
}

#pragma mark ---左滑取消拉黑
//可编辑删除等等
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//左滑动出现的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消拉黑";
}
//是否可编辑状态，包含删除或者插入，目前只知道删除用
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//删除所做的动作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatBlackListModel *model = self.dataArray[indexPath.row];
    NSString *tagerId = [model.userId stringValue];
    //这里做一个左滑取消拉黑的操作
    /*!
     将某个用户移出黑名单
     
     @param userId          需要移出黑名单的用户ID
     @param successBlock    移出黑名单成功的回调
     @param errorBlock      移出黑名单失败的回调[status:失败的错误码]
     */
    [[RCIMClient sharedRCIMClient] removeFromBlacklist:tagerId success:^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            // 从数据源中删除
            [_dataArray removeObjectAtIndex:indexPath.row];
            // 从列表中删除
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        });
        
    } error:^(RCErrorCode status) {
    
//        NSLog(@"%d",status);
    }];
    
}



@end
