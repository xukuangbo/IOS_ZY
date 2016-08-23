//
//  TacticSingleModel.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/4/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TacticSingleTipsModel;
@interface TacticSingleModel : NSObject

@property (nonatomic, copy) NSString *videoUrl;

@property (nonatomic, copy) NSString *videoImg;
//"destDate":1460530621000,
//"viewType":2,
@property (nonatomic, assign) NSInteger viewType;
//"mgViews":[],
@property (nonatomic, strong) NSArray *mgViews;
//"viewImg":"  ",
@property (nonatomic, copy) NSString *viewImg;
//"viewImg":"  ",
@property (nonatomic, copy) NSString *min_viewImg;
//"country":"俄罗斯",
@property (nonatomic, copy) NSString *country;
//"country":"俄罗斯",
@property (nonatomic, copy) NSString *countryImg;
//"id":150,
@property (nonatomic, assign) NSInteger ID;
//"mgViewsName":"克里姆林宫,红场,圣瓦西里升天教堂,新圣女公墓,莫斯科大学,莫斯科察里津诺庄园,阿尔巴特街,麻雀山,普希金造型艺术博物馆,卡洛明斯克皇家庄园,莫斯科地铁",
@property (nonatomic, copy) NSString *mgViewsName;
//"tipsId":13,
@property (nonatomic, assign) NSInteger tipsId;
//"pics":[""],
@property (nonatomic, copy) NSString *pics;
//"viewText":"    莫斯科是俄罗斯联邦首都、莫斯科州首府，在希腊语中为“城堡”之意，斯拉夫语为“石匠的城寨”。莫斯科是俄罗斯的政治、经济、文化、金融、交通中心以及最大的综合性城市，是一座国际化大都市。\r\n    莫斯科地处东欧平原中部，面积1081平方公里，人口约1151.4万。城市沿莫斯科河而建，是世界著名的古城，拥有众多的名胜古迹，是历史悠久的红场、克里姆林宫、胜利广场的所在地。莫斯科城市规划优美，掩映在一片绿海之中，故有“森林中的首都”之美誉。大片的林木、斯大林式建筑，诸多东正教大教堂的洋葱顶，勾勒出莫斯科城市绝美的线条。",
@property (nonatomic, copy) NSString *viewText;
//"foods":[
//         {"destDate":1460624038000,
//             "foodImg":"1460624036251冬阴功汤.jpg",
//             "foodText":"        “冬阴”是酸辣的意思，“功”是虾的意思，翻译过来其实就是酸辣虾汤。将辅料放入桶中煲至出味，而后放入大头虾、鱼露、草菇、花奶、椰汁等一起炖煮，酸味鲜美开胃。这汤以色泽全红，汤味馥郁可口，辣度十足的为佳。",
//             "id":34,"name":"冬荫功汤",
//             "status":1}
//         ],
@property (nonatomic, strong) NSArray *foods;
//"name":"莫斯科",
@property (nonatomic, copy) NSString *name;
//"foodsName":"格瓦斯,伏特加,鱼子酱,俄式肉冻,黑面包,冷酸鱼,罗宋汤,熏肠",
@property (nonatomic, copy) NSString *foodsName;
//"tips":{
//    "destDate":1460964808000,
//    "id":13,
//    "name":"俄罗斯贴士",
//    "status":1,
//    "tipsImg":"",
//    "tipsText":"1.通讯：俄罗斯支持国际漫游，游客也可以办理当地电话卡，如Beeline、Megafon、MTC等。
//}
@property (nonatomic, strong) TacticSingleTipsModel *tips;
///**
// *  长图，一张图看懂
// */
@property (nonatomic, copy) NSString *glid;

//概况后面的内容
/**
 *  天气
 */
@property (nonatomic, copy) NSString *weather;
/**
 *  交通
 */
@property (nonatomic, copy) NSString *traffic;
/**
 *  住宿
 */
@property (nonatomic, copy) NSString *stay;
/**
 *  购物
 */
@property (nonatomic, copy) NSString *shopping;
/**
 *  语言
 */
@property (nonatomic, copy) NSString *language;
/**
 *  汇率
 */
@property (nonatomic, copy) NSString *parities;
/**
 *  签证
 */
@property (nonatomic, copy) NSString *visa;

@end
