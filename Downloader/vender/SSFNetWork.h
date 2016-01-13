//
//  SSFNetWork.h
//  Downloader
//
//  Created by 赛峰 施 on 16/1/6.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSFNetWorkDelegate.h"

@interface SSFNetWork : NSObject

@property (nonatomic,strong) SSFNetWorkDelegate *defaultSessionDelegate;
@property (nonatomic,strong) SSFNetWorkDelegate *backgroundSessionDelegate;

- (void)signInWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSString *obj,NSData *resumeData))handler;

//default
- (NSURLSessionDownloadTask *)downloadFileWithProgressHandler:(void(^)(double progress))progressHandler Completion:(void (^)(NSString *obj,NSData *resumeData))handler;
- (NSURLSessionDownloadTask *)resumeDownloadFileWithResumeData:(NSData *)resumeData ProgressHandler:(void (^)(double progress))progressHandler Completion:(void (^)(NSString * obj,NSData *resumeData))handler;

//background
- (NSURLSessionDownloadTask *)downloadFileBackgroundWithProgressHandler:(void (^)(double))progressHandler Completion:(void (^)(NSString *obj,NSData *resumeData))handler;
- (NSURLSessionDownloadTask *)resumeDownloadFileBackgroundWithResumeData:(NSData *)resumeData ProgressHandler:(void (^)(double))progressHandler Completion:(void (^)(NSString *obj,NSData *resumeData))handler;

+ (instancetype)sharedNetWork;
@end
