//
//  WriteTextView.h
//  hupoTravel
//
//  Created by mac on 16/2/11.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteTextView : UITextView

/**
 *  占位文字
 */
@property (nonatomic, copy) NSString *placeholder;
/**
 *  占位颜色
 */
@property (strong, nonatomic) UIColor *placeholderColor;
@end
