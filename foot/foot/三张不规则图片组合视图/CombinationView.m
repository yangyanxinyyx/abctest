//
//  CombinationView.m
//  UIImageView的不规则
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 严玉鑫. All rights reserved.
//

#import "CombinationView.h"

@implementation CombinationView
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
       self.shapedImageV = [[ShapedImageView alloc]initWithFrame:CGRectMake(0,0, frame.size.width,(450)/3)];
        [self addSubview:_shapedImageV];
        self.midImageV = [[MidImageView alloc]initWithFrame:CGRectMake(0, (450)/3-8, frame.size.width, (450)/3+8)];
        [self addSubview:_midImageV];
        self.endImageV = [[EndImageView alloc]initWithFrame:CGRectMake(0, 2*(450)/3-8,frame.size.width, (450)/3+8)];
        [self addSubview:_endImageV];
        self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(130, 460, 100, 20)];
        self.labelTitle.textAlignment = NSTextAlignmentCenter;
        self.labelTitle.textColor = [UIColor blackColor];

        [self addSubview:self.labelTitle];
    }
    return self;
}

@end
