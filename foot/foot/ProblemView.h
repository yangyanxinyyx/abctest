//
//  ProblemView.h
//  foot
//
//  Created by lanou on 16/5/12.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ProblemViewDelegate <NSObject>

-(void)toucheProblemComeBackButton;

@end
@interface ProblemView : UIView
@property (nonatomic)id<ProblemViewDelegate>delegate;

@end
