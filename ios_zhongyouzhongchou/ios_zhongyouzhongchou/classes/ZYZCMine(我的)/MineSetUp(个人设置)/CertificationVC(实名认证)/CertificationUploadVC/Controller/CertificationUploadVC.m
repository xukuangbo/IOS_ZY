//
//  CertificationUploadVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/11/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "CertificationUploadVC.h"
#import "CertificationUploadMapView.h"
@interface CertificationUploadVC ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) CertificationUploadMapView *frontCardView;

@property (nonatomic, strong) CertificationUploadMapView *backCardView;

@property (nonatomic, strong) CertificationUploadMapView *peopleCardView;
@end

@implementation CertificationUploadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
}

- (void)setUpViews{
    
    [self setBackItem];
    
    _scrollView = [UIScrollView new];
    
    _frontCardView = [[[NSBundle mainBundle] loadNibNamed:@"CertificationUploadMapView" owner:nil options:nil] lastObject];
    [CertificationUploadMapView new];
    _backCardView = [[[NSBundle mainBundle] loadNibNamed:@"CertificationUploadMapView" owner:nil options:nil] lastObject];
    _peopleCardView = [[[NSBundle mainBundle] loadNibNamed:@"CertificationUploadMapView" owner:nil options:nil] lastObject];
    
    _frontCardView.bgImage.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    _frontCardView.imageView.image = [UIImage imageNamed:@"real_id1"];
    _backCardView.bgImage.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    _backCardView.imageView.image = [UIImage imageNamed:@"real_id2"];
    _peopleCardView.bgImage.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    _peopleCardView.imageView.image = [UIImage imageNamed:@"real_id3"];
    
    _frontCardView.titleLabel.text = @"1、证件正面";
    _backCardView.titleLabel.text = @"2、证件反面";
    _peopleCardView.titleLabel.text = @"3、手持证件照";
    
    _frontCardView.contentLabel.text = @"仅支持jpg、png格式图片不能超过300k";
    _backCardView.contentLabel.text = @"仅支持jpg、png格式图片不能超过300k";
    _peopleCardView.contentLabel.text = @"请确保证件信息清晰\n请确保面部不被遮挡\n\n仅支持jpg、png格式图片不能超过300k";
    
    [self changeCommitButtonUIWithStatus:NO];
    
    [self.view addSubview:_scrollView];
    [self.view addSubview:_frontCardView];
    [self.view addSubview:_backCardView];
    [self.view addSubview:_peopleCardView];
    
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_frontCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(_frontCardView.mas_width).multipliedBy(250 / 600.0);
    }];
    
    [_backCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_frontCardView.mas_bottom).offset(10);
        make.centerX.equalTo(_frontCardView.mas_centerX);
        make.size.equalTo(_frontCardView);
    }];
    
    [_peopleCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_backCardView.mas_bottom).offset(10);
        make.centerX.equalTo(_frontCardView.mas_centerX);
        make.size.equalTo(_frontCardView);
    }];
}

/* 改变可选择按钮状态 */
- (void)changeCommitButtonUIWithStatus:(BOOL)canSelect{
    
    if (!canSelect) {
        [_commitButton setTitleColor:[UIColor ZYZC_TextGrayColor04] forState:UIControlStateNormal];
        _commitButton.backgroundColor = KCOLOR_RGBA(221, 221, 221,0.95);
        _commitButton.enabled = NO;
    }else{
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitButton.backgroundColor = [UIColor ZYZC_MainColor];
        _commitButton.enabled = YES;
    }
}
@end
