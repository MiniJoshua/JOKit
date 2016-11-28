//
//  JOWebViewController.h
//  JOKit
//
//  Created by 刘维 on 16/11/18.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JOWebViewController : UIViewController

/**
 关闭不允许使用WKWebView,默认是允许的.那么8.0以上的系统将会使用WKWebView 8.0以下的将会使用UIWebView.
 */
- (void)closeWKWebViewEnable;

/**
 关闭webView的缓存. 默认为开启的.
 如果已经存在缓存的话,该方法不会为你清空已经存在的缓存,会使用缓存的数据.
 你需要自己调用下面提供的方法去清除缓存.
 */
- (void)closeWebCacheEnable;

/**
 设置进度条的颜色.

 @param color 进度条的颜色
 */
- (void)setProgressTintColor:(UIColor *)color;

/**
 使用的webView,可能是WKWebView或UIWebView

 @return 当前正在使用的webView
 */
- (id)usedWebView;

/*
 加载一个网页
 */
- (void)loadURLString:(NSString *)urlString;
- (void)loadURL:(NSURL *)url;
- (void)loadRequest:(NSURLRequest *)request;

/*
 移除当前的网页的缓存.
 */
- (void)removeURLCache;

/*
 根据request清除指定的缓存.
 */
+ (void)removeAllURLCache;
+ (void)removeURLCacheWithURLString:(NSString *)urlString;
+ (void)removeURLCacheWithURL:(NSURL *)url;
+ (void)removeURLCacheWithRequest:(NSURLRequest *)request;

@end
