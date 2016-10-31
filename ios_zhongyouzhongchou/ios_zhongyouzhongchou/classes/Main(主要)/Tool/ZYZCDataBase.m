//
//  FHFDBManager.m
//

#import "ZYZCDataBase.h"
#import "LanguageTool.h"
static ZYZCDataBase *_db;

@implementation ZYZCDataBase
{
    FMDatabase *_fmdb;
    BOOL hasSaveSpotData;
    BOOL hasGetSpotData;
}


+(instancetype )sharedDBManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if (!_db) {
            _db=[[ZYZCDataBase alloc]init];
        }
    });
    
    return _db;
}

-(instancetype)init
{
    if (self=[super init]) {
    
    }
    return self;
}

#pragma mark --- 创建数据库表单
-(void)createTables
{
    [self deleteAllDataWithBlock:^(BOOL doSuccess) {
        //初始化数据时，需要给数据库一个沙盒路径进行永久保存，存储在Documents目录下
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path=[docDir stringByAppendingPathComponent:@"DataBase.db"];
        
//        NSLog(@"%@",path);
        
        _fmdb=[FMDatabase databaseWithPath:path];
        
        BOOL isSuccess=[_fmdb open];
        if (isSuccess) {
            
            // 数据库语言，sqlite语句，创建一张数据库表名
            //创建地名库表单
            NSString *spotSQL=@"create table if not exists ViewSpot(id integer,viewType integer,name string,country string,pinyin string)";
            BOOL spotTableSucced=[_fmdb executeUpdate:spotSQL];
            if (spotTableSucced) {
//                NSLog(@"spot表格创建成功");
                //存储数据
                [self saveDataWithFinishBlock:nil];
            }
            else{
//                NSLog(@"spot表格创建失败");
            }
        }
        else{
//            NSLog(@"数据库创建失败%@", _fmdb.lastErrorMessage);
        }
    }];
}

#pragma mark----增（景点地名库）

-(BOOL)insertDataWithId:(NSNumber *)dataId andType:(NSNumber *)type andName:(NSString *)name  andCountry:(NSString *)country  andPinyin:(NSString *)pinyin
{
    /*
     增insert into 表名(applicationId,name,iconurl) values(?,?,?)
     */
    BOOL exist=[self searchOneDataWithID:dataId];
    if (exist) {
        NSLog(@"数据已存在!");
        return NO;
    }
    NSString *sql=@"insert into ViewSpot(id,viewType,name,country,pinyin) values(?,?,?,?,?)";
    
    //插入一条数据
    BOOL success=[_fmdb executeUpdate:sql,dataId,type,name,country,pinyin];
    
    if (success) {
//        NSLog(@"插入成功");
    }
    else{
//        NSLog(@"插入失败%@",_fmdb.lastErrorMessage);
    }
    
    return success;
    
}

#pragma mark---查（景点地名库）

-(BOOL )searchOneDataWithID:(NSNumber *)dataId
{
    /*查询某一个是否存在select from 表名 where Id = ?*/
    
    NSString *sql=@"select name from ViewSpot where  id=?";
    FMResultSet *set=[_fmdb executeQuery:sql,dataId];
    
    BOOL success=[set next];
    if (success) {
//        NSLog(@"查找成功");
    }
    else{
//        NSLog(@"没有找到%@",_fmdb.lastErrorMessage);
    }
    return success;
}

#pragma mark --- 查询某个地名（景点地名库）
-(OneSpotModel *) searchOneDataWithName:(NSString *)name
{
    NSString *sql=@"select * from ViewSpot where  name=?";
    FMResultSet *set=[_fmdb executeQuery:sql,name];
    
    BOOL success=[set next];
    if (success) {
        OneSpotModel *oneSpotModel=[[OneSpotModel alloc]init];
        oneSpotModel.ID       =(NSNumber *)[set stringForColumn:@"id"];
        oneSpotModel.viewType =(NSNumber *)[set stringForColumn:@"viewType"];
        oneSpotModel.name     =[set stringForColumn:@"name"];
        oneSpotModel.country  =[set stringForColumn:@"country"];
        oneSpotModel.pinyin   =[set stringForColumn:@"pinyin"];
//        NSLog(@"查找成功");
        return oneSpotModel;
    }
    else{
//        NSLog(@"没有找到%@",_fmdb.lastErrorMessage);
    }
    
    return nil;
}

