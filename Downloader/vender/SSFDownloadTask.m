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
    self.state = DOWNLOAD_TASK_STATE_TYPE_DOWNLOADING;
   NSURLSessionDownloadTask *downloadTask = [[SSFNetWork sharedNetWork] downloadFileWithProgressHandler:^(double progress) {
        self.progress = progress;
    } Completion:^(NSString *obj,NSData *resumeData) {
        if ([obj isEqualToString:@"success"]) {
            self.state = DOWNLOAD_TASK_STATE_TYPE_COMPLETE;
            [self.delegate SSFDownloadTaskDidCompletionWithTask:self];
        } else {
            if (self.state == DOWNLOAD_TASK_STATE_TYPE_DOWNLOADING) {
                self.state = DOWNLOAD_TASK_STATE_TYPE_FAIL;
                if (resumeData) {
                    //可继续下载
                    self.resumeData = resumeData;
                    self.isContinueDowonload = YES;
                } else {
                    //不可继续下载
                    self.resumeData = nil;
                    self.isContinueDowonload = NO;
                }
                [self.delegate SSFDownloadTaskDidCancelWithTask:self cancelType:DOWNLOAD_TASK_CANCEL_TYPE_FAIL];
            } else if (self.state == DOWNLOAD_TASK_STATE_TYPE_PAUSE) {
                [self.delegate SSFDownloadTaskDidCancelWithTask:self cancelType:DOWNLOAD_TASK_CANCEL_TYPE_PAUSE];
            }
            
        }
    }];
    self.identifier = downloadTask.taskIdentifier;
    self.downloadTask = downloadTask;
}

- (void)resume {
    if (self.resumeData) {
        self.state = DOWNLOAD_TASK_STATE_TYPE_DOWNLOADING;
        NSURLSessionDownloadTask *resumeDownloadTask = [[SSFNetWork sharedNetWork] resumeDownloadFileWithResumeData:self.resumeData ProgressHandler:^(double progress) {
            self.progress = progress;
        } Completion:^(NSString *obj,NSData *resumeData) {
            if ([obj isEqualToString:@"success"]) {
                [self.delegate SSFDownloadTaskDidCompletionWithTask:self];
            } else {
                if (self.state == DOWNLOAD_TASK_STATE_TYPE_DOWNLOADING) {
                    self.state = DOWNLOAD_TASK_STATE_TYPE_FAIL;
                    if (resumeData) {
                        //可继续下载
                        self.resumeData = resumeData;
                        self.isContinueDowonload = YES;
                    } else {
                        //不可继续下载
                        self.resumeData = nil;
                        self.isContinueDowonload = NO;
                    }
                    [self.delegate SSFDownloadTaskDidCancelWithTask:self cancelType:DOWNLOAD_TASK_CANCEL_TYPE_FAIL];
                } else if (self.state == DOWNLOAD_TASK_STATE_TYPE_PAUSE) {
                    [self.delegate SSFDownloadTaskDidCancelWithTask:self cancelType:DOWNLOAD_TASK_CANCEL_TYPE_PAUSE];
                }

            }
        }];
        self.identifier = resumeDownloadTask.taskIdentifier;
        self.downloadTask = resumeDownloadTask;
    }
}

- (void)pause {
    self.state = DOWNLOAD_TASK_STATE_TYPE_PAUSE;
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        if (resumeData) {
            //手动暂停，可继续下载
            self.resumeData = resumeData;
            self.isContinueDowonload = YES;
        } else {
            //手动暂停，不可继续下载
            self.resumeData = nil;
            self.isContinueDowonload = NO;
        }
    }];
}

#pragma mark - properties 

- (void)setProgress:(double)progress {
    _progress = progress;
    [self.delegate SSFDownloadTaskWithProgress:_progress task:self];
}

@end
