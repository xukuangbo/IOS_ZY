//
//  ZCDetailReturnSecondCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/25.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCDetailReturnSecondCell.h"
#import "ZCDetailCustomButton.h"
#import "HotCommentCell.h"
#import "UIView+GetSuperTableView.h"
@interface ZCDetailReturnSecondCell ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) ZCDetailCustomButton *iconBtn;
//@property (nonatomic, strong) UILabel  *nameLab;
//@property (nonatomic, strong) UIImageView *sexImg;
//@property (nonatomic, strong) UIImageView *vipImg;
//@property (nonatomic, strong) UILabel  *timeLab;
//@property (nonatomic, strong) UILabel  *contentLab;

@property (nonatomic, strong) UITableView *table;

@end
@implementation ZCDetailReturnSecondCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        
//    }
//    return self;
//}

-(void)configUI
{
    [super configUI];
    self.titleLab.text=@"热门评论";
    self.bgImg.height=0;
    
    UIImageView *moreImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.bgImg.width-14-KEDGE_DISTANCE, self.topLineView.top-14-KEDGE_DISTANCE, 7, 14)];
    moreImg.image=[UIImage imageNamed:@"btn_rig_mor"];
    [self.bgImg addSubview:moreImg];
    
    _table=[[UITableView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, self.topLineView.bottom, self.bgImg.width-2*KEDGE_DISTANCE, 0) style:UITableViewStylePlain];
    _table.scrollEnabled=NO;
    _table.dataSource=self;
    _table.delegate  =self;
    _table.showsVerticalScrollIndicator=NO;
    _table.tableFooterView=[[UIView alloc]init];
    _table.backgroundColor=[UIColor whiteColor];
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    _table.userInteractionEnabled=NO;
    [self.bgImg addSubview:_table];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _comments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId=@"hotcComment";
    HotCommentCell *hotCommentCell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!hotCommentCell) {
        hotCommentCell=[[HotCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    ZCCommentModel *commentModel=_comments[indexPath.row];
    hotCommentCell.commentModel=commentModel;
    if (indexPath.row==_comments.count-1)
    {
        hotCommentCell.lineView.hidden=YES;
    }
    return hotCommentCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZCCommentModel *commentModel=_comments[indexPath.row];
    return commentModel.cellHeight;
}


-(void)setCommentList:(ZCCommentList *)commentList
{
    _commentList=commentList;
    NSMutableArray *comments=[NSMutableArray array];
    for(ZCCommentModel *commentModel in _commentList.commentList)
    {
        [comments addObject:commentModel];
    }
    _comments=comments;
    [_table reloadData];
    
    CGFloat selfHeight=0.0;
    for (ZCCommentModel *commentModel in comments) {
        selfHeight+=[self caculateOneCellHeightByModel:commentModel];
    }
    _table.height=selfHeight;
    self.bgImg.height=_table.bottom+5;
    _commentList.listCommentHeight=self.bgImg.height;
    
}

-(CGFloat )caculateOneCellHeightByModel:(ZCCommentModel *)commentModel
{
    CGFloat oneTableCellHeight=0.0;
//    计算content内容
        NSString *content= commentModel.comment.content;
        CGSize contentSize=[ZYZCTool calculateStrLengthByText:content andFont:[UIFont systemFontOfSize:16] andMaxWidth:self.bgImg.width-90];
    
        CGFloat height01=80;
        CGFloat height02=40+contentSize.height+KEDGE_DISTANCE;
    
    oneTableCellHeight=MAX(height01, height02);
    
    return oneTableCellHeight;
}



-(void)dealloc
{
    
}


@end














