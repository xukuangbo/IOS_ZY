//
//  WXApiShare.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/5/14.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "WXApiShare.h"
#import "FCIMChatGetImage.h"

#define kcMaxThumbnailSize 32*1024

@implementation WXApiShare

#pragma mark --- 分享网址
+(void)shareScene:(int)scene  withTitle:(NSString *)title andDesc:(NSString *)description andThumbImage:(NSString *)thumbImage andWebUrl:(NSString *)webUrl
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
        req.scene=scene;
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
        req.scene=scene;
        [WXApi sendReq:req];
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

#pragma mark ---分享视频
+(void)shareToWeChatWithScene:(int)scene  withTitle:(NSString *)title andDesc:(NSString *)description andThumbImage:(UIImage *)thumbImage andVideoUrl:(NSString *)videoUrl
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:[UIImage imageNamed:@"Share_iocn"]];
    WXVideoObject *videoObject = [WXVideoObject object];
    videoObject.videoUrl = videoUrl;
    videoObject.videoLowBandUrl = videoObject.videoUrl;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText=NO;
    req.message = message;
    req.scene =scene;
    [WXApi sendReq:req];
}


#pragma mark --- 压缩image
+ (UIImage *)compressImageUnder32K:(UIImage *)image
{
    if(!image)
    {
        return nil;
    }
    NSData *imgData=UIImageJPEGRepresentation(image, 1.0);
    DDLog(@"原图大小:%zd",imgData.length);
    //获取图片正确方向
    UIImage *rightImage = [FCIMChatGetImage rotateScreenImage:image];
    
    if (imgData.length>kcMaxThumbnailSize) {
        CGSize asize=CGSizeMake(rightImage.size.width*0.5, rightImage.size.height*0.5);
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        NSData * imageData = UIImageJPEGRepresentation(newimage,0.5);
        UIImage *compressImage = [UIImage imageWithData:imageData];
        DDLog(@"压缩后图片大小:%ld",imageData.length) ;
        return compressImage;
    }
    else
    {
        return image;
    }
}

@end























