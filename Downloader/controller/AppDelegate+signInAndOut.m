//
//  AppDelegate+signInAndOut.m
//  Downloader
//
//  Created by 赛峰 施 on 16/1/12.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import "AppDelegate+signInAndOut.h"
#import "ViewController.h"
#import "MainTableViewController.h"

@implementation AppDelegate (signInAndOut)
- (void)showSignInView {
    ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    self.window.rootViewController = vc;
}

- (void)showMainTableView {
    MainTableViewController *mtvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UINavigationController"];
    self.window.rootViewController = mtvc;
}
@end
