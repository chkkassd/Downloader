//
//  AppDelegate.m
//  Downloader
//
//  Created by 赛峰 施 on 16/1/6.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+signInAndOut.h"
#import "SSFNetWork.h"
#import "SSFNetWorkDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:SIGN_IN_USER_NAME];
    if (userName) {
        //存在，跳主界面
        [self showMainTableView];
    } else {
        //不存在，跳登陆页面
        [self showSignInView];
    }
    return YES;
}

//1.只有后台任务呗系统终结的时候，重启app，系统会调用次方法，通过idengtifier来重造session。
//2.或者在后台的时候，session完成了他所有的后台任务，系统会自动重启app并调用这个方法，储存handler给delegate调用
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    SSFNetWorkDelegate *netDelegate = [[SSFNetWork sharedNetWork] backgroundSessionDelegate];
    
    NSURLSessionConfiguration *backgroundSessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
    NSURLSession *backgroundSession = [NSURLSession sessionWithConfiguration:backgroundSessionConfiguration delegate:netDelegate delegateQueue:[NSOperationQueue mainQueue]];
    netDelegate.finishAllBackgroundTasksHandler = completionHandler;

}

@end
