//
//  MixFoodModel.h
//  foot
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "FoodModel.h"

@interface MixFoodModel : FoodModel

@property(nonatomic,strong)NSString *image;
@property(nonatomic,strong)NSString *text;
@property(nonatomic,strong)NSArray *data;

@property(nonatomic,assign)BOOL isSelect;
@end
