//
//  GuideImageView.h
//  foot
//
//  Created by lanou on 16/5/13.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuideImageViewDelegate <NSObject>

-(void)toucheToMain;

@end
@interface GuideImageView : UIView
@property (nonatomic,strong)UIScrollView *scroll;
@property (nonatomic,strong)UIImageView *imageV1;
@property (nonatomic,strong)UIImageView *imageV2;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,weak)id<GuideImageViewDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)framel;
@end
