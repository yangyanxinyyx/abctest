//
//  FoodDetailsModel.h
//  foot
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "FoodModel.h"

@interface FoodDetailsModel : FoodModel

@property(nonatomic,strong)NSString *topImage;//大图
@property(nonatomic,strong)NSString *name; //菜名
@property(nonatomic,strong)NSString *level; //难易度
@property(nonatomic,strong)NSString *cookTime; //烹饪时间
@property(nonatomic,strong)NSString *introduce; //描述介绍
@property(nonatomic,strong)NSArray *materiaArray; //材料数组
@property(nonatomic,strong)NSArray *stepArray; // 步骤
@property(nonatomic,strong)NSArray *tipArray; //小贴士数组

@end
