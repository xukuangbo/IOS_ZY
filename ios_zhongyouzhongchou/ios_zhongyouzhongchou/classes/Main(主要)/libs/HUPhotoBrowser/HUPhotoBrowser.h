//
//  HUPhotoBrowser.h
//  HUPhotoBrowser
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ __nullable DismissBlock)(UIImage * __nullable image, NSInteger index);

typedef void (^__nullable DeleteOneImage)();

@interface HUPhotoBrowser : UIView

/*
 * @param imageView    点击的imageView
 * @param URLStrings   加载的网络图片的urlString
 * @param index        点击的图片在所有要展示图片中的位置
 */

+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withURLStrings:(nullable NSArray *)URLStrings atIndex:(NSInteger)index;

/*
 * @param imageView    点击的imageView
 * @param withImages   加载的本地图片
 * @param index        点击的图片在所有要展示图片中的位置
 */

+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withImages:(nullable NSArray *)images atIndex:(NSInteger)index;

/*
 * @param imageView    点击的imageView
 * @param URLStrings   加载的网络图片的urlString
 * @param image        占位图片
 * @param index        点击的图片在所有要展示图片中的位置
 * @param dismiss      photoBrowser消失的回调
 */
+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withURLStrings:(nullable NSArray *)URLStrings placeholderImage:(nullable UIImage *)image atIndex:(NSInteger)index dismiss:(DismissBlock)block;

/*
 * @param imageView    点击的imageView
 * @param withImages   加载的本地图片
 * @param image        占位图片
 * @param index        点击的图片在所有要展示图片中的位置
 * @param dismiss      photoBrowser消失的回调
 */
+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withImages:(nullable NSArray *)images atIndex:(NSInteger)index dismiss:(DismissBlock)block;


//查看或删除单个本地图片
+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withImages:(nullable NSArray *)images atIndex:(NSInteger)index deleteImg:(DeleteOneImage )block;

//查看或删除单个网络图片

+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withURLStrings:(nullable NSArray *)URLStrings placeholderImage:(nullable UIImage *)image atIndex:(NSInteger)index  deleteImg:(DeleteOneImage)block;

/**
 *  Description      查看图片
 *
 *  @param imageView 点击的本地图片
 *  @param imgURL    图片地址（网络图片或本地图片）
 *  @param image     占位图片
 *  @param index     点击的图片在所有要展示图片中的位置
 *
 */
+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withImgURLs:(nullable NSArray *)imgURLs placeholderImage:(nullable UIImage *)image atIndex:(NSInteger)index dismiss:(DismissBlock)block;

@property (nonatomic, strong, nullable) UIImage *placeholderImage;

@end
