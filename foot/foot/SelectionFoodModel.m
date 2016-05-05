//
//  SelectionFoodModel.m
//  foot
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "SelectionFoodModel.h"

@implementation SelectionFoodModel
-(void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues{
    
    self.aid =[keyedValues objectForKey:@"id"];
    self.img = [keyedValues objectForKey:@"img"];
    self.n = [keyedValues objectForKey:@"n"];
    self.vc = [keyedValues objectForKey:@"vc"];
    self.fc = [keyedValues objectForKey:@"fc"];
    
}
@end
