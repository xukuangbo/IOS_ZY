//
//  GoalSecondCell.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/18.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define ThemeImagePath  KMY_ZC_FILE_PATH(@"themeImage.png")

#define TRAVELPLACEHOLDER @"编写旅行主题名(18字以内)"
#define LIMIT_STR_NUMBER   18
#define ALERTTEXT @"选择目的地封面"//添加风景图提示文字
#import "GoalSecondCell.h"
#import "ChooseSceneImgController.h"
#import "SelectImageViewController.h"
#import "UIView+GetSuperTableView.h"
#import "MoreFZCViewController.h"
#import "ZYZCTool+getLocalTime.h"
#import "MBProgressHUD+MJ.h"
#import "JudgeAuthorityTool.h"
#import "ZYZCDataBase.h"
#import <objc/runtime.h>

@interface GoalSecondCell()<UIAlertViewDelegate>

@end

@implementation GoalSecondCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)configUI
{
    [super configUI];
    self.bgImg.height=SECONDCELLHEIGHT;
    [self.titleLab removeFromSuperview];
    _textField= [[ZYBaseLimitTextField alloc]initWithFrame:CGRectMake(2*KEDGE_DISTANCE, 15, KSCREEN_W-40, 20) andMaxTextNum:LIMIT_STR_NUMBER];
    _textField.borderStyle=UITextBorderStyleNone;
    _textField.placeholder=TRAVELPLACEHOLDER;
    _textField.font=[UIFont systemFontOfSize:17];
    _textField.limitTextFieldDelegate=self;
    _textField.returnKeyType=UIReturnKeyDone;
    _textField.textColor=[UIColor ZYZC_TextBlackColor];
    [self.contentView addSubview:_textField];
    
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    if (manager.goal_travelTheme) {
        _textField.text=manager.goal_travelTheme;
    }
    //添加空白框架背景
    UIImageView *frameImg=[[UIImageView alloc]initWithFrame:CGRectMake(2*KEDGE_DISTANCE, self.topLineView.bottom+KEDGE_DISTANCE, KSCREEN_W-4*KEDGE_DISTANCE, 175*KCOFFICIEMNT)];
    frameImg.contentMode=UIViewContentModeScaleAspectFill;
    frameImg.layer.cornerRadius=5;
    frameImg.layer.masksToBounds=YES;
    frameImg.layer.borderWidth=1;
    frameImg.layer.borderColor=[UIColor ZYZC_BgGrayColor].CGColor;
    frameImg.userInteractionEnabled=YES;
    [self.contentView addSubview:frameImg];
    _frameImg=frameImg;
    //添加提示文字lab
    CGFloat labWidth=[ZYZCTool calculateStrLengthByText:ALERTTEXT andFont:[UIFont systemFontOfSize:15] andMaxWidth:KSCREEN_W].width+5;
    UILabel *alertLab=[[UILabel alloc]init];
    alertLab.size=CGSizeMake(labWidth, 20);
    alertLab.center=frameImg.center;
    alertLab.font=[UIFont systemFontOfSize:15];
    alertLab.text=ALERTTEXT;
    alertLab.textColor=[UIColor ZYZC_TextGrayColor01];
    [self.contentView addSubview:alertLab];
    
    //添加图片标示
    UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(alertLab.right, alertLab.top,26, 19)];
    iconImg.userInteractionEnabled=NO;
    iconImg.image=[UIImage imageNamed:@"ico_fmpic"];
    [self.contentView addSubview:iconImg];
    
    [self.contentView bringSubviewToFront:frameImg];
    
    //给图片添加点击手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHappen:)];
    [frameImg addGestureRecognizer:tap];
    //初始化图片
    if (manager.goal_travelThemeImgUrl) {
        NSRange range=[manager.goal_travelThemeImgUrl rangeOfString:KMY_ZHONGCHOU_FILE];
        if (range.length) {
            //加载本地图片
            frameImg.image =[UIImage imageWithContentsOfFile:manager.goal_travelThemeImgUrl];
        }
        else
        {
            //加载网络图片
            [frameImg sd_setImageWithURL:[NSURL URLWithString:manager.goal_travelThemeImgUrl] placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
        }
    }
}

