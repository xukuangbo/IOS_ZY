//
//  QPMVManager.h
//  DevQPSDKCore
//
//  Created by Worthy on 16/9/18.
//  Copyright © 2016年 LYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QPMVManager : NSObject


- (void)fetchMVResourcesWithSuccess:(void (^)(NSArray *mvs))success failure:(void (^)(NSError *error))failure;


@end
