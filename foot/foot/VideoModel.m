//
//  VideoModel.m
//  foot
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel
-(void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues{
    
    self.name = [keyedValues objectForKey:@"name"];
    NSString *str = [keyedValues objectForKey:@"intro"];
    NSArray *introName = [str componentsSeparatedByString:@"&nbsp;·&nbsp;"];
    if ([introName[0] isEqualToString:@"精选视频推荐"]) {
        self.browse = introName[0];
    }else{
    self.browse = introName[0];
        if (introName.count == 3) {
                self.collect = [introName[1] stringByAppendingString:introName[2]];
        }else{
            self.collect = introName[1];
        }
    }
       self.pic = [keyedValues objectForKey:@"pic"];
}
@end
