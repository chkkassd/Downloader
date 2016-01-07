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
    [downloadTask start];
    
    [self.dataArr addObject:downloadTask];
    [self.tableView reloadData];
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
    cell.resumeHandler = ^(bool flag) {
        if (flag)
            [task resume];
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

- (void)SSFDownloadTaskDidFailWithTask:(SSFDownloadTask *)task {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"hello" message:@"下载失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:NULL];
}
@end
