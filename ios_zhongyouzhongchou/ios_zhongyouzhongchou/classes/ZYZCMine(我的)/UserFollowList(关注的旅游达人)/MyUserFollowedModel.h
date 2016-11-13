//
//  MyUserFollowedModel.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUserFollowedModel : NSObject
//"city": "Wenzhou",
@property (nonatomic, copy) NSString *city;
//"country": "CN",
@property (nonatomic, copy) NSString *country;
//"faceImg": "http://wx.qlogo.cn/mmopen/ajNVdqHZLLAKDuBty3mAk921tiaxwBZglCian8WpND8GtMANxTN2H4wkoeW9riaXZZvQ5njnaibrGs7IMgDZVzIu0A/0",
@property (nonatomic, copy) NSString *faceImg;
//"openid": "oulbuvkOQJLtwqxiKguneyS1Pj-o",
@property (nonatomic, copy) NSString *openid;
//"province": "Zhejiang",
@property (nonatomic, copy) NSString *province;
//"sex": "2",
@property (nonatomic, copy) NSString *sex;
//"userId": 59,
@property (nonatomic, assign) NSInteger userId;
//"userName": "蔡雨璇"
@property (nonatomic, copy) NSString *userName;
//"company"
@property (nonatomic, copy) NSString *company;
//"title"
@property (nonatomic, copy) NSString *title;
//"realName"
@property (nonatomic, copy) NSString *realName;
@end
