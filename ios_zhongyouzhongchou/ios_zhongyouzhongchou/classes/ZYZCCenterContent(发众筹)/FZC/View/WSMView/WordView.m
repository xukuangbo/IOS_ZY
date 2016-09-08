//
//  WordView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/3/31.
//  Copyright © 2016年 liuliang. All rights reserved.
//
#define TEXT_PLACEHOLDER @"编写众筹描述"

#import "WordView.h"
#import "UIView+GetSuperTableView.h"
#import "UIView+ViewController.h"
#import "WordEditViewController.h"
#import "JudgeAuthorityTool.h"
#import "XMNPhotoPickerController.h"

#import "HUPhotoBrowser.h"
#import "ZYDescImage.h"
@interface WordView ()
@property (nonatomic, assign) CGFloat    imgView_width ;//图片宽
@property (nonatomic, strong) UILabel    *placeHolderLab;
@property (nonatomic, strong) UIButton   *imgDesBtn;
@property (nonatomic, strong) UIView     *imgView;
@property (nonatomic, strong) UIButton   *addBtn;
@property (nonatomic, strong) XMNPhotoPickerController *picker;

@property (nonatomic, strong) NSMutableArray *imgModelArr;
@property (nonatomic, assign) NSInteger      beforeNumber;

@property (nonatomic, copy  ) NSString   *currentImgUrlStr;

@end

@implementation WordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)configUI
{
    _imgView_width=(self.width-3*KEDGE_DISTANCE)/4.0;
    //文字编辑框
    _textView=[[UITextView alloc]init];
    _textView.editable=NO;
    _textView.font=[UIFont systemFontOfSize:15];
    _textView.layer.cornerRadius=KCORNERRADIUS;
    _textView.layer.masksToBounds=YES;
    _textView.textColor=[UIColor ZYZC_TextBlackColor];
    _textView.backgroundColor=[UIColor ZYZC_BgGrayColor01];
    _textView.contentInset = UIEdgeInsetsMake(-5, 0, 5, 0);
    _textView.frame=CGRectMake(0, 0, self.width, self.height-KEDGE_DISTANCE-_imgView_width);
    [self addSubview:_textView];

    //placeHolder
    _placeHolderLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, _textView.width, 20)];
    _placeHolderLab.numberOfLines=0;
    _placeHolderLab.text=TEXT_PLACEHOLDER;
    _placeHolderLab.font=[UIFont systemFontOfSize:15];
    _placeHolderLab.textColor=[UIColor ZYZC_TextGrayColor02];
    [_textView addSubview:_placeHolderLab];
    [_textView addTarget:self action:@selector(tapHappen:)];
    
    //图片负载框
    _imgView = [[UIView alloc]initWithFrame:CGRectMake(_textView.left, _textView.bottom+5, _textView.width, _imgView_width)];
//    _imgView.backgroundColor=[UIColor orangeColor];
    [self addSubview:_imgView];
    
    //添加按钮
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn .frame= CGRectMake(0, 0, _imgView_width, _imgView_width);
    [_addBtn addTarget:self action:@selector(addImg) forControlEvents:UIControlEventTouchUpInside];
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"btn_jjd"] forState:UIControlStateNormal];
    [_imgView addSubview:_addBtn];
    
    _beforeNumber=0;
    _maxImgNumber=3;
    _imgModelArr=[NSMutableArray array];
}

