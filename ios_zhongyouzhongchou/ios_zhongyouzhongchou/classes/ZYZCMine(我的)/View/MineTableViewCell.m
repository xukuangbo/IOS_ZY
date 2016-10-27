//
//  MineTableViewCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#import "MineTableViewCell.h"
#import "MyProductViewController.h"
#import "MyReturnViewController.h"
#import "MineWantGoVC.h"
#import "ZYZCRCManager.h"
#import "MyUserFollowedVC.h"
#import "ZYZCAccountTool.h"
#import "ZYZCAccountModel.h"
#import "MBProgressHUD+MJ.h"
//#import "MineWalletVc.h"
#import "WalletHomeVC.h"
#import "MineTravelTagVC.h"
#import "ZYFootprintController.h"
@interface MineTableViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel     *textLab;
@property (nonatomic, strong) UIImageView *arrowImg;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *table;
@end

@implementation MineTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _dataArr=[NSMutableArray array];
        NSArray *iconNames=@[@"icon_trip",@"icon_reture",@"icon_wallet",@"icon_message",@"draft",@"icon_destination",@"icon_man",@"tag"];
        NSArray *titles=@[@"我的行程",@"我的回报",@"我的钱包",@"私信",@"我的草稿",@"我想去的目的地",@"我关注的旅行达人",@"我的旅行标签"];

        for (int i=0; i<CELL_NUMBER; i++) {
            MineOneItemModel *itemModel=[[MineOneItemModel alloc]init];
            itemModel.iconImg=iconNames[i];
            itemModel.title=titles[i];
            [_dataArr addObject:itemModel];
        }
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, KSCREEN_W-2*KEDGE_DISTANCE, MINE_CELL_HEIGHT)];
    bgImg.image=KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    [self.contentView addSubview:bgImg];
    bgImg.userInteractionEnabled=YES;
    
    _table=[[UITableView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 5/2, bgImg.width-2*KEDGE_DISTANCE, bgImg.height-5) style:UITableViewStylePlain];
    _table.dataSource=self;
    _table.delegate=self;
    _table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    _table.backgroundColor=[UIColor ZYZC_BgGrayColor];
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    _table.showsVerticalScrollIndicator=NO;
    _table.scrollEnabled=NO;
    [bgImg addSubview:_table];

}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CELL_NUMBER;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString *cellId=@"mineItemCell";
    MineOneItemCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[MineOneItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.itemModel=_dataArr[indexPath.row];
    }
    
    if (indexPath.row==CELL_NUMBER-1) {
        cell.hiddenLine=YES;
    }
    
    if (indexPath.row == 3)
    {
        cell.myBadgeValue=_myBadgeValue;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ONE_ITEM_CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *userId=[ZYZCAccountTool getUserId];
    if (!userId) {
        [MBProgressHUD showError:@"请登录后操作!"];
        return;
    }
    
    if (indexPath.row==0) {
        //我的行程
        MyProductViewController *myTravelVC=[[MyProductViewController alloc]init];
        myTravelVC.hidesBottomBarWhenPushed=YES;
        [self.viewController.navigationController pushViewController:myTravelVC animated:YES];
    }
    if (indexPath.row==1) {
        //我的回报
        MyReturnViewController *returnViewController=[[MyReturnViewController alloc]init];
        returnViewController.productType=MyReturnProduct;
        returnViewController.hidesBottomBarWhenPushed=YES;
        [self.viewController.navigationController pushViewController:returnViewController animated:YES];

        
    }
    else if (indexPath.row==2)
    {
        //我的钱包
        [self.viewController.navigationController pushViewController:[[WalletHomeVC alloc] init] animated:YES];
    }
    else if (indexPath.row==3)
    {
        //私信
        ZYZCRCManager *RCManager=[ZYZCRCManager defaultManager];
        [RCManager getMyConversationListWithSupperController:self.viewController];

    }
    else if(indexPath.row==4)
    {
        //我的草稿
        MyReturnViewController *myDraftController=[[MyReturnViewController alloc]init];
        myDraftController.productType=MyDraftProduct;
        myDraftController.hidesBottomBarWhenPushed=YES;
        [self.viewController.navigationController pushViewController:myDraftController animated:YES];
    }
    else if (indexPath.row==5)
    {
        //我想去的目的地
        MineWantGoVC *wantGoVC = [[MineWantGoVC alloc] init];
        [self.viewController.navigationController pushViewController:wantGoVC animated:YES];
    }
    else if (indexPath.row==6)
    {
        //我关注的旅行达人
        MyUserFollowedVC *myUserFollowedVC = [[MyUserFollowedVC alloc] init];
        [self.viewController.navigationController pushViewController:myUserFollowedVC animated:YES];
    }
    else if(indexPath.row==7)
    {
        //标签
        [self.viewController.navigationController pushViewController:[[MineTravelTagVC alloc] init] animated:YES];
    }
}

-(void)setMyBadgeValue:(NSInteger)myBadgeValue
{
    _myBadgeValue=myBadgeValue;
    [_table reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
