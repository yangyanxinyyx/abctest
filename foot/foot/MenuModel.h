//
//  Menu.h
//  foot
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "FoodModel.h"

@interface MenuModel : FoodModel

@property(nonatomic,strong)NSString *name; //详细的分类
@property(nonatomic,strong)NSString *identify; //分类的id
@property(nonatomic,strong)NSString *imageUrl;  //分类的图片


@end
