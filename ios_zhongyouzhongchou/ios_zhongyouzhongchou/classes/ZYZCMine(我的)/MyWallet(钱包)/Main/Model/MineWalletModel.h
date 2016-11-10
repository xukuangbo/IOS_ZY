//
//  MineWalletModel.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/10.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineWalletModel : NSObject


//down = 0;
//headImage = "http://zyzc-bucket01.oss-cn-hangzhou.aliyuncs.com/oQGFKxNqnb9zIq2XG2mK5m7sowx4/20160703210830/themeImage.png";//项目背景图
@property (nonatomic, copy) NSString *headImage;
//productEndTime = "2016-07-06";//项目结束时间
@property (nonatomic, copy) NSString *productEndTime;
//productId = 79;//项目id
@property (nonatomic, strong) NSNumber *productId;
//productName = "\U53bb\U73a9\U4e8614";//项目名称
@property (nonatomic, copy) NSString *productName;
//productPrice = 1000;
//productStartTime = "2016-07-04";
//status = 2;//项目的状态
//travelendTime = "2016-07-11";
//travelstartTime = "2016-07-08";
//txstatus = 3;//提现的状态0不可提现，1：审核中；2待提现;3已提现
@property (nonatomic, assign) NSInteger txstatus;
//txtotles = 12000;//总共筹到的钱
@property (nonatomic, assign) CGFloat txtotles;
//up = 0;

//productDest = "[\"\U676d\U5dde\",\"\U590f\U5a01\U5937\",\"\U6fb3\U95e8\",\"\U9a6c\U5fb7\U671b\"]";
@property (nonatomic, copy) NSString *productDest;



@end
