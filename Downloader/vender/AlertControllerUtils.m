//
//  AlertControllerUtils.m
//  Downloader
//
//  Created by 赛峰 施 on 16/1/8.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import "AlertControllerUtils.h"

@implementation AlertControllerUtils

+ (void)simpleAlertWithTitle:(NSString *)title message:(NSString *)message alertControllerStyle:(UIAlertControllerStyle)style presentViewController:(UIViewController *)controller {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
    }];
    [alert addAction:action];
    [controller presentViewController:alert animated:YES completion:NULL];
}
@end
