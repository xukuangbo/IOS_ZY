//
//  FHFDBManager.h
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

//地名库模型
#import "ZYZCViewSpotModel.h"
//聊天人模型
#import "ChatUserModel.h"

typedef void (^DoFinish)(BOOL doSuccess);

@interface ZYZCDataBase : NSObject

+(instancetype )sharedDBManager;

/**
 *  创建表单
 */
-(void)createTables;
/**
 *  增
 */
-(BOOL)insertDataWithId:(NSNumber *)dataId andType:(NSNumber *)type andName:(NSString *)name  andCountry:(NSString *)country  andPinyin:(NSString *)pinyin;
/**
 *  查
 */
-(OneSpotModel *) searchOneDataWithName:(NSString *)name;

/**
 *  获取所有数据
 */
-(NSArray *)recieveDBData;

/**
 *  删除所有数据
 */
-(BOOL)deleteAllDataWithBlock:(DoFinish )doFinish;

/**
 *  存储数据到数据库
 */
-(void)saveDataWithFinishBlock:(DoFinish )doFinish;

/**
 *  拼音匹配
 */
-(NSArray*)queryWithPinyinCondition:(NSString *)condition;
/**
 *  文字匹配
 */
-(NSArray*)queryWithStrCondition:(NSString *)condition;


//========================
//聊天信息

/**
 *  增
 */
-(BOOL)insertDataWithUserId:(NSString *)userId andName:(NSString *)name andportraitUri:(NSString *)portraitUri andToken:(NSString *)token;
/**
 *    查,返回对象
 */
-(ChatUserModel *)searchOneUerWithUserID:(NSString *)userId;
/**
 *  查看所有,返回ChatUserModel对象数组
 */
-(NSArray *)recieveChatUsers;

@end
