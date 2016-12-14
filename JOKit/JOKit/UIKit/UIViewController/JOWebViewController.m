//
//  JOWebViewController.m
//  JOKit
//
//  Created by 刘维 on 16/11/18.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOWebViewController.h"
#import "JOKit.h"
#import <WebKit/WebKit.h>

@interface JOWebViewController ()<WKNavigationDelegate,WKUIDelegate,UIWebViewDelegate> {

    BOOL        WKWebUnable;
    BOOL        webCacheUnable;
    NSInteger   startURLCount;
    CGFloat     progressValue;
}

@property (nonatomic, copy)     NSURLRequest    *request;
@property (nonatomic, strong)   WKWebView       *WKWebView;
@property (nonatomic, strong)   UIWebView       *webView;
@property (nonatomic, strong)   UIProgressView  *progressView;
@property (nonatomic, strong)   UIColor         *progressTintColor;

@property (nonatomic, strong)   NSTimer         *progressTimer;

@end

@implementation JOWebViewController

- (void)dealloc {

    if (JOWKWebViewEnable(WKWebUnable)) {
    
    }else {
        if (_progressTimer) {
            [_progressTimer invalidate];
            self.progressTimer = nil;
        }
    }
}

- (void)closeWKWebViewEnable {
    WKWebUnable = YES;
}

- (void)closeWebCacheEnable {
    webCacheUnable = YES;
}

- (void)setProgressTintColor:(UIColor *)color {

    self.progressTintColor = nil;
    self.progressTintColor = color;
}

- (id)usedWebView {

    if (JOWKWebViewEnable(WKWebUnable)) {
        return _WKWebView;
    }else {
        return _webView;
    }
}

#pragma mark - load
#pragma mark -

- (void)loadURLString:(NSString *)urlString {
    [self loadURL:[NSURL URLWithString:urlString]];
}

- (void)loadURL:(NSURL *)url {
    [self loadRequest:JODefaultURLRequest(url)];
}

- (void)loadRequest:(NSURLRequest *)request {
    
    self.request = nil;
    self.request = request;
}

#pragma mark - view
#pragma mark -

- (void)setupWKWebView {
    
    self.WKWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[WKWebViewConfiguration new]];
    [_WKWebView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_WKWebView setNavigationDelegate:self];
    [self.view addSubview:_WKWebView];
    
    [_WKWebView layoutTop:0.];
    [_WKWebView layoutLeft:0.];
    [_WKWebView layoutRight:0.];
    [_WKWebView layoutBottom:0.];
    
    @weakify(self);
    [self joObservered:_WKWebView keyPath:@"estimatedProgress" newValueBlock:^(id newValue) {
    @strongify(self);
       [self.progressView setProgress:[newValue floatValue] animated:YES];
    }];
    
    progressValue = 0.2;
}

- (void)setupWebView {

    self.webView = [UIWebView newAutoLayoutView];
    [_webView setDelegate:self];
    [_webView setScalesPageToFit:YES];
    [self.view addSubview:_webView];
    
    [_webView layoutTop:0.];
    [_webView layoutLeft:0.];
    [_webView layoutRight:0.];
    [_webView layoutBottom:0.];
}

- (void)loadView {

    [super loadView];
    
    [self loadWebView];
    
    if (!_progressTintColor) {
        _progressTintColor = JORGBMake(22., 165., 63.);
    }

    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [_progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_progressView setProgressTintColor:_progressTintColor];
    [self.view addSubview:_progressView];
    
    [_progressView layoutTop:64.];
    [_progressView layoutLeft:0.];
    [_progressView layoutRight:0.];
    [_progressView layoutHeight:2.];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self removeURLCache];
}

#pragma mark - remove cache
#pragma mark -

- (void)removeURLCache {
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:_request];
}

+ (void)removeAllURLCache {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

+ (void)removeURLCacheWithURLString:(NSString *)urlString {
    [self removeURLCacheWithRequest:JODefaultURLRequest([NSURL URLWithString:urlString])];
}

+ (void)removeURLCacheWithURL:(NSURL *)url {
    [self removeURLCacheWithRequest:JODefaultURLRequest(url)];
}

+ (void)removeURLCacheWithRequest:(NSURLRequest *)request {
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
}

#pragma mark - private
#pragma mark - 

- (void)loadWebView {
    
    if(JOWKWebViewEnable(WKWebUnable)) {
        [self setupWKWebView];
    }else {
        [self setupWebView];
    }

    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:_request];
    if (cachedResponse) {
        //cache已经存在 直接用web加载本地的数据
        NSLog(@"cache存在 直接加载本地的数据");
        
        if(JOWKWebViewEnable(WKWebUnable)) {
            [_WKWebView loadHTMLString:[[NSString alloc] initWithData:cachedResponse.data encoding:NSUTF8StringEncoding] baseURL:_request.URL];
        }else {
            [_webView loadHTMLString:[[NSString alloc] initWithData:cachedResponse.data encoding:NSUTF8StringEncoding] baseURL:_request.URL];
        }
    }else {
        //cache还不存在
        NSLog(@"cache不存在 需要从网络加载");
        if (!webCacheUnable) {
            
            NSURLSessionDownloadTask *task = [[NSURLSession sharedSession]
                                              downloadTaskWithRequest:_request
                                              completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                  
                                                  NSData *data = [NSData dataWithContentsOfURL:location];
                                                  NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:_request];
                                                  if ((!cachedResponse) && response && data) {
                                                      NSCachedURLResponse *cachedURLResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
                                                      [[NSURLCache sharedURLCache] storeCachedResponse:cachedURLResponse forRequest:_request];
                                                  }
                                              }];
            [task resume];
        }
        
        if(JOWKWebViewEnable(WKWebUnable)) {
            [_WKWebView loadRequest:_request];
        }else {
            [_webView loadRequest:_request];
        }
    }
    
    [self updateBarItemState];
}

