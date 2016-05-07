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
    label.text = @"使用条款与隐私政策\n <1>    版权声明\n本app所有内容,包括⽂文字、图⽚片、⾳音频、视频、软件、程序、以及版式设计等均在⺴⽹网 上搜集。访问者可将本app提供的内容或服务⽤用于个⼈人学习、研究或欣赏,以及其他⾮非商业性或 ⾮非盈利性⽤用途,但同时应遵守著作权法及其他相关法律的规定,不得侵犯本app及相关权利⼈人的合法权利。除此以外,将本app任何内容或服务⽤用于其他⽤用途时,须征得本app及相关权 利⼈人的书⾯面许可,并⽀支付报酬。本app内容原作者如不愿意在本app刊登内容,请及时通知本app,予以删除。 地址:电话:13336525635\n 传真:\n 电⼦子邮箱:1272871380@qq.com\n\n <2>在此声明该APP不涉及任何钱财交易,如有钱财交易,请及时报警!\n <3>给app不会收录用户任何隐私信息，请放心使用 ";
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
