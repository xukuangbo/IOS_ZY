//
//  ZYLimitTextBaseView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/10/19.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZYBaseLimitTextView.h"

@interface ZYBaseLimitTextView ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel   *placeHolderLab;

@property (nonatomic, assign) NSInteger maxTextNum;//最大文字字数

@end

@implementation ZYBaseLimitTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame andMaxTextNum:(NSInteger)maxNum
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor=[UIColor ZYZC_MainColor];
        self.textColor=[UIColor ZYZC_TextBlackColor];
        self.showsVerticalScrollIndicator=NO;
        _maxTextNum = maxNum;
        self.delegate=self;
    }
    return self;
}

- (instancetype)initWithMaxTextNum:(NSInteger)maxNum
{
    self = [super init];
    if (self) {
        self.tintColor=[UIColor ZYZC_MainColor];
        self.textColor=[UIColor ZYZC_TextBlackColor];
        self.showsVerticalScrollIndicator=NO;
        _maxTextNum = maxNum;
        self.delegate=self;
    }
    return self;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (_placeHolderLab) {
        _placeHolderLab.hidden=YES;
    }
    return YES;
}

-(BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    textView.text=[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    BOOL isEmptyStr=[ZYZCTool isEmpty:textView.text];
    if (_placeHolderLab) {
         _placeHolderLab.hidden=!isEmptyStr;
    }
    return YES;
}

-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < _maxTextNum) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = _maxTextNum - comcatstr.length;
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                     if (idx >= rg.length) {
                         *stop = YES; //取出所需要就break，提高效率
                         return ;
                     }
                     
                     trimString = [trimString stringByAppendingString:substring];
                     
                     idx++;
                    }];
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
//            //既然是超出部分截取了，那一定是最大限制了。
            if (_textChangeBlock) {
                _textChangeBlock(0);
            }
        }
        return NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > _maxTextNum)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:_maxTextNum];
        
        [textView setText:s];
    }
    //不让显示负数 口口日
    if (_textChangeBlock) {
        _textChangeBlock(MAX(0,_maxTextNum - existTextNum));
    }
}

- (void) setPlaceholder:(NSString *)placeholder
{
    _placeholder=placeholder;
    self.placeHolderLab.text=placeholder;
}

-(UILabel *)placeHolderLab
{
    if (!_placeHolderLab) {
        _placeHolderLab =[[UILabel alloc]initWithFrame:CGRectMake(5, 8, self.width-5, 20)];
        _placeHolderLab.font=self.font;
        _placeHolderLab.textColor=[UIColor ZYZC_TextGrayColor01];
        [self addSubview:_placeHolderLab];
    }
    return _placeHolderLab;
}

@end
