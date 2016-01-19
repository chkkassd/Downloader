//
//  SSFNetWork.m
//  Downloader
//
//  Created by 赛峰 施 on 16/1/6.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

#import "SSFNetWork.h"

#define SERVER_IP                     @"120.24.67.134"
#define SERVER_WEB_SERVICE_PORT       8080

@interface SSFNetWork()

@property (nonatomic)  NSURLSession *defaultSession;
@property (nonatomic)  NSURLSession *backgroundSession;

@end

@implementation SSFNetWork

- (NSString *)baseURL {
    NSString *baseURL = [NSString stringWithFormat:@"http://%@:%@/Chat/", SERVER_IP, @(SERVER_WEB_SERVICE_PORT)];
    return baseURL;
}

#pragma mark - request

//Fetch Resource Using System-Provided Delegate
- (void)sendHttpRequestWithUrl:(NSURL *)url body:(NSData *)body completion:(void(^)(NSString *obj))handler {
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
    [[self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            handler(nil);
        } else {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (httpResponse.statusCode == 200) {
                    NSString *result = [NSString decode:data];
                    NSLog(@"result: %@", result);
                    handler(result);
                } else {
                    handler(nil);
                }
            }
        }
    }] resume];
}

//Fetch Resource Using A Cutom Delegate
- (void)sendHttpRequestWithUrl:(NSURL *)url body:(NSData *)body withCompletion:(void(^)(NSString *obj,NSData *resumeData))handler {
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
    NSURLSessionDataTask *dataTask = [self.defaultSession dataTaskWithRequest:request];
    [self.defaultSessionDelegate addCompletionHandler:handler progressHandler:nil forTaskIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)dataTask.taskIdentifier]];
    [dataTask resume];
}

//downloadTask request
- (NSURLSessionDownloadTask *)downloadRequestWithUrl:(NSURL *)url progressHandler:(void(^)(double progress))progressHandler completion:(void(^)(NSString *obj,NSData *resumeData))completionHandler {
    NSURLSessionDownloadTask *downloadTask = [self.defaultSession downloadTaskWithURL:url];
    [self.defaultSessionDelegate addCompletionHandler:completionHandler progressHandler:progressHandler forTaskIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]];
    [downloadTask resume];
    return downloadTask;
}

//resume downloadTask
- (NSURLSessionDownloadTask *)resumeDownloadRequestWithResumeData:(NSData *)resumeData progressHandler:(void(^)(double progress))progressHandler completion:(void(^)(NSString *obj,NSData *resumeData))completionHandler {
    NSURLSessionDownloadTask *downloadTask = [self.defaultSession downloadTaskWithResumeData:resumeData];
    [self.defaultSessionDelegate addCompletionHandler:completionHandler progressHandler:progressHandler forTaskIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]];
    [downloadTask resume];
    return downloadTask;
}

//background downloadTask request
- (NSURLSessionDownloadTask *)backgroundDownloadRequestWithUrl:(NSURL *)url progressHandler:(void(^)(double progress))progressHandler completion:(void(^)(NSString *obj,NSData *resumeData))completionHandler {
    NSURLSessionDownloadTask *downloadTask = [self.backgroundSession downloadTaskWithURL:url];
    [self.backgroundSessionDelegate addCompletionHandler:completionHandler progressHandler:progressHandler forTaskIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]];
    [downloadTask resume];
    return downloadTask;
}

//background resume downloadTask
- (NSURLSessionDownloadTask *)backgroundResumeDownloadRequestWithResumeData:(NSData *)resumeData progressHandler:(void(^)(double progress))progressHandler completion:(void(^)(NSString *obj,NSData *resumeData))completionHandler {
    NSURLSessionDownloadTask *downloadTask = [self.backgroundSession downloadTaskWithResumeData:resumeData];
    [self.backgroundSessionDelegate addCompletionHandler:completionHandler progressHandler:progressHandler forTaskIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]];
    [downloadTask resume];
    return downloadTask;
}

#pragma mark - properties

- (NSURLSession *)defaultSession {
    if (!_defaultSession) {
        NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        //cache
        NSString *cachePath = @"/MyCacheDirectory";
        NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *myPath    = [myPathList  objectAtIndex:0];
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        NSString *fullCachePath = [[myPath stringByAppendingPathComponent:bundleIdentifier] stringByAppendingPathComponent:cachePath];
        NSURLCache *myCache = [[NSURLCache alloc] initWithMemoryCapacity:16384 diskCapacity:268435456 diskPath:fullCachePath];
        
        defaultConfiguration.URLCache = myCache;
        defaultConfiguration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        
        _defaultSession = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:self.defaultSessionDelegate delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _defaultSession;
}

- (NSURLSession *)backgroundSession {
    if (!_backgroundSession) {
        NSURLSessionConfiguration *backgroundConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"MyBackgroundSession"];
        
        _backgroundSession = [NSURLSession sessionWithConfiguration:backgroundConfiguration delegate:self.backgroundSessionDelegate delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _backgroundSession;
}

- (SSFNetWorkDelegate *)defaultSessionDelegate {
    if (!_defaultSessionDelegate) {
        _defaultSessionDelegate = [[SSFNetWorkDelegate alloc] init];
    }
    return _defaultSessionDelegate;
}

- (SSFNetWorkDelegate *)backgroundSessionDelegate {
    if (!_backgroundSessionDelegate) {
        _backgroundSessionDelegate = [[SSFNetWorkDelegate alloc] init];
    }
    return _backgroundSessionDelegate;
}

#pragma mark - connection

//test defaultSession dataTask
- (void)signInWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSString *obj,NSData *resumeData))handler {
    NSURL *url = [NSURL URLWithString:[[self baseURL] stringByAppendingString:@"SignIn"]];
    password = [NSString md5ForString:password];
    NSString *bodyString = [NSString stringWithFormat:@"email=%@&password=%@",email, password];
    NSData *body = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [self sendHttpRequestWithUrl:url body:body withCompletion:handler];
}

