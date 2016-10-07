//
//  ZYVideoImageCollection.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/10/7.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYVideoImageCollection.h"
#import "HJCarouselViewLayout.h"
#import "HJCarouselViewCell.h"
static NSString * const reuseIdentifier = @"VideoImageCell";

@interface ZYVideoImageCollection ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *images;

@end

@implementation ZYVideoImageCollection

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame andImages:(NSArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        
        HJCarouselViewLayout *layout= [[HJCarouselViewLayout alloc] initWithAnim:HJCarouselAnimLinear];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(150, 150);
        
        self.images=images;
        self.delegate=self;
        self.dataSource=self;
        self.collectionViewLayout=layout;
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([HJCarouselViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return self;
}

- (NSIndexPath *)curIndexPath {
    NSArray *indexPaths = [self indexPathsForVisibleItems];
    NSIndexPath *curIndexPath = nil;
    NSInteger curzIndex = 0;
    for (NSIndexPath *path in indexPaths.objectEnumerator) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:path];
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
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"click %ld", indexPath.row);
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HJCarouselViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = self.images[indexPath.row];
    return cell;
}




@end
