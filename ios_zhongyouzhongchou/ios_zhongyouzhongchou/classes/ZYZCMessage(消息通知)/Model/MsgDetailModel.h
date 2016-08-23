//
//  MsgDetailModel.h
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/8/5.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgDetailModel : NSObject

@property (nonatomic, copy  ) NSString *topMsg;        //进一步操作的文字
@property (nonatomic, assign) NSInteger step;          //进度

//我发布
@property (nonatomic, assign) NSInteger pstatus;       //众筹状态
@property (nonatomic, copy  ) NSString *pfbTime;       //发布时间
@property (nonatomic, copy  ) NSString *pzcSuccessTime;//众筹成功时间
@property (nonatomic, copy  ) NSString *pSelLbtime;    //选择旅伴完成时间
@property (nonatomic, copy  ) NSString *pOutTime;      //旅行出发时间
@property (nonatomic, copy  ) NSString *pHbTime;       //兑现回报，侣伴确认时间
@property (nonatomic, copy  ) NSString *pUppzTime;     //上传凭证时间
@property (nonatomic, copy  ) NSString *pTxTime;       //提现时间


//一起游
@property (nonatomic, assign) NSInteger myStatus;      //一起游状态
@property (nonatomic, copy  ) NSString *pBmTime;       //报名时间
@property (nonatomic, copy  ) NSString *pYyTime;       //被邀约时间
@property (nonatomic, copy  ) NSString *pJgtime;       //确认同行/未同游时间
@property (nonatomic, copy  ) NSString *pEndTime;      //行程结束时间


//我的回报
//@property (nonatomic, copy  ) NSString *pBmTime;       //报名时间
//@property (nonatomic, copy  ) NSString *pJgtime;       //被邀约时间



@end
