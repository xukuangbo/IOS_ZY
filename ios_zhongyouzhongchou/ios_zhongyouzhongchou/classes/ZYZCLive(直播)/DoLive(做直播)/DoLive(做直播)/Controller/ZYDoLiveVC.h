//
//  ZYDoLiveVC.h
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/8/22.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYZCBaseViewController.h"
#import "RCDLiveInputBar.h"

@interface ZYDoLiveVC : ZYZCBaseViewController


#pragma mark - 直播需要的属性
@property (nonatomic, copy) NSString *pushUrl;
@property (nonatomic, copy) NSString *pullUrl;

@property (nonatomic, copy) NSString *chatRoomID;



#pragma mark - 聊天需要的属性
/*!
 当前会话的会话类型
 */
@property(nonatomic) RCConversationType conversationType;
/*!
 消息列表CollectionView和输入框都在这个view里
 */
@property(nonatomic, strong) UIView *contentView;
/*!
 输入工具栏
 */
@property(nonatomic,strong) RCDLiveInputBar *inputBar;
/*!
 聊天界面的CollectionView
 */
@property(nonatomic, strong) UIView *conversationMessageCollectionView;


@end
