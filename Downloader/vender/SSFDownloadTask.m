//
//  SSFDownloadTask.m
//  Downloader
//
//  Created by 赛峰 施 on 16/1/7.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import "SSFDownloadTask.h"

@interface SSFDownloadTask()
@property (weak, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSData *resumeData;
@end

@implementation SSFDownloadTask

- (void)start {
   NSURLSessionDownloadTask *downloadTask = [[SSFNetWork sharedNetWork] downloadFileWithProgressHandler:^(double progress) {
        self.progress = progress;
    } Completion:^(NSString *obj) {
        if ([obj isEqualToString:@"success"]) {
            [self.delegate SSFDownloadTaskDidCompletionWithTask:self];
        } else {
            [self.delegate SSFDownloadTaskDidFailWithTask:self];
        }
    }];
    self.identifier = downloadTask.taskIdentifier;
    self.downloadTask = downloadTask;
}

- (void)resume {
    NSURLSessionDownloadTask *resumeDownloadTask = [[SSFNetWork sharedNetWork] resumeDownloadFileWithResumeData:self.resumeData ProgressHandler:^(double progress) {
        self.progress = progress;
    } Completion:^(NSString *obj) {
        if ([obj isEqualToString:@"success"]) {
            [self.delegate SSFDownloadTaskDidCompletionWithTask:self];
        } else {
            [self.delegate SSFDownloadTaskDidFailWithTask:self];
        }
    }];
    self.identifier = resumeDownloadTask.taskIdentifier;
    self.downloadTask = resumeDownloadTask;
}

- (void)pause {
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumeData = resumeData;
    }];
}

#pragma mark - properties 

- (void)setProgress:(double)progress {
    _progress = progress;
    [self.delegate SSFDownloadTaskWithProgress:_progress task:self];
}

@end
