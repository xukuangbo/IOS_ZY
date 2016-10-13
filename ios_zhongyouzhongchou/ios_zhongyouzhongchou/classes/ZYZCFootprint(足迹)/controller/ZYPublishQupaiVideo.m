//
//  CollectionViewController.m
//  HJCarouselDemo
//
//  Created by haijiao on 15/8/20.
//  Copyright (c) 2015年 olinone. All rights reserved.
//

#import "ZYPublishQupaiVideo.h"
#import "HJCarouselViewCell.h"
#import "VideoService.h"
@interface ZYPublishQupaiVideo ()
@property (nonatomic, strong) UIButton     *publishBtn;
@property (nonatomic, strong) NSArray      *imageData;
@end

@implementation ZYPublishQupaiVideo

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.collectionView.frame=CGRectMake(0, 64, KSCREEN_W, 150);
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HJCarouselViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self configNavUI];
    [self getImageData];
}

-(void )getImageData
{
    NSFileManager *manager=[NSFileManager defaultManager];
    BOOL exist=[manager fileExistsAtPath:self.videoPath];
    if(exist)
    {
        NSArray *images=[VideoService thumbnailImagesForVideo:[NSURL fileURLWithPath:self.videoPath] withImageCount:20];
        self.imageData=images;
        [self.collectionView reloadData];
    }
}

-(void)configNavUI
{
    //navUI
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 64)];
    navView.backgroundColor=[UIColor ZYZC_BgGrayColor];
    [self.view addSubview:navView];
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 100, 44)];
    titleLab.text=@"添加足迹";
    titleLab.textColor=[UIColor ZYZC_TextBlackColor];
    titleLab.font=[UIFont systemFontOfSize:20];
    titleLab.centerX=navView.centerX;
    [navView addSubview:titleLab];
    
    //退出按钮
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(10, 20, 50, 44);
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [backBtn  addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    //发布按钮
    UIButton *publishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame=CGRectMake(KSCREEN_W-60, 20, 50, 44);
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
    publishBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [publishBtn addTarget:self action:@selector(publishMyFootprint) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:publishBtn];
    _publishBtn=publishBtn;
    
    UIView *lineView=[UIView lineViewWithFrame:CGRectMake(0, navView.height-0.5, KSCREEN_W, 0.5) andColor:[UIColor lightGrayColor]];
    [navView addSubview:lineView];
}

#pragma mark --- 返回操作
-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark ---  发布足迹👣
-(void)publishMyFootprint
{
    
}


- (NSIndexPath *)curIndexPath {
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *curIndexPath = nil;
    NSInteger curzIndex = 0;
    for (NSIndexPath *path in indexPaths.objectEnumerator) {
        UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:path];
        if (!curIndexPath) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
            continue;
        }
        if (attributes.zIndex > curzIndex) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
        }
    }
    return curIndexPath;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *curIndexPath = [self curIndexPath];
    if (indexPath.row == curIndexPath.row) {
        return YES;
    }
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"click %ld", indexPath.row);
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HJCarouselViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = self.imageData[indexPath.row];
    cell.imageView.contentMode=UIViewContentModeScaleAspectFit;
    return cell;
}


@end
