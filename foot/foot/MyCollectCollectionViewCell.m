//
//  MyCollectCollectionViewCell.m
//  foot
//
//  Created by lanou on 16/5/9.
//  Copyright © 2016年 念恩. All rights reserved.
//

#define Cell_W self.contentView.frame.size.width
#import "MyCollectCollectionViewCell.h"

@interface MyCollectCollectionViewCell ()
@property(nonatomic,strong)UIView *layerView;
@property(nonatomic,strong)CAGradientLayer *gradientLayer;
@end

@implementation MyCollectCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageV];
        
        self.labelName = [[UILabel alloc] init];
        [self.contentView addSubview:self.labelName];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageV.frame = self.contentView.frame;
    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
    self.imageV.clipsToBounds = YES;
    
    //添加一个渐变色
    self.layerView = [[UIView alloc] initWithFrame:CGRectMake(0, Cell_W - 30, Cell_W, 30)];
    [self.imageV addSubview:self.layerView];
    
    self.gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = _layerView.bounds;
    _gradientLayer.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.5].CGColor];
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
    _gradientLayer.locations =@[@(0.3f) ,@(1.0f)];
    [self.layerView.layer insertSublayer:_gradientLayer atIndex:0];
    
    
    
    self.labelName.frame = CGRectMake(0, Cell_W/5*4, Cell_W, Cell_W/5);
    self.labelName.textAlignment = NSTextAlignmentCenter;
    self.labelName.font = [UIFont boldSystemFontOfSize:[UIScreen mainScreen].bounds.size.width*20/414];
    self.labelName.backgroundColor = [UIColor clearColor];
    self.labelName.textColor = [UIColor whiteColor];
    
    
}




@end
