//
//  JOViewController.m
//  JOKit
//
//  Created by 刘维 on 16/11/16.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOViewController.h"
#import "JOActivityHUDView.h"
#import "JOBannerView.h"
#import "JOKit.h"

#define JOActivityHUDSize JOSize(100.,100)

@interface JOViewController () {

    UIColor *_HUDColor;
    UIColor *_bannerColor;
    UIColor *_bannerPromptColor;
    UIFont  *_bannerPromptFont;
}

@end

@implementation JOViewController

- (void)loadView {

    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - HUD
#pragma mark -

- (void)setActivityHUDColor:(UIColor *)color {
    _HUDColor = color;
}

- (void)showActivityHUD {
     [self showActivityHUDWithView:self.view style:JOActivityHUDStyleIndicator];
}

- (void)showActivityHUDWithView:(UIView *)view {
    [self showActivityHUDWithView:view style:JOActivityHUDStyleIndicator];
}

- (void)showActivityHUDWithStyle:(JOActivityHUDStyle)style {
    [self showActivityHUDWithView:self.view style:style];
}

- (void)showActivityHUDWithView:(UIView *)view style:(JOActivityHUDStyle)style {
    JOActivityHUDView *HUDView =  [JOActivityHUDView showInView:view style:style];
    [HUDView setActivityHUDBackgroundColor:_HUDColor];
}

- (void)hiddenActivityHUD {
    [self hiddenActivityHUDWithView:self.view];
}

- (void)hiddenActivityHUDWithView:(UIView *)view {
    [JOActivityHUDView hiddenInView:view];
}

#pragma mark - Banner
#pragma mark -

- (void)bannerColor:(UIColor *)bannerColor promptFont:(UIFont *)font promptColor:(UIColor *)color {
    
    _bannerColor = bannerColor;
    _bannerPromptFont = font;
    _bannerPromptColor = color;
}

- (void)showBannerWithPrompt:(NSString *)prompt {
    [self showBannerWithPromat:prompt duration:1.5 tapHandler:nil];
}

- (void)showBannerWithPromat:(NSString *)prompt duration:(NSTimeInterval)duration {
    [self showBannerWithPromat:prompt duration:duration tapHandler:nil];
}

- (void)showBannerWithPromat:(NSString *)prompt duration:(NSTimeInterval)duration tapHandler:(void(^)())handler {
    JOBannerView * bannerView = [JOBannerView showWithMessage:prompt duration:duration tapHandler:handler];
    [bannerView setBannerBackgroundColor:_bannerColor];
    [bannerView setBannerPromptColor:_bannerPromptColor];
    [bannerView setBannerPromptFont:_bannerPromptFont];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
