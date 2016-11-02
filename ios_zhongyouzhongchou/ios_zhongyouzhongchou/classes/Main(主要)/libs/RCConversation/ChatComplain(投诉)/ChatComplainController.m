//
//  ChatComplainController.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/7/20.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#define CHAT_COMPLAIN_URL [NSString stringWithFormat:@"%@productInfo/msgComplaint.action",BASE_URL]

#import "ChatComplainController.h"
#import "XMNPhotoPickerFramework/XMNPhotoPickerFramework.h"
#import "MediaUtils.h"
#import "JudgeAuthorityTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZYZCOSSManager.h"
#import "NetWorkManager.h"
#import "AboutTousuVC.h"
#define ADD_BTN_WIDTH 80
@interface ChatComplainController ()<UIScrollViewDelegate,UIAlertViewDelegate>
@property (nonatomic, assign) CGFloat  img_width;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton  *sureBtn;
@property (nonatomic, strong) XMNPhotoPickerController* picker;
@property (nonatomic, strong) NSMutableArray   *picArr;
@property (nonatomic, strong) NSMutableArray   *fileTmpPathArr;
@property (nonatomic, strong) NSMutableArray   *imgUrlArr;
@property (nonatomic, strong) MBProgressHUD    *mbProgress;
@property (nonatomic, assign) BOOL             uploadSuccess;
@end

