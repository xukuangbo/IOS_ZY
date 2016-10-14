//
//  detailGuideView.h
//  Pods
//
//  Created by patty on 15/12/15.
//
//

#import <UIKit/UIKit.h>
#import "ZYNewGuiView.h"
//typedef enum : NSUInteger {
//    commonType,//居右
//    leftType,//居左
//    centerType,
//    rightType,
//    brushType,
//    DodoodleType,
//    cleanDoodleType,
//    openFlashType,
//    flashLessonType,
//} AlignmentType;


@interface ZYDetailGuideView : UIView

@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIButton *seeButton;

- (void)createDetailWithAlignmentType:(detailType)alignmentType; // 引导页

@end
