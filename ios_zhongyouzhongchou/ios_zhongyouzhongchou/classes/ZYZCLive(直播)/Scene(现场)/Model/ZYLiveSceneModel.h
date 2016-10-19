//
//  ZYLiveSceneModel.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZYLiveSceneModel : NSObject
/* 宽:高 */
@property (nonatomic, assign) CGFloat videoimgsize;
/* 时长 */
@property (nonatomic, assign) CGFloat videosize;
/**封面 */
@property (nonatomic, copy) NSString *videoimg;

/**地址 */
@property (nonatomic, copy) NSString *video;
@end
