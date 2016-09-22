//
//  ZYCommentFootprintCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYCommentFootprintCell.h"
#import "ZYOneFootprintView.h"

@interface ZYCommentFootprintCell ()
@property (nonatomic, strong) ZYOneFootprintView *oneFootprintView;
@end

@implementation ZYCommentFootprintCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    _oneFootprintView=[[ZYOneFootprintView alloc]initWithFrame:CGRectMake(20, 0, KSCREEN_W-35, 0.1)];
//    _oneFootprintView.backgroundColor=[UIColor orangeColor];
    _oneFootprintView.commentEnterType=enterCommentEdit;
    _oneFootprintView.canOpenText=NO;
    [self.contentView addSubview:_oneFootprintView];

}

-(void)setFootprintModel:(ZYFootprintListModel *)footprintModel
{
    _footprintModel=footprintModel;
    _oneFootprintView.footprintModel=footprintModel;
    footprintModel.cellHeight=_oneFootprintView.bottom+KEDGE_DISTANCE;
}



@end
