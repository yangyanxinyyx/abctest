//
//  GuideImageView.m
//  foot
//
//  Created by lanou on 16/5/13.
//  Copyright © 2016年 念恩. All rights reserved.
//
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#import "GuideImageView.h"

@implementation GuideImageView

-(instancetype)initWithFrame:(CGRect)framel{
    if (self = [super initWithFrame:framel]) {
        [self addSubview:self.scroll];

       
        
        
    }
    return self;
}
//懒加载
-(UIScrollView *)scroll{
    if (!_scroll) {
        self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        self.scroll.contentSize = CGSizeMake(KScreenWidth*4, KScreenHeight);
        self.scroll.bounces = NO;
        _scroll.pagingEnabled = YES;
        _scroll.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i<3; i++) {
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth*i, 0, KScreenWidth, KScreenHeight)];
            [_scroll addSubview:imageV];
            //添加图片
            NSString *name = [NSString stringWithFormat:@"引导图%d",i+1];
            UIImage *image = [UIImage imageNamed:name];
            imageV.image = image;
            
        }
        [self.scroll addSubview:self.imageV1];
        [self.scroll addSubview:self.imageV2];
        [_scroll addSubview:self.button];
    }
    return _scroll;
}
-(UIImageView *)imageV1{
    if (!_imageV1) {
        self.imageV1 = [[UIImageView alloc]init];
        _imageV1.frame = CGRectMake(KScreenWidth*3, 0, KScreenWidth/2, KScreenHeight);
        UIImage *image = [UIImage imageNamed:@"引导图4"];
        CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, image.size.width/2, image.size.height));
        _imageV1.image = [UIImage imageWithCGImage:ref];
    }
    return _imageV1;
}-(UIImageView *)imageV2{
    if (!_imageV2) {
        self.imageV2 = [[UIImageView alloc]init];
        _imageV2.frame = CGRectMake(KScreenWidth*3.5, 0, KScreenWidth/2, KScreenHeight);
        UIImage *image = [UIImage imageNamed:@"引导图4"];
        CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(image.size.width/2, 0, image.size.width/2, image.size.height));
        _imageV2.image = [UIImage imageWithCGImage:ref];
    }
    return _imageV2;
}
-(UIButton *)button{
    if (!_button) {
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(KScreenWidth*3.5-60, 540*KScreenWidth/375, 120, 40);
//        _button.backgroundColor = [UIColor orangeColor];
    [_button setShowsTouchWhenHighlighted:YES];
    [_button addTarget:self action:@selector(toucheButtonValue) forControlEvents:UIControlEventTouchDown];
 
    }
    return _button;
    
}
-(void)toucheButtonValue{
    [UIView animateWithDuration:1 animations:^{
        
        self.imageV1.transform = CGAffineTransformMakeTranslation(-KScreenWidth, 0);
        self.imageV2.transform = CGAffineTransformMakeTranslation(KScreenWidth/2,0);


        
    } completion:^(BOOL finished) {
        //添加标记
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        [userD setValue:@"yes" forKey:@"标记"];
        
        [self removeFromSuperview];
        [self.delegate toucheToMain];
        
    }];

}
@end
