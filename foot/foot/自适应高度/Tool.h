//
//  Tool.h
//  UI12_cell自适应
//
//  Created by lanou on 16/1/28.
//  Copyright © 2016年 严玉鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Tool : NSObject
//计算图片高度的方法
-(CGFloat)getImageHeight:(NSString *)picName;
//计算label高度的方法;
-(CGFloat)getLabelHeight:(NSString *)content font:(UIFont*)font;

@end
