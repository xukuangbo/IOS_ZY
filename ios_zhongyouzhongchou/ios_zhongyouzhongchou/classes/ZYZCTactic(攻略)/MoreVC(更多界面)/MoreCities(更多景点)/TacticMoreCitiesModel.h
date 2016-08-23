//
//  TacticMoreCitiesModel.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/7/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TacticMoreCitiesModel : NSObject
//"id": 824,
@property (nonatomic, assign) NSInteger id;
//"viewText": " 龙目岛是印度尼西亚西努沙登加拉省岛屿，面积5435平方公里，人口约350万。
@property (nonatomic, copy) NSString *viewText;
//数百万年来，龙目岛及其周边小岛与世隔绝，保存了原始的生物物种和生态环境，与印尼其他地区、甚至一道海峡之隔的巴厘岛都截然不同。但龙目岛海边风光完全可以和巴厘岛媲美，它拥有清澈碧蓝的海水、雄壮的林贾嘉尼活火山，独特的萨萨克族传统风俗文化。无论是潜入深海里，还是行走在陆地上，都能感受到开阔的视野，让人惊艳的美景，呼吸到纯净的空气，体味到出世的安宁平和。",
//"viewImg": "1467960327308.jpg",
@property (nonatomic, copy) NSString *viewImg;
//"min_viewImg": "1467960327421.jpg",
@property (nonatomic, copy) NSString *min_viewImg;
//"name": "龙目岛"
@property (nonatomic, copy) NSString *name;
@end
