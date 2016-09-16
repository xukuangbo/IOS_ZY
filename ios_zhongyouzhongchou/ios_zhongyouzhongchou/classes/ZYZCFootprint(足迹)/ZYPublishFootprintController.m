//
//  ZYPublishFootprintController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/9/8.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define PLACEHOLDER_TEXT  @"分享此刻的心情"
#define LOCATION_TEXT     @"显示当前位置"


#define PIC_HEIGHT     (KSCREEN_W-60)/3.0
#define BGIMAGE_HEIGHT PIC_HEIGHT*2+80

#import "ZYPublishFootprintController.h"
#import <objc/runtime.h>
#import "HUImagePickerViewController.h"
#import "HUPhotoBrowser.h"
#import "XMNPhotoPickerController.h"
#import "JudgeAuthorityTool.h"

@interface ZYPublishFootprintController ()<UITextViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIButton     *publishBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView  *bgImageView;
@property (nonatomic, strong) UITextView   *textView;//文字
@property (nonatomic, strong) UILabel      *placeHolderLab;

@property (nonatomic, strong) UIView       *contentView;//图片，视频。。。
@property (nonatomic, strong) UIView       *locationView;//显示位置
@property (nonatomic, strong) UIButton     *addBtn;
@property (nonatomic, strong) XMNPhotoPickerController *picker;
@property (nonatomic, strong) UIImageView  *locationIcon;
@property (nonatomic, strong) UILabel      *locationLab;
@property (nonatomic, assign) BOOL         showLocation;

@end

@implementation ZYPublishFootprintController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self configNavUI];
    [self configBodyUI];
    [self reloadImageData];
}

-(void)configNavUI
{
    //navUI
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_W, 64)];
    navView.backgroundColor=[UIColor ZYZC_BgGrayColor];
    [self.view addSubview:navView];
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 100, 44)];
    titleLab.text=@"添加足迹";
    titleLab.textColor=[UIColor ZYZC_TextBlackColor];
    titleLab.font=[UIFont systemFontOfSize:20];
    titleLab.centerX=navView.centerX;
    [navView addSubview:titleLab];
    
    //退出按钮
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(10, 20, 50, 44);
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [backBtn  addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    //发布按钮
    UIButton *publishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame=CGRectMake(KSCREEN_W-60, 20, 50, 44);
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
    publishBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [publishBtn addTarget:self action:@selector(publishMyFootprint) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:publishBtn];
    _publishBtn=publishBtn;
    
    UIView *lineView=[UIView lineViewWithFrame:CGRectMake(0, navView.height-0.5, KSCREEN_W, 0.5) andColor:[UIColor lightGrayColor]];
    [navView addSubview:lineView];
}

-(void)configBodyUI
{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, KSCREEN_W, KSCREEN_H-64)];
    _scrollView.contentSize=CGSizeMake(0, _scrollView.height+1);
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.backgroundColor=[UIColor ZYZC_BgGrayColor];
    _scrollView.delegate=self;
    [self.view addSubview:_scrollView];
    
    //卡片
    _bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, _scrollView.width-2*KEDGE_DISTANCE, BGIMAGE_HEIGHT)];
    _bgImageView.image=KPULLIMG(@"tab_bg_boss0", 5, 0, 5, 0);
    _bgImageView.userInteractionEnabled=YES;
    [_scrollView addSubview:_bgImageView];
    
    //文字框
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, KEDGE_DISTANCE, _bgImageView.width-2*KEDGE_DISTANCE, PIC_HEIGHT)];
//    _textView.backgroundColor=[UIColor greenColor];
    _textView.delegate=self;
    _textView.font=[UIFont systemFontOfSize:15];
    _textView.tintColor=[UIColor ZYZC_MainColor];
    _textView.textColor=[UIColor ZYZC_TextBlackColor];
    [_bgImageView addSubview:_textView];
    
    //占位文字
    _placeHolderLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, _textView.width-5, 20)];
    _placeHolderLab.text=PLACEHOLDER_TEXT;
     _placeHolderLab.font=[UIFont systemFontOfSize:15];
    _placeHolderLab.textColor= [UIColor ZYZC_TextGrayColor01];
    [_textView addSubview:_placeHolderLab];
    
    //放图片，视频的控件
    _contentView=[[UIView alloc]initWithFrame:CGRectMake(0,_textView.bottom+KEDGE_DISTANCE , _bgImageView.width, PIC_HEIGHT)];
//    _contentView.backgroundColor=[UIColor orangeColor];
    [_bgImageView addSubview:_contentView];
    
    //添加按钮
    _addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.frame=CGRectMake(KEDGE_DISTANCE, 0, PIC_HEIGHT, PIC_HEIGHT);
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"footprint-add"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addPic) forControlEvents:UIControlEventTouchUpInside];
    _addBtn.hidden=YES;
    [_contentView addSubview:_addBtn];
    
    //显示位置
    _locationView = [[UIView alloc]initWithFrame:CGRectMake(0, _contentView.bottom+KEDGE_DISTANCE,_bgImageView.width , 40)];
    [_bgImageView addSubview:_locationView];
    
    [_locationView addSubview:[UIView lineViewWithFrame:CGRectMake(0, 0, _locationView.width, 0.5) andColor:[UIColor lightGrayColor]]];
    
    UIImageView  *locationIcon=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, (_locationView.height-23)/2.0, 19, 23)];
    locationIcon.image=[UIImage imageNamed:@"footprint-coordinate-2"];
    [_locationView addSubview:locationIcon];
    _locationIcon=locationIcon;
    
    
    UILabel *locationLab=[[UILabel alloc]initWithFrame:CGRectMake(locationIcon.right+KEDGE_DISTANCE, 0, 200, _locationView.height)];
    locationLab.text=LOCATION_TEXT;
    locationLab.font=[UIFont systemFontOfSize:15];
    locationLab.textColor=[UIColor ZYZC_TextGrayColor01];
    [_locationView addSubview:locationLab];
    _locationLab=locationLab;
    
    UISwitch *locationSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(_locationView.width-60, (_locationView.height-30)/2, 50, 30)];
    locationSwitch.on=NO;
    [locationSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_locationView addSubview:locationSwitch];
    
    _showLocation=locationSwitch.on;
    
}

