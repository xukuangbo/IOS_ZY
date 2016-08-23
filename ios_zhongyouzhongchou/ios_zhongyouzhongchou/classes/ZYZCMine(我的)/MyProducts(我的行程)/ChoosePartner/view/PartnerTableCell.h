//
//  PartnerTableCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/6/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define PARTYNER_CELL_HEIGHT  80
#import "ZYZCBaseTableViewCell.h"
#import "UserModel.h"
#import "ParterStatusBtn.h"
@interface PartnerTableCell : ZYZCBaseTableViewCell
@property (nonatomic, strong) NSNumber       *productId;
@property (nonatomic, strong) UserModel      *partnerModel;
//区分一起游的人／回报的人
@property (nonatomic, assign) MyPartnerType  myPartnerType;

//评价类型
@property (nonatomic, assign) CommentType    commentType;

@property (nonatomic, assign) BOOL           fromMyReturn;//是否来自回报

@end
