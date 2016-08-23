//
//  VersionModel.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/6/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionModel : NSObject
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *versionDesc;
@property (nonatomic, assign) NSInteger appupdate;
@end
