//
//  UserModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

typedef NS_ENUM(NSInteger, MyPartnerType)
{
    TogtherPartner=1,
    ReturnPartner
};

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy  ) NSString *openid;
@property (nonatomic, copy  ) NSString *userName;
@property (nonatomic, copy  ) NSString *realName;
@property (nonatomic, copy  ) NSString *faceImg;
@property (nonatomic, copy  ) NSString *faceImg640;
@property (nonatomic, copy  ) NSString *faceImg132;
@property (nonatomic, copy  ) NSString *faceImg64;
@property (nonatomic, copy  ) NSString *sex;//0未知，1.男，2.女
@property (nonatomic, copy  ) NSString *weixinProvince;
@property (nonatomic, copy  ) NSString *weixinCity;
@property (nonatomic, copy  ) NSString *weixinCountry;
@property (nonatomic, strong) NSNumber *usedPoints;
@property (nonatomic, copy  ) NSString *school;
@property (nonatomic, strong) NSNumber *usedBalance;
@property (nonatomic, copy  ) NSString *tags;//兴趣标签
@property (nonatomic, copy  ) NSString *company;
@property (nonatomic, strong) NSNumber *maritalStatus;//0:单身, 1:已婚, 2:恋爱中
@property (nonatomic, copy  ) NSString *title;//职位
@property (nonatomic, copy  ) NSString *birthday;
@property (nonatomic, copy  ) NSString *department;
@property (nonatomic, copy  ) NSString *province;
@property (nonatomic, copy  ) NSString *city;
@property (nonatomic, copy  ) NSString *district;
@property (nonatomic, copy  ) NSString *constellation;//星座
@property (nonatomic, copy  ) NSString *phone;
@property (nonatomic, strong) NSNumber *weight;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, copy  ) NSString *img;//支持人头像
@property (nonatomic, copy  ) NSString *mobilePhone;//手机号
/**
 *  实名认证:1 认证失败 ， 0 未认证 2 正在认证 1 认证成功
 **/
@property (nonatomic, copy) NSString *authStatus;

//旅伴？回报？
@property (nonatomic, assign) MyPartnerType mypartnerType;
//是否加入了意向列表
@property (nonatomic, strong) NSNumber *isSelect;

//意向一起游的状态
@property (nonatomic, strong) NSNumber *my_status;

//邀约的状态
@property (nonatomic, strong) NSNumber *product_owner_status;

//评价一起游／回报的人的状态（是否已评价）
@property (nonatomic, strong) NSNumber *hasPj;

//投诉一起游／回报的人的状态（是否已投诉）
@property (nonatomic, strong) NSNumber *hasTs;

@end
