//
//  MoreFZCReturnTableView.m
//  ios_zhongyouzhongchou
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCReturnTableView.h"
#import "ReturnFirstCell.h"
#import "ReturnSecondCell.h"
#import "ReturnThirdCell.h"
//#import "ReturnThirdCellTwo.h"
#import "ReturnFourthCell.h"
#import "MoreFZCViewController.h"
@interface MoreFZCReturnTableView ()
@property (nonatomic, weak) UITextField *editingTextField;
@end

@implementation MoreFZCReturnTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource =self;
        self.delegate  = self;
        self.backgroundColor = [UIColor ZYZC_BgGrayColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (NSMutableArray *)openArray
{
    if (!_openArray) {
        _openArray = [NSMutableArray arrayWithArray:@[@0,@0,@0,@0,@0,@0,@0,@0]];
    }
    return _openArray;
}

/**
 *  初始化数组高度
 */
- (NSArray *)heightArray
{
    if (!_heightArray) {
        
        //第一高度
        CGFloat firstRowHeight = 0;
        CGSize firstSize = [ZYZCTool calculateStrByLineSpace:10 andString:ZYLocalizedString(@"support_one_yuan") andFont:BgDescLabelFont andMaxWidth:BgDescLabelWidth];
        if (firstSize.height + 60 <= ReturnFirstCellRowHeight) {
            firstRowHeight = firstSize.height + 60;
        }else{
            firstRowHeight = ReturnFirstCellRowHeight;
        }
        
        //第二行高度
        CGFloat secondRowHeight = 0;
        CGSize secondSize = [ZYZCTool calculateStrByLineSpace:10 andString:ZYLocalizedString(@"supoort_any_yuan") andFont:BgDescLabelFont andMaxWidth:BgDescLabelWidth];
        if (secondSize.height + 60 <= ReturnSecondCellRowHeight) {
            secondRowHeight = secondSize.height + 60;
        }else{
            secondRowHeight = ReturnSecondCellRowHeight;
        }
        
        //第三行高度
        CGFloat thirdRowHeight = 0;
        CGSize thirdSize = [ZYZCTool calculateStrByLineSpace:10 andString:ZYLocalizedString(@"support_return") andFont:BgDescLabelFont andMaxWidth:BgDescLabelWidth];
        if (thirdSize.height + (277 + CONTENTHEIGHT) <= ReturnThirdCellHeight) {
            thirdRowHeight = thirdSize.height + (277 + CONTENTHEIGHT);
        }else{
            thirdRowHeight = ReturnThirdCellHeight;
        }
        
        //第四行高度
        CGFloat fourthRowHeight = 0;
        CGSize fourthSize = [ZYZCTool calculateStrByLineSpace:10 andString:ZYLocalizedString(@"support_together") andFont:BgDescLabelFont andMaxWidth:BgDescLabelWidth];
        if (fourthSize.height + ReturnFourthCellHeight-60 <= ReturnFourthCellHeight) {
            fourthRowHeight = fourthSize.height + ReturnFourthCellHeight-60;
        }else{
            fourthRowHeight = ReturnFourthCellHeight;
        }
        
        _heightArray = [NSMutableArray arrayWithArray:@[@(fourthRowHeight),@10,@(thirdRowHeight),@10,@(firstRowHeight),@10,@(secondRowHeight),@10]];
    }
    return _heightArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.heightArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 7) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        return cell;
    }else if (indexPath.row == 0){
        ReturnFourthCell *cell = [self dequeueReusableCellWithIdentifier:@"ReturnFourthCell"];
        if (!cell) {
            cell = [[ReturnFourthCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReturnFourthCell"];
        }
        [cell reloadManagerData];
        cell.open = [self.openArray[indexPath.row] intValue];
        return cell;

    }else if(indexPath.row == 2){
        NSString *cellId=@"ReturnThirdCell";
        ReturnThirdCell *cell = [self dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[ReturnThirdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.open = [self.openArray[indexPath.row] intValue];
        [cell reloadManagerData];
        return cell;
        
    }else if(indexPath.row == 4){
        ReturnFirstCell *cell = [self dequeueReusableCellWithIdentifier:@"ReturnFirstCell"];
        if (!cell) {
            cell = [[ReturnFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReturnFirstCell"];
        }
        cell.open = [self.openArray[indexPath.row] intValue];
        return cell;
    }else{
        ReturnSecondCell *cell = [self dequeueReusableCellWithIdentifier:@"ReturnSecondCell"];
        if (!cell) {
            cell = [[ReturnSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReturnSecondCell"];
        }
        cell.open = [self.openArray[indexPath.row] intValue];
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.heightArray[indexPath.row] floatValue];
}


#pragma mark - textfildNoti
- (void)keyboardWillShow:(NSNotification *)noti {
    // 拿到正在编辑中的textfield
    [self getIsEditingView:self];
    // textfield在window中的位置
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGFloat viewY = [_editingTextField convertRect:_editingTextField.bounds toView:window].origin.y + _editingTextField.size.height;
    // 键盘的Y值
    NSDictionary *userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardEndY = value.CGRectValue.origin.y;
    if (keyboardEndY < viewY) {
        // 动画
        NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:duration.doubleValue animations:^{
            if (viewY > keyboardEndY) {
                CGRect rect = self.frame;
                rect.origin.y += keyboardEndY - (viewY);
                self.frame = rect;
            }
        }];
    }

}

- (void)keyboardWillHide:(NSNotification *)noti {
    CGRect rect = self.frame;
    rect.origin.y = 0;
    self.frame = rect;
}
/**
 *  获取正在编辑中的textfield
 */
- (void)getIsEditingView:(UIView *)rootView {
    for (UIView *subView in rootView.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            if (((UITextField *)subView).isEditing) {
                self.editingTextField = (UITextField *)subView;
                return;
            }
        }
        [self getIsEditingView:subView];
    }
}


@end
