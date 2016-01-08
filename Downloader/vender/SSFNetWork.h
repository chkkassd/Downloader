//
//  SSFNetWork.h
//  Downloader
//
//  Created by 赛峰 施 on 16/1/6.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSFNetWork : NSObject
- (void)signInWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSString *obj,NSData *resumeData))handler;
- (NSURLSessionDownloadTask *)downloadFileWithProgressHandler:(void(^)(double progress))progressHandler Completion:(void (^)(NSString *obj,NSData *resumeData))handler;
- (NSURLSessionDownloadTask *)resumeDownloadFileWithResumeData:(NSData *)resumeData ProgressHandler:(void (^)(double progress))progressHandler Completion:(void (^)(NSString * obj,NSData *resumeData))handler;
+ (instancetype)sharedNetWork;
@end