#pragma mark---查看所有（景点地名库）

-(NSArray *)recieveDBData
{
    /* 查询所有的数据select * from 表名 */
    
    NSString *sql=@"select * from ViewSpot";
    
    FMResultSet *set=[_fmdb executeQuery:sql];
    
    NSMutableArray *array=[NSMutableArray array];
    
    while ([set next]) {
        
        NSDictionary *dic=[set resultDictionary];
        
        [array addObject:dic];
    }
    return array;
}

#pragma mark --- 删除数据库
-(BOOL)deleteAllDataWithBlock:(DoFinish )doFinish
{
    //如果文件已存在则删除，如果不存在表示删除成功
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path=[docDir stringByAppendingPathComponent:@"DataBase.db"];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL success=YES;
    if ([fileManager fileExistsAtPath:path]) {
        success=[fileManager removeItemAtPath:path error:nil];
        if (success) {
            hasSaveSpotData=NO;
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            [user setObject:nil forKey:KVIEWSPOT_SAVE];
            [user synchronize];
            if (doFinish) {
                doFinish(success);
            }
        }
    }
    else
    {
        if (doFinish) {
            doFinish(success);
        }
    }
    return success;
}

#pragma mark --- 保存地名到数据库（景点地名库）
-(void)saveDataWithFinishBlock:(DoFinish )doFinish
{
    if (hasSaveSpotData) {
        if (doFinish) {
            doFinish(YES);
        }
        return;
    }
    if (hasGetSpotData) {
        if (doFinish) {
            doFinish(NO);
        }
        return;
    }
    
//    NSLog(@"spotsUrl:%@",GETVIEWSPOT);
    
    NSString *url = [[ZYZCAPIGenerate sharedInstance] API:@"viewSpot_getAllViews"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"2" forKey:@"viewType"];
    [ZYZCHTTPTool GET:url parameters:parameter withSuccessGetBlock:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            ZYZCViewSpotModel *viewSpotModel=[[ZYZCViewSpotModel alloc]mj_setKeyValues:result];
            hasGetSpotData=YES;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (OneSpotModel *oneSpotModel in viewSpotModel.data) {
                    NSString *pinyin=[LanguageTool chineseChangeToPinYin:oneSpotModel.name];
                    [self insertDataWithId:oneSpotModel.ID andType:oneSpotModel.viewType andName:oneSpotModel.name andCountry:oneSpotModel.country  andPinyin:pinyin];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    hasSaveSpotData=YES;
                    [[NSNotificationCenter defaultCenter]postNotificationName:KSAVE_SPOT_FINISH object:nil];
                    if (doFinish) {
                        doFinish(isSuccess);
                    }
                });
            });
        }
    } andFailBlock:^(id failResult) {
        
    }];
//    NSString *httpUrl=[NSString stringWithFormat:@"%@viewType=2",GETVIEWSPOT];
}


#pragma mark --- 拼音匹配（景点地名库）
-(NSArray*)queryWithPinyinCondition:(NSString *)condition
{
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM pinyinSimple WHERE alpha like '%@%%'",item.dream_keyword];//模糊查询，查找alpha中 以 item.dream_keyword 开头的内容
    
     NSString *sql = [NSString stringWithFormat:@"SELECT * FROM ViewSpot WHERE pinyin like '%%%@%%'",condition];//模糊查询，查询pinyin中包含 condition 的内容
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    FMResultSet *rs = [_fmdb executeQuery:sql];
    while ([rs next])
    {
        OneSpotModel *oneSpotModel=[[OneSpotModel alloc]init];
         oneSpotModel.ID       =(NSNumber *)[rs stringForColumn:@"id"];
         oneSpotModel.viewType =(NSNumber *)[rs stringForColumn:@"viewType"];
         oneSpotModel.name     =[rs stringForColumn:@"name"];
         oneSpotModel.pinyin   =[rs stringForColumn:@"pinyin"];
         oneSpotModel.country   =[rs stringForColumn:@"country"];

        [array addObject:oneSpotModel];
    }
    return array;
}

