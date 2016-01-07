//
//  SSFNetWorkDelegate.m
//  Downloader
//
//  Created by 赛峰 施 on 16/1/6.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import "SSFNetWorkDelegate.h"

@interface SSFNetWorkDelegate()

@property (strong, nonatomic) NSMutableDictionary *completionHandlerDirectory;//存储每个task完成后的回调block
@property (strong, nonatomic) NSMutableDictionary *resultDataDirectrory;//存储每个dataTask的接受数据的容器
@property (strong, nonatomic) NSMutableDictionary *progressHandlerDirectory;//存储每个downloadTask的进度block
@end

@implementation SSFNetWorkDelegate

- (void)addCompletionHandler:(ResultHandler)handler progressHandler:(ProgressHandler)progressHandler forTaskIdentifier:(NSString *)identifier {
    if (handler) [self.completionHandlerDirectory setObject:handler forKey:identifier];
    if (progressHandler)
        [self.progressHandlerDirectory setObject:progressHandler forKey:identifier];
    else
        [self.resultDataDirectrory setObject:[[NSMutableData alloc] init] forKey:identifier];
    
    NSLog(@"add completion count:%lu \n add resultData count:%lu \n add progress count:%lu \n",(unsigned long)self.completionHandlerDirectory.count,(unsigned long)self.resultDataDirectrory.count,(unsigned long)self.progressHandlerDirectory.count);
}

- (void)callCompletionHandlerForTaskIdentifier:(NSString *)identifier withResultString:(NSString *)string {
    ResultHandler resultHandler = [self.completionHandlerDirectory objectForKey:identifier];
    if (resultHandler) {
        resultHandler(string);
    }
}

- (void)removeCompletionHandlerAndResultDataForIdentifier:(NSString *)identifier {
    if ([self.completionHandlerDirectory objectForKey:identifier]) [self.completionHandlerDirectory removeObjectForKey:identifier];
    if ([self.resultDataDirectrory objectForKey:identifier]) [self.resultDataDirectrory removeObjectForKey:identifier];
    if ([self.progressHandlerDirectory objectForKey:identifier]) [self.progressHandlerDirectory removeObjectForKey:identifier];
    NSLog(@"remove completion count:%lu \n remove resultData count:%lu \n remove progress count:%lu \n",(unsigned long)self.completionHandlerDirectory.count,(unsigned long)self.resultDataDirectrory.count,(unsigned long)self.progressHandlerDirectory.count);
}

#pragma mark - properties

- (NSMutableDictionary *)completionHandlerDirectory {
    if (!_completionHandlerDirectory) {
        _completionHandlerDirectory = [[NSMutableDictionary alloc] init];
    }
    return _completionHandlerDirectory;
}

- (NSMutableDictionary *)resultDataDirectrory {
    if (!_resultDataDirectrory) {
        _resultDataDirectrory = [[NSMutableDictionary alloc] init];
    }
    return _resultDataDirectrory;
}

- (NSMutableDictionary *)progressHandlerDirectory {
    if (!_progressHandlerDirectory) {
        _progressHandlerDirectory = [[NSMutableDictionary alloc] init];
    }
    return _progressHandlerDirectory;
}

#pragma mark - NSURLSessionDateDelegate
//require
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSMutableData *resultData = [self.resultDataDirectrory objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)dataTask.taskIdentifier]];
    [resultData appendData:data];
}

#pragma mark - NSURLSessionTaskDelegate
//require
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (!error) {
        if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
            //dataTask complete
            NSString *result = [NSString decode:[self.resultDataDirectrory objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)task.taskIdentifier]]];
            NSLog(@"result: %@\n", result);
            [self callCompletionHandlerForTaskIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)task.taskIdentifier] withResultString:result];
            [self removeCompletionHandlerAndResultDataForIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)task.taskIdentifier]];
            
        } else {
            [self callCompletionHandlerForTaskIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)task.taskIdentifier] withResultString:@"success"];
            [self removeCompletionHandlerAndResultDataForIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)task.taskIdentifier]];
        }
    } else {
        if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
            //dataTask complete
            [self callCompletionHandlerForTaskIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)task.taskIdentifier] withResultString:nil];
            [self removeCompletionHandlerAndResultDataForIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)task.taskIdentifier]];
        } else {
            [self callCompletionHandlerForTaskIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)task.taskIdentifier] withResultString:@"fail"];
            [self removeCompletionHandlerAndResultDataForIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)task.taskIdentifier]];
        }
    }
}

#pragma NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *downloadFilePath = [cacheDirectory stringByAppendingPathComponent:@"downloadFile"];
    NSURL *downloadFilePathUrl = [NSURL fileURLWithPath:downloadFilePath];
    
    NSError *error = nil;
    if ([fileManager moveItemAtURL:location toURL:downloadFilePathUrl error:&error]) {
        NSLog(@"success to download and move to new file url");
    } else {
        NSLog(@"fail to download and move to new file url");
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"Session %@ download task %@ wrote an additional %lld bytes (total %lld bytes) out of an expected %lld bytes.\n",
          session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    double a = totalBytesWritten/1000.0;
    double b = totalBytesExpectedToWrite/1000.0;
    ProgressHandler progressHandler = [self.progressHandlerDirectory objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]];
    progressHandler(a/b);
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"Session %@ download task %@ resumed at offset %lld bytes out of an expected %lld bytes.\n",
          session, downloadTask, fileOffset, expectedTotalBytes);
}

@end
