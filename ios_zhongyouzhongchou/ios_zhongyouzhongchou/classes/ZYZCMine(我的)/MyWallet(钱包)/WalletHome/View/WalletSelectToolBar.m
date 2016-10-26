//
//  WalletSelectToolBar.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletSelectToolBar.h"
@interface WalletSelectToolBar ()
@property (nonatomic, strong) UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *ktxBtn;
@property (weak, nonatomic) IBOutlet UIButton *ybjBtn;
- (IBAction)selectBtnAction:(UIButton *)sender;

//当前点击的按钮
@property (nonatomic, weak) UIButton *pressBtn;;
@end


@implementation WalletSelectToolBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _pressBtn = _ktxBtn;
    self.backgroundColor = [UIColor ZYZC_BgGrayColor];
    [_ktxBtn setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
    [_ybjBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
    _ktxBtn.tag = WalletSelectTypeKTX;
    _ybjBtn.tag = WalletSelectTypeYBJ;
    
    [self setUpLineView];
}


- (void)setUpLineView
{
    _lineView = [[UIView alloc] init];
    [self addSubview:_lineView];
    _lineView.backgroundColor = [UIColor ZYZC_MainColor];
    _lineView.size = CGSizeMake(KSCREEN_W / 2 - 2 * 20, 1);
    _lineView.top = self.bottom - 2;
    _lineView.left = 20;
    [_lineView setNeedsLayout];
//    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(KSCREEN_W / 2 - 2 * 20));
//        make.height.equalTo(@1);
//        make.centerX.equalTo(self.mas_centerX).multipliedBy(0.5);
//        make.bottom.equalTo(self.mas_bottom).offset(-2);
//    }];
}

#pragma mark ---选择点击动作
- (IBAction)selectBtnAction:(UIButton *)sender {
    //重复点击
    if (sender.tag == _pressBtn.tag) {
        return ;
    }
    
    if (_pressBtn&&_pressBtn!=sender) {
        
        //改颜色
        [_pressBtn setTitleColor:[UIColor ZYZC_TextGrayColor] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
        _pressBtn=sender;
        
        if (_selectBlock) {
            _selectBlock(sender.tag);
        }
        
        
        
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            _lineView.centerX = sender.centerX;
            
        } completion:nil];
        
    }
    
}

@end
