//
//  StepModel.h
//  foot
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "FoodModel.h"

@interface StepModel : FoodModel

@property(nonatomic,strong)NSString *stepImage; //步骤图片
@property(nonatomic,strong)NSString *stepDetails; //步骤
@property(nonatomic,assign)NSInteger ordernum; //步骤序号

@end
