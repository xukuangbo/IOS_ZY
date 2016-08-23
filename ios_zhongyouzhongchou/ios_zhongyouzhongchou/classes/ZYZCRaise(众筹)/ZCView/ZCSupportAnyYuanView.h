//
//  ZCSupportAnyYuanView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCSupportBaseView.h"
#import "ZYZCCustomTextField.h"
@interface ZCSupportAnyYuanView : ZCSupportBaseView<ZYZCCustomTextFieldDelegate>
@property (nonatomic, strong) ZYZCCustomTextField *textField;
@end
