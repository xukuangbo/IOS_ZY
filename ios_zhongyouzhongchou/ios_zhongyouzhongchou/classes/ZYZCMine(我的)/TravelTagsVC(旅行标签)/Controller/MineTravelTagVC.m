//
//  MineTravelTagVC.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MineTravelTagVC.h"
#import "MineTravelTagsModel.h"
#import "MineTravelTagButton.h"
#import "MineTravelTagBgView.h"
#import "ZYZCAccountTool.h"
#import "MBProgressHUD+MJ.h"
#define SetUpFirstCellLabelHeight 34
@interface MineTravelTagVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *titleArrayOne;
@property (nonatomic, strong) NSMutableArray *titleArrayTwo;
@property (nonatomic, strong) MineTravelTagBgView *firstBg;
@property (nonatomic, strong) MineTravelTagBgView *secondBg;
@property (nonatomic, strong) NSArray *personTagArray;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, assign) BOOL hasFZC;
@end

@implementation MineTravelTagVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self configUI];
        
        [self requestPersonTagData];
        
        [self requestHadFZCData];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor ZYZC_NavColor] colorWithAlphaComponent:1]];
    
    [self reloadUIFrame];
}
#pragma mark - system方法

#pragma mark - setUI方法
- (void)configUI
{
    self.hidesBottomBarWhenPushed = YES;
    
    self.view.backgroundColor = [UIColor ZYZC_BgGrayColor];
    
    self.title = @"旅行标签";
    
    [self setBackItem];
    
    //设置确定的消息
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.size = CGSizeMake(50, 25);
//    [sureButton setImage:[UIImage imageNamed:@"btn_pas_ld"] forState:UIControlStateNormal];
    [sureButton setTitle:@"保存" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sureButton];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor ZYZC_BgGrayColor];
    _scrollView.hidden = YES;
    [self.view addSubview:_scrollView];
    _scrollView.delegate = self;
    
    [self createSaveButton];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self createSaveButton];
}

/**
 *  保存按钮
 */
- (void)createSaveButton
{
    //保存按钮
    CGFloat saveButtonX = KEDGE_DISTANCE;
    CGFloat saveButtonY = 0;
    CGFloat saveButtonW = KSCREEN_W - 2 * saveButtonX;
    CGFloat saveButtonH = SetUpFirstCellLabelHeight * 2;
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(saveButtonX, saveButtonY, saveButtonW, saveButtonH);
    saveButton.layer.cornerRadius = 5;
    saveButton.layer.masksToBounds = YES;
    saveButton.titleLabel.textColor = [UIColor whiteColor];
    saveButton.backgroundColor = [UIColor ZYZC_MainColor];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:25];
    [saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    
    [self.scrollView addSubview:saveButton];
    self.saveButton = saveButton;
    
}

- (void)reloadUIFrame
{
    _firstBg.top = KEDGE_DISTANCE;
    _secondBg.top = _firstBg.bottom + KEDGE_DISTANCE;
    _saveButton.top = _secondBg.bottom + KEDGE_DISTANCE;
    
    _scrollView.contentSize = CGSizeMake(0, _saveButton.bottom + KEDGE_DISTANCE);
}
#pragma mark - requsetData方法
- (void)requestPersonTagData
{
    NSString *userId = [ZYZCAccountTool getUserId];
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"register_getUserInfo_action"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:userId forKey:@"userId"];
    [MBProgressHUD showMessage:@"正在加载"];
    
    WEAKSELF
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        NSString *tagstring = result[@"data"][@"user"][@"tags"];
        if (tagstring) {
            weakSelf.personTagArray = [tagstring componentsSeparatedByString:@","];
            [self requestDataOne];
        }else{
            [self requestDataOne];
        }
    } andFailBlock:^(id failResult) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:ZYLocalizedString(@"no_netwrk")];
    }];

}

- (void)requestDataOne{
    
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"user_listLabelAction"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"1" forKey:@"tag"];
    WEAKSELF
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        weakSelf.titleArrayOne = [MineTravelTagsModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        [self requestDataTwo];
    } andFailBlock:^(id failResult) {
        
    }];
}

- (void)requestDataTwo{
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"user_listLabelAction"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"2" forKey:@"tag"];
    WEAKSELF
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        weakSelf.titleArrayTwo = [MineTravelTagsModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        [weakSelf reloadUIFrame];
        _scrollView.hidden = NO;
        [MBProgressHUD hideHUD];
    } andFailBlock:^(id failResult) {
        [MBProgressHUD hideHUD];
    }];
}

- (void)requestHadFZCData
{
    
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"productInfo_checkMyProduct"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:[ZYZCAccountTool getUserId] forKey:@"userId"];
    WEAKSELF
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        //data为0表示没有发过众筹，1表示发过
        if ([result[@"data"] integerValue] == 0) {
            weakSelf.hasFZC = NO;
        }else{
            weakSelf.hasFZC = YES;
        }
    } andFailBlock:^(id failResult) {
        
    }];
}

