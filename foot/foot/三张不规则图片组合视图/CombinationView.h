//
//  CombinationView.h
//  UIImageView的不规则
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 严玉鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShapedImageView.h"
#import "MidImageView.h"
#import "EndImageView.h"

@interface CombinationView : UIView
@property (nonatomic,strong)ShapedImageView *shapedImageV;
@property (nonatomic,strong)MidImageView *midImageV;
@property (nonatomic,strong)EndImageView *endImageV;
@property (nonatomic,strong)UILabel *labelTitle;
-(instancetype)initWithFrame:(CGRect)frame;
@end
