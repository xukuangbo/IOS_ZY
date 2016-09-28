//
//  EntryPlaceholderView.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "EntryPlaceholderView.h"
#define titleFont [UIFont boldSystemFontOfSize:16]
#define contentFont [UIFont systemFontOfSize:14]
#define imageHeight(imageWidth) (imageWidth * 0.57)

@implementation EntryPlaceholderView


#pragma mark ---枚举值添加占位view
+ (instancetype)viewWithSuperView:(UIView *)superView type:(EntryType)entryType
{
    UIImage *image = nil;
    NSString *title = nil;
    NSString *content = nil;
    if (entryType == EntryTypeCaogao) {
        image = [UIImage imageNamed:@"Empty-Draft-box-empty"];
        title = @"你的草稿是空的";
        content = @"你还没有发起过旅费众筹项目\n点击加号发起众筹";
    }else if (entryType == EntryTypeSixin) {
        image = [UIImage imageNamed:@"Empty-Not-yet-chat"];
        title = @"你没有发起过私信聊天";
        content = @"私信聊天找到靠谱旅伴\n点击他人头像 空间可发起私信聊天";
    }else if (entryType == EntryTypeHuibao) {
        image = [UIImage imageNamed:@"Empty-No-yet--return"];
        title = @"你没有支持过项目回报";
        content = @"众筹项目中有回报支持\n快去支持别人吧";
    }else if (entryType == EntryTypeXiangquDest) {
        image = [UIImage imageNamed:@"Empty-No-marked-address"];
        title = @"你没有标记过想去目的地";
        content = @"想去目的地就是你的旅行愿望\n快去目的地标记吧";
    }else if (entryType == EntryTypeGuanzhuDaren) {
        image = [UIImage imageNamed:@"Empty-Follow-friends"];
        title = @"你还没有关注过旅行达人";
        content = @"关注旅行达人可以获取他们的动态信息\n快去关注吧";
    }else if (entryType == EntryTypeLiveList) {
        image = [UIImage imageNamed:@"Empty-nothing"];
        title = @"这里什么都没有";
        content = @"点击右上角发起\n自己动手做一个主播吧";
    }else if (entryType == EntryTypeSearch) {
        image = [UIImage imageNamed:@"Empty-Search-without-result"];
        title = @"没有找到搜索结果";
        content = @"换个关键词再试试吧";
    }
    
    
    EntryPlaceholderView *view = [[EntryPlaceholderView alloc] initWithFrame:superView.bounds];
    view.backgroundColor = [UIColor colorWithRed:245 / 256.0 green:248 / 256.0 blue:248 / 256.0 alpha:1];
    view.userInteractionEnabled = NO;
    
    [superView addSubview:view];
    
    DDLog(@"%@",NSStringFromCGRect(superView.frame));
    //创建图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.width = superView.frame.size.width * 0.65;
    imageView.height = imageHeight(imageView.width);
    imageView.image = image;
//    imageView.backgroundColor = [UIColor redColor];
    //判断是否是tableview
    if ([superView isKindOfClass:[UITableView class]]) {
        imageView.center = CGPointMake(superView.width * 0.5, superView.frame.size.height * 0.4);
    }else{
        imageView.center = CGPointMake(superView.width * 0.5, superView.frame.size.height * 0.5);
    }
    [view addSubview:imageView];
    
//    NSLog(@"%@",NSStringFromCGRect(imageView.frame));
    
    //创建标题
    CGFloat titleLabelX = KEDGE_DISTANCE;
    CGFloat titleLabelY = imageView.top - KEDGE_DISTANCE * 3 - 20;
    CGFloat titleLabelW = KSCREEN_W - titleLabelX * 2;
    CGFloat titleLabelH = 20;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    [view addSubview:titleLabel];
    titleLabel.font = titleFont;
    //    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.textColor = [UIColor ZYZC_TextBlackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.numberOfLines = 0;
    
    
    //创建内容
    CGFloat contentX = KEDGE_DISTANCE;
    CGFloat contentY = imageView.bottom + KEDGE_DISTANCE * 3;
    CGFloat contentW = KSCREEN_W - contentX * 2;
    CGFloat contentH = 0;
    //如果没有图片就让label上移
    if (image == nil) {
        contentY = superView.frame.size.height * 0.2;
    }
    //计算文字高度
    CGSize titleSize = [ZYZCTool calculateStrByLineSpace:10 andString:content andFont:contentFont andMaxWidth:contentW];
    contentH = titleSize.height;
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentX, contentY, contentW, contentH)];
    contentLabel.font = contentFont;
