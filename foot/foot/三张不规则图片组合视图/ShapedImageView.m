
//
//  ShapedImageView.m
//  UIImageView的不规则
//
//  Created by lanou on 16/4/28.
//  Copyright © 2016年 严玉鑫. All rights reserved.
//

#import "ShapedImageView.h"

@implementation ShapedImageView
-(instancetype)initWithFrame:(CGRect)frame{
    self.frame = frame;
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toucheImageView)];
        [self addGestureRecognizer:tapGest];
        [self setup];
        self.labelName = [[UILabel alloc]init];
        [self addSubview:self.labelName];
        self.labelIntroduce = [[UILabel alloc]init];
        [self addSubview:self.labelIntroduce];
        
    }
    return self;
}

-(void)setup
{

   CGMutablePathRef path = CGPathCreateMutable();
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGPathMoveToPoint(path, NULL, 0, 0);//点到点
    CGPathAddLineToPoint(path, NULL, width,0);
    CGPathAddLineToPoint(path, NULL, width,height);
    CGPathAddLineToPoint(path, NULL, 0,height -20);
    
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
    self.labelName.frame = CGRectMake(self.frame.size.width -150, self.frame.size.height-60, 150, 20);
    self.labelName.textAlignment = NSTextAlignmentRight;
    self.labelName.textColor = [UIColor whiteColor];
    self.labelName.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];

    self.labelIntroduce.frame = CGRectMake(10, self.frame.size.height-40, self.frame.size.width-20, 15);
    self.labelIntroduce.textAlignment = NSTextAlignmentRight;
    self.labelIntroduce.textColor = [UIColor whiteColor];
    self.labelIntroduce.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];

    
}
-(void)setImage:(UIImage *)image{
    
    _contentLayer.contents = (id)image.CGImage;
    
}
-(void)toucheImageView{
    NSLog(@"q");
}
@end
