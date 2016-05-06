//
//  VideoModel.h
//  foot
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "FoodModel.h"

@interface VideoModel : FoodModel
@property (nonatomic,strong)NSString *pic;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *intro;
@property (nonatomic,strong)NSString *browse;
@property (nonatomic,strong)NSString *collect;
@property (nonatomic,strong)NSString *video_url;
@property (nonatomic,strong)NSString *videoID;
@end
