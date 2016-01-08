//
//  AlertControllerUtils.h
//  Downloader
//
//  Created by 赛峰 施 on 16/1/8.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertControllerUtils : NSObject
+ (void)simpleAlertWithTitle:(NSString *)title message:(NSString *)message alertControllerStyle:(UIAlertControllerStyle)style presentViewController:(UIViewController *)controller;
@end
