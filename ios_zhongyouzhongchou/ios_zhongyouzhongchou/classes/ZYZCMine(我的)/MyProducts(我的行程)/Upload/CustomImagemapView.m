//
//  CustomImagemapView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "CustomImagemapView.h"
#import "XMNPhotoPickerController.h"
@interface CustomImagemapView ()
@property (nonatomic, strong) XMNPhotoPickerController *picker;

@property (nonatomic, assign) NSInteger                siteNumber;

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, weak) UIButton *currentButton;
@end
@implementation CustomImagemapView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        _imgArr=[NSMutableArray array];
        
        _addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame=CGRectMake(0, 0 ,self.height ,self.height );
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"uploadVoncher"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addSceneImgView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addBtn];
        
    }
    return self;
}

#pragma mark --- 添加图片
-(void)addSceneImgView
{
    __weak typeof(self) weakSelf = self;
    
    _picker = [[XMNPhotoPickerController alloc] initWithMaxCount:1 delegate:nil];
    _picker.pickingVideoEnable = NO;
    _picker.autoPushToPhotoCollection = YES;
    _picker.autoPushToVideoCollection = NO;
    [_picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<XMNAssetModel *> * _Nullable asset) {
    
        [weakSelf createNewUploadImageView];
        
        [weakSelf.currentButton setImage:imageArray[0] forState:UIControlStateNormal];
        
        [weakSelf.picker dismissViewControllerAnimated:YES completion:nil];
    }];
    //    点击取消
    [_picker setDidCancelPickingBlock:^{
        [weakSelf.viewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.viewController presentViewController:_picker animated:YES completion:nil];
    
}


- (void)createNewUploadImageView
{
    if (self.siteNumber<3) {
        //创建图片按钮
        UIButton *siteImg=[UIButton buttonWithType:UIButtonTypeCustom];
        siteImg.frame=self.addBtn.frame;
        siteImg.tag=self.siteNumber;
        [siteImg addTarget:self action:@selector(changeImg:) forControlEvents:UIControlEventTouchUpInside];
        siteImg.userInteractionEnabled = YES;
        [self addSubview:siteImg];
        [self.imgArr addObject:siteImg];
        self.currentButton = siteImg;
        //添加删除标记
        CGFloat deleteMapViewWH = 40;
        UIButton *deleteMapView = [[UIButton alloc] initWithFrame:CGRectMake(self.height - deleteMapViewWH * 0.75, -deleteMapViewWH * 0.25, deleteMapViewWH, deleteMapViewWH)];
        [deleteMapView addTarget:self action:@selector(removeSite:) forControlEvents:UIControlEventTouchUpInside];
        [siteImg addSubview:deleteMapView];
        
        CGFloat deleteImgWH = 20;
        UIImageView *deleteImg=[[UIImageView alloc] init];
        deleteImg.userInteractionEnabled = YES;
        deleteImg.size = CGSizeMake(deleteImgWH, deleteImgWH);
        deleteImg.right = deleteMapViewWH;
        deleteImg.top = 0;
        deleteImg.image = [UIImage imageNamed:@"icn_xxcc"];
        [deleteMapView addSubview:deleteImg];
        //添加按钮向后平移一个位置
        self.addBtn.left+=self.height+KEDGE_DISTANCE;
        if (self.siteNumber==2) {
            self.addBtn.hidden=YES;
        }
        self.siteNumber++;
    }
    
}

#pragma mark --- 更改图片
-(void)changeImg:(UIButton *)button
{
    //改变图片
    __weak typeof(self) weakSelf = self;
    weakSelf.currentButton = button;
    [weakSelf.picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<XMNAssetModel *> * _Nullable asset) {
        
        [weakSelf.picker dismissViewControllerAnimated:YES completion:nil];
        
        [weakSelf.currentButton setImage:imageArray[0] forState:UIControlStateNormal];
        
    }];
//    点击取消
    [weakSelf.picker setDidCancelPickingBlock:^{
        
        [weakSelf.viewController dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [weakSelf.viewController presentViewController:weakSelf.picker animated:YES completion:nil];
    
}

#pragma mark --- 删除某个景点
-(void)removeSite:(UIButton *)sender
{
    _siteNumber--;
    [sender.superview removeFromSuperview];
    [_imgArr removeObject:sender.superview];
    //从数组中删除该图片的唯一标识符
    //已有景点重新排序
    for (int i=0; i<_imgArr.count; i++) {
        UIButton *btn=_imgArr[i];
        btn.left=(self.height+KEDGE_DISTANCE)*i;
    }
    //添加按钮向前平移一个位置
    self.addBtn.left-=self.height+KEDGE_DISTANCE;
    self.addBtn.hidden=NO;
}

@end
