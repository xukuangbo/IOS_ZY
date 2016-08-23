//
//  TacticVideoModel.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TacticVideoModel : NSObject

//"name": "test12",
@property (nonatomic, copy) NSString *viewImg;
//"min_viewImg": "1462261382283.jpg",
@property (nonatomic, copy) NSString *min_viewImg;
//"videoImg": "1461969356071.jpg"
@property (nonatomic, copy) NSString *videoImg;
//"videoUrl": "http://www.baidu.com",
@property (nonatomic, copy) NSString *videoUrl;
////"name": "越南",
@property (nonatomic, copy) NSString *name;
////"id": 12
@property (nonatomic, assign) NSInteger viewid;
//        "viewType": 3
@property (nonatomic, assign) NSInteger viewType;

@property (nonatomic, copy) NSString *viewText;
//一般景点数据
// "pics": "1461046312210.jpg,1461046315094.jpg",
@property (nonatomic, copy) NSString *pics;

@end
