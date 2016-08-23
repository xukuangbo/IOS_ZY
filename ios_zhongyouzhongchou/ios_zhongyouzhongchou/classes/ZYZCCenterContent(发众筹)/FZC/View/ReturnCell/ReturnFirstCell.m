//
//  ReturnFirstCell.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/23.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ReturnFirstCell.h"
#import "MoreFZCReturnTableView.h"
#import "UIView+GetSuperTableView.h"
@implementation ReturnFirstCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        ReturnCellBaseBGView *bgImageView = [ReturnCellBaseBGView viewWithRect:CGRectMake(KEDGE_DISTANCE, 0, KSCREEN_W - KEDGE_DISTANCE * 2, ReturnFirstCellRowHeight) title:@"支持5元" image:[UIImage imageNamed:@"btn_xs_one"] selectedImage:nil desc:ZYLocalizedString(@"support_one_yuan")];
        [self.contentView addSubview:bgImageView];
        bgImageView.index = 0;
        self.bgImageView = bgImageView;
        
        __weak typeof(&*self) weakSelf = self;
        
      
        _bgImageView.descLabelClickBlock = ^(){
            if (weakSelf.bgImageView.index == 0) {//第一个
                MoreFZCReturnTableView *tableView = ((MoreFZCReturnTableView *)weakSelf.getSuperTableView);
                //取到当前的row
                ReturnFirstCell *cell = (ReturnFirstCell *)weakSelf;
                NSIndexPath *indexPath = [tableView indexPathForCell:cell];
                
                BOOL isOpen = [tableView.openArray[indexPath.row] intValue];
                
                if (isOpen == NO) {
                    //这里要改变里面的内容
                    CGSize textSize = [ZYZCTool calculateStrByLineSpace:10 andString:ZYLocalizedString(@"support_one_yuan") andFont:BgDescLabelFont andMaxWidth:BgDescLabelWidth];
                    tableView.heightArray[indexPath.row] = @(textSize.height + 60);
                    tableView.openArray[indexPath.row] = @1;
                    
                }else
                {
                    tableView.heightArray[indexPath.row] = @(ReturnFirstCellRowHeight);
                    tableView.openArray[indexPath.row] = @0;
                }
                
                [tableView reloadData];
            }
        
        };
    }
    return self;
}


- (void)setOpen:(BOOL)open
{
    _open = open;
    
    if (open == YES) {
        //这里就是展开，改变所有东西的值
         NSString *support_one_yuan = ZYLocalizedString(@"support_one_yuan");
        CGSize textSize = [ZYZCTool calculateStrByLineSpace:10 andString:support_one_yuan andFont:BgDescLabelFont andMaxWidth:BgDescLabelWidth];
        self.bgImageView.height = textSize.height + 60;
//        NSLog(@"%@",NSStringFromCGSize(textSize));
        self.bgImageView.descLabel.numberOfLines = 0;
        self.bgImageView.descLabel.height = textSize.height;
        self.bgImageView.downButton.hidden = YES;
    }else{
        //第一高度
        CGFloat firstRowHeight = 0;
        CGSize firstSize = [ZYZCTool calculateStrByLineSpace:10 andString:ZYLocalizedString(@"support_one_yuan") andFont:BgDescLabelFont andMaxWidth:BgDescLabelWidth];
        if (firstSize.height <= 71) {
            firstRowHeight = firstSize.height + 60;
            self.bgImageView.descLabel.userInteractionEnabled = NO;
            self.bgImageView.descLabel.height = firstSize.height;
            self.bgImageView.downButton.hidden = YES;
        }else{
            firstRowHeight = ReturnFirstCellRowHeight;
            self.bgImageView.descLabel.height = 71;
            self.bgImageView.downButton.hidden = NO;
        }
        
        self.bgImageView.height = firstRowHeight;
        self.bgImageView.descLabel.numberOfLines = 3;
        self.bgImageView.downButton.bottom = self.bgImageView.descLabel.bottom;
    }

}

@end
