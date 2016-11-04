//
//  WalletYbjSelectXcCell.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/11/2.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletYbjSelectXcCell.h"
#import "Masonry.h"
#import "WalletProductView.h"
@implementation WalletYbjSelectXcCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor ZYZC_BgGrayColor];
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews{
    
    _productView = [[[NSBundle mainBundle] loadNibNamed:@"WalletProductView" owner:nil options:nil] lastObject];
    [self.contentView addSubview:_productView];
    
    [_productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom);
    }];
}



@end
