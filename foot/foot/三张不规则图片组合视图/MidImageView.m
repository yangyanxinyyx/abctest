
//
//  MidImageView.m
//  UIImageView的不规则
//
//  Created by lanou on 16/4/28.
//  Copyright © 2016年 严玉鑫. All rights reserved.
//

#import "MidImageView.h"

@implementation MidImageView
-(void)setup{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint origin = self.bounds.origin;
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGPathMoveToPoint(path, NULL, origin.x, origin.y );//点到点
    CGPathAddLineToPoint(path, NULL,origin.x + width,origin.y+20);
    CGPathAddLineToPoint(path, NULL, origin.x + width, origin.y +height -20);
    CGPathAddLineToPoint(path, NULL, origin.x, origin.y +height );
    
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.path = path;
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    _maskLayer.strokeColor = [UIColor redColor].CGColor;
    _maskLayer.frame = self.bounds;
    _maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;//非常关键设置自动拉伸的效果且不变形
    
    _contentLayer = [CALayer layer];
    _contentLayer.mask = _maskLayer;
    _contentLayer.frame = self.bounds;
    [self.layer addSublayer:_contentLayer];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.labelName.frame = CGRectMake(10, self.frame.size.height -60, 100, 20);
//    self.labelName.backgroundColor = [UIColor blackColor];
    self.labelName.textAlignment = NSTextAlignmentLeft;
    self.labelIntroduce.textAlignment = NSTextAlignmentLeft;
}

@end
