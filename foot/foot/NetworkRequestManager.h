//
//  NetworkRequestManager.h
//  生活小助手
//
//  Created by lanou on 16/4/12.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义一个枚举表示请求类型
typedef NS_ENUM(NSInteger,RequestType){
    POST,
    GET
};

//定义一个请求结束时的block
typedef void(^RequestFinish)(NSData *data);

//定义一个请求失败时的block
typedef void(^RequestError)(NSError *error);

@interface NetworkRequestManager : NSObject


+(void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic header:(NSDictionary *)header finish:(RequestFinish)finish error:(RequestError)err;


@end
