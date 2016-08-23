//
//  ZYLiveListViewModel.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ViewModelClass.h"

typedef enum : NSUInteger {
    RefreshTypeDefault,
    RefreshTypeHead,
    RefreshTypeFoot
} RefreshType;

@interface ZYLiveListViewModel : ViewModelClass


@property (nonatomic, assign) RefreshType refreshType ;
/**
 *  上啦刷新请求直播列表页面数据
 */
- (void)footRefreshDataWithPageNo:(NSInteger )pageNO;

/**
 *  下拉刷新
 */
- (void)headRefreshData;


/**
 *  推到直播的控制器
 */
//- (void)pushToLiveController;
/**
 *  返回数据
 */
-(void)fetchValueSuccessWithDic: (NSDictionary *) returnValue;

@end
