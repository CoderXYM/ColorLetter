//
//  FZY_DataHandle.m
//  ColorLetter
//
//  Created by dllo on 16/10/31.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_DataHandle.h"
#import "FZY_User.h"

@interface FZY_DataHandle ()

@property (nonatomic, strong) FMDatabaseQueue *myQueue;

@end

@implementation FZY_DataHandle

+ (FZY_DataHandle *)shareDatahandle {
    static FZY_DataHandle *data = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[FZY_DataHandle alloc] init];
    });
    return data;
}



- (void)open {
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"user.sqlite"];
    
//    //2.获得数据库
//    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
//    
//    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
//    if ([db open]) {
//        //4.创表
//        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS user (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
//        if (result) {
//            NSLog(@"创建表成功");
//        }
//    }
    
    self.myQueue = [FMDatabaseQueue databaseQueueWithPath:fileName];
    [_myQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSLog(@"打开成功");
            if ([db executeUpdate:@"create table if not exists user (user_id integer primary key autoincrement, name text NOT NULL, imageUrl text)"]) {
                NSLog(@"创建成功");
            }else {
                NSLog(@"创建失败");
            }
        }else {
            NSLog(@"打开失败");
        }
    }];
}

//- (void)createTable {
//    [self.myQueue inDatabase:^(FMDatabase *db) {
//        if ([db executeUpdate:@"create table if not exists user (user_id integer primary key autoincrement, name text, imageUrl text)"]) {
//            NSLog(@"创建成功");
//        }else {
//            NSLog(@"创建失败");
//        }
//    }];
//}

- (void)insert:(FZY_User *)user {
    [self.myQueue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdateWithFormat:@"insert into user values (null, '%@', '%@')", user.name, user.imageUrl]) {
            NSLog(@"插入成功");
        }else {
            NSLog(@"插入失败");
        }
        
    }];
}

- (void)delete:(FZY_User *)user {
    [self.myQueue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdateWithFormat:@"delete from user where name = %@;",user.name]) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }];
}

- (void)update:(FZY_User *)user new:(FZY_User *)new {
    [self.myQueue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdate:[NSString stringWithFormat:@"update user set imageurl = '%@' where imageUrl = '%@'", new.imageUrl, user.imageUrl]]) {
            NSLog(@"修改成功");
        }else {
            NSLog(@"修改失败");
        }
    }];
}

//查询
-(void)select:(FZY_User *)user{

    [self.myQueue inDatabase:^(FMDatabase *db) {
        NSString *select;
        if (nil == user) {
            select = [NSString stringWithFormat:@"select * from user"];
        }else {
            select = [NSString stringWithFormat:@"select from user where name = '%@'", user.name];
        }
        FMResultSet *Set = [db executeQuery:select];
        while ([Set next]) {
            FZY_User * model = [[FZY_User alloc] init];
            // 从结果集中获取数据
            // 注：sqlite数据库不区别分大小写
            model.name = [Set stringForColumn:@"name"];
            model.imageUrl= [Set stringForColumn:@"imageUrl"];
//            model.stuheadimage=[set dataForColumn:@"headimage"];
            NSLog(@"%@", model);
        }
        
    }];
}


@end
