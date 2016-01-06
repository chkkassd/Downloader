//
//  SSFNetWork.h
//  Downloader
//
//  Created by 赛峰 施 on 16/1/6.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloaderHeader.h"

@interface SSFNetWork : NSObject
- (void)signInWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSString *obj))handler;
- (void)downloadFileTest;
+ (instancetype)sharedNetWork;
@end
