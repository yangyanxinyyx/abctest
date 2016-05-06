//
//  CollectAndTimeView.h
//  foot
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectAndTimeView : UIView

@property(nonatomic,strong)UIButton *collectButton;


-(instancetype)initWithFrame:(CGRect)frame level:(NSString *)level collectIcom:(UIImage *)icon time:(NSString *)time;

@end
