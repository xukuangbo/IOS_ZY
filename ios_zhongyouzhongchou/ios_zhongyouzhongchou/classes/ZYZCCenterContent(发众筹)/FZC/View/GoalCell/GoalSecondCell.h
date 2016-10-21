//
//  GoalSecondCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCBaseTableViewCell.h"
//#import "ZYZCCustomTextField.h"
#import "ZYBaseLimitTextField.h"
#define SECONDCELLHEIGHT 65+175*KCOFFICIEMNT

@interface GoalSecondCell : MoreFZCBaseTableViewCell<ZYBaseLimitTextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImageView *frameImg;
@property (nonatomic, strong) ZYBaseLimitTextField *textField;

@end
