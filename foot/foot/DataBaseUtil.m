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

#pragma -mark  收藏
//建表
-(BOOL)createCollectTable{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"create table if not exists CollectSql (id integer primary key autoincrement,topImage text,foodName text,url text,urlId text,parDic blob,header blob,content text,foodId text,materiaDic blob,stepDic blob,tipDic blob)"];
        BOOL result = [_db executeUpdate:sql];
        [_db close];
        return result;
    }
    return NO;
}
//增
-(BOOL)insertCollectModel:(CollectModel *)model{
    if ([_db open]) {
        
        NSData *parDic = [self setDicToNSData:model.parDic];
        NSData *header = [self setDicToNSData:model.header];
        NSData *materiaDic = [self setDicToNSData:model.materiaDic];
        NSData *stepDic = [self setDicToNSData:model.stepDic];
        NSData *tipDic = [self setDicToNSData:model.tipDic];
        
        BOOL result = [_db executeUpdate:@"insert into CollectSql (topImage,foodName,url,urlId,parDic,header,content,foodId,materiaDic,stepDic,tipDic) values (?,?,?,?,?,?,?,?,?,?,?)",model.topImage,model.foodName,model.url,model.urlId,parDic,header,model.content,model.foodId,materiaDic,stepDic,tipDic];
        [_db close];
        if (result) {
            NSLog(@"添加成功");
        }
        return result;
    }
    return NO;
}

//删单个
-(BOOL)deleteCollectWithFoodName:(NSString *)name urlId:(NSString *)urlId{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from CollectSql where foodName = '%@' and urlId = '%@'",name,urlId];
        BOOL result = [_db executeUpdate:sql];
        [_db close];
        if (result) {
            NSLog(@"删除成功");
        }
        return result;
    }
    return NO;
}

//查单个
-(CollectModel *)selectCollectWithFoodName:(NSString *)name urlId:(NSString *)urlId{
    
    CollectModel *model = [[CollectModel alloc]init];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from CollectSql where foodName = '%@' and urlId = '%@'",name,urlId];
        FMResultSet *set = [_db executeQuery:sql];
        while ([set next]) {
            
            NSString *foodName = [set stringForColumn:@"foodName"];
            model.foodName = foodName;
            
            NSString *Id = [set stringForColumn:@"urlId"];
            model.urlId = Id;
            
        }
        [_db close];
        
    }
    
    return model;
    
}


-(NSMutableArray*)selectCollectModel{
    NSMutableArray *array = [NSMutableArray array];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from CollectSql"];
        FMResultSet *set = [_db executeQuery:sql];
        while ([set next]) {
          
            NSString *topImage = [set stringForColumn:@"topImage"];
            NSString *foodName = [set stringForColumn:@"foodName"];
            NSString *url = [set stringForColumn:@"url"];
            NSString *urlId = [set stringForColumn:@"urlId"];
            NSData *dataParDic = [set dataForColumn:@"parDic"];
            NSDictionary *parDic = [self setNSDataToDic:dataParDic];
            NSData *dataHeader = [set dataForColumn:@"header"];
            NSDictionary *header = [self setNSDataToDic:dataHeader];
            NSString *content = [set stringForColumn:@"content"];
            NSString *foodId = [set stringForColumn:@"foodId"];
            NSData *dataMateriaDic = [set dataForColumn:@"materiaDic"];
            NSDictionary *materiaDic = [self setNSDataToDic:dataMateriaDic];
            NSData *dataStepDic = [set dataForColumn:@"stepDic"];
            NSDictionary *stepDic = [self setNSDataToDic:dataStepDic];
            NSData *dataTipDic = [set dataForColumn:@"tipDic"];
            NSDictionary *tipDic = [self setNSDataToDic:dataTipDic];
            
            CollectModel *model = [[CollectModel alloc]init];
            model.topImage = topImage;
            model.foodName = foodName;
            model.url = url;
            model.urlId = urlId;
            model.parDic = parDic;
            model.header = header;
            model.content = content;
            model.foodId = foodId;
            model.materiaDic = materiaDic;
            model.stepDic = stepDic;
            model.tipDic = tipDic;
         
            [array addObject:model];
        }
        [_db close];
    }
    
    return array;
}

-(BOOL)deleteCollectAll
{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from CollectSql"];
        BOOL result = [_db executeUpdate:sql];
        if (result) {
            NSLog(@"删除全部成功");
        }
        [_db close];
        return result;
    }
    return NO;
}



#pragma -mark 将字典转为NSData
-(NSData *)setDicToNSData:(NSDictionary *)dic
{
    //创建数组存放所有键值对
    NSMutableArray *dicArray = [NSMutableArray array];
    for (NSString *key in dic) {
        NSString *keyAndValue = [NSString stringWithFormat:@"%@=%@",key,dic[key]];
        [dicArray addObject:keyAndValue];
    }
    
    //将数组转为字符串
    NSString *str = [dicArray componentsJoinedByString:@"&"];
    
    //将字符串转为NSData
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

#pragma -mark 将NSData转为字典
-(NSDictionary *)setNSDataToDic:(NSData *)data
{
    if (data != nil) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *dicArray = [str componentsSeparatedByString:@"&"];
        NSMutableArray *keyArray = [NSMutableArray array];
        NSMutableArray *valueArray = [NSMutableArray array];
        
        for (NSString *string in dicArray) {
            
            NSArray *array = [string componentsSeparatedByString:@"="];
            [keyArray addObject:array[0]];
            [valueArray addObject:array[1]];
            
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (int i = 0; i<keyArray.count; i++) {
            [dic setValue:valueArray[i] forKey:keyArray[i]];
        }
        return dic;
    }else
    {
        return nil;
    }
   
}

@end