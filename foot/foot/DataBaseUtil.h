//
//  DataBaseUtil.h
//  foot
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryModel.h"
#import "CollectModel.h"
@interface DataBaseUtil : NSObject
//单列
+(instancetype)shareDataBase;
//建表
-(BOOL)createTable;
//添加
-(BOOL)insertModel:(HistoryModel*)model;
//删除数据的方法
-(BOOL)deleteModelWithContent:(NSString *)content;
//删除全部数据
-(BOOL)deleteMode;
//查询获取数据
-(NSArray *)selectModel;
//查询单个对象
-(HistoryModel *)selectModelWithContent:(NSString *)content;


//收藏
-(BOOL)createCollectTable;

-(BOOL)insertCollectModel:(CollectModel *)model;

-(BOOL)deleteCollectWithFoodName:(NSString *)name urlId:(NSString *)urlId;

-(CollectModel *)selectCollectWithFoodName:(NSString *)name urlId:(NSString *)urlId;

-(NSMutableArray*)selectCollectModel;
@end
