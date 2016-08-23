//
//  WriteTextView.m
//  hupoTravel
//
//  Created by mac on 16/2/11.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "WriteTextView.h"

@implementation WriteTextView


/**
 *  如何为文字添加一个占位的文字呢，我们可以使用画画的方法
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:16];
        //添加通知给自己,当文本发生改变的时候
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}


/**
 *  文字改变的时候调用的方法,对set方法进行setNeedsDisplay。可以即时反映，这是一种自定义控件的思想，还有copy属性的set方法要用copy
 */
- (void)textDidChange
{
    // 重绘（重新调用）
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    // setNeedsDisplay会在下一个消息循环时刻，调用drawRect:
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    
    //在这里进行一次判断,如果有文字，就不显示
    if (self.hasText) {
        return ;
    }
    
    //在这里添加文本属性
    //    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.placeholder];
    //创建一个属性字典
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = self.font;
    dic[NSForegroundColorAttributeName] = self.placeholderColor ? self.placeholderColor : [UIColor lightGrayColor];
    
    //画画的属性设置
    CGFloat drawX = 5;
    CGFloat drawY = 8;
    CGFloat drawW = rect.size.width - 2 * drawX;
    CGFloat drawH = rect.size.height - 2 * drawY;
    [self.placeholder drawInRect:CGRectMake(drawX, drawY, drawW, drawH) withAttributes:dic];
    
    
}


/**
 *  销毁的时候移除通知
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