#pragma mark --- 文字匹配（景点地名库）
-(NSArray*)queryWithStrCondition:(NSString *)condition
{
    //    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM pinyinSimple WHERE alpha like '%@%%'",item.dream_keyword];//模糊查询，查找alpha中 以 item.dream_keyword 开头的内容
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM ViewSpot WHERE name like '%%%@%%'",condition];//模糊查询，查询文字中包含 condition 的内容
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    FMResultSet *rs = [_fmdb executeQuery:sql];
    while ([rs next])
    {
        OneSpotModel *oneSpotModel=[[OneSpotModel alloc]init];
        oneSpotModel.ID       =(NSNumber *)[rs stringForColumn:@"id"];
        oneSpotModel.viewType =(NSNumber *)[rs stringForColumn:@"viewType"];
        oneSpotModel.name     =[rs stringForColumn:@"name"];
        oneSpotModel.pinyin   =[rs stringForColumn:@"pinyin"];
        oneSpotModel.country   =[rs stringForColumn:@"country"];
        [array addObject:oneSpotModel];
    }
    return array;
}

/**
 *  ==============================================================
 */

//聊天表单
#pragma mark----增（聊天）

-(BOOL)insertDataWithUserId:(NSString *)userId andName:(NSString *)name andportraitUri:(NSString *)portraitUri andToken:(NSString *)token
{
    BOOL exist=[self searchOneUerWithID:userId];
    if (exist) {
//        NSLog(@"数据已存在!");
        return NO;
    }
    
    NSString *sql=@"insert into ChatUsers(userId,name,portraitUri,token) values(?,?,?,?)";
    
    //插入一条数据
    BOOL success=[_fmdb executeUpdate:sql,userId,name,portraitUri,token];
    
    if (success) {
//        NSLog(@"插入成功");
    }
    else{
//        NSLog(@"插入失败%@",_fmdb.lastErrorMessage);
    }
    return success;
}

#pragma mark---查，返回bool（聊天）

-(BOOL )searchOneUerWithID:(NSString *)userId
{
    NSString *sql=@"select name from ChatUsers where  userId=?";
    FMResultSet *set=[_fmdb executeQuery:sql,userId];
    BOOL success=[set next];
    if (success) {
//        NSLog(@"查找成功");
    }
    else{
//        NSLog(@"没有找到%@",_fmdb.lastErrorMessage);
    }
    return success;
}

#pragma mark---查返回对象（聊天）
-(ChatUserModel *)searchOneUerWithUserID:(NSString *)userId
{
    NSString *sql=@"select name from ChatUsers where  userId=?";
    FMResultSet *set=[_fmdb executeQuery:sql,userId];
    BOOL success=[set next];
    if (success) {
//        NSLog(@"查找成功");
        ChatUserModel *chatUserModel=[[ChatUserModel alloc]init];
        chatUserModel.userId       =[set stringForColumn:@"userId"];
        chatUserModel.name         =[set stringForColumn:@"name"];
        chatUserModel.portraitUri  =[set stringForColumn:@"portraitUri"];
        chatUserModel.token        =[set stringForColumn:@"token"];
        return chatUserModel;
    }
    else{
//        NSLog(@"没有找到%@",_fmdb.lastErrorMessage);
    }
    return nil;
}


#pragma mark---查看所有,返回ChatUserModel对象数组（聊天）

-(NSArray *)recieveChatUsers
{
    /* 查询所有的数据select * from 表名 */
    
    NSString *sql=@"select * from ChatUsers";
    
    FMResultSet *set=[_fmdb executeQuery:sql];
    
    NSMutableArray *array=[NSMutableArray array];
    
    while ([set next]) {
        NSDictionary *dic=[set resultDictionary];
        ChatUserModel *chatUserModel=[[ChatUserModel alloc]mj_setKeyValues:dic];
        [array addObject:chatUserModel];
    }
    return array;
}

@end











