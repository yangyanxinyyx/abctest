//
//  ClauseView.h
//  foot
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClauseViewDelegate <NSObject>

-(void)toucheComeBackButton;

@end
@interface ClauseView : UIView
@property (nonatomic,strong)NSString *conten;
@property (nonatomic)id<ClauseViewDelegate>delegate;
@end
