//
//  JOViewController.h
//  JOKit
//
//  Created by 刘维 on 16/11/16.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOViewControllerConstans.h"

@class JOActivityHUDView;

@interface JOViewController : UIViewController

- (void)activityHUDColor:(UIColor *)color;
/*
 在视图上面显示一个HUD,若给定的视图为nil,则默认为本身的视
 */
- (void)showActivityHUD;
- (void)showActivityHUDWithView:(UIView *)view;
- (void)showActivityHUDWithStyle:(JOActivityHUDStyle)style;
- (void)showActivityHUDWithView:(UIView *)view style:(JOActivityHUDStyle)style;

/*
 隐藏一个视图上面的HUD
 */
- (void)hiddenActivityHUD;
- (void)hiddenActivityHUDWithView:(UIView *)view;

/**
 设置Banner相关的属性.

 @param bannerColor banner的背景颜色.
 @param font 提示语的字体.
 @param color 提示语的颜色.
 */
- (void)bannerColor:(UIColor *)bannerColor promptFont:(UIFont *)font promptColor:(UIColor *)color;

/*
 显示一个banner
 */
- (void)showBannerWithPrompt:(NSString *)prompt;
- (void)showBannerWithPromat:(NSString *)prompt duration:(NSTimeInterval)duration;
- (void)showBannerWithPromat:(NSString *)prompt duration:(NSTimeInterval)duration tapHandler:(void(^)())handler;

@end
