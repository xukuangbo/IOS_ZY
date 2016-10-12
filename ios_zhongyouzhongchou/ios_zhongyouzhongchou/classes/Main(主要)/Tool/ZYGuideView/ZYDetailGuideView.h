//
//  detailGuideView.h
//  Pods
//
//  Created by patty on 15/12/15.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    commonType,//居右
    leftType,//居左
    centerType,
    rightType,
    brushType,
    DodoodleType,
    cleanDoodleType,
    openFlashType,
    flashLessonType,
} AlignmentType;


@interface ZYDetailGuideView : UIView

@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIButton *seeButton;

- (void)createDetailTitle:(NSString *)title withAlignmentType:(AlignmentType)alignmentType;//学生端
- (void)createTeacherGuideTitle:(NSString *)title withAlignmentType:(AlignmentType)alignmentType;//老师端


@end
