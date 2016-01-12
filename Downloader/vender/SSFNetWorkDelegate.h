//
//  SSFNetWorkDelegate.h
//  Downloader
//
//  Created by 赛峰 施 on 16/1/6.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResultHandler)(NSString *obj,NSData *resumeData);
typedef void(^ProgressHandler)(double progress);
typedef void (^FinishAllBackgroundTasksHandler)();

@interface SSFNetWorkDelegate : NSObject<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate,NSURLSessionDownloadDelegate>

- (void)addCompletionHandler:(ResultHandler)handler progressHandler:(ProgressHandler)progressHandler forTaskIdentifier:(NSString *)identifier;
@property (nonatomic, copy) FinishAllBackgroundTasksHandler finishAllBackgroundTasksHandler;//所有后台任务在后台完成时appdelegate所调用的block
@end
