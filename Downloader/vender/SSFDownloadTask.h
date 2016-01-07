//
//  SSFDownloadTask.h
//  Downloader
//
//  Created by 赛峰 施 on 16/1/7.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSFDownloadTaskDelegate;

@interface SSFDownloadTask : NSObject
@property (nonatomic, assign) NSUInteger identifier;
@property (nonatomic, assign) double progress;
@property (nonatomic, weak) id <SSFDownloadTaskDelegate> delegate;

- (void)start;
- (void)resume;
- (void)pause;
@end


@protocol SSFDownloadTaskDelegate <NSObject>

@optional
- (void)SSFDownloadTaskDidCompletionWithTask:(SSFDownloadTask *)task;
- (void)SSFDownloadTaskDidFailWithTask:(SSFDownloadTask *)task;
- (void)SSFDownloadTaskWithProgress:(double)progress task:(SSFDownloadTask *)task;
@end