//test defaultSession downloadTask
- (NSURLSessionDownloadTask *)downloadFileWithProgressHandler:(void (^)(double))progressHandler Completion:(void (^)(NSString *obj,NSData *resumeData))handler {
    //    NSURL *url = [NSURL URLWithString:@"http://api.ezendai.com:8888/ios/thumb_large.png"];
    NSURL *url = [NSURL URLWithString:@"http://devstreaming.apple.com/videos/wwdc/2014/709xx1q8hdvo14x/709/709_cross_platform_nearby_networking.pdf"];
    return [self downloadRequestWithUrl:url progressHandler:progressHandler completion:handler];
}

//test defaultSession resumeDownloadTask
- (NSURLSessionDownloadTask *)resumeDownloadFileWithResumeData:(NSData *)resumeData ProgressHandler:(void (^)(double))progressHandler Completion:(void (^)(NSString *obj,NSData *resumeData))handler {
//    NSURL *url = [NSURL URLWithString:@"http://devstreaming.apple.com/videos/wwdc/2014/718xxctf8ley20j/718/718_hd_adopting_airprint.mov"];
    return [self resumeDownloadRequestWithResumeData:resumeData progressHandler:progressHandler completion:handler];
}

//test backgroundSession downloadTask
- (NSURLSessionDownloadTask *)downloadFileBackgroundWithProgressHandler:(void (^)(double))progressHandler Completion:(void (^)(NSString *obj,NSData *resumeData))handler {
    //    NSURL *url = [NSURL URLWithString:@"http://api.ezendai.com:8888/ios/thumb_large.png"];
    NSURL *url = [NSURL URLWithString:@"http://devstreaming.apple.com/videos/wwdc/2014/709xx1q8hdvo14x/709/709_cross_platform_nearby_networking.pdf"];
    return [self backgroundDownloadRequestWithUrl:url progressHandler:progressHandler completion:handler];
}

//test backgroundSession resumeDownloadTask
- (NSURLSessionDownloadTask *)resumeDownloadFileBackgroundWithResumeData:(NSData *)resumeData ProgressHandler:(void (^)(double))progressHandler Completion:(void (^)(NSString *obj,NSData *resumeData))handler {
    return [self backgroundResumeDownloadRequestWithResumeData:resumeData progressHandler:progressHandler completion:handler];
}

//test https authentication

#define DefaultProjectNo    @"Lc_WS2015"//捞财宝流水号
#define kSecret @"KWOJT23434LT3PAD"//验签
//#define kSecret @"KWOJT23434LT3JT"//验签,ceshi
- (void)testHttpsAuthenticationCompletion:(void (^)(NSString *, NSData *))handler {
    NSDictionary * dic = @{
                              @"pageNo":@"1",
                              @"pageSize": @"10",
                              @"customerId": @""
                              };

    NSString *projectNo = DefaultProjectNo;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *userAgent = [NSString stringWithFormat:@"%@ %@(iOS;%@;zh_CN)",appName,appVersion,[[UIDevice currentDevice] systemVersion]];
//    NSString * sessionToken = kUserInfoModel?kUserInfoModel.sessionToken:@"";
    NSDictionary *reqHeadParam = @{
                                   @"mechanism":@"证大",
                                   @"platform":@"App",
                                   @"togatherType":@"证大无线",
                                   @"openchannel":@"AppStore",
                                   @"token":@"",
                                   @"userAgent":userAgent,
                                   @"sessionToken":@"",
                                   @"version":@"1.9"
                                   };
    NSString * dateString = [[NSString stringTranslatedFromDate:[NSDate date]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *randomString = [self getRandomStringWithCount:5];
    NSString * sn = [NSString stringWithFormat:@"%@-%@-%@",DefaultProjectNo,dateString,randomString];
    
    NSString * signOri = [NSString stringWithFormat:@"%@|%@|%@",projectNo,sn,kSecret];
    NSString * sign = [NSString md5StringFromString:signOri];
    
    NSDictionary *paramDic = @{@"projectNo":projectNo,
                               @"reqUrl":@"",
                               @"reqParam":dic,
                               @"reqHeadParam":reqHeadParam,
                               @"reqTimestamp":@"",
                               @"sn":sn,
                               @"sign":sign
                               };
    
    NSString * dataString = [paramDic JSONString];
    
    NSURL *url = [NSURL URLWithString:@"https://trade.laocaibao.com/laocaibao_webservice_1.10/Api/requestDeal"];
    NSString * requestString = [NSString stringWithFormat:@"arg0=%@&arg1=%@", @"500001", dataString];
    NSData *bodyData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    [self sendHttpRequestWithUrl:url body:bodyData withCompletion:handler];
}

- (NSString *)getRandomStringWithCount:(int)count
{
    NSString *string = [[NSString alloc] init];
    for (int i = 0; i < count; i ++) {
        int a = arc4random() % 10;
        string = [string stringByAppendingString:[NSString stringWithFormat:@"%d",a]];
    }
    return string;
}


#pragma mark - Initialization

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

+ (instancetype)sharedNetWork {
    static SSFNetWork *netWork = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWork = [[super allocWithZone:nil] init];
    });
    return netWork;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    @throw [NSException exceptionWithName:@"Alloc SSFNetWork Error"
                                   reason:@"This class only can be used by [SSFNetWork sharedNetWork]"
                                 userInfo:nil];
    return nil;
}

@end
