//
//  MVMoreViewController.m
//  qupai
//
//  Created by yly on 15/2/9.
//  Copyright (c) 2015年 duanqu. All rights reserved.
//

#import "QPMVMoreViewController.h"
#import "QPMVMoreGroup.h"
//#import "MVMoreManager.h"
#import "QPMVMoreGroupViewCell.h"
#import "QPPlayerManager.h"
#import "QPResourcesManagerViewController.h"
#import "QPEffectManager.h"
#import "QPMVManager.h"


@interface QPMVMoreViewController ()<QPMVMoreViewCellDelegate,MVMoreDownViewDelegate,QPResourcesManagerViewControllerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) QPPlayerManager *playerManager;
@property (nonatomic, strong) QPMVManager *mvManager;
@end

@implementation QPMVMoreViewController
{
//    MVMoreManager *_mvManager;
    NSInteger _curGroupIndex;
    UIView *_lineView;
    NSMutableArray *_downItemID;
    BOOL _finishSaveCache;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    _downItemID = [NSMutableArray array];

    [self loadRemoteData];
    [self addNotification];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setupSubviews {
    self.navigationController.navigationBarHidden = YES;
    self.topLineHeightConst.constant = 0.5;
    self.moreGroupCell.delegate = self;
    self.moreGroupCell.controller = self;
    self.downView.delegate = self;
}

- (void)loadRemoteData {
    QPMVMoreGroup *group = [[QPMVMoreGroup alloc] init];
    group.gid = 1;
    [self.mvManager fetchMVResourcesWithSuccess:^(NSArray *mvs) {
        [self updateMVStatus:mvs];
        group.mvs = mvs;
        self.moreGroupCell.group = group;
    } failure:^(NSError *error) {
        
    }];

}

- (void)updateMVStatus:(NSArray *)mvs {
    for (QPEffectMV *mv in mvs) {
        mv.type = QPEffectTypeMV;
        NSInteger index = [[QPEffectManager sharedManager] effectIndexByID:mv.eid type:QPEffectTypeMV];
        if (index) {
            mv.downStatus = QPEffectItemDownStatusFinish;
        }else {
            mv.downStatus = QPEffectItemDownStatusNone;
        }
    }
}

- (void)addNotification {
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification:)
                                                  name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillEnterForegroundNotification:(NSNotification *)notification {
    [self.moreGroupCell checkReplay];
}

- (void)dealloc
{
    [self removeNotification];
}

#pragma mark - Action

- (IBAction)buttonCloseClick:(id)sender {
//    [self saveCache];
    [_delegate mvMoreViewControllerClose:self downID:_downItemID isNew:NO];
}

- (IBAction)buttonManagerClick:(id)sender {
    QPResourcesManagerViewController *manager = [[QPResourcesManagerViewController alloc] initWithNibName:@"QPResourcesManagerViewController" bundle:nil];
    manager.delegate = self;
    [self.navigationController pushViewController:manager animated:YES];
}
//
- (IBAction)maskViewUpClick:(id)sender {
//    MVMoreGroupViewCell *cell = [self currentGroupCell];
    [self.moreGroupCell cancelSelect];
}

- (IBAction)maskViewDownClick:(id)sender {
    [self maskViewUpClick:sender];
}

- (IBAction)buttonCellCloseClick:(id)sender {
    [self maskViewUpClick:sender];
}

#pragma mark MVMoreViewCell Delegate

- (void)mvMoreViewCellPlay:(QPMVMoreViewCell *)cell {
    NSURL *playUrl = [NSURL URLWithString:cell.effectMV.previewMp4];
    [self.playerManager playVideoWithUrl:playUrl atView:cell.playerView];
}

- (void)mvMoreViewCellStop:(QPMVMoreViewCell *)cell {
    [self.playerManager stop];
}

- (void)mvMoreViewCellClose:(QPMVMoreViewCell *)cell {
    [[QPEffectManager sharedManager] updateMVEffect];
}

- (void)mvMoreViewCellDown:(QPMVMoreViewCell *)cell {
    [_downItemID addObject:@(cell.effectMV.eid)];
    [[QPEffectManager sharedManager] downEffect:cell.effectMV];
}

- (void)mvMoreViewCellUse:(QPMVMoreViewCell *)cell {
    [[QPEffectManager sharedManager] updateMVEffect];
    [_delegate mvMoreViewController:self useItem:cell.effectMV];
}

#pragma mark - ResourcesManagerViewControllerDelegate Delegate

- (void)resourcesManagerViewControllerClose {
//    [[QPEffectManager sharedManager] updateMVEffect];
    [self updateMVStatus:self.moreGroupCell.group.mvs];
    [self.moreGroupCell.tableView reloadData];
}

#pragma mark -  QPMVMoreGroupViewCell delegate

- (void)mvMoreGroupScaleItem:(QPEffectMV *)effectMV {
    self.downView.effectMV = effectMV;
}

- (void)mvMoreGroupViewCell:(QPMVMoreGroupViewCell *)cell maskViewFrame:(CGRect)rect enable:(BOOL)enable {
    _maskViewUpHeightConst.constant = CGRectGetMinY(rect);
    _maskViewDownHeightConst.constant = ScreenHeight - CGRectGetMaxY(rect);

}

#pragma mark MVMoreDownView delegate

- (void)mvMoreDownViewDown:(QPEffectMV *)effectMV {
    [_downItemID addObject:@(effectMV.eid)];
    [[QPEffectManager sharedManager] downEffect:effectMV];
}

- (void)mvMoreDownViewUse:(QPEffectMV *)effectMV {
    [[QPEffectManager sharedManager] updateMVEffect];
    [_delegate mvMoreViewController:self useItem:effectMV];
}

#pragma mark - Getter Setter

- (QPPlayerManager *)playerManager {
    if (!_playerManager) {
        _playerManager = [[QPPlayerManager alloc] init];
    }
    return  _playerManager;
}

- (QPMVManager *)mvManager {
    if (!_mvManager) {
        _mvManager = [[QPMVManager alloc] init];
    }
    return _mvManager;
}

@end
