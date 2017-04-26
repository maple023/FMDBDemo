//
//  DatabaseCenter.m
//  FMDBDemo
//
//  Created by happi on 2017/4/26.
//  Copyright © 2017年 xishan. All rights reserved.
//

#import "DatabaseCenter.h"

#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__);} }
#define VersionKey @"VersionKey"
#define DBVersion 1

@implementation DatabaseCenter

/**
 *  初始化数据库 判断版本 是否需要 创建 更新
 */
+ (void)initDatabase {
    NSLog(@"==>%@",[DatabaseCenter dataFilePath]);
    //获取当前版本号
    NSInteger currVersion = [[NSUserDefaults standardUserDefaults] integerForKey:VersionKey];
    //数据是否存在
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:[DatabaseCenter dataFilePath]];
    if (!fileExist) {
        DatabaseCenter *db = [[DatabaseCenter alloc] init];
        if ([db getDB]) {
            [db createTables];
            [db updateTables];
            [db closeDB];
            [[NSUserDefaults standardUserDefaults] setInteger:DBVersion forKey:VersionKey];
        }
    } else if (currVersion < DBVersion) {
        DatabaseCenter *db = [[DatabaseCenter alloc] init];
        if ([db getDB]) {
            [db updateTables];
            [db closeDB];
            [[NSUserDefaults standardUserDefaults] setInteger:DBVersion forKey:VersionKey];
        }
    }
    
}

+ (NSString *)dataFilePath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    return [path stringByAppendingPathComponent:DatabaseName];
}



- (BOOL)getDB {
    NSString* filePath = [DatabaseCenter dataFilePath];
    _db = [FMDatabase databaseWithPath:filePath];
    if (![self.db open]) {
        return false;
    }
    [_db setShouldCacheStatements:YES];
    _queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    FMDBQuickCheck(_queue);
    return true;
}

- (void)closeDB {
    [_db close];
}

- (void)createTables {
    //用户信息表
    [_db executeUpdate:@"create table if not exists user(ID integer primary key,name text,age integer,sex text)"];
    
}
//数据库升级增加表字段
- (void)updateTables {
    [self updateTableName:@"user" Column:@"height" type:@"double"];
    [self updateTableName:@"user" Column:@"weight" type:@"double"];
    [self updateTableName:@"user" Column:@"autograph" type:@"text"];
}
/**
 *  给某个表添加一个字段
 *  tableName   表名
 *  column      字段名
 *  type        数据类型 integer double text ...
 */
- (void)updateTableName:(NSString *)tableName Column:(NSString *)column type:(NSString *)type {
    //1、判读字段是否存在  [db columnExists:@"需要增加的字段" inTableWithName:@"表名"]
    if (![_db columnExists:column inTableWithName:tableName]){
        [self.queue inDatabase:^(FMDatabase *db) {
            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@",tableName,column,type];
            BOOL worked = [_db executeUpdate:alertStr];
            FMDBQuickCheck(worked);
        }];
    } else {
        NSLog(@"字段存在");
    }
}









//添加一条用户信息
- (void)insertUser:(NSString *)name Age:(NSInteger)age Sex:(NSString *)sex{
    [self.queue inDatabase:^(FMDatabase *db) {
        [self.db executeUpdate:@"insert into user(name ,age ,sex) values (?, ?, ?)" ,
         name,
         [NSNumber numberWithInteger:age],
         sex
         ];
    }];
}

- (void)insertUser:(NSString *)name Age:(NSInteger)age Sex:(NSString *)sex Height:(double)height Weight:(double)weight Autograph:(NSString *)autograph{
    [self.queue inDatabase:^(FMDatabase *db) {
        [self.db executeUpdate:@"insert into user(name, age, sex, height, weight, autograph) values (?, ?, ?, ?, ?, ?)" ,
         name,
         [NSNumber numberWithInteger:age],
         sex,
         [NSNumber numberWithDouble:height],
         [NSNumber numberWithDouble:weight],
         autograph
         ];
    }];
}


//删除一条订单记录
- (void)deleteUserID:(NSInteger)ID {
    [self.queue inDatabase:^(FMDatabase *db) {
        [self.db executeUpdate:@"delete from user where ID = ?",
         [NSNumber numberWithInteger:ID]
         ];
    }];
}

//更新一条商品订单记录 的 COUNT
- (void)updateUserName:(NSString *)name Age:(NSInteger)age{
    [self.queue inDatabase:^(FMDatabase *db) {
        [self.db executeUpdate:@"update user set age = ? where  name = ?",
         [NSNumber numberWithInteger:age],
         name
         ];
    }];
}

- (NSMutableArray *)getUser {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [self.db executeQuery:@"SELECT * FROM user"];
        while ([rs next]) {
            
            NSMutableDictionary *user = [[NSMutableDictionary alloc] initWithCapacity:3];
            [user setValue:[rs stringForColumn:@"name"] forKey:@"name"];
            [user setValue:[NSNumber numberWithInteger:[rs intForColumn:@"age"]] forKey:@"age"];
            [user setValue:[rs stringForColumn:@"sex"] forKey:@"sex"];
            [user setValue:[NSNumber numberWithDouble:[rs doubleForColumn:@"height"]] forKey:@"height"];
            [user setValue:[NSNumber numberWithDouble:[rs doubleForColumn:@"weight"]] forKey:@"weight"];
            [user setValue:[rs stringForColumn:@"autograph"] forKey:@"autograph"];
            [array addObject:user];
        }
    }];
    return array;
}


@end
