//
//  SSFDownloadTask.h
//  Downloader
//
//  Created by 赛峰 施 on 16/1/7.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    DOWNLOAD_TASK_CANCEL_TYPE_FAIL,
    DOWNLOAD_TASK_CANCEL_TYPE_PAUSE
}DownloadTaskCncelType;

typedef enum{
    DOWNLOAD_TASK_STATE_TYPE_PAUSE,//手动暂停
    DOWNLOAD_TASK_STATE_TYPE_DOWNLOADING,//正在下载
    DOWNLOAD_TASK_STATE_TYPE_FAIL,//下载失败
    DOWNLOAD_TASK_STATE_TYPE_COMPLETE
}DownloadTaskStateType;

@protocol SSFDownloadTaskDelegate;

@interface SSFDownloadTask : NSObject
@property (nonatomic, assign) NSUInteger identifier;//task唯一标识符
@property (nonatomic, assign) double progress;//task下载进度
@property (nonatomic) BOOL isContinueDowonload;//task是否可继续下载
@property (nonatomic, assign) DownloadTaskStateType state;//task状态
@property (nonatomic, weak) id <SSFDownloadTaskDelegate> delegate;

- (void)start;
- (void)resume;
- (void)pause;
@end


@protocol SSFDownloadTaskDelegate <NSObject>

@optional
- (void)SSFDownloadTaskDidCompletionWithTask:(SSFDownloadTask *)task;
- (void)SSFDownloadTaskDidCancelWithTask:(SSFDownloadTask *)task cancelType:(DownloadTaskCncelType)cancelType;
- (void)SSFDownloadTaskWithProgress:(double)progress task:(SSFDownloadTask *)task;
@end