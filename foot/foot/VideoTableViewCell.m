
//
//  VideoTableViewCell.m
//  foot
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 念恩. All rights reserved.
//
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#import "VideoTableViewCell.h"

@implementation VideoTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *viewBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 300)];
        [self addSubview:viewBack];
        [viewBack addSubview:self.ImageView];
        [viewBack addSubview:self.labelName];


        UIView *viewGray = [[UIView alloc]initWithFrame:CGRectMake(0, 300-10, KScreenWidth, 10)];
        viewGray.backgroundColor = [UIColor lightGrayColor];
        [viewBack addSubview:viewGray];
    }
    return  self;
}
#pragma MARK -懒加载
-(UIImageView *)ImageView{
    if (!_ImageView) {
        self.ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10,KScreenWidth-20, 220)];
        UIImage *image = [UIImage imageNamed:@"播放"];
        UIImageView *imageViewBof = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        imageViewBof.center = _ImageView.center;
        imageViewBof.image = image;
//        imageViewBof.backgroundColor = [UIColor clearColor];
        [_ImageView addSubview:imageViewBof];
    }
    return _ImageView;
}
-(UILabel *)labelName{
    if (!_labelName) {
        self.labelName = [[UILabel alloc]initWithFrame:CGRectMake(20, 235, KScreenWidth-100, 20)];
        self.labelName.textColor = [UIColor blackColor];
        
    }
    return _labelName;
}
@end
