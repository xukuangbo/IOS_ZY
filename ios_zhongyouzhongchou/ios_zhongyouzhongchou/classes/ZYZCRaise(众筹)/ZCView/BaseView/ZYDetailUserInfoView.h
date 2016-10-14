//
//  ZYDetailUserInfoView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/10/9.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYDetailUserInfoView : UIView

//目的地
@property (weak, nonatomic) IBOutlet UIScrollView *destScroll;
@property (weak, nonatomic) IBOutlet UILabel *recommendLab;
@property (weak, nonatomic) IBOutlet UIView *faceBottomView;
@property (weak, nonatomic) IBOutlet UIImageView *faceImg;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *startDest;
@property (weak, nonatomic) IBOutlet UILabel *jobLab;
@property (weak, nonatomic) IBOutlet UILabel *baseInfoLab;
//兴趣标签
@property (weak, nonatomic) IBOutlet UIView *interestView;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *startDateLab;
@property (weak, nonatomic) IBOutlet UIImageView *progressImg;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *rateLab;
@property (weak, nonatomic) IBOutlet UILabel *leftDayLab;

@end
