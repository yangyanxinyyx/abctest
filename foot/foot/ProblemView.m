//
//  ProblemView.m
//  foot
//
//  Created by lanou on 16/5/12.
//  Copyright © 2016年 念恩. All rights reserved.
//
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#import "ClauseView.h"
#import "Tool.h"
#import "ProblemView.h"

@implementation ProblemView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setLayout];
    }
    return self;
}
-(void)setLayout{
    UIButton *but =[[ UIButton alloc]initWithFrame:CGRectMake(10, 10, 100, 40)];
    [but setTitle:@"收回" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(toucheButComeBack) forControlEvents:UIControlEventTouchDown];
     but.layer.cornerRadius = 10;
     but.layer.masksToBounds = YES;
     but.backgroundColor = [UIColor whiteColor];
     [but setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
     [self addSubview:but];
     UILabel *label = [[UILabel alloc]init];
     label.numberOfLines = 0;
     label.text = @"<1>、该app由于本软件方向所决定,没有做横屏,所以该软件无法横屏操作.\n <2>、该app存储的个人数据均是本地,无法导出\n <3>、该app暂时没有提供第三方登陆 \n <4>、该app不支持在iPhone4s上运行\n ";
     label.font = [UIFont systemFontOfSize:15];
     Tool *tool = [[Tool alloc]init];
     CGFloat height = [tool getLabelHeight:label.text font:[UIFont systemFontOfSize:15]];
     label.frame = CGRectMake(20, 60,KScreenWidth-40,height);
     [self addSubview:label];
    
    
}
-(void)toucheButComeBack{
        [self.delegate toucheProblemComeBackButton];
}
@end