#pragma mark --- 是否显示当前位置
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        BOOL allowLocation=[JudgeAuthorityTool judgeLocationAuthority];
        if (allowLocation) {
            _locationIcon.image=[UIImage imageNamed:@"footprint-coordinate-2"];
            _locationLab.textColor=[UIColor ZYZC_MainColor];
        }
        else
        {
            switchButton.on=NO;
        }
    }else {
        _locationIcon.image=[UIImage imageNamed:@"footprint-coordinate-2"];
        _locationLab.textColor=[UIColor ZYZC_TextGrayColor01];
    }
    _showLocation=switchButton.on;
}


#pragma mark --- 加载图片
-(void)reloadImageData
{
    NSArray *views=[_contentView subviews];
    for (NSInteger i=views.count-1; i>=0; i-- ) {
        if ([views[i] isKindOfClass:[UIImageView class]]) {
            [views[i] removeFromSuperview];
        }
    }
    
    if (_images.count) {
        _addBtn.hidden=NO;
        NSInteger count=_images.count;
        CGFloat lastBottom=0.0;
        for (NSInteger i=0; i<count; i++) {
            UIImageView *pic= [[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE+(i%3)*(PIC_HEIGHT+KEDGE_DISTANCE), (i/3)*(PIC_HEIGHT+KEDGE_DISTANCE), PIC_HEIGHT, PIC_HEIGHT)];
            pic.image=_images[i];
            pic.tag=i;
            pic.contentMode=UIViewContentModeScaleAspectFill;
            pic.layer.masksToBounds=YES;
            lastBottom=pic.bottom;
            [pic addTarget:self action:@selector(tapPic:)];
            [_contentView addSubview:pic];
            
            if(i==count-1&&i<8)
            {
                _addBtn.frame=CGRectMake(KEDGE_DISTANCE+((i+1)%3)*(PIC_HEIGHT+KEDGE_DISTANCE), ((i+1)/3)*(PIC_HEIGHT+KEDGE_DISTANCE),PIC_HEIGHT,PIC_HEIGHT);
                lastBottom=_addBtn.bottom;
                _addBtn.hidden=NO;
            }
            
            if (i==8) {
                _addBtn.hidden=YES;
            }
        }
        _contentView.height=lastBottom;
    }
    else
    {
        _addBtn.hidden=NO;
        _contentView.height=PIC_HEIGHT;
        _addBtn.frame=CGRectMake(KEDGE_DISTANCE, 0, PIC_HEIGHT, PIC_HEIGHT);
    }
    
    _locationView.top= _contentView.bottom+KEDGE_DISTANCE;
    _bgImageView.height=_locationView.bottom+KEDGE_DISTANCE;
    _bgImageView.height=MAX(_bgImageView.height, BGIMAGE_HEIGHT);
}

#pragma mark --- 点击浏览和编辑图片
-(void)tapPic:(UITapGestureRecognizer *)tap
{
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
    }
    
    UIImageView *pic=(UIImageView *)tap.view;
    
    WEAKSELF;
    HUPhotoBrowser *browser=[HUPhotoBrowser showFromImageView:pic withImages:_images atIndex:pic.tag dismissWithImages:^(NSArray * _Nullable images) {
            weakSelf.images=images;
            [self reloadImageData];
        if(weakSelf.images.count==0)
        {
            weakSelf.publishBtn.enabled=NO;
            [weakSelf.publishBtn setTitleColor:[UIColor ZYZC_TextBlackColor] forState:UIControlStateNormal];
        }
        }];
    browser.notDismissWhenDelete=YES;
   
}

#pragma mark --- 添加图片
-(void)addPic
{
    _picker=nil;
    _picker = [[XMNPhotoPickerController alloc] initWithMaxCount:9-_images.count delegate:nil];
    _picker.pickingVideoEnable=NO;
    _picker.autoPushToPhotoCollection=YES;

    __weak typeof(self) weakSelf = self;
    // 选择图片后回调
    [_picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable asset) {
        
        [weakSelf.picker dismissViewControllerAnimated:NO completion:^{
            NSMutableArray *newImages=[NSMutableArray arrayWithArray:weakSelf.images];
            [newImages addObjectsFromArray:images];
            weakSelf.images=newImages;
            [weakSelf reloadImageData];
            if (weakSelf.images.count) {
                weakSelf.publishBtn.enabled=YES;
                  [weakSelf.publishBtn setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
            }
        }];
    }];
    
    //点击取消
    [_picker setDidCancelPickingBlock:^{
        [weakSelf.picker dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:_picker animated:YES completion:nil];
}


#pragma mark --- scrollView代理
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
    }
}

#pragma mark --- textView代理
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _placeHolderLab.hidden=YES;
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    textView.text=[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    BOOL isEmptyStr=[ZYZCTool isEmpty:textView.text];
    
    if (isEmptyStr) {
        _placeHolderLab.hidden=NO;
    }

    return YES;
}

#pragma mark --- 返回操作
-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---  发布足迹👣
-(void)publishMyFootprint
{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:
     UIStatusBarStyleDefault];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:
     UIStatusBarStyleLightContent];
}

-(void)dealloc
{
    DDLog(@"dealloc:%@",[self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
