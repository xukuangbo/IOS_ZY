//
//  GoalSecondCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "MoreFZCBaseTableViewCell.h"
#import "ZYZCCustomTextField.h"
#define SECONDCELLHEIGHT 65+175*KCOFFICIEMNT

@interface GoalSecondCell : MoreFZCBaseTableViewCell<ZYZCCustomTextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImageView *frameImg;
@property (nonatomic, strong) ZYZCCustomTextField *textField;

@end
