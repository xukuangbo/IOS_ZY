//
//  MineWantGoModel.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/5.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineWantGoModel : NSObject
//"id": 317,
@property (nonatomic, assign) NSInteger ID;
//"viewType": 2,
@property (nonatomic, assign) NSInteger viewType;
//"viewImg": "1464842213329.jpg",
@property (nonatomic, copy) NSString *viewImg;
//"country": "比利时",
@property (nonatomic, copy) NSString *country;
//"name": "安特卫普"
@property (nonatomic, copy) NSString *name;
@end
