//
//  MoreFZCChooseSceneController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define LIMIT_CITY_NUM    6
#define LIMIT_DEST_NUM    6
#import "MoreFZCChooseSceneController.h"
#import "ZYZCDataBase.h"
#import "LanguageTool.h"
#import "TacticGeneralVC.h"
#import "TacticSingleViewController.h"
#import "MBProgressHUD+MJ.h"
@interface MoreFZCChooseSceneController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) OneSpotModel *chooseSpotModel;
@property (nonatomic, strong) NSMutableArray  *viewSpot;
@property (nonatomic, assign) BOOL         hasFlurData;
@end

@implementation MoreFZCChooseSceneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewSpot=[NSMutableArray array];
    self.title=_isStartDest?@"出发地":@"目的地";
    [self setBackItem];
    [self configUI];
    if (!_isStartDest) {
        [self getData];
    }
}

-(void)configUI
{
    //创建搜索框
    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 10+64, KSCREEN_W-2*KEDGE_DISTANCE, 40)];
    _searchBar.delegate=self;
    _searchBar.layer.cornerRadius=KCORNERRADIUS;
    _searchBar.layer.masksToBounds=YES;
    _searchBar.placeholder=_isStartDest?@"输入出发地":@"输入目的地";
    _searchBar.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:_searchBar];
    
    
    if (!_isStartDest) {
        //创建tableView
        _table=[[UITableView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, _searchBar.bottom, KSCREEN_W-2*KEDGE_DISTANCE, KSCREEN_H-_searchBar.bottom) style:UITableViewStylePlain];
        _table.delegate=self;
        _table.dataSource=self;
        _table.separatorStyle=UITableViewCellSeparatorStyleNone;
        _table.showsVerticalScrollIndicator=NO;
        _table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_table];
    }
   
    
        [_searchBar becomeFirstResponder];
    
}

-(void)getData
{
    ZYZCDataBase *dataBase=[ZYZCDataBase sharedDBManager];
    [dataBase saveDataWithFinishBlock:^(BOOL saveSuccess) {
        if (saveSuccess) {
            [self getDataSuccess];
        }
        else
        {
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDataSuccess) name:KSAVE_SPOT_FINISH object:nil];
        }
    }];

}

-(void)getDataSuccess
{
    ZYZCDataBase *dataBase=[ZYZCDataBase sharedDBManager];
    NSArray *dataArr=[dataBase recieveDBData];
    for (NSDictionary *dic in dataArr) {
        OneSpotModel *oneSportModel=[[OneSpotModel alloc]mj_setKeyValues:dic];
        [_viewSpot addObject:oneSportModel];
    }
    [_table reloadData];
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    NSLog(@"%@",text);
//    if ([ZYZCTool stringContainsEmoji:text]) {
//        return NO;
//    }
    return YES;
}

