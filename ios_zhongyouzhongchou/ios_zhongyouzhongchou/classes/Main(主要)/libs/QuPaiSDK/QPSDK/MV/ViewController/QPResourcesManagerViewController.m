//
//  ResourcesManagerViewController.m
//  qupai
//
//  Created by Worthy on 14/11/27.
//  Copyright (c) 2014年 duanqu. All rights reserved.
//

#import "QPResourcesManagerViewController.h"
#import "QPResourcesManagerCell.h"
#import "QPEffectManager.h"

@interface QPResourcesManagerViewController ()
{
    NSMutableArray *_array;
    BOOL _showStatusBar;

}
@property (nonatomic, weak) IBOutlet UIButton * buttonRank;
@property (nonatomic, weak) IBOutlet UIView * guideButtonView;
@property (nonatomic, weak) IBOutlet UIView * guideRankViewTop;
@property (nonatomic, weak) IBOutlet UIView * guideRankViewBottom;


@end

@implementation QPResourcesManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"QPResourcesManagerCell" bundle:nil] forCellWithReuseIdentifier:@"QPResourcesManagerCell"];
    
    layout.itemSize = CGSizeMake(ScreenWidth, layout.itemSize.height);
    _constraintsViewLineHeight.constant = 1.0/[[UIScreen mainScreen] scale];
    [self updateEmptyViewIndex:1];
    [[QPEffectManager sharedManager] updateMVEffect];
    _array = [[QPEffectManager sharedManager] getLocalMVEffects];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)buttonCloseClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(resourcesManagerViewControllerClose)]) {
        [_delegate resourcesManagerViewControllerClose];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateEmptyViewIndex:(NSInteger)index {
    NSArray *texts = @[@"你还没有下载动图",@"你还没有下载iMV",@"你还没有下载音乐"];
    _imageViewEmpty.image = [UIImage imageNamed:@"icon-no-data"];
    _labelEmpty.text = texts[index];
}

#pragma mark - UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QPResourcesManagerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QPResourcesManagerCell" forIndexPath:indexPath];
    QPEffectMV *effectMV = _array[indexPath.row];
    if (indexPath.row <_array.count) {
        cell.delegate = (id<QPResourcesManagerCellDelegate>)self;
        cell.effectMV = effectMV;
    }
    return cell;
}

- (void)resourcesManagerCellDelete:(QPResourcesManagerCell*)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    QPEffectMV *effectMV = _array[indexPath.row];
    
    [[QPEffectManager sharedManager] deleteEffectById:effectMV.eid type:QPEffectTypeMV];
//    Paster *p = _array[indexPath.item];
//    [[NSFileManager defaultManager] removeItemAtPath:p.unzipDir error:nil];
//    [_array removeObjectAtIndex:indexPath.item];
//    if (_type == PasterMusic) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:ShopMusicDeleteNotification object:p];
//        [EventManager event:QUEventDeleteMusic];
//    
//        if ([[PasterManager share] canAddDeleteList:p]) {
//            [[[PasterManager share] deleteDownMusic] addObject:p];
//            [[GlobalConfig shared] addDeleteMusicID:p.clientID];
//        }
//    }else if(_type == PasterMV){
//        [[NSNotificationCenter defaultCenter] postNotificationName:ShopMVDeleteNotification object:p];
//        [EventManager event:QUEventDeleteMv];
//        
//        if ([[PasterManager share] canAddDeleteList:p]) {
//            [[[PasterManager share] deleteDownMV] addObject:p];
//            [[GlobalConfig shared] addDeleteMVID:p.clientID];
//        }
//    }else if(_type == PasterPaster){
//        
//    }
    _array = [[QPEffectManager sharedManager] getLocalMVEffects];
    [self.collectionView reloadData];
    _viewEmpty.hidden = _array.count != 0;
}

@end
