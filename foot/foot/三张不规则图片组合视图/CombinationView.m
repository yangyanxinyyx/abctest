//
//  CombinationView.m
//  UIImageView的不规则
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 严玉鑫. All rights reserved.
//

#import "CombinationView.h"
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation CombinationView
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5;
#pragma mark第一张图片
       self.shapedImageV = [[ShapedImageView alloc]initWithFrame:CGRectMake(0,0, frame.size.width,(frame.size.height -50)/3)];
        [self addSubview:_shapedImageV];
    
#pragma mark第2张图片
        self.midImageV = [[MidImageView alloc]initWithFrame:CGRectMake(0, (frame.size.height -50)/3-8, frame.size.width, (frame.size.height -50)/3+8)];
        [self addSubview:_midImageV];
        
#pragma mark第3张图片
        self.endImageV = [[EndImageView alloc]initWithFrame:CGRectMake(0, 2*(frame.size.height -50)/3-8,frame.size.width, (frame.size.height -50)/3+8)];
        [self addSubview:_endImageV];
   
        
        self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake((KScreenWidth-100)/2-10, frame.size.height-40, 100, 20)];
        self.labelTitle.textAlignment = NSTextAlignmentCenter;
        self.labelTitle.textColor = [UIColor blackColor];

        [self addSubview:self.labelTitle];
    }
    return self;
}

@end
