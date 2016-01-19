//
//  MainTableViewController.m
//  Downloader
//
//  Created by 赛峰 施 on 16/1/6.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import "MainTableViewController.h"
#import "DownloadTableViewCell.h"
#import "SSFNetWork.h"

@interface MainTableViewController()<SSFDownloadTaskDelegate>
@property (strong, nonatomic) NSMutableArray *dataArr;
@end

@implementation MainTableViewController

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (IBAction)addATask:(id)sender {
    SSFDownloadTask *downloadTask = [[SSFDownloadTask alloc] init];
    downloadTask.delegate = self;
    [downloadTask startForBackground];
    
    [self.dataArr addObject:downloadTask];
    [self.tableView reloadData];
}

- (IBAction)testHttps:(id)sender {
    [[SSFNetWork sharedNetWork] testHttpsAuthenticationCompletion:^(NSString *obj, NSData *resumeData) {
        NSLog(@"========https:%@",obj);
    }];
}

#pragma mark - table datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DownloadTableViewCell";
    DownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    SSFDownloadTask *task = self.dataArr[indexPath.row];
    cell.progressView.progress = task.progress;
    cell.progressLabel.text = [NSString stringWithFormat:@"%0.2f%%",task.progress * 100];
    cell.resumeHandler = ^(BOOL flag) {
        if (flag)
            [task resumeForBackground];
         else
            [task pause];
    };
    return cell;
}

#pragma mark - SSFDownloadTaskDelegate

- (void)SSFDownloadTaskWithProgress:(double)progress task:(SSFDownloadTask *)task {
    NSUInteger a = [self.dataArr indexOfObject:task];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:a inSection:0];
    DownloadTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.progressView.progress = progress;
    cell.progressLabel.text = [NSString stringWithFormat:@"%0.2f%%",progress * 100];
}

- (void)SSFDownloadTaskDidCancelWithTask:(SSFDownloadTask *)task cancelType:(DownloadTaskCncelType)cancelType {
    switch (cancelType) {
        case DOWNLOAD_TASK_CANCEL_TYPE_FAIL:
        {
            NSUInteger a = [self.dataArr indexOfObject:task];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:a inSection:0];
            DownloadTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.downloadButton.selected = YES;
            [AlertControllerUtils simpleAlertWithTitle:@"hello" message:@"下载失败" alertControllerStyle:UIAlertControllerStyleAlert presentViewController:self];
            break;
        }
        case DOWNLOAD_TASK_CANCEL_TYPE_PAUSE:
            [AlertControllerUtils simpleAlertWithTitle:@"hello" message:@"下载暂停" alertControllerStyle:UIAlertControllerStyleAlert presentViewController:self];
            break;
        default:
            break;
    }
}

- (void)SSFDownloadTaskDidCompletionWithTask:(SSFDownloadTask *)task {
    NSUInteger a = [self.dataArr indexOfObject:task];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:a inSection:0];
    DownloadTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.progressView.progress = 1.0;
    cell.progressLabel.text = @"100.00%";
    cell.downloadButton.selected = YES;
    
    [AlertControllerUtils simpleAlertWithTitle:@"hello" message:@"下载成功" alertControllerStyle:UIAlertControllerStyleAlert presentViewController:self];
}
@end
