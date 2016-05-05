//
//  MenuListModel.h
//  foot
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "FoodModel.h"

@interface MenuListModel : FoodModel

@property(nonatomic,strong)NSString *title; //描述
@property(nonatomic,strong)NSString *identifiy;   //菜品id
@property(nonatomic,strong)NSString *imageUrl; //菜品图片
@property(nonatomic,strong)NSString *name; //菜品名字
@property(nonatomic,strong)NSString *collectCount; //收藏数

@end
