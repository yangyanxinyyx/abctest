//
//  CollectAndTimeView.m
//  foot
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "CollectAndTimeView.h"
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define Color(x,y,z,a) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a]
@implementation CollectAndTimeView

-(instancetype)initWithFrame:(CGRect)frame level:(NSString *)level collectIcom:(UIImage *)icon time:(NSString *)time
{
    if (self = [super initWithFrame:frame]) {
        
        self.collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectButton.frame = CGRectMake(SCREEN_W/2 - 12.5, 5, 25, 25);
        [self addSubview:_collectButton];
        [_collectButton setImage:icon forState:UIControlStateNormal];
        
        if (level.length>0) {
            UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 0, 0)];
            [self addSubview:levelLabel];
            levelLabel.text = [NSString stringWithFormat:@"难度: %@",level];
            levelLabel.textColor = Color(220, 220, 220, 1);
            [levelLabel sizeToFit];
        }
        
        if (time.length>0) {
            UILabel *timeLabel = [[UILabel alloc] init];
            timeLabel.text = [NSString stringWithFormat:@"时间: %@",time];
            timeLabel.textColor = Color(220, 220, 220, 1);
            [timeLabel sizeToFit];
            CGRect frame = timeLabel.frame;
            frame.origin.x = SCREEN_W - 30 - frame.size.width;
            frame.origin.y = 5;
            timeLabel.frame = frame;
            [self addSubview:timeLabel];
            
        }
        
    }
    return self;
}


@end
