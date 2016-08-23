//
//  TacticSingleFoodModel.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
//"destDate":1460618963000,
//"foodImg":"1460618963079鲤鱼豆饼.jpg",
//"foodText":"        在面粉和糯米面里放上小豆做成的鲫鱼豆饼是冬季的街头美味。因为是用糯米做的，所以吃起来口感筋道，且物美价廉，2000韩元可以买到5-6个。",
//"id":52,
//"name":"鲤鱼豆饼"
//"status":1
@interface TacticSingleFoodModel : NSObject
//"destDate": 1458657885000,

//"foodImg": "/productImg/show/indexImg/1458657885064.jpg",
@property (nonatomic, copy) NSString *foodImg;

@property (nonatomic, copy) NSString *min_foodImg;
//"foodText": "小笼包",
@property (nonatomic, copy) NSString *foodText;
//"id": 5,
@property (nonatomic, assign) NSInteger ID;
//"name": "小笼包",
@property (nonatomic, copy) NSString *name;
//"status": 1
@property (nonatomic, copy) NSArray *pics;
@end
