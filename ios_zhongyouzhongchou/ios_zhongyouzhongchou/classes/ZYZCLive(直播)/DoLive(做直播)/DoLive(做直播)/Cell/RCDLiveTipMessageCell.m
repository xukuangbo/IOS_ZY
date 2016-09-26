//
//  RCDLiveTipMessageCell.m
//  RongIMKit
//
//  Created by xugang on 15/1/29.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDLiveTipMessageCell.h"
#import "RCDLiveTipLabel.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveKitCommonDefine.h"
#import "RCDLiveGiftMessage.h"
@interface RCDLiveTipMessageCell ()<RCDLiveAttributedLabelDelegate>
@end

@implementation RCDLiveTipMessageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tipMessageLabel = [RCDLiveTipLabel greyTipLabel];
        self.tipMessageLabel.textAlignment = NSTextAlignmentLeft;
//        self.tipMessageLabel.delegate = self;
        self.tipMessageLabel.userInteractionEnabled = YES;
        [self.baseContentView addSubview:self.tipMessageLabel];
        self.tipMessageLabel.font = [UIFont systemFontOfSize:12.f];;
//        self.tipMessageLabel.marginInsets = UIEdgeInsetsMake(0.5f, 0.5f, 0.5f, 0.5f);
        self.tipMessageLabel.marginInsets = UIEdgeInsetsMake(0.5f, 5.0f, 0.5f, 0.5f);
    }
    return self;
}

- (void)setDataModel:(RCDLiveMessageModel *)model {
    [super setDataModel:model];
    RCMessageContent *content = model.content;
    RCDLiveGiftMessage *notification = (RCDLiveGiftMessage *)content;
    NSString *localizedMessage = @"送了一个钻戒";
    if ([content isMemberOfClass:[RCDLiveGiftMessage class]]) {
        if(notification && [notification.type isEqualToString:@"1"]){
            localizedMessage = @"为直播点了赞";
            return;
        }
    }
    if ([content isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *notification = (RCInformationNotificationMessage *)content;
        NSString *localizedMessage = [RCDLiveKitUtility formatMessage:notification];
        self.tipMessageLabel.text = localizedMessage;
        self.tipMessageLabel.textColor = RCDLive_HEXCOLOR(0xffb83c);
        self.tipMessageLabel.backgroundColor = [UIColor colorWithRed:104 / 256.0 green:111 / 256.0 blue:229 / 256.0 alpha:1];

    }else if ([content isMemberOfClass:[RCTextMessage class]]){
        RCTextMessage *notification = (RCTextMessage *)content;
        NSString *localizedMessage = [RCDLiveKitUtility formatMessage:notification];
        NSString *name;
        if (content.senderUserInfo) {
            name = [NSString stringWithFormat:@"%@:",content.senderUserInfo.name];
        }
        NSString *str =[NSString stringWithFormat:@"%@ %@",name,localizedMessage];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:(RCDLive_HEXCOLOR(0x3ceff)) range:[str rangeOfString:name]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:([UIColor whiteColor]) range:[str rangeOfString:localizedMessage]];
        self.tipMessageLabel.attributedText = attributedString.copy;
        
        self.tipMessageLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        //判断是否是打赏还是进入直播
        if ([notification.extra isEqualToString:kPaySucceed]) {
            self.tipMessageLabel.backgroundColor = [UIColor redColor];
            self.tipMessageLabel.text = [NSString stringWithFormat:@"%@ %@",name,localizedMessage];
            self.tipMessageLabel.textColor = [UIColor whiteColor];
        }
    }else if ([content isMemberOfClass:[RCDLiveGiftMessage class]]){
        RCDLiveGiftMessage *notification = (RCDLiveGiftMessage *)content;
        NSString *name;
        if (content.senderUserInfo) {
            name = [ZYZCAccountTool account].realName;
        }
        NSString *localizedMessage = @"送了一个钻戒";
        if(notification && [notification.type isEqualToString:@"1"]){
          localizedMessage = @"为主播点了赞";
        }
        
        NSString *str =[NSString stringWithFormat:@"%@ %@",name,localizedMessage];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:(RCDLive_HEXCOLOR(0x3ceff)) range:[str rangeOfString:name]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:(RCDLive_HEXCOLOR(0xf719ff)) range:[str rangeOfString:localizedMessage]];
        self.tipMessageLabel.attributedText = attributedString.copy;
        
        self.tipMessageLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
    }

    NSString *__text = self.tipMessageLabel.text;
    CGSize __labelSize = [RCDLiveTipMessageCell getTipMessageCellSize:__text];
    
    //设置圆角
    self.tipMessageLabel.layer.cornerRadius = __labelSize.height * 0.5;
    self.tipMessageLabel.layer.masksToBounds = YES;

    if (_isFullScreenMode) {
        self.tipMessageLabel.frame = CGRectMake(6,0, __labelSize.width, __labelSize.height);
//        self.tipMessageLabel.backgroundColor = RCDLive_HEXCOLOR(0x000000);
//        self.tipMessageLabel.alpha = 0.5;

    }else{
        self.tipMessageLabel.frame = CGRectMake((self.baseContentView.bounds.size.width - __labelSize.width) / 2.0f,0, __labelSize.width, __labelSize.height);
//        self.tipMessageLabel.backgroundColor = RCDLive_HEXCOLOR(0xBBBBBB);
//        self.tipMessageLabel.alpha = 1;
    }
    
}



