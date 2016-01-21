# Downloader
我写这个工程，主要是用来测试NSURLSession的使用，包括它的dataTask，downloadTask，uploadTask，以及后台运行机制。

# 要点
核心的类为网络类:SSFNetWork,SSFNetWorkDelegate,以及model类:SSFDownloadTask。
SSFNetWork,SSFNetWorkDelegate这两个主要封装了NSURLSession的网络连接机制，主要测试了在defaultSession和backgroundSession下的dataTask，downloadTask,uploadTask未测试。

一，defaultSessionConfiguration
defaultSession是一个很强大的会话，它能够支持所有task任务，一般的网络请求dataTask，下载用的downloadTask，上传用的uploadTask都能够完美支持。
downloadTask可以开启，暂停，继续一个下载任务，下载失败，也可以用NSError里的resumeData重开一个任务继续下载，并能够通过自定义delegate反应下载实时进度。

二，backgroundSessionConfiguration
backgroundSession支持downloadTask和uploadTask，当你在前台时，表现和defaultSession一样，但是一旦退到后台，下载任务可以继续执行，因为系统给他开了一个单独的线程。

当下载任务在后台下载时，- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler ;这个方法在下面两种情况下会被调用：
1.后台任务被系统终结的时候，重启app，如果有未完成的后台下载或上台任务，系统会调用此方法，通过idengtifier来重造session，session会自动恢复原来的下载或上传任务。如果是用户终结的app，那就会cancel所有task，在重启时，不会调用这个方法，也不会恢复原来的任务。
2.在app不运行的时候，session完成了他所有的后台任务，系统会自动重启app并调用这个方法，储存handler给session的delegate调用。这时候，app已被系统重启，会调用session对应的delegate方法，包括downloadTaskDelegate和taskDelegate，以及sessionDelegate的- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session;方法


# NSURLSession authentication相关
相关的Api在Security Framework中，验证流程如下：

1). 第一步，先获取需要验证的信任对象(Trust Object)。这个Trust Object在不同的应用场景下获取的方式都不一样，对于NSURLConnection来说，是从delegate方法-connection:willSendRequestForAuthenticationChallenge:回调回来的参数challenge中获取([challenge.protectionSpace serverTrust])。

2). 使用系统默认验证方式验证Trust Object。SecTrustEvaluate会根据Trust Object的验证策略，一级一级往上，验证证书链上每一级数字签名的有效性（上一部分有讲解），从而评估证书的有效性。

3). 如第二步验证通过了，一般的安全要求下，就可以直接验证通过，进入到下一步：使用Trust Object生成一份凭证([NSURLCredential credentialForTrust:serverTrust])，传入challenge的sender中([challenge.sender useCredential:cred forAuthenticationChallenge:challenge])处理，建立连接。

4). 假如有更强的安全要求，可以继续对Trust Object进行更严格的验证。常用的方式是在本地导入证书，验证Trust Object与导入的证书是否匹配。更多的方法可以查看Enforcing Stricter Server Trust Evaluation，这一部分在讲解AFNetworking源码中会讲解到。

5). 假如验证失败，取消此次Challenge-Response Authentication验证流程，拒绝连接请求。

ps: 假如是自建证书的，则会跳过第二步，使用第三部进行验证，因为自建证书的根CA的数字签名未在操作系统的信任列表中。

iOS授权验证的API和流程大概了解了


我们通过protectionSpace.authenticationMethod判断是否信任服务器证书 
- NSURLSessionAuthChallengeUseCredential = 0, 使用凭据 ，信任服务器证书 
- NSURLSessionAuthChallengePerformDefaultHandling = 1, 默认处理，忽略服务器证书 
- NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2, 整个请求被取消 凭据被忽略 
- NSURLSessionAuthChallengeRejectProtectionSpace = 3, 本次拒绝，下次重试