//    titleLabel.backgroundColor = [UIColor redColor];
    contentLabel.textColor = [UIColor ZYZC_TextGrayColor];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = content;
    contentLabel.numberOfLines = 0;
    [view addSubview:contentLabel];
    
    return view;
}


#pragma mark ---自定义占位图
+ (instancetype)viewWithSuperView:(UIView *)superView image:(UIImage *)image title:(NSString *)title
{
    EntryPlaceholderView *view = [[EntryPlaceholderView alloc] initWithFrame:superView.bounds];
    view.backgroundColor = [UIColor colorWithRed:245 / 256.0 green:248 / 256.0 blue:248 / 256.0 alpha:1];
    view.userInteractionEnabled = NO;
    
    [superView addSubview:view];
    //创建图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.width = superView.frame.size.width * 0.65;
    imageView.height = imageHeight(imageView.width);
    imageView.image = image;
//    imageView.backgroundColor = [UIColor redColor];
    imageView.center = CGPointMake(superView.width * 0.5, superView.frame.size.height * 0.4);
    [view addSubview:imageView];
    
//    NSLog(@"%@",NSStringFromCGRect(imageView.frame));
    //创建标题
    CGFloat titleLabelX = KEDGE_DISTANCE;
    CGFloat titleLabelY = imageView.bottom + KEDGE_DISTANCE * 3;
    CGFloat titleLabelW = KSCREEN_W - titleLabelX * 2;
    CGFloat titleLabelH = 0;
    //计算文字高度
    CGSize titleSize = [ZYZCTool calculateStrByLineSpace:10 andString:title andFont:titleFont andMaxWidth:titleLabelW];
    titleLabelH = titleSize.height;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    titleLabel.font = titleFont;
//    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.textColor = [UIColor ZYZC_TextGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.numberOfLines = 0;
    [view addSubview:titleLabel];
    
    
    return view;
}


#pragma mark ---直接返回一个占位view，无需提供父视图
+ (instancetype)viewWithFrame:(CGRect)rect type:(EntryType)entryType
{
    UIImage *image = nil;
    NSString *title = nil;
    if (entryType == EntryTypeCaogao) {
        image = [UIImage imageNamed:@"Empty-Draft-box-empty"];
        title = @"您还没有发起过旅费众筹项目\n点击加号发起众筹";
    }else if (entryType == EntryTypeSixin) {
        image = [UIImage imageNamed:@"Empty-Not-yet-chat"];
        title = @"私信聊天找到靠谱旅伴\n点击他人头像 空间可发起私信聊天";
    }else if (entryType == EntryTypeHuibao) {
        image = [UIImage imageNamed:@"Empty-No-yet--return"];
        title = @"众筹项目中有回报支持\n快去支持别人吧";
    }else if (entryType == EntryTypeXiangquDest) {
        image = [UIImage imageNamed:@"Empty-No-marked-address"];
        title = @"想去目的地就是你的旅行愿望\n快去目的地标记吧";
    }else if (entryType == EntryTypeGuanzhuDaren) {
        image = [UIImage imageNamed:@"Empty-Follow-friends"];
        title = @"关注旅行达人可以获取他们的动态信息\n快去关注吧";
    }
    
    
    EntryPlaceholderView *view = [[EntryPlaceholderView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor colorWithRed:245 / 256.0 green:248 / 256.0 blue:248 / 256.0 alpha:1];
    view.userInteractionEnabled = NO;
    
    //创建图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.width = rect.size.width * 0.65;
    imageView.height = imageHeight(imageView.width);
    imageView.image = image;
//    imageView.backgroundColor = [UIColor redColor];
    imageView.center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.4);
    [view addSubview:imageView];

    //创建标题
    CGFloat titleLabelX = KEDGE_DISTANCE;
    CGFloat titleLabelY = imageView.bottom + KEDGE_DISTANCE * 3;
    CGFloat titleLabelW = KSCREEN_W - titleLabelX * 2;
    CGFloat titleLabelH = 0;
    //计算文字高度
    CGSize titleSize = [ZYZCTool calculateStrByLineSpace:10 andString:title andFont:titleFont andMaxWidth:titleLabelW];
    titleLabelH = titleSize.height;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    titleLabel.font = titleFont;
//    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.textColor = [UIColor ZYZC_TextGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.numberOfLines = 0;
    [view addSubview:titleLabel];
    
    return view;
}



#pragma mark ---删除占位界面
+ (void)hidePlaceholderForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[EntryPlaceholderView class]]) {
            [subview removeFromSuperview];
        }
    }
}

@end
