//
//  UploadView.m
//  foot
//
//  Created by lanou on 16/5/12.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "UploadView.h"

@implementation UploadView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];

        view.center = self.center;
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.7;
        UIActivityIndicatorView *activityV = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityV.center = CGPointMake(50, 50);
        [view addSubview:activityV];
        [activityV startAnimating];
        [self addSubview:view];
//        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
    }
    return self;
}

@end
