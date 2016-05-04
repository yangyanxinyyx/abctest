//
//  NetworkRequestManager.m
//  生活小助手
//
//  Created by lanou on 16/4/12.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "NetworkRequestManager.h"

@implementation NetworkRequestManager

+(void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic header:(NSDictionary *)header finish:(RequestFinish)finish error:(RequestError)err
{
    NetworkRequestManager *manager = [[NetworkRequestManager alloc] init];
    [manager requestWithType:type urlString:urlString parDic:parDic header:header finish:finish error:err];
}

-(void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic header:(NSDictionary *)header finish:(RequestFinish)finish error:(RequestError)err
{
    // 将字符串转为Url
    NSURL *url = [NSURL URLWithString:urlString];
    //创建可变的request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //添加header
    if (header) {
        NSArray *array = [header allKeys];
        for (int i = 0; i<array.count; i++) {
            [request setValue:header[array[i]] forHTTPHeaderField:array[i]];
        }
        
    }
    
    //判断请求类型
    if (type == POST) {
        //设置请求类型为POST
        [request setHTTPMethod:@"POST"];
        //设置body体
        
        if (parDic.count > 0) {
            //将字典转为nsdata
            NSData *data = [self setDicToNSData:parDic];
            [request setHTTPBody:data];
        }
    }
    
    //进行数据请求
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            finish(data);
        }
        else
        {
            err(error);
        }
        
    }];
    
    [task resume];
    
}


#pragma -mark 将字典转为NSData
-(NSData *)setDicToNSData:(NSDictionary *)dic
{
    //创建数组存放所有键值对
    NSMutableArray *dicArray = [NSMutableArray array];
    for (NSString *key in dic) {
        NSString *keyAndValue = [NSString stringWithFormat:@"%@=%@",key,dic[key]];
        [dicArray addObject:keyAndValue];
    }
    
    //将数组转为字符串
    NSString *str = [dicArray componentsJoinedByString:@"&"];
    
    //将字符串转为NSData
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

@end