#pragma mark --- 选择图片
-(void)tapHappen:(UITapGestureRecognizer *)tap
{
    //获取已选图库ids
    BOOL canChooseNetImages=NO;
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    DDLog(@"目的地:%@",manager.goal_goals);
    NSMutableArray *views=[NSMutableArray array];
    NSMutableArray *viewIds=[NSMutableArray array];
    if (manager.goal_goals.count>1) {
        for (NSInteger i=1; i<manager.goal_goals.count; i++) {
            ZYZCDataBase *dataManager=[ZYZCDataBase sharedDBManager];
           OneSpotModel *oneSpotModel = [dataManager searchOneDataWithName:manager.goal_goals[i]];
            if (oneSpotModel) {
                canChooseNetImages=YES;
                [views addObject:manager.goal_goals[i]];
                [viewIds addObject:oneSpotModel.ID];
                DDLog(@"%@",oneSpotModel.ID);
            }
        }
    }
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = NO;
    __weak typeof (&*self)weakSelf=self;
    //创建UIAlertController控制器
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    选择众游图库
    UIAlertAction *collectionAction = [UIAlertAction actionWithTitle:@"众游图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
        if (canChooseNetImages) {
            ChooseSceneImgController *chooseImgVC=[[ChooseSceneImgController alloc]init];
            chooseImgVC.views=views;
            chooseImgVC.viewIds=viewIds;
            __weak typeof (&*self)weakSelf=self;
            chooseImgVC.chooseImageBolck=^(NSString *imgUrl)
            {
                [weakSelf.frameImg sd_setImageWithURL:[NSURL URLWithString:imgUrl]  placeholderImage:[UIImage imageNamed:@"icon_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
            };
            
            [weakSelf.viewController.navigationController pushViewController:chooseImgVC animated:YES];
        }
    }];
    //选择本地相册
    UIAlertAction *draftsAction = [UIAlertAction actionWithTitle:@"本地相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //判断是否可以选择照片
        BOOL canChooseAlbum=[JudgeAuthorityTool judgeAlbumAuthority];
        if (!canChooseAlbum) {
            return ;
        }
        
        weakSelf.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
         weakSelf.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        [weakSelf.viewController presentViewController:weakSelf.imagePicker animated:YES completion:nil];
        
    }];
    //选择拍照
    UIAlertAction *giftCardAction = [UIAlertAction actionWithTitle:@"拍照获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //判断是否可以拍照
        BOOL canUseMedia=[JudgeAuthorityTool judgeMediaAuthority];
        if (!canUseMedia) {
            return ;
        }
        
        weakSelf.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        weakSelf.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        [weakSelf.viewController presentViewController:weakSelf.imagePicker animated:YES completion:nil];
    }];
    
    if (!canChooseNetImages) {
        [collectionAction setValue:[UIColor lightGrayColor] forKey:@"_titleTextColor"];
    }
    [alertController addAction:cancelAction];
    [alertController addAction:collectionAction];
    [alertController addAction:draftsAction];
    [alertController addAction:giftCardAction];
    
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark --- 获取本地照片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage])
    {
        __weak typeof (&*self)weakSelf=self;
        [picker dismissViewControllerAnimated:YES completion:^{
            SelectImageViewController *selectImgVC=[[SelectImageViewController alloc]initWithImage:[ZYZCTool fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]] WHScale:(16 / 10.0)];
            selectImgVC.imageBlock=^(UIImage *img)
            {
               [ZYZCTool removeExistfile:ThemeImagePath];
#warning 需要 压缩处理
                weakSelf.frameImg.image=img ;
                // 将图片保存为png格式到documents中
                NSString *filePath=ThemeImagePath;
                [UIImagePNGRepresentation(img)
                 writeToFile:filePath atomically:YES];
                //将图片路径保存到单例中
                MoreFZCDataManager  *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
                manager.goal_travelThemeImgUrl=ThemeImagePath;
            };
            [weakSelf.viewController.navigationController pushViewController:selectImgVC animated:YES];
        }];
    }
}
/**
 *  判断封面图片大小
 */
- (BOOL)judgeImgSizeByImg:(CGSize)imageSize
{
//    NSLog(@"%f,%f",KSCREEN_W,KSCREEN_H);
    CGFloat screenWidth = KSCREEN_W;
    CGFloat screenHeight = KSCREEN_W / 16.0 * 10;
//    (imageSize.height * KSCREEN_W)/imageSize.width >= screenHeight
    if (imageSize.width >= screenWidth && imageSize.height >= screenHeight ) {
        return YES;
    }else{
        return NO;
    }
}


#pragma mark --- textField代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField endEditing:YES];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //监听键盘的出现和收起
    [ZYNSNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [ZYNSNotificationCenter addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.text=[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    if (textField.text.length) {
        manager.goal_travelTheme=_textField.text;
    }
    else
    {
        manager.goal_travelTheme=nil;
    }

    [ZYNSNotificationCenter removeObserver:self];
    return YES;
}

#pragma mark --- 键盘出现和收起方法
-(void)keyboardWillShow:(NSNotification *)notify
{
    [ZYZCTool handleKeyBoardScroOn:self.getSuperTableView forTarget:_textField noti:notify state:@"show"];
}

-(void)keyboardWillHidden:(NSNotification *)notify
{
    [ZYZCTool handleKeyBoardScroOn:self.getSuperTableView forTarget:_textField noti:notify state:@"hide"];
}

@end