#pragma mark - set方法
- (void)setTitleArrayOne:(NSMutableArray *)titleArrayOne
{
    _titleArrayOne = titleArrayOne;
    
    //移除所有的子button
    for(UIView *mylabelview in [_firstBg subviews])
    {
        if ([mylabelview isKindOfClass:[UIButton class]]) {
            [mylabelview removeFromSuperview];
        }
    }
    
    CGFloat bgImageViewX = KEDGE_DISTANCE;
    CGFloat bgImageViewY = KEDGE_DISTANCE;
    CGFloat bgImageViewW = KSCREEN_W - 2 * bgImageViewX;
    CGFloat bgImageViewH = _scrollView.height - bgImageViewY * 2;
    _firstBg = [[MineTravelTagBgView alloc] initWithFrame:CGRectMake(bgImageViewX, bgImageViewY, bgImageViewW, bgImageViewH) Title:@"请选择旅行标签" DetailTitle:@"最多可选10个标签" TitleArray:titleArrayOne PesonTitleArray:_personTagArray];
//    NSLog(@"%@",NSStringFromCGRect(_firstBg.frame));
    [_scrollView addSubview:_firstBg];
}

- (void)setTitleArrayTwo:(NSMutableArray *)titleArrayTwo
{
    //移除所有的子button
    for(UIView *mylabelview in [_secondBg subviews])
    {
        if ([mylabelview isKindOfClass:[UIButton class]]) {
            [mylabelview removeFromSuperview];
        }
    }
    CGFloat bgImageViewX = KEDGE_DISTANCE;
    CGFloat bgImageViewY = _firstBg.bottom + KEDGE_DISTANCE;
    CGFloat bgImageViewW = KSCREEN_W - 2 * bgImageViewX;
    CGFloat bgImageViewH = 0;
    _secondBg = [[MineTravelTagBgView alloc] initWithFrame:CGRectMake(bgImageViewX, bgImageViewY, bgImageViewW, bgImageViewH) Title:@"请选择兴趣标签" DetailTitle:@"最多可选10个标签" TitleArray:titleArrayTwo PesonTitleArray:_personTagArray];
    [_scrollView addSubview:_secondBg];
    
    
}

#pragma mark ---确定按钮点击方法
- (void)sureButton
{
    [self saveButtonAction];
}


#pragma mark - button点击方法
- (void)saveButtonAction
{
    
    //拼接第一个
    NSString *string = [NSString string];
    for (UIView *view in _firstBg.subviews) {
        if ([view isKindOfClass:[MineTravelTagButton class]]) {
            MineTravelTagButton *button = (MineTravelTagButton *)view;
            if (button.selected == YES) {
                
                if (string.length < 1) {
                    string = [string stringByAppendingString:[NSString stringWithFormat:@"%@",button.textString]];
                }else{
                    string = [string stringByAppendingString:[NSString stringWithFormat:@",%@",button.textString]];
                }
                
            }else{
                
            }
        }
    }
    //拼接第二个
    for (UIView *view in _secondBg.subviews) {
        if ([view isKindOfClass:[MineTravelTagButton class]]) {
            MineTravelTagButton *button = (MineTravelTagButton *)view;
            if (button.selected == YES) {
                if (string.length < 1) {
                    string = [string stringByAppendingString:[NSString stringWithFormat:@"%@",button.textString]];
                }else{
                    string = [string stringByAppendingString:[NSString stringWithFormat:@",%@",button.textString]];
                }
            }else{
                
            }
        }
        
    }
    
    //点击按钮的时候先做一次是否发过众筹的判断
    BOOL judge = [self judgeHasFZC:string];
    if (judge == NO) {
        //如果不通过就返回
        return;
    }
//    NSLog(@"%@",string);
    
    NSString *userId = [ZYZCAccountTool getUserId];
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 @"tags":string
                                 };
    __weak typeof(&*self) weakSelf = self;
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:[[ZYZCAPIGenerate sharedInstance] API:@"register_saveTagInfo"] andParameters:parameters    andSuccessGetBlock:^(id result, BOOL isSuccess) {
        [MBProgressHUD showSuccess:@"旅行标签设置成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } andFailBlock:^(id failResult) {
//        NSLog(@"%@",failResult);
        [MBProgressHUD showError:@"旅行标签设置失败"];
    }];
}

- (BOOL)judgeHasFZC:(NSString *)tagString
{
    if (_hasFZC == NO) {
        return YES;
    }else{
       
        if (tagString.length <= 0) {
            
            [MBProgressHUD showError:ZYLocalizedString(@"hasFZC_Error_Tag")];
            return NO;
        }
        
        return YES;
        
    }
}
#pragma mark - delegate方法

@end
