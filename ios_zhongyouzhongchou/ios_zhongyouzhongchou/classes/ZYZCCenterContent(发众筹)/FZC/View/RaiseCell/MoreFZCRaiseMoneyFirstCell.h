//
//  MoreFZCRaiseMoneyFirstCell.h
//  ios_zhongyouzhongchou

#import "MoreFZCBaseTableViewCell.h"
#import "RaiseMoneyFirstModel.h"
#import "ZYZCCustomTextField.h"
#define kRaiseMoneyRealHeight 120

typedef void (^ChangeHeightBlock)(BOOL open);


@interface MoreFZCRaiseMoneyFirstCell : MoreFZCBaseTableViewCell<ZYZCCustomTextFieldDelegate>
/**
 *  明细按钮
 */
@property (nonatomic, weak) UIButton *openButton;
/**
 *  背景白图
 */
@property (nonatomic, weak) UIImageView *bgView;
/**
 *  添加明细的界面
 */
@property (nonatomic, weak) UIView *detailView;

/**
 *  money输入框
 */
@property (nonatomic, weak) ZYZCCustomTextField *moneyTextfiled;

//4个输入框的数据
@property (nonatomic, weak) ZYZCCustomTextField *sightTextfiled;
@property (nonatomic, weak) ZYZCCustomTextField *transportTextfiled;
@property (nonatomic, weak) ZYZCCustomTextField *liveTextfiled;
@property (nonatomic, weak) ZYZCCustomTextField *eatTextfiled;

@property (nonatomic, copy) ChangeHeightBlock changeHeightBlock;

@property (nonatomic, assign) BOOL open;

@end
