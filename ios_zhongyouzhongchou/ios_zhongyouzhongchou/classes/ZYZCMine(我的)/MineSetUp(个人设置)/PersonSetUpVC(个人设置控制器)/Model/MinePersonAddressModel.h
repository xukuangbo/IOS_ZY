//
//  MinePersonAddressModel.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MinePersonAddressModel : NSObject
//"userbyaddress": {
//    "address": "文一西路",
@property (nonatomic, copy) NSString *address;
//    "city": "杭州市",
@property (nonatomic, copy) NSString *city;
//    "consignee": "Band",
@property (nonatomic, copy) NSString *consignee;
//    "district": "西湖区",
@property (nonatomic, copy) NSString *district;
//    "id": 11,
@property (nonatomic, copy) NSString *ID;
//    "phone": "120",
@property (nonatomic, copy) NSString *phone;
//    "province": "浙江省",
@property (nonatomic, copy) NSString *province;
//    "userId": 1001639556,
@property (nonatomic, copy) NSString *userId;
//    "zipCode": 310000
@property (nonatomic, copy) NSString *zipCode;
@property (nonatomic, copy) NSString *descript;

//}
@end
