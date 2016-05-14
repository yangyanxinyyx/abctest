//
//  MyView_V2.h
//  foot
//
//  Created by lanou on 16/5/12.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyViewDelegate <NSObject>
-(void)buttonVlaue:(UIButton *)Button;
-(void)buttonSetValue:(UIButton*)Butoon;

@end
@interface MyView_V2 : UIView
@property (nonatomic,strong)UIView *outView;
@property (nonatomic)CGPoint centerPoint;
@property (nonatomic,weak)id<MyViewDelegate>delegate;
-(instancetype)initWithFrame:(CGRect)frame;
-(void)doButtonValue:(UIButton*)but;
@end
