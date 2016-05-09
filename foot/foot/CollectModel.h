//
//  CollectModel.h
//  foot
//
//  Created by lanou on 16/5/9.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "FoodModel.h"

@interface CollectModel : FoodModel

@property(nonatomic,strong)NSString *topImage;
@property(nonatomic,strong)NSString *foodName;

@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *urlId;
@property(nonatomic,strong)NSDictionary *parDic;
@property(nonatomic,strong)NSDictionary *header;

@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *foodId;

@property(nonatomic,strong)NSDictionary *materiaDic;
@property(nonatomic,strong)NSDictionary *stepDic;
@property(nonatomic,strong)NSDictionary *tipDic;

@end