-(void)getDataManagerImgUrl
{
    MoreFZCDataManager *manager= [MoreFZCDataManager sharedMoreFZCDataManager];
    //筹旅费图片
    if([self.contentBelong isEqualToString:RAISEMONEY_CONTENTBELONG])
    {
        self.imageUrlStr=manager.raiseMoney_imgUrlStr;
    }
    //回报1图片
    else if ([self.contentBelong isEqualToString:RETURN_01_CONTENTBELONG])
    {
        self.imageUrlStr=manager.return_imgUrlStr;
    }
    //回报2文字描述
    else if ([self.contentBelong isEqualToString:RETURN_02_CONTENTBELONG])
    {
        self.imageUrlStr=manager.return_imgUrlStr01;
    }
    //一起游文字描述
    else if ([self.contentBelong isEqualToString:TOGTHER_CONTENTBELONG])
    {
        self.imageUrlStr=manager.return_togtherImgUrlStr;
    }
    //行程文字描述
    for (int i=0; i<manager.travelDetailDays.count; i++) {
        if ([self.contentBelong isEqualToString:TRAVEL_CONTENTBELONG(i+1)]) {
            MoreFZCTravelOneDayDetailMdel *model=manager.travelDetailDays[i];
            self.imageUrlStr=model.imgUrlStr;
            break;
        }
    }
}

#pragma mark --- 已存在图片

-(void)setImageUrlStr:(NSString *)imageUrlStr
{
    if(imageUrlStr.length>0){
        _imgModelArr=[NSMutableArray array];
        NSArray *urlArr=[imageUrlStr componentsSeparatedByString:@","];
        for (NSInteger i=0; i<urlArr.count; i++) {
            ZYDescImgModel *imageModel=[[ZYDescImgModel alloc]init];
            imageModel.isLocalImage=NO;
            imageModel.minUrl=urlArr[i];
            imageModel.maxUrl=urlArr[i];
            [_imgModelArr addObject:imageModel];
        }
        [self addImagesInView:_imgModelArr];
    }
}

