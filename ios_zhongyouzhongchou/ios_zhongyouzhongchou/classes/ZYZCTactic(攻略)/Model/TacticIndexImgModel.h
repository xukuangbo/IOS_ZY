//
//  TacticIndexImgModel.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/6/5.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TacticIndexImgModel : NSObject
//"id": 4,
@property (nonatomic, assign) NSInteger ID;
//"proImg": "/productImg/show/indexImg/1415153179970.jpg",
@property (nonatomic, copy) NSString *proImg;
//"proUrl": "http://1yyg.zp8848.com",
@property (nonatomic, copy) NSString *proUrl;
//"status": 0,
@property (nonatomic, assign) NSInteger status;
//"title": "小米电视2"
@property (nonatomic, copy) NSString *title;
@end
