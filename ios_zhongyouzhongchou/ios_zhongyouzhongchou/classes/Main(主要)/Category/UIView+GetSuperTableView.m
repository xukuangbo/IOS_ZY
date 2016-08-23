//
//  UIView+GetSuperTableView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/28.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "UIView+GetSuperTableView.h"

@implementation UIView (GetSuperTableView)

-(UITableView *)getSuperTableView{
    UIResponder *next = self.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass:[UITableView class]]) {
            
            return (UITableView *)next;
        }
        
        next = next.nextResponder;
    }
    return nil;
}
@end
