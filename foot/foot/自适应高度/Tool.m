//
//  Tool.m
//  UI12_cell自适应
//
//  Created by lanou on 16/1/28.
//  Copyright © 2016年 严玉鑫. All rights reserved.
//

#import "Tool.h"

@implementation Tool
-(CGFloat)getImageHeight:(NSString *)picName{
    
    UIImage *image = [UIImage imageNamed:picName];
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    
    
    return (375*h)/w;
}
-(CGFloat)getLabelHeight:(NSString *)content font:(UIFont *)font{
        CGSize size = CGSizeMake(375, 100000);    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGRect rect = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
        return rect.size.height;
    
}

@end
