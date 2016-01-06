//
//  SSFNetWorkDelegate.h
//  Downloader
//
//  Created by 赛峰 施 on 16/1/6.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResultHandler)(NSString *obj);

@interface SSFNetWorkDelegate : NSObject<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate,NSURLSessionDownloadDelegate>

- (void)addCompletionHandler:(ResultHandler)handler forTaskIdentifier:(NSString *)identifier;
- (void)callCompletionHandlerForTaskIdentifier:(NSString *)identifier withResultString:(NSString *)string;
@end
