//
//  TacticSingleTipsModel.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TacticSingleTipsModel : NSObject
//"destDate": 1458407077000,
//"id": 1,
@property (nonatomic, assign) NSInteger ID;
//"name": "小果果",
@property (nonatomic, copy) NSString *name;
//"status": 1,
//"tipsImg": "/productImg/show/indexImg/1458406438462.jpg",
@property (nonatomic, copy) NSString *tipsImg;
//"tipsText": "多喝水，少花钱"
@property (nonatomic, copy) NSString *tipsText;
@end
