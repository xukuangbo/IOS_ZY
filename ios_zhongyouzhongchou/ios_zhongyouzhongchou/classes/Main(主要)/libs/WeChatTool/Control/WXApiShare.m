//
//  WXApiShare.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WXApiShare.h"

@implementation WXApiShare

+(void)shareScene:(BOOL )zoneScene  withTitle:(NSString *)title andDesc:(NSString *)description andThumbImage:(NSString *)thumbImage andWebUrl:(NSString *)webUrl
{
    WXMediaMessage *message=[WXMediaMessage message];
    message.title=title;
    message.description=description;
    //图片不能大于32k
    if (!thumbImage) {
        [message setThumbImage:[UIImage imageNamed:@"Share_iocn"]];
        WXWebpageObject *webpageObject=[WXWebpageObject object];
        webpageObject.webpageUrl=webUrl;
        message.mediaObject=webpageObject;
        SendMessageToWXReq *req=[[SendMessageToWXReq alloc]init];
        req.bText=NO;
        req.message=message;
        req.scene=zoneScene?WXSceneTimeline:WXSceneSession;
        [WXApi sendReq:req];
    }
    else{
        if ([thumbImage hasSuffix:@"/0"]) {
            thumbImage=[thumbImage stringByReplacingCharactersInRange:NSMakeRange(thumbImage.length-2, 2) withString:@"/132"];
            DDLog(@"thumbImage:%@",thumbImage);
        }
        
        NSData *imgData=[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbImage]];
        UIImage *image=[UIImage imageWithData:imgData];
        [message setThumbImage:[self compressImage:image]];
        WXWebpageObject *webpageObject=[WXWebpageObject object];
        webpageObject.webpageUrl=webUrl;
        message.mediaObject=webpageObject;
        SendMessageToWXReq *req=[[SendMessageToWXReq alloc]init];
        req.bText=NO;
        req.message=message;
        req.scene=zoneScene?WXSceneTimeline:WXSceneSession;
        [WXApi sendReq:req];
        
//        UIImageView *iconImg=[[UIImageView alloc]init];
//        [iconImg sd_setImageWithURL:[NSURL URLWithString:thumbImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
////            [message setThumbData:[self compressImage:image]];
//            [message setThumbImage:[self compressImage:image]];
//            WXWebpageObject *webpageObject=[WXWebpageObject object];
//            webpageObject.webpageUrl=webUrl;
//            message.mediaObject=webpageObject;
//            SendMessageToWXReq *req=[[SendMessageToWXReq alloc]init];
//            req.bText=NO;
//            req.message=message;
//            req.scene=zoneScene?WXSceneTimeline:WXSceneSession;
//            [WXApi sendReq:req];
//        }];
    }
}

#pragma mark --- 压缩image
+(UIImage *)compressImage:(UIImage *)image
{
    NSInteger maxLength=20*1024;
    NSData *imgData=nil;
    imgData=UIImageJPEGRepresentation(image, 1.0);
//    NSLog(@"oldImgData:%ld",imgData.length);
    float scale=(float)maxLength/(float)imgData.length;
    imgData=UIImageJPEGRepresentation(image, MIN(1.0, scale));
//    NSLog(@"newImgData:%ld",imgData.length);
    if (imgData.length>32*1024&&!imgData) {
        return [UIImage imageNamed:@"Share_iocn"];
    }
    else
    {
        return  [UIImage imageWithData:imgData];
    }
}

@end























