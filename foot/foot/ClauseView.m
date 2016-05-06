//
//  ClauseView.m
//  foot
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 念恩. All rights reserved.
//
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#import "ClauseView.h"
#import "Tool.h"

@implementation ClauseView

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
    label.text = @"使用条款与隐私政策\n <1>在此声明该APP不涉及任何钱财交易,如有钱财交易,请及时报警!\n <2>在此声明该APP的任何数据均来自网络,如有雷同,并且侵犯了您的利益,请及时与本APP联系,我们会及时删除!";
    label.font = [UIFont systemFontOfSize:15];
    Tool *tool = [[Tool alloc]init];
    CGFloat height = [tool getLabelHeight:label.text font:[UIFont systemFontOfSize:15]];
      label.frame = CGRectMake(20, 60,KScreenWidth-40,height);
    [self addSubview:label];
    
    
}
-(void)toucheButComeBack{
    [self.delegate toucheComeBackButton];
}
@end
