//
//  ShapedImageView.h
//  UIImageView的不规则
//
//  Created by lanou on 16/4/28.
//  Copyright © 2016年 严玉鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShapedImageView : UIImageView
{
    CALayer *_contentLayer;
    CAShapeLayer *_maskLayer;
}
@property (nonatomic,strong)UILabel *labelName;
@property (nonatomic,strong)UILabel *labelIntroduce;
-(void)setup;
-(void)toucheImageView;
@end
