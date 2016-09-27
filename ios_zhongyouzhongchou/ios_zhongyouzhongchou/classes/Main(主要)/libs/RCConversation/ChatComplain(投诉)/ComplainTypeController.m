//
//  ComplainTypeController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/7/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ComplainTypeController.h"
#import "ChatComplainController.h"
@interface ComplainTypeController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray     *titleArr;
@end

@implementation ComplainTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"投诉";
    _titleArr=@[@"色情低俗",@"赌博",@"政治敏感",@"欺诈骗钱",@"违法(暴力恐怖、违禁品等)"];
    [self configUI];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setBackItem];
}

-(void)configUI
{
    [self setBackItem];

    _table =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _table.dataSource=self;
    _table.delegate=self;
    _table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    _table.backgroundColor = [UIColor ZYZC_BgGrayColor];
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text=_titleArr[indexPath.row];
    [cell.contentView addSubview:[UIView lineViewWithFrame:CGRectMake(0, cell.height-1, KSCREEN_W, 1) andColor:nil]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 44)];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, view.width-KEDGE_DISTANCE, 44)];
    lab.text=@"请选择投诉原因";
    lab.textColor=[UIColor ZYZC_TextGrayColor];
    lab.font=[UIFont systemFontOfSize:15];
    [view addSubview:lab];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatComplainController *complainController=[[ChatComplainController alloc]init];
    complainController.title=_titleArr[indexPath.row];
    complainController.targetId=_targetId;
    complainController.complainType=indexPath.row+1;
    [self.navigationController pushViewController:complainController animated:YES];
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
