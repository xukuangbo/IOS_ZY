//
//  WalletSelectToolBar.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/10/21.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletSelectToolBar.h"
#import "Masonry.h"
@interface WalletSelectToolBar ()
//@property (nonatomic, strong) UIButton  *ktxBtn;//可提现
//@property (nonatomic, strong) UIButton  *ybjBtn;      //预备金
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
    _ktxBtn.backgroundColor = [UIColor yellowColor];
    _pressBtn = _ktxBtn;
    _ktxBtn.tag = WalletSelectTypeKTX;
    _ybjBtn.tag = WalletSelectTypeYBJ;
}





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
        
        //移动下划线
    }
    
}

@end