@implementation ChatComplainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    _img_width=(KSCREEN_W-4*KEDGE_DISTANCE)/3;
    _picArr =[NSMutableArray array];
    _fileTmpPathArr=[NSMutableArray array];
    _imgUrlArr=[NSMutableArray array];
    [self configUI];
    [self setBackItem];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)configUI
{
    _scroll=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scroll.showsVerticalScrollIndicator=NO;
    _scroll.delegate=self;
    _scroll.top=64;
    _scroll.height=self.view.height-90-64;
    _scroll.contentSize=CGSizeMake(0, _scroll.height+1);
    [self.view addSubview:_scroll];

    //提示
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE, 0, self.view.width-KEDGE_DISTANCE, 44)];
    lab.text=@"请上传截图证据(最多9张)";
    lab.textColor=[UIColor ZYZC_TextGrayColor];
    lab.font=[UIFont systemFontOfSize:15];
    [_scroll addSubview:lab];
    
    _addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.frame=CGRectMake(5,lab.bottom ,ADD_BTN_WIDTH ,ADD_BTN_WIDTH );
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"btn_jjd"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:_addBtn];
    
    //提交按钮
    CGFloat btnHeight=60;
    _sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame=CGRectMake(KEDGE_DISTANCE, self.view.height-btnHeight-20, self.view.width-2*KEDGE_DISTANCE, btnHeight);
    _sureBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [_sureBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor ZYZC_MainColor] forState:UIControlStateNormal];
    _sureBtn.layer.cornerRadius=KCORNERRADIUS;
    _sureBtn.layer.masksToBounds=YES;
    _sureBtn.backgroundColor=[UIColor whiteColor];
    [_sureBtn addTarget:self action:@selector(showCommitAlert) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn.enabled=NO;
    [self.view addSubview:_sureBtn];
    
    UIButton *navRightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.frame=CGRectMake(0, 0, 60, 44);
    [navRightBtn setTitle:@"投诉须知" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    navRightBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [navRightBtn addTarget:self action:@selector(learnComplaintNotes ) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:navRightBtn];

}

#pragma mark --- 投诉须知
-(void)learnComplaintNotes
{
    AboutTousuVC *aboutTousuVC=[[AboutTousuVC alloc]init];
    [self.navigationController pushViewController:aboutTousuVC animated:YES];
}

#pragma mark --- 添加图片
-(void)addPicture
{
    //相册是否允许访问
    BOOL canChooseAlbum =[JudgeAuthorityTool judgeAlbumAuthority];
    if (!canChooseAlbum) {
        return;
    }
    if (!_picker) {
        _picker = [[XMNPhotoPickerController alloc] initWithMaxCount:9 delegate:nil];
        _picker.pickingVideoEnable=NO;
        _picker.autoPushToPhotoCollection=YES;
    }
    __weak typeof(self) weakSelf = self;
    
    // 选择图片后回调
    [_picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable asset) {
        _uploadSuccess=NO;
        [weakSelf.picArr removeAllObjects];
        NSMutableArray *newImgs=[NSMutableArray array];
        for (NSInteger i=0; i<images.count; i++) {
            [newImgs addObject:[ZYZCTool imageByScalingAndCroppingWithSourceImage:images[i]]];
        }
        [weakSelf.picArr addObjectsFromArray:newImgs];
        [weakSelf finishChooseWithImages:newImgs];
        weakSelf.sureBtn.enabled=YES;
        [weakSelf.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        weakSelf.sureBtn.backgroundColor=[UIColor ZYZC_MainColor];
        [weakSelf.picker dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //点击取消
    [_picker setDidCancelPickingBlock:^{
        [weakSelf.picker dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self presentViewController:_picker animated:YES completion:nil];

}

#pragma mark --- 选择图片后
-(void)finishChooseWithImages:(NSArray *)images
{
    for (UIView *view in [_scroll subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    _addBtn.hidden=YES;
    CGFloat lastY=0.0;
    for (NSInteger i=0; i<images.count; i++) {
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(KEDGE_DISTANCE+(_img_width+KEDGE_DISTANCE)*(i%3), _addBtn.top+(_img_width+KEDGE_DISTANCE)*(i/3), _img_width, _img_width)];
        img.image=images[i];
        img.contentMode=UIViewContentModeScaleAspectFill;
        img.layer.masksToBounds=YES;
        lastY=img.bottom+KEDGE_DISTANCE;
        [img addTarget:self action:@selector(addPicture)];
        [_scroll addSubview:img];
    }
    if (lastY>KSCREEN_H-90) {
        _scroll.contentSize=CGSizeMake(0, lastY);
    }
}

#pragma mark --- 提交投诉
-(void)showCommitAlert
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"是否确认提交" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil  ];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self commit];
    }
}



#pragma mark --- 提交
-(void)commit
{
    if(_uploadSuccess)
    {
        [self commitData];
        return;
    }
    
    [_fileTmpPathArr removeAllObjects];
    
    //将图片保存到本地tmp中
    NSString *tmpDir = NSTemporaryDirectory();
    for (NSInteger i=0; i<_picArr.count; i++) {
       NSString *path =[tmpDir stringByAppendingPathComponent:[NSString stringWithFormat:@"chatComplain%ld.png",i]];
        [_fileTmpPathArr addObject:path];
        UIImage *image=_picArr[i];
        BOOL writeResult=[UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
        if (!writeResult) {
            [MBProgressHUD showError:@"数据出错，提交失败"];
            return;
        }
    }
    //将图片上传到oss
    ZYZCOSSManager *ossManager=[ZYZCOSSManager defaultOSSManager];
    [MBProgressHUD showMessage:@"正在提交..."];
    __weak typeof (&*self)weakSelf=self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^
    {
        NSString *userId=[ZYZCAccountTool getUserId];
        NSString *timeStmp=[ZYZCTool getTimeStamp];
        for (NSInteger i=0; i<_fileTmpPathArr.count; i++) {
            NSString *fileName=[NSString stringWithFormat:@"%@/chatComplain/%@/%ld.png",userId,timeStmp,i];
            NSString *imgUrl=[NSString stringWithFormat:@"%@/%@",KHTTP_FILE_HEAD,fileName];
            [weakSelf.imgUrlArr addObject:imgUrl];
            
            BOOL uploadResult=[ossManager uploadIconSyncByFileName:fileName andFilePath:_fileTmpPathArr[i]];
            
            if (!uploadResult) {
                //回到主线程提示上传失败
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"网络出错,提交失败"];
                });
                return;
            }
        }
        //数据上传完成， 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^
        {
            _uploadSuccess=YES;
            [MBProgressHUD hideHUD];
            [self commitData];
            

        });
    });
}

#pragma mark --- 上传数据到服务器
-(void)commitData
{
    NSString *images=[_imgUrlArr componentsJoinedByString:@","];
    NSString *httpUrl=CHAT_COMPLAIN_URL;
    NSDictionary *param=@{@"selfUserId":[ZYZCAccountTool getUserId],
                          @"userId":_targetId,
                          @"type":[NSNumber numberWithInteger:_complainType],
                          @"images":images,
                          @"content":@"无"
                          };
//    NSLog(@"param:%@",param);
//    NSLog(@"httpUrl:%@",httpUrl);
    [ZYZCHTTPTool postHttpDataWithEncrypt:YES andURL:httpUrl andParameters:param andSuccessGetBlock:^(id result, BOOL isSuccess) {
//        NSLog(@"%@",result);
        if (isSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"提交成功"];
        }
        else
        {
            [MBProgressHUD showError:@"提交失败"];
        }
    }
     andFailBlock:^(id failResult) {
//     NSLog(@"%@",failResult);
    [NetWorkManager showMBWithFailResult:failResult];
    }];

}

-(void)dealloc
{
    for (NSInteger i=0; i<_fileTmpPathArr.count; i++) {
        [ZYZCTool removeExistfile:_fileTmpPathArr[i]];
    }
    DDLog(@"dealloc:%@",self.class);
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
