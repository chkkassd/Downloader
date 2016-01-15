//
//  DownloadTableViewCell.h
//  Downloader
//
//  Created by 赛峰 施 on 16/1/7.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ResumeHandler)(BOOL flag);

@interface DownloadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (copy, nonatomic) ResumeHandler resumeHandler;
@end