#pragma mark ---searchBar代理方法实现
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{

    //监听键盘的出现和收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchText=[ZYZCTool filterEmoji:searchText];
    searchBar.text=searchText;
    NSInteger limitNum=_isStartDest?LIMIT_CITY_NUM:LIMIT_DEST_NUM;
    if (searchText.length>limitNum) {
        searchBar.text=[searchText substringToIndex:limitNum];
    }
    
    if (_isStartDest) {
        return;
    }
    
    ZYZCDataBase *dataBase=[ZYZCDataBase sharedDBManager];
    NSArray *arr=[dataBase queryWithStrCondition:searchText];
    if (!arr.count) {
        arr=[dataBase queryWithPinyinCondition:[LanguageTool chineseChangeToPinYin:searchText]];
    }
    [_viewSpot removeAllObjects];
    for (OneSpotModel *oneSpotModel in arr) {
        [_viewSpot addObject:oneSpotModel];
    }
    _hasFlurData=arr.count>0;
    [_table reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    BOOL isEmptyStr=[ZYZCTool isEmpty:searchBar.text];
    if (isEmptyStr) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"文字不能为空" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        searchBar.text=nil;
        return;
    }
    
    //攻略主页搜索
    if (_isHomeSearch) {
        if (_searchBar.text.length) {
            ZYZCDataBase *dataBase=[ZYZCDataBase sharedDBManager];
            OneSpotModel *spotModel=[dataBase searchOneDataWithName:_searchBar.text];
            if (spotModel) {
                 [self.navigationController pushViewController:[[TacticSingleViewController alloc] initWithViewId:[spotModel.ID intValue]] animated:YES];
            }
            else
            {
                if (!_hasFlurData) {
                    [MBProgressHUD showError:ZYLocalizedString(@"error_no_spot")];
                }
                else
                {
                    [_searchBar resignFirstResponder];
                }
            }
        }
    }
    //发众筹搜索
    else{
        for (NSString *obj in self.mySceneArr) {
            if ([obj isEqualToString:_searchBar.text]) {
                [MBProgressHUD showError:@"该目的地已存在"];
                return;
            }
        }
        if (self.getOneScene) {
            self.getOneScene(_searchBar.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark --- table代理方法实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _viewSpot.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    OneSpotModel *oneSpotModel=_viewSpot[indexPath.row];
    cell.textLabel.text=oneSpotModel.country.length>0?[NSString stringWithFormat:@"%@    %@",oneSpotModel.name,oneSpotModel.country]:oneSpotModel.name;
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.textLabel.attributedText=[self getAttributeTextByModel:oneSpotModel];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel  *headView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,_table.width, 40)];
    headView.text=@"热门搜索";
    headView.font=[UIFont boldSystemFontOfSize:14];
    headView.textColor=[UIColor ZYZC_TextGrayColor];
    headView.textAlignment=NSTextAlignmentCenter;
    UIView *lineView=[UIView lineViewWithFrame:CGRectMake(KEDGE_DISTANCE, 35, headView.width-2*KEDGE_DISTANCE, 1) andColor:nil];
    headView.backgroundColor=[UIColor whiteColor];
    [headView addSubview:lineView];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _chooseSpotModel=_viewSpot[indexPath.row];
    _searchBar.text=_chooseSpotModel.name;
    if (!_isHomeSearch) {
        for (NSString *obj in self.mySceneArr) {
            if ([obj isEqualToString:_searchBar.text]) {
                [MBProgressHUD showError:@"该目的地已存在"];
                return;
            }
        }
        //返回地名
        if (self.getOneScene) {
            self.getOneScene(_searchBar.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if ([_chooseSpotModel.viewType intValue] == 1) {
        [self.navigationController pushViewController:[[TacticSingleViewController alloc] initWithViewId:[_chooseSpotModel.ID intValue]] animated:YES];
        return;
    }else if([_chooseSpotModel.viewType intValue] == 2) {
        [self.navigationController pushViewController:[[TacticSingleViewController alloc] initWithViewId:[_chooseSpotModel.ID intValue]] animated:YES];
        return;
    }else if ([_chooseSpotModel.viewType intValue] == 3){
        [self.navigationController pushViewController:[[TacticGeneralVC alloc] initWithViewId:[_chooseSpotModel.ID intValue]] animated:YES];
        return;
    }
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_searchBar.isFirstResponder) {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark --- 键盘出现和收起方法
-(void)keyboardWillShow:(NSNotification *)notify
{
    NSDictionary *dic = notify.userInfo;
    NSValue *value = dic[UIKeyboardFrameEndUserInfoKey];
    CGFloat height=value.CGRectValue.size.height;
     _table.height-=height;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

-(void)keyboardWillHidden:(NSNotification *)notify
{
    NSDictionary *dic = notify.userInfo;
    NSValue *value = dic[UIKeyboardFrameEndUserInfoKey];
    CGFloat height=value.CGRectValue.size.height;
    _table.height+=height;
    [[NSNotificationCenter defaultCenter] removeObserver: self name:UIKeyboardWillHideNotification object:nil];
}


-(NSMutableAttributedString *)getAttributeTextByModel:(OneSpotModel *)oneSpotModel
{
    NSString *text=oneSpotModel.country.length>0?[NSString stringWithFormat:@"%@   %@",oneSpotModel.name,oneSpotModel.country]:oneSpotModel.name;
    NSMutableAttributedString *attrStr=[[NSMutableAttributedString alloc]initWithString:text];
    NSRange range=[text rangeOfString:oneSpotModel.name];
    
    if (text.length) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, range.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, range.length)];
        
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(range.length, text.length-range.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor ZYZC_TextGrayColor] range:NSMakeRange(range.length, text.length-range.length)];
    }
    return  attrStr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor ZYZC_NavColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_searchBar.isFirstResponder) {
        [_searchBar resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
