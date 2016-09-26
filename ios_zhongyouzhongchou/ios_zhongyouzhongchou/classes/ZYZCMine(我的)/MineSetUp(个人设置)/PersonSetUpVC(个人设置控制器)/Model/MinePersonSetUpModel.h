//
//  MinePersonSetUpModel.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MinePersonAddressModel;
@interface MinePersonSetUpModel : NSObject
//user: {
//birthday: "1986-08-09",
@property (nonatomic, copy) NSString *birthday;
//city: "杭州市",
@property (nonatomic, copy) NSString *city;
//company: "公司",
@property (nonatomic, copy) NSString *company;
//constellation: "狮子座",
@property (nonatomic, copy) NSString *constellation;
//country: "中国",
@property (nonatomic, copy) NSString *country;
//department: "计算机学院",
@property (nonatomic, copy) NSString *department;
//district: "西湖区",
@property (nonatomic, copy) NSString *district;
//faceImg: "http://wx.qlogo.cn/mmopen/g3MonUZtNHkdmzicIlibx6iaFqAc56vxLSUfpb6n5WKSYVY0ChQKkiaJSgQ1dZuTOgvLLrhJbERQQ4eMsv84eavHiaiceqxibJxCfHe/0",
@property (nonatomic, copy) NSString *faceImg;

//maritalStatus: "0",
@property (nonatomic, copy) NSString *maritalStatus;
//openid: "o6_bmjrPTlm6_2sgVt7hMZOPfL2M",
@property (nonatomic, copy) NSString *openid;
//phone: "130",
@property (nonatomic, copy) NSString *qq;
//province: "浙江省",
@property (nonatomic, copy) NSString *province;
//realName: "Band",
@property (nonatomic, copy) NSString *realName;
//school: "某某职业技术学校",
@property (nonatomic, copy) NSString *school;
//sex: "1",
@property (nonatomic, copy) NSString *sex;
//tags: "美食,穷游",
@property (nonatomic, copy) NSString *tags;
//title: "工程师",
@property (nonatomic, copy) NSString *title;
//usedBalance: 0,
@property (nonatomic, copy) NSString *usedBalance;
//usedPoints: 0,
@property (nonatomic, copy) NSString *usedPoints;
//userId: 1001639556,
@property (nonatomic, copy) NSString *userId;
//userName: "Band",
@property (nonatomic, copy) NSString *userName;
//weight: 50
@property (nonatomic, assign) int weight;
//height: 170,
@property (nonatomic, assign) int height;

@property (nonatomic, copy) NSString *mail;
// 粉丝
@property (nonatomic, copy) NSString *meGzAll;
// 关注
@property (nonatomic, copy) NSString *gzMeAll;

@property (nonatomic, strong) MinePersonAddressModel *userbyaddress;
//}
@end
