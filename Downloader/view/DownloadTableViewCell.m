//
//  DownloadTableViewCell.m
//  Downloader
//
//  Created by 赛峰 施 on 16/1/7.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import "DownloadTableViewCell.h"

@implementation DownloadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)downloadButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.resumeHandler(NO);
    } else {
        self.resumeHandler(YES);
    }
}

@end
