//
//  ZYCustomIconView.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/7/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^FinishChoose)(UIImage *iocnImg);
typedef void (^UploadToOSSResult)(BOOL result,NSString *imgUrl);
@interface ZYCustomIconView : UIImageView

@property (nonatomic, strong) NSString     *userId;
@property (nonatomic, copy  ) FinishChoose finishChoose;
/**
 *  上传头像到oss
 *
 *  @param image 头像数据
 *
 *  @return 是否上传成功
 */
-(void)uploadImageToOSS:(UIImage *)image andResult:(UploadToOSSResult)uploadToOSSResult;


@end