- (void)progressFinished {
    
    [_progressView setProgress:1. animated:YES];
    [self joPerformBlock:^{
        [_progressView setHidden:YES];
    } afterDelay:1.];
    
    if (_progressTimer) {
        [_progressTimer invalidate];
        self.progressTimer = nil;
    }
    
    [self updateBarItemState];
}

- (void)progressStart {

    progressValue = 0.;
    [_progressView setProgress:0];
    [_progressView setHidden:NO];
    
    if (_progressTimer) {
        [_progressTimer invalidate];
        self.progressTimer = nil;
    }
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(progressUpate) userInfo:nil repeats:YES];
}

- (void)progressUpate {
    
        if (progressValue < 0.85) {
            progressValue += 0.03;
        }
    [_progressView setProgress:progressValue animated:YES];
}

- (void)WKWebProgressFinished {

    [self joPerformBlock:^{
        [_progressView setHidden:YES];
    } afterDelay:1.];
    [_progressView setProgress:0. animated:NO];
    [self updateBarItemState];
}

- (void)WKWebProgressStart {
    [_progressView setHidden:NO];
}

- (void)popWebController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goBack {

    if (JOWKWebViewEnable(WKWebUnable)) {
        [_WKWebView goBack];
    }else {
        [_webView goBack];
    }
}

- (void)more {
    
}

- (void)updateBarItemState {
    
    [self updateLeftBarItemState];
    
    UIBarButtonItem *moreBarItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStyleDone target:self action:@selector(more)];
    [self.navigationItem setRightBarButtonItem:moreBarItem];
}

- (void)updateLeftBarItemState {
    
    BOOL leftDoubleItemState = NO;
    if (JOWKWebViewEnable(WKWebUnable)) {
        leftDoubleItemState = [_WKWebView canGoBack];//[[[_WKWebView backForwardList] backList] count];
    }else {
        leftDoubleItemState = [_webView canGoBack];
    }
    
    if (leftDoubleItemState) {
        UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithTitle:@"后退" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
        UIBarButtonItem *closeBarItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(popWebController)];
        [self.navigationItem setLeftBarButtonItems:@[backBarItem,closeBarItem]];
    }else {
        UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithTitle:@"后退" style:UIBarButtonItemStyleDone target:self action:@selector(popWebController)];
        [self.navigationItem setLeftBarButtonItems:@[backBarItem]];
    }
}

JO_STATIC_INLINE BOOL JOWKWebViewEnable(BOOL WKWebUnable) {

    if(JOAllowMinSystemVersion(__IPHONE_8_0) && !WKWebUnable) {
        return YES;
    }else {
        return NO;
    }
}

JO_STATIC_INLINE NSURLRequest *JODefaultURLRequest(NSURL *url) {
    return [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.];
}

#pragma mark - WebView Delegate
#pragma mark -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    BOOL shouldStart = YES;
    if ([request.URL.absoluteString isEqualToString:@"webviewprogress:///complete"]) {
        [self progressFinished];
        return NO;
    }

    BOOL isFragmentJump = NO;
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    BOOL isHTTP = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"];
    if (shouldStart && !isFragmentJump && isHTTP && isTopLevelNavigation && navigationType != UIWebViewNavigationTypeBackForward) {
        //        _url = [request URL];
        [self progressStart];
    }

    return shouldStart;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    startURLCount++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    startURLCount--;
    if (!startURLCount) {
        [self progressFinished];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    startURLCount = 0;
    [self progressFinished];
}

#pragma mark - WKWebView Delegate
#pragma mark - 

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self WKWebProgressStart];
    
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    [self WKWebProgressStart];
//    [self updateBarItemState];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    if (webView.title.length > 0) {
        self.title = webView.title;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self WKWebProgressFinished];
    
    NSLog(@"backList:%lu",(unsigned long)[[[_WKWebView backForwardList] backList] count]);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self WKWebProgressFinished];
}

@end
