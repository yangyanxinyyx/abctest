//
//  FireTableViewCell.m
//  foot
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 念恩. All rights reserved.
//
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#import "FireTableViewCell.h"

@implementation FireTableViewCell
-(void)layoutSubviews{
    [super layoutSubviews];
    NSArray *array = [NSArray arrayWithObjects:@"小龙虾",@"粽子",@"烧烤",@"羊肉串",@"烤羊",@"下午茶", nil];
    for (int i =0; i<2; i++) {
        for (int j = 0; j<3; j++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/3*j, i*30, KScreenWidth/3, 30)];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.borderWidth = 0.2;
            [button setTitle:array[i*3+j] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button addTarget:self action:@selector(toucheButton:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:button];
        }
    }
    


}
-(void)toucheButton:(UIButton *)but{
    [self.delegate toucheBuutonWith:but];

}
@end
