//
//  MVMoreGroupViewCell.m
//  qupai
//
//  Created by yly on 15/4/14.
//  Copyright (c) 2015年 duanqu. All rights reserved.
//

#import "QPMVMoreGroupViewCell.h"
#import "QPMVMoreViewCell.h"

@interface QPMVMoreGroupViewCell () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation QPMVMoreGroupViewCell{
    NSUInteger _scaleRow;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _tableView = [[UITableView alloc] initWithFrame:self.bounds];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"QPMVMoreViewCell" bundle:nil] forCellReuseIdentifier:@"QPMVMoreViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
     _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:_tableView];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    _tableView.frame = self.bounds;
}

- (void)setGroup:(QPMVMoreGroup *)group {
    _group = group;
    _scaleRow = INT_MAX;
    [_tableView reloadData];
}

- (void)cancelSelect {
    if (_scaleRow != INT_MAX) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_scaleRow inSection:0];
        [self tableView:_tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)checkReplay {
    if (_scaleRow != INT_MAX) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_scaleRow inSection:0];
        QPMVMoreViewCell *cell = (QPMVMoreViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        [_controller mvMoreViewCellPlay:cell];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QPMVMoreGroup *group = _group;
    if (nil == group) {
        return 60;
    }
    CGFloat space = 0;
    if (_scaleRow == [_group mvCount] - 1 && tableView.contentSize.height > CGRectGetHeight(_tableView.bounds) - ScreenWidth) {
        space = 100;
    }
    return _scaleRow == indexPath.row ? ScreenWidth + space : ScreenWidth / (640.0/230.0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    QPMVMoreGroup *group = _group;
    NSInteger count = group.mvCount;
    _offlineLabel.hidden = !(count == 0);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QPMVMoreGroup *group = _group;
    QPEffectMV *si = [group itemAtIndex:indexPath.row];
//    if (nil == si) {
//        MVMoreLoadMoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MVMoreLoadMoreViewCell"];
//        [cell.activity startAnimating];
//        [group loadNext:^(MVMoreGroup *group, NSError *error) {
//            if (!error) {
//                [_tableView reloadData];
//            }
//        }];
//        return cell;
//    }
    
    QPMVMoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QPMVMoreViewCell"];
    cell.effectMV = si;
    cell.delegate = _controller;
    cell.lineView.hidden = indexPath.row == group.mvCount-1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QPMVMoreViewCell *cell = (QPMVMoreViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (_scaleRow == indexPath.row) {
        _scaleRow = INT_MAX;
        [cell closeDetailView];
    }else{
        _scaleRow = indexPath.row;
        [cell showDetailView];
    }
    [tableView beginUpdates];
    [tableView endUpdates];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self updateMaskView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_group.mvs.count) {
        return;
    }
    [self updateMaskView];
}

- (void)updateMaskView {
    CGRect rect = [[UIScreen mainScreen] bounds];
    BOOL enable = YES;
    if (_scaleRow == INT_MAX) {
        _tableView.scrollEnabled = YES;
        enable = YES;
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_scaleRow inSection:0];
        QPMVMoreViewCell *cell = (QPMVMoreViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        rect = [window convertRect:cell.frame fromView:_tableView];
        rect.size.height = rect.size.width;
        _tableView.scrollEnabled = NO;
        enable = NO;
        [cell updateFrame];
        [_delegate mvMoreGroupScaleItem:cell.effectMV];
    }
    [_delegate mvMoreGroupViewCell:self maskViewFrame:rect enable:enable];
}

@end
