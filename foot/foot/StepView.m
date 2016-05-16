//
//  StepView.m
//  foot
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "StepView.h"
#import "UIImageView+WebCache.h"
#define SCREEN_W [UIScreen mainScreen].bounds.size.width

@interface StepView ()

{
    float _height;
}

@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *label;

@end

@implementation StepView

-(instancetype)initWithFrame:(CGRect)frame image:(NSString *)image title:(NSString *)title ordernum:(NSInteger)ordernum
{
    if (self = [super initWithFrame:frame]) {
        
        if (image.length>0) {
            self.imageV = [[UIImageView alloc] init];
            self.imageV.contentMode = UIViewContentModeScaleAspectFill;
            self.imageV.clipsToBounds = YES;
            [self.imageV sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"等待占位图"]];
            [self addSubview:self.imageV];
        }
        
        self.label = [[UILabel alloc] init];
        [self addSubview:self.label];
        if ([title containsString:@"."]) {
            title = [title substringFromIndex:3];
        }
        NSString *str = [NSString stringWithFormat:@"%ld. %@",ordernum,title];
        self.label.text = str;
        
        
        self.label.frame = CGRectMake(20, 0, SCREEN_W - 40, 0);
        if (self.imageV) {
            self.imageV.frame = CGRectMake(20, 0, SCREEN_W - 40, (SCREEN_W-20)/1.7);
            
            self.label.frame = CGRectMake(20, (SCREEN_W-20)/1.7 + 10, SCREEN_W - 40, 0);
            
        }   
        self.label.numberOfLines = 0;
        self.label.lineBreakMode = NSLineBreakByCharWrapping;
        CGSize size = [self.label sizeThatFits:CGSizeMake(self.label.frame.size.width, MAXFLOAT)];
        CGRect frame = self.label.frame;
        frame.size.height = size.height + 10;
        self.label.frame = frame;
        
        
        
        _height = frame.size.height + 10 + self.imageV.frame.size.height;
        CGRect rect = self.frame;
        rect.size.height = _height;
        self.frame = rect;
//        NSLog(@"%f",self.frame.size.height);
        
    }
    return self;
}


@end
