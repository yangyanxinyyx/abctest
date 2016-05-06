//
//  TipView.m
//  foot
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "TipView.h"
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define Color(x,y,z,a) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a]
@implementation TipView

-(instancetype)initWithFrame:(CGRect)frame tipTitle:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        
        UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(5, 7, 7, 7)];
        pointView.layer.cornerRadius = 3.5;
        pointView.layer.masksToBounds = YES;
        pointView.backgroundColor = Color(228, 53, 42, 1);
        [self addSubview:pointView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, SCREEN_W - 13 -10, 0)];
        titleLabel.text = title;
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        CGSize size = CGSizeMake(SCREEN_W - 13 - 10, MAXFLOAT);
        CGSize size1 = [titleLabel sizeThatFits:size];
        CGRect frame = titleLabel.frame;
        frame.size.height = size1.height;
        titleLabel.frame = frame;
        [self addSubview:titleLabel];
        CGRect selfFrame = self.frame;
        selfFrame.size.height = titleLabel.frame.size.height + 10;
        self.frame = selfFrame;
        
    }
    return self;
}

@end
