//
//  FZCSaveDraftData.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/25.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCListModel.h"
#import "ZCDetailModel.h"
typedef  void (^DoBlock)();
@interface FZCSaveDraftData : NSObject
+ (void)saveDraftDataInOneModel:(ZCOneModel *)oneModel andDetailProductModel:(ZCDetailProductModel *)detailProductModel andDoBlock:(DoBlock )doBlock;
@end
