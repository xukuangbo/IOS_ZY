//
//  ZCTotalPeopleView.m
//  ios_zhongyouzhongchou
//
//  Created by liuliang on 16/4/26.
//  Copyright © 2016年 liuliang. All rights reserved.
//

#import "ZCTotalPeopleView.h"
#import "UserModel.h"
//#import "ZCDetailCustomButton.h"
#import "LoginJudgeTool.h"
#import "ZYUserZoneController.h"
@interface ZCTotalPeopleView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collection;
@end

@implementation ZCTotalPeopleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame=CGRectMake(0, KSCREEN_H, KSCREEN_W, KSCREEN_H);
        self.backgroundColor=[UIColor clearColor];
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height*2/5)];
    [view addTarget:self action:@selector(down)];
    [self addSubview:view];
    
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, self.height*2/5, self.width, 44)];
    topView.backgroundColor=[UIColor whiteColor];
    [self addSubview:topView];
    
    UIButton *downBtn =[ZYZCTool getCustomBtnByTilte:@"收起" andImageName:@"btn_up" andtitleFont:[UIFont systemFontOfSize:17] andTextColor:nil andSpacing:2];
    downBtn.frame=CGRectMake(self.width-60, 0, 50, topView.height);
     [downBtn addTarget:self action:@selector(down) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:downBtn];
    
    CGFloat btn_width=50*KCOFFICIEMNT;
    CGFloat btn_edg=(self.width-5*btn_width )/6;
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset=UIEdgeInsetsMake(1.0,10.0,1.0,10.0);
    flowLayout.itemSize=CGSizeMake(btn_width,btn_width);
    flowLayout.minimumLineSpacing=btn_edg;
    flowLayout.minimumInteritemSpacing=btn_edg;
    
    UICollectionView *collection=[[UICollectionView alloc]initWithFrame:CGRectMake(0, topView.bottom, self.width, self.height*3/5-topView.height) collectionViewLayout:flowLayout];
    collection.backgroundColor=[UIColor whiteColor];
    collection.dataSource=self;
    collection.delegate=self;
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"userCollection"];
    [self addSubview:collection];
    _collection=collection;
    
    WEAKSELF
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.top=0;
        weakSelf.backgroundColor=[UIColor colorWithWhite:0.000 alpha:0.300];
    }];
}

-(void)setUsers:(NSArray *)users
{
    _users=users;
    [_collection reloadData];
//    int     row=5;
//    CGFloat btn_width=50*KCOFFICIEMNT;
//    CGFloat btn_edg=(self.width-row*btn_width )/6;
//    
//    CGFloat lastBtn_bottom=0.0;
//    for (NSInteger i=0; i<users.count; i++) {
//        UserModel *user=users[i];
//        ZCDetailCustomButton *userBtn=[[ZCDetailCustomButton alloc]initWithFrame:CGRectMake(btn_edg+(btn_edg+btn_width)*(i%row), btn_edg+(btn_edg+btn_width)*(i/row), btn_width, btn_width)];
//        [userBtn sd_setImageWithURL:[NSURL URLWithString:user.img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_hh"]];
//        userBtn.userId=user.userId;
//        userBtn.layer.cornerRadius=4;
//        userBtn.layer.masksToBounds=YES;
//        [_scroll addSubview:userBtn];
//        if (i==users.count-1) {
//            lastBtn_bottom=userBtn.bottom;
//        }
//    }
//    if (lastBtn_bottom>_scroll.height) {
//        _scroll.contentSize=CGSizeMake(0, lastBtn_bottom+KEDGE_DISTANCE);
//    }
}


#pragma mark --- 收起
-(void)down
{
    WEAKSELF
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.top=KSCREEN_H;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _users.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"userCollection" forIndexPath:indexPath];
    UIImageView *faceImg=[[UIImageView alloc]initWithFrame:cell.contentView.bounds];
    UserModel *user=_users[indexPath.row];
    [faceImg sd_setImageWithURL:[NSURL URLWithString:[ZYZCTool getSmailIcon:user.img?user.img:user.faceImg]] placeholderImage:[UIImage imageNamed:@"head_hh"]];
    faceImg.contentMode=UIViewContentModeScaleToFill;
    faceImg.layer.cornerRadius=4;
    faceImg.layer.masksToBounds=YES;
    cell.backgroundView=faceImg;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserModel *user=_users[indexPath.row];
    [self personZone:user.userId];
}

#pragma mark --- 访问个人空间，如果是用户自己，进用户个人主页，如果是别人，进别人主页
-(void)personZone:(NSNumber *)userId
{
    BOOL loginResult=[LoginJudgeTool judgeLogin];
    if (!loginResult) {
        return;
    }
    //判断是否是自己的
    if ([[ZYZCAccountTool getUserId] isEqual:[userId stringValue]]) {
        return;
    }
    ZYUserZoneController *userZoneController=[[ZYUserZoneController alloc]init];
    userZoneController.hidesBottomBarWhenPushed=YES;
    userZoneController.friendID=userId;
    [self.viewController.navigationController pushViewController:userZoneController animated:YES];
    
}




@end
