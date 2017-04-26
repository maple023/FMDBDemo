//
//  DatabaseCenter.h
//  FMDBDemo
//
//  Created by happi on 2017/4/26.
//  Copyright © 2017年 xishan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__);} }
#define DatabaseName @"FMDNDemo.db"

@interface DatabaseCenter : NSObject

@property(nonatomic,retain)FMDatabase* db;
@property(nonatomic,retain)FMDatabaseQueue *queue;

+ (void)initDatabase;//初始化数据库
- (BOOL)getDB;
- (void)closeDB;
//- (void)createTables;
//- (void)updateTables;


- (void)insertUser:(NSString *)name Age:(NSInteger)age Sex:(NSString *)sex;
- (void)insertUser:(NSString *)name Age:(NSInteger)age Sex:(NSString *)sex Height:(double)height Weight:(double)weight Autograph:(NSString *)autograph;
- (void)deleteUserID:(NSInteger)ID;
- (void)updateUserName:(NSString *)name Age:(NSInteger)age;
- (NSMutableArray *)getUser;

@end
