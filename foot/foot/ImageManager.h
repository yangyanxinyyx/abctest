//
//  ImageManager.h
//  foot
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "FoodModel.h"
#import <UIKit/UIKit.h>
@interface ImageManager : FoodModel
+(instancetype)shareImageManger;
-(UIImage *)oldImage:(UIImage *)image scaleToSize :(CGSize)size;
@end
