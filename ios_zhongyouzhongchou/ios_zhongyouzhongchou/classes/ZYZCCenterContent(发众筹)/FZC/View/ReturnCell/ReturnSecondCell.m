//
//  ReturnSecondCell.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ReturnSecondCell.h"
#import "MoreFZCReturnTableView.h"
#import "UIView+GetSuperTableView.h"

@implementation ReturnSecondCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
//        //低二高度
//        CGFloat secondRowHeight = 0;
//        CGSize secondSize = [ZYZCTool calculateStrByLineSpace:10 andString:ZYLocalizedString(@"supoort_any_yuan") andFont:BgDescLabelFont andMaxWidth:BgDescLabelWidth];
//        if (secondSize.height + 60 <= ReturnSecondCellRowHeight) {
//            secondRowHeight = secondSize.height + 60;
//            self.bgImageView.descLabel.height = secondSize.height;
//            self.bgImageView.downButton.hidden = YES;
//        }else{
//            secondRowHeight = ReturnSecondCellRowHeight;
//            self.bgImageView.descLabel.height = 71;
//        }
//        
        ReturnCellBaseBGView *bgImageView = [ReturnCellBaseBGView viewWithRect:CGRectMake(10, 0, KSCREEN_W - 20, ReturnSecondCellRowHeight) title:@"支持任意金额" image:[UIImage imageNamed:@"btn_xs_one"] selectedImage:nil desc:ZYLocalizedString(@"supoort_any_yuan")];
        [self.contentView addSubview:bgImageView];
        bgImageView.index = 1;
        self.bgImageView = bgImageView;
        
        __weak typeof(&*self) weakSelf = self;
        
        _bgImageView.descLabelClickBlock = ^(){
            if (weakSelf.bgImageView.index == 1) {//第一个
                MoreFZCReturnTableView *tableView = ((MoreFZCReturnTableView *)weakSelf.getSuperTableView);
                //取到当前的row
                ReturnSecondCell *cell = (ReturnSecondCell *)weakSelf;
                NSIndexPath *indexPath = [tableView indexPathForCell:cell];
                
                BOOL isOpen = [tableView.openArray[indexPath.row] intValue];
                
                if (isOpen == NO) {
                    //这里要改变里面的内容
                    CGSize textSize = [ZYZCTool calculateStrByLineSpace:10 andString:ZYLocalizedString(@"supoort_any_yuan") andFont:BgDescLabelFont andMaxWidth:BgDescLabelWidth];
                    tableView.heightArray[indexPath.row] = @(textSize.height + 60);
                    tableView.openArray[indexPath.row] = @1;
                    
                }else
                {
                    tableView.heightArray[indexPath.row] = @(ReturnSecondCellRowHeight);
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
            NSString *support_any_yuan = ZYLocalizedString(@"supoort_any_yuan");
            CGSize textSize = [ZYZCTool calculateStrByLineSpace:10 andString:support_any_yuan andFont:BgDescLabelFont andMaxWidth:BgDescLabelWidth];
            self.bgImageView.height = textSize.height + 60;
//            NSLog(@"%@",NSStringFromCGSize(textSize));
            self.bgImageView.descLabel.numberOfLines = 0;
            self.bgImageView.descLabel.height = textSize.height;
            self.bgImageView.downButton.hidden = YES;
        }else{
            
            //低二高度
            CGFloat secondRowHeight = 0;
            CGSize secondSize = [ZYZCTool calculateStrByLineSpace:10 andString:ZYLocalizedString(@"supoort_any_yuan") andFont:BgDescLabelFont andMaxWidth:BgDescLabelWidth];
            if (secondSize.height <= 71) {
                secondRowHeight = secondSize.height + 60;
                self.bgImageView.descLabel.userInteractionEnabled = NO;
                self.bgImageView.descLabel.height = secondSize.height;
                self.bgImageView.downButton.hidden = YES;
            }else{
                secondRowHeight = ReturnSecondCellRowHeight;
                self.bgImageView.descLabel.height = 71;
                self.bgImageView.downButton.hidden = NO;
            }
            
            self.bgImageView.height = secondRowHeight;
            self.bgImageView.descLabel.numberOfLines = 3;
            self.bgImageView.downButton.bottom = self.bgImageView.descLabel.bottom;
        }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    
    
}

@end
