//
//  MyCollectCollectionViewCell.m
//  foot
//
//  Created by lanou on 16/5/9.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "MyCollectCollectionViewCell.h"

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
    self.imageV.backgroundColor = [UIColor redColor];
    
    self.labelName.frame = CGRectMake(0, self.contentView.frame.size.width/5*4, self.contentView.frame.size.width, self.contentView.frame.size.width/5);
    self.labelName.textAlignment = NSTextAlignmentCenter;
    self.labelName.font = [UIFont systemFontOfSize:[UIScreen mainScreen].bounds.size.width*17/414];
    self.labelName.backgroundColor = [UIColor clearColor];
    
}




@end
