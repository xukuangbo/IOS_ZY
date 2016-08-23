//
//  MoreFZCReturnTableView.h
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCBaseTableView.h"

@interface MoreFZCReturnTableView : MoreFZCBaseTableView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *openArray;

@property (nonatomic, strong) NSMutableArray *heightArray;

/**
 *  return第三个cell的是否展开
 */
@property (nonatomic, assign) BOOL returnThirdDownbuttonOpen;

@property (nonatomic, assign) BOOL keyboardOpen;

@end
