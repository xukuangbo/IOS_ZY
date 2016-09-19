//
//  ZYfootprintListCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYfootprintListCell.h"

@interface ZYfootprintListCell ()
@property (nonatomic, strong) UIImageView *bgImage;
@end

@implementation ZYfootprintListCell

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
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    _bgImage=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, KSCREEN_W-2*KEDGE_DISTANCE, 1.0)];
    
}

-(void)setListModel:(ZYFootprintListModel *)listModel
{
    _listModel =listModel;
    
    NSString *imageName=[NSString stringWithFormat:@"background-%ld",listModel.cellType];
    _bgImage.image=KPULLIMG(imageName,5, 0, 5, 0);

}



@end
