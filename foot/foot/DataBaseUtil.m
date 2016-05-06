//
//  DataBaseUtil.m
//  foot
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "DataBaseUtil.h"
#import "FMDatabase.h"

static DataBaseUtil *dataBase = nil;
@interface DataBaseUtil ()
@property (nonatomic,strong)FMDatabase *db;
@end

@implementation DataBaseUtil
+(instancetype)shareDataBase{
    if (dataBase == nil) {
        dataBase = [[DataBaseUtil alloc]init];
    }
    return dataBase;
}
-(instancetype)init{
    
    if (self = [super init]) {
        
        NSString *pathDoc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString *pathDB = [pathDoc stringByAppendingPathComponent:@"数据库.sqlite"];
        _db = [FMDatabase databaseWithPath:pathDB];
        NSLog(@"%@",pathDB);
    }
    return self;
}
//建表
-(BOOL)createTable{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"create table if not exists HistorySql (id integer primary key autoincrement,content text)"];
        BOOL result = [_db executeUpdate:sql];
        [_db close];
        return result;
    }
    return NO;
}
//增
-(BOOL)insertModel:(HistoryModel *)model{
    if ([_db open]) {
        
        NSString *sql = [NSString stringWithFormat:@"insert into HistorySql (content) values ('%@')",model.content];
        BOOL result = [_db executeUpdate:sql];
        [_db close];
        if (result) {
            NSLog(@"添加成功");
        }
        return result;
    }
    return NO;
}
//删单个
-(BOOL)deleteModelWithContent:(NSString *)content{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from HistorySql where content = '%@'",content];
        BOOL result = [_db executeUpdate:sql];
        [_db close];
        if (result) {
            NSLog(@"删除成功");
        }
        return result;
    }
    return NO;
}
//删除全部
-(BOOL)deleteMode{
    
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from HistorySql"];
        BOOL result = [_db executeUpdate:sql];
        if (result) {
            NSLog(@"删除全部");
        }
        [_db close];
        return  result;
    }
    
    return NO;
}
//查全部数据
-(NSArray*)selectModel{
    NSMutableArray *array = [NSMutableArray array];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from HistorySql"];
        FMResultSet *set = [_db executeQuery:sql];
        while ([set next]) {
            NSString *content = [set stringForColumn:@"content"];
            HistoryModel *model = [[HistoryModel alloc]init];
            model.content = content;
            [array addObject:model];
        }
        [_db close];
    }
    
    return array;
}
//查单个
-(HistoryModel *)selectModelWithContent:(NSString *)content{
    
        HistoryModel *model = [[HistoryModel alloc]init];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from HistorySql where content = '%@'",content];
        FMResultSet *set = [_db executeQuery:sql];
        while ([set next]) {

            NSString *content = [set stringForColumn:@"content"];
            model.content = content;
  
           }
        [_db close];
       
    }
    
        return model;
    
}
@end
