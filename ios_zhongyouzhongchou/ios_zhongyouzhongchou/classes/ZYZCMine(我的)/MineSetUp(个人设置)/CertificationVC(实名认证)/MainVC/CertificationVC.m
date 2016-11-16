//
//  CertificationVC.m
//  ios_zhongyouzhongchou
//
//  Created by syk on 16/11/16.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "CertificationVC.h"

@interface CertificationVC ()
@property (weak, nonatomic) IBOutlet UIImageView *Bg1;
@property (weak, nonatomic) IBOutlet UIImageView *Bg2;
@property (weak, nonatomic) IBOutlet UIImageView *Bg3;
@property (weak, nonatomic) IBOutlet UIView *upLoadImage;

//协议三件套
@property (weak, nonatomic) IBOutlet UIView *xieyiSelectView;
@property (weak, nonatomic) IBOutlet UILabel *xieyiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *xieyiImageView;
//是否确认协议
@property (nonatomic, assign) BOOL isSelectXieyi;
@end

@implementation CertificationVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _Bg1.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    _Bg2.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    _Bg3.image = KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    
    _xieyiImageView.image = [UIImage imageNamed:@"shiming_yes_select"];
    _isSelectXieyi = YES;
    
    [_upLoadImage addTarget:self action:@selector(upLoadImageAction)];
    [_xieyiSelectView addTarget:self action:@selector(xieyiSelectAction)];
    
    //更改协议的文字颜色
    _xieyiLabel.attributedText = [self changeXieYiTextFontAndColorByString:_xieyiLabel.text];
}

#pragma mark - 自定义方法
- (NSMutableAttributedString *)changeXieYiTextFontAndColorByString:(NSString *)str{
    NSMutableAttributedString *attrStr=[[NSMutableAttributedString alloc]initWithString:str];
    if (str.length) {
        NSRange range1 = [str rangeOfString:@"同意"];
        NSRange range2 = NSMakeRange(range1.location + range1.length, str.length - range1.length - range1.location);
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor ZYZC_titleBlackColor] range:range1];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor ZYZC_MainColor] range:range2];
    }
    return  attrStr;
}


#pragma mark - 点击动作
- (void)upLoadImageAction{
    DDLog(@"上传到图片");
}

- (void)xieyiSelectAction{
    DDLog(@"点击了协议");
    
    _isSelectXieyi = !_isSelectXieyi;
    
    
}
@end
