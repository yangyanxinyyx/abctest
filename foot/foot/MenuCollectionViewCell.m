//
//  MenuCollectionViewCell.m
//  foot
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "MenuCollectionViewCell.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define CELL_SIZE CGSizeMake((SCREEN_W - 50)/4, (SCREEN_W - 50)/4)
#define Color(x,y,z,a) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a]
@interface MenuCollectionViewCell ()

@property(nonatomic,strong)UIView *layerView;
@property(nonatomic,strong)CAGradientLayer *gradientLayer;

@end

@implementation MenuCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imageV = [[UIImageView alloc] init];
        
        _imageV.layer.cornerRadius = 8;
        _imageV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageV];
        _imageV.frame = self.bounds;
        
        //添加一个渐变色的view
        self.layerView = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_SIZE.height - 30, CELL_SIZE.width, 30)];
        [self.imageV addSubview:self.layerView];
        
        self.gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = _layerView.bounds;
        _gradientLayer.colors = @[(id)[UIColor clearColor].CGColor,(id)Color(200, 200, 200, 0.5).CGColor];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
        _gradientLayer.locations =@[@(0.3f) ,@(1.0f)];
        [self.layerView.layer insertSublayer:_gradientLayer atIndex:0];
        
        self.nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.frame = CGRectMake(0, 5 , CELL_SIZE.width, 22);
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.layerView addSubview:self.nameLabel];
    }
    return self;
}






@end
