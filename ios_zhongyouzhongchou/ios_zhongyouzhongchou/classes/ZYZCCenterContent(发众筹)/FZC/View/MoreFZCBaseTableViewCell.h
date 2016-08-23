//
//  MoreFZCBaseTableViewCell.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MoreFZCBaseTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *bgImg;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIView *topLineView;
/**
 *  将视图创建在此方法中
 */
-(void)configUI;
/**
 *  创建下面带有一条灰线的Lab
 *
 */
-(UILabel *)createLabAndUnderlineWithFrame:(CGRect )frame andTitle:(NSString *)title;
@end
