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
    self.videoID = [keyedValues objectForKey:@"id"];
    self.name = [keyedValues objectForKey:@"name"];
    NSString *str = [keyedValues objectForKey:@"intro"];
    NSArray *introName = [str componentsSeparatedByString:@"&nbsp;·&nbsp;"];
    if ([introName[0] isEqualToString:@"精选视频推荐"]) {
        self.intro = introName[0];
    }else{
        self.intro = [introName componentsJoinedByString:@"  ·  "];
    }
    self.pic = [keyedValues objectForKey:@"pic"];
    self.video_url = [keyedValues objectForKey:@"video_url"];
}
@end