- (void)attributedLabel:(RCDLiveAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSString *urlString=[url absoluteString];
    if (![urlString hasPrefix:@"http"]) {
        urlString = [@"http://" stringByAppendingString:urlString];
    }
    if ([self.delegate respondsToSelector:@selector(didTapUrlInMessageCell:model:)]) {
        [self.delegate didTapUrlInMessageCell:urlString model:self.model];
        return;
    }
}

/**
 Tells the delegate that the user did select a link to an address.
 
 @param label The label whose link was selected.
 @param addressComponents The components of the address for the selected link.
 */
- (void)attributedLabel:(RCDLiveAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
    
}

/**
 Tells the delegate that the user did select a link to a phone number.
 
 @param label The label whose link was selected.
 @param phoneNumber The phone number for the selected link.
 */
- (void)attributedLabel:(RCDLiveAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    NSString *number = [@"tel://" stringByAppendingString:phoneNumber];
    if ([self.delegate respondsToSelector:@selector(didTapPhoneNumberInMessageCell:model:)]) {
        [self.delegate didTapPhoneNumberInMessageCell:number model:self.model];
        return;
    }
}

-(void)attributedLabel:(RCDLiveAttributedLabel *)label didTapLabel:(NSString *)content
{
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

+ (CGSize)getTipMessageCellSize:(NSString *)content{
    CGFloat maxMessageLabelWidth = 220;
    CGSize __textSize = CGSizeZero;
    if (RCDLive_IOS_FSystenVersion < 7.0) {
        __textSize = RCDLive_RC_MULTILINE_TEXTSIZE_LIOS7(content, [UIFont systemFontOfSize:12.0f], CGSizeMake(maxMessageLabelWidth, MAXFLOAT), NSLineBreakByTruncatingTail);
    }else {
        __textSize = RCDLive_RC_MULTILINE_TEXTSIZE_GEIOS7(content, [UIFont systemFontOfSize:12.0f], CGSizeMake(maxMessageLabelWidth, MAXFLOAT));
    }
    //这里是将文本的cell往外扩张了点内容
//    __textSize = CGSizeMake(ceilf(__textSize.width)+10 , ceilf(__textSize.height)+6);    return __textSize;
    __textSize = CGSizeMake(ceilf(__textSize.width)+16 , ceilf(__textSize.height)+6);    return __textSize;
}
@end