#pragma mark --- 添加图片
-(void)addImg
{
//    [ZYZCTool getZCDraftFiles];
    _beforeNumber=_imgModelArr.count;
    //相册是否允许访问
    BOOL canChooseAlbum =[JudgeAuthorityTool judgeAlbumAuthority];
    if (!canChooseAlbum) {
        return;
    }
    if (!_picker) {
        _picker = [[XMNPhotoPickerController alloc] initWithMaxCount:_maxImgNumber-_imgModelArr.count delegate:nil];
        _picker.pickingVideoEnable=NO;
        _picker.autoPushToPhotoCollection=YES;
    }
    else
    {
        _picker.maxCount=_maxImgNumber-_imgModelArr.count;
    }
    
    __weak typeof(self) weakSelf = self;
    // 选择图片后回调
    [_picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable asset) {
        [weakSelf addLocalImageInView:images];
        [weakSelf.picker dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //点击取消
    [_picker setDidCancelPickingBlock:^{
        [weakSelf.picker dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.viewController presentViewController:_picker animated:YES completion:nil];
}

#pragma mark --- 添加本地图片
-(void)addLocalImageInView:(NSArray *)images
{
//    DDLog(@"%ld",_beforeNumber);
    CGFloat edg=KEDGE_DISTANCE;
    //添加本地图片到视图上
    for (NSInteger i=0; i<images.count; i++) {
        ZYDescImage *imgView=[[ZYDescImage alloc]initWithFrame:CGRectMake((_beforeNumber+i)*(_imgView_width+edg), 0, _imgView_width, _imgView_width)];
        [_imgView addSubview:imgView];
        [imgView addTarget:self action:@selector(showBigImg:)];
        _addBtn.left=imgView.right+KEDGE_DISTANCE;
        
        //保存图片到document
        NSString *fileName=[NSString stringWithFormat:@"%@_%@.png",self.contentBelong,[ZYZCTool getTimeStamp]];
        NSString *filePath=KMY_ZC_FILE_PATH(fileName);
        [UIImagePNGRepresentation(images[i])
         writeToFile:filePath atomically:YES];
        
        //创建model
        ZYDescImgModel *imgModel=[[ZYDescImgModel alloc]init];
        imgModel.isLocalImage=YES;
        imgModel.image=images[i];
        imgModel.filePath=filePath;
    
        imgView.imgModel=imgModel;
        [_imgModelArr addObject:imgModel];
//        DDLog(@"filePath:%@",filePath);
    }
    if (_imgModelArr.count>=_maxImgNumber) {
        _addBtn.hidden=YES;
    }
    else
    {
        _addBtn.hidden=NO;
    }
    [self addImageDataInManager];
}

#pragma mark --- 添加图片到文字下方
-(void)addImagesInView:(NSArray *)imageModelArr
{
    NSArray *views=[_imgView subviews];
    for (NSInteger i=views.count-1;i>=0;i--) {
        if ([views[i] isKindOfClass:[ZYDescImage class]]) {
            [views[i] removeFromSuperview];
        }
    }

    CGFloat edg=KEDGE_DISTANCE;
    for (NSInteger i=0; i<imageModelArr.count; i++) {
        ZYDescImage *imgView=[[ZYDescImage alloc]initWithFrame:CGRectMake((_beforeNumber+i)*(_imgView_width+edg), 0, _imgView_width, _imgView_width)];
        ZYDescImgModel *imgModel=imageModelArr[i];
        [_imgView addSubview:imgView];
         imgView.imgModel=imgModel;
        [imgView addTarget:self action:@selector(showBigImg:)];
        _addBtn.left=imgView.right+KEDGE_DISTANCE;
    }
    
    if (_imgModelArr.count>=_maxImgNumber) {
        _addBtn.hidden=YES;
    }
    else
    {
        _addBtn.hidden=NO;
    }
}

#pragma mark --- 查看大图
-(void)showBigImg:(UITapGestureRecognizer *)tap
{
    ZYDescImage *img=(ZYDescImage *)tap.view;
    //如果是本地图片
    __weak typeof (&*self)weakSelf=self;
    if (img.imgModel.isLocalImage) {
        [HUPhotoBrowser showFromImageView:img withImages:@[img.image] atIndex:0  deleteImg:^{
            //删除本地图片
            weakSelf.beforeNumber=0;
            weakSelf.addBtn.left=0;
            NSArray *views=[weakSelf.imgView subviews];
            for (NSInteger i = views.count-1; i>=0; i--) {
                if ([views[i] isKindOfClass:[ZYDescImage class]]) {
                    [views[i] removeFromSuperview];
                }
            }
            //删除document中的文件
            [ZYZCTool removeExistfile:img.imgModel.filePath];
            
            [weakSelf.imgModelArr removeObject:img.imgModel];
            [weakSelf addImagesInView:weakSelf.imgModelArr];
            [weakSelf addImageDataInManager];
        }];
    }
    //如果是网络图片
    else
    {
        [HUPhotoBrowser showFromImageView:img withURLStrings:@[img.imgModel.maxUrl] placeholderImage:[UIImage imageNamed:@"image_placeholder"] atIndex:0 deleteImg:^{
            //删除网络图片
            weakSelf.beforeNumber=0;
            weakSelf.addBtn.left=0;
            NSArray *views=[weakSelf.imgView subviews];
            for (NSInteger i = views.count-1; i>=0; i--) {
                if ([views[i] isKindOfClass:[ZYDescImage class]]) {
                    [views[i] removeFromSuperview];
                }
            }
            [weakSelf.imgModelArr removeObject:img.imgModel];
            [weakSelf addImagesInView:weakSelf.imgModelArr];
            [weakSelf addImageDataInManager];
        }];
    }
}

#pragma mark --- 点击文字
-(void)tapHappen:(UITapGestureRecognizer *)tap
{
    WordEditViewController *wordEditVC=[[WordEditViewController alloc]init];
    wordEditVC.myTitle=@"文字描述";
    wordEditVC.preText=_textView.text;
    __weak typeof (&*self)weakSelf=self;
    wordEditVC.textBlock=^(NSString *textStr)
    {
        if (textStr.length) {
            weakSelf.placeHolderLab.hidden=YES;
        }
        else
        {
            weakSelf.placeHolderLab.hidden=NO;
            textStr=nil;
        }
        weakSelf.textView.text=textStr;
        //文字描述存入单例中
        MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
        //筹旅费文字描述
        if([weakSelf.contentBelong isEqualToString:RAISEMONEY_CONTENTBELONG])
        {
            manager.raiseMoney_wordDes=textStr;
        }
        //回报1文字描述
        else if ([weakSelf.contentBelong isEqualToString:RETURN_01_CONTENTBELONG])
        {
            manager.return_wordDes=textStr;
        }
        //回报2文字描述
        else if ([weakSelf.contentBelong isEqualToString:RETURN_02_CONTENTBELONG])
        {
            manager.return_wordDes01=textStr;
        }
        //一起游文字描述
        else if ([weakSelf.contentBelong isEqualToString:TOGTHER_CONTENTBELONG])
        {
            manager.return_togtherWordDes=textStr;
        }
        //行程文字描述
        for (int i=0; i<manager.travelDetailDays.count; i++) {
            if ([weakSelf.contentBelong isEqualToString:TRAVEL_CONTENTBELONG(i+1)]) {
                MoreFZCTravelOneDayDetailMdel *model=manager.travelDetailDays[i];
                model.wordDes=textStr;
                break;
            }
        }
    };

    [self.viewController presentViewController:wordEditVC animated:YES completion:nil];
}

#pragma mark --- 保存图片数据
-(void)addImageDataInManager
{
    NSMutableString *mutStr=[NSMutableString string];
    for (NSInteger i=0; i<_imgModelArr.count; i++) {
        ZYDescImgModel *imgModel=_imgModelArr[i];
        if (imgModel.isLocalImage) {
            [mutStr appendString:[NSString stringWithFormat:@"%@,",imgModel.filePath]];
        }
        else
        {
            [mutStr appendString:[NSString stringWithFormat:@"%@,",imgModel.maxUrl]];
        }
        
        if (i==_imgModelArr.count-1) {
            [mutStr replaceCharactersInRange:NSMakeRange(mutStr.length-1, 1) withString:@""];
        }
    }

    DDLog(@"mutStr:%@",mutStr);
    //图片url存入单例中
    MoreFZCDataManager *manager=[MoreFZCDataManager sharedMoreFZCDataManager];
    //筹旅费图片描述
    if([self.contentBelong isEqualToString:RAISEMONEY_CONTENTBELONG])
    {
        manager.raiseMoney_imgUrlStr=mutStr;
    }
    //回报1图片描述
    else if ([self.contentBelong isEqualToString:RETURN_01_CONTENTBELONG])
    {
        manager.return_imgUrlStr    =mutStr;
    }
    //回报2图片描述
    else if ([self.contentBelong isEqualToString:RETURN_02_CONTENTBELONG])
    {
        manager.return_imgUrlStr    =mutStr;
    }
    //一起游图片描述
    else if ([self.contentBelong isEqualToString:TOGTHER_CONTENTBELONG])
    {
        manager.return_togtherImgUrlStr=mutStr;
    }
    //行程图片描述
    for (int i=0; i<manager.travelDetailDays.count; i++) {
        if ([self.contentBelong isEqualToString:TRAVEL_CONTENTBELONG(i+1)]) {
            MoreFZCTravelOneDayDetailMdel *model=manager.travelDetailDays[i];
            model.imgUrlStr        =mutStr;
            break;
        }
    }
}

-(void)setPlaceHolderText:(NSString *)placeHolderText
{
    _placeHolderText=placeHolderText;
    _placeHolderLab.text=placeHolderText;
    CGFloat height=[ZYZCTool calculateStrLengthByText:placeHolderText andFont:[UIFont systemFontOfSize:15] andMaxWidth:_placeHolderLab.width].height;
    _placeHolderLab.height=height;
}

-(void)setHiddenPlaceHolder:(BOOL)hiddenPlaceHolder
{
    _hiddenPlaceHolder=hiddenPlaceHolder;
    self.placeHolderLab.hidden=hiddenPlaceHolder;
}

-(void)setContentBelong:(NSString *)contentBelong
{
    [super setContentBelong:contentBelong];
    [self getDataManagerImgUrl];
}

@end













