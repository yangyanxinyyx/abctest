//
//  CookDetailsViewController.h
//  foot
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "FoodViewController.h"

@interface CookDetailsViewController : FoodViewController

@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSDictionary *parDic;
@property(nonatomic,strong)NSDictionary *header;
@property(nonatomic,assign)NSInteger urlId;

@property(nonatomic,strong)NSString *content; //食材组合 需要传的菜品描述
@property(nonatomic,strong)NSString *foodName; //食材组合 传菜名
@property(nonatomic,strong)NSString *foodId;   //食材组合 传菜id

@end
