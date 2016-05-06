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

@end
