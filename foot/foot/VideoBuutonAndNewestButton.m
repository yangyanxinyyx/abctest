//
//  VideoBuutonAndNewestButton.m
//  foot
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "VideoBuutonAndNewestButton.h"
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation VideoBuutonAndNewestButton

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.VideoButton];
        [self addSubview:self.NewestButton];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 70, KScreenWidth, 10)];
        view.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:view];
    }
    return self;
    
}
#pragma mark -懒加载
-(UIButton *)VideoButton{
    if (!_VideoButton) {
        self.VideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_VideoButton setBackgroundImage:[UIImage imageNamed:@"视频"] forState:UIControlStateNormal];
        _VideoButton.frame = CGRectMake(KScreenWidth/4, 0, 55, 55);
        [_VideoButton setTitle:@"视频推荐" forState:UIControlStateNormal];
        _VideoButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_VideoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [_VideoButton setTitleEdgeInsets:UIEdgeInsetsMake(+64, 0, 0, 0)];
        [_VideoButton addTarget:self action:@selector(toucheVideoButtonValue) forControlEvents:UIControlEventTouchDown];
    }
    return _VideoButton;
}
-(UIButton *)NewestButton{
    if (!_NewestButton) {
        self.NewestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_NewestButton setBackgroundImage:[UIImage imageNamed:@"最新"] forState:UIControlStateNormal];
        _NewestButton.frame = CGRectMake(KScreenWidth/2+(KScreenWidth/4 - 55), 0, 55, 55);
        [_NewestButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_NewestButton setTitle:@"今日最新" forState:UIControlStateNormal];
        _NewestButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_NewestButton setTitleEdgeInsets:UIEdgeInsetsMake(+64, 0, 0, 0)];
        
        [_NewestButton addTarget:self action:@selector(toucheNewestButtonValue) forControlEvents:UIControlEventTouchDown];
      
    }
    return _NewestButton;
}
-(void)toucheVideoButtonValue{
    [self.delegate toucheVideoButton];
}
-(void)toucheNewestButtonValue{
    [self.delegate toucheNewestButton];
}
@end
