//
//  HomeFootModel.m
//  foot
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "HomeFootModel.h"

@implementation HomeFootModel
-(void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues{
    
   self.idFood = [keyedValues objectForKey:@"id"];
    self.descriptionFood = [keyedValues objectForKey:@"description"];
    self.name = [keyedValues objectForKey:@"name"];
    self.imageid = [keyedValues objectForKey:@"imageid"];
}
@end
