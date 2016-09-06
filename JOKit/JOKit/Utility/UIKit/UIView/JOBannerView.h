//
//  JOBannerView.h
//  JOKit
//
//  Created by 刘维 on 16/9/6.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BannerTapBlock)();

@interface JOBannerView : UIView

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, assign) CGFloat bannerHeight;

+ (instancetype)showWithMessage:(NSString *)message;
+ (instancetype)showWithMessage:(NSString *)message tapHandler:(BannerTapBlock)tapHandler;
+ (instancetype)showWithMessage:(NSString *)message duration:(NSTimeInterval)duration;
+ (instancetype)showWithMessage:(NSString *)message duration:(NSTimeInterval)duration tapHandler:(BannerTapBlock)tapHandler;

- (void)showWithMessage:(NSString *)message;
- (void)showWithMessage:(NSString *)message tapHandler:(BannerTapBlock)tapHandler;
- (void)showWithMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (void)showWithMessage:(NSString *)message duration:(NSTimeInterval)duration tapHandler:(BannerTapBlock)tapHandler;

- (void)hidden;

@end
