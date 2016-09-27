//
//  ZYFootprintCommentTable.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseTableView.h"

#import "ZYCommentFootprintCell.h"
#import "ZYFootprintOneCommentCell.h"

typedef void(^ScrollDidEndDeceleratingBlock)();
typedef void(^ScrollWillBeginDecelerating)();
typedef void(^CommentNumberChangeBlock)(NSInteger commentNumber);

@interface ZYFootprintCommentTable : ZYZCBaseTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andFootprintModel:(ZYFootprintListModel *)footprintModel;

@property (nonatomic, strong)ZYSupportListModel *supportUsersModel;

@property (nonatomic, strong) NSNumber      *replyUserId;
@property (nonatomic, copy  ) NSString      *replyUserName;

@property (nonatomic, copy  )ScrollDidEndDeceleratingBlock scrollDidEndDeceleratingBlock;

@property (nonatomic, copy  )ScrollWillBeginDecelerating scrollWillBeginDecelerating;

@property (nonatomic, copy  )CommentNumberChangeBlock commentNumberChangeBlock;//评论数发生改变

@end
