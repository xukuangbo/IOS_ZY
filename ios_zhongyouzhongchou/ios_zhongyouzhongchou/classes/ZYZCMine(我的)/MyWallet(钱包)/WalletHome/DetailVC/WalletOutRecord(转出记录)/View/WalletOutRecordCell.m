//
//  WalletOutRecordCell.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/11/10.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WalletOutRecordCell.h"
#import "WalletOutRecordModel.h"
@interface WalletOutRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end
@implementation WalletOutRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _sourceLabel.font = [UIFont systemFontOfSize:17];
    _sourceLabel.textColor = [UIColor ZYZC_titleBlackColor];
    
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor ZYZC_TextGrayColor04];
    
    _moneyLabel.font = [UIFont systemFontOfSize:20];
    _moneyLabel.textColor = [UIColor ZYZC_titleBlackColor];
}


- (void)setModel:(WalletOutRecordModel *)model{
    _model = model;
    
    //来源
    if ([model.toWhere isEqualToString:@"wechat"]) {
        
        _sourceLabel.text = [NSString stringWithFormat:@"微信钱包"];
    }else if([model.toWhere isEqualToString:@"alipay"]) {
        _sourceLabel.text = [NSString stringWithFormat:@"支付宝"];
    }else{
        _sourceLabel.text = [NSString stringWithFormat:@"未知"];
    }
    
    //时间(状态判断)
    if (model.status == 0) {//待打款
        _timeLabel.text = @"72小时内到指定账户";
    }else if (model.status == 1){//已打款
        if (model.paymentTime.length > 0) {
            _timeLabel.text = model.paymentTime;
        }else{
            _timeLabel.text = @"未知";
        }
    }
    
    
    //转出金额
    if (model.amount > 0) {
        _moneyLabel.text = [NSString stringWithFormat:@"%.2f",(CGFloat)(model.amount / 100)];
    }else{
        _moneyLabel.text = @"¥0.00";
    }
}
@end
