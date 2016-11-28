//
//  JOActivityHUDView.m
//  JOKit
//
//  Created by 刘维 on 16/11/17.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOActivityHUDView.h"
#import "JOKit.h"
#import "JOLoadingView.h"

#define kJOActivityViewSize     JOSize(100., 100.)
#define kJOActivityHUDInset     UIEdgeInsetsMake(20., 20., -20., -20)

@implementation JOActivityHUDView

- (instancetype)initWithActivityHUDStyle:(JOActivityHUDStyle)style {

    self = [super init];
    if (self) {
        
        [self setBackgroundColor:JORGBAMake(0., 0., 0., 0.7)];
        [self joViewCornerRadius:6.];

        UIView *activityHUD = [self activityHUDWithStyle:style];
        [self addSubview:activityHUD];
    
        [activityHUD layoutEdge:kJOActivityHUDInset];
    }
    return self;
}

- (void)setActivityHUDBackgroundColor:(UIColor *)activityHUDBackgroundColor {

    if (activityHUDBackgroundColor) {
        _activityHUDBackgroundColor = activityHUDBackgroundColor;
        [self setBackgroundColor:_activityHUDBackgroundColor];
    }else {
        [self setBackgroundColor:JORGBAMake(0., 0., 0., 0.7)];
    }
}

+ (instancetype)activityHUDViewWithStyle:(JOActivityHUDStyle)style {
    
    return [[self alloc] initWithActivityHUDStyle:style];
}

+ (instancetype)showInView:(UIView *)view {

    return [self showInView:view style:JOActivityHUDStyleIndicator size:kJOActivityViewSize];
}

+ (instancetype)showInView:(UIView *)view style:(JOActivityHUDStyle)style {

    return [self showInView:view style:style size:kJOActivityViewSize];
}

+ (instancetype)showInView:(UIView *)view style:(JOActivityHUDStyle)style size:(CGSize)size{

    JOActivityHUDView *HUDView = [JOActivityHUDView activityHUDViewWithStyle:style];
    [HUDView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view addSubview:HUDView];
    
    [HUDView layoutCenterView:view];
    [HUDView layoutSize:size];
    
    return HUDView;
}

+ (void)hiddenInView:(UIView *)view {
    
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            [subview setHidden:YES];
            [subview removeFromSuperview];
        }
    }
}

#pragma mark - privite

- (UIView *)activityHUDWithStyle:(JOActivityHUDStyle)style {
    
    if (style == JOActivityHUDStyleIndicator) {
        
        UIActivityIndicatorView *actitityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [actitityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [actitityIndicatorView startAnimating];
        [actitityIndicatorView hidesWhenStopped];
        return actitityIndicatorView;
        
    }else if (style == JOActivityHUDStyleCircleBall) {
        
        JOLoadingView *loadingView = [JOLoadingView loadingViewWithModel:JOLoadingStyleTraceCircleBall loadingItemBlock:^(JOLoadingItem *item) {
            JOCircleBallLoadingItem *circleBallItem = (JOCircleBallLoadingItem *)item;
            circleBallItem.ballCount = 10;
            circleBallItem.intervalTime = 0.1;
            circleBallItem.startColor = JORGBAMake(230., 230., 230., 1.);
            circleBallItem.endColor = JORGBAMake(38., 38., 38., 0.7);
            circleBallItem.ballRadius = 4.;
            circleBallItem.animationDuration = 1.5;
            circleBallItem.animationIntervalTime = 2.;
        }];
        return loadingView;
    }else if (style == JOActivityHUDStyleCircleLine) {
        
        JOLoadingView *loadingView = [JOLoadingView loadingViewWithModel:JOLoadingStyleCircleLine loadingItemBlock:^(JOLoadingItem *item) {
            JOCircleLineLoadingItem *loadintItem = (JOCircleLineLoadingItem *)item;
            loadintItem.colors = @[(__bridge id)JORGBAMake(230., 230., 230., 1.).CGColor,(__bridge id)JORGBAMake(230., 230., 230., 1.).CGColor];
            loadintItem.locations = @[@(0.),@(1.)];
        }];
        
        return loadingView;
        
    }else if (style == JOActivityHUDStyleSixPolygonals) {
        
        JOLoadingView *loadingView = [JOLoadingView loadingViewWithModel:JOLoadingStyleSixPolygonals loadingItemBlock:^(JOLoadingItem *item) {
            JOSixPolygonalsLoadingItem *loadintItem = (JOSixPolygonalsLoadingItem *)item;
            loadintItem.polygonalColor = JORGBMake(255., 255., 255.);
            loadintItem.polygonalBorderColor = JORGBAMake(218., 218., 218., 0.9);
            loadintItem.polygonalBorderWidth = 1.;
            loadintItem.offset = -1.5;
        }];
        
        return loadingView;
        
    }else if (style == JOActivityHUDStyleCircleDrawLine) {
        
        JOLoadingView *loadingView = [JOLoadingView loadingViewWithModel:JOLoadingStyleCircleDrawLine loadingItemBlock:^(JOLoadingItem *item) {
            JOCircleLineDrawLoadingItem *loadintItem = (JOCircleLineDrawLoadingItem *)item;
            loadintItem.maxLineCount = 76.;
            loadintItem.drawLineIntervalTime = 0.15;
            loadintItem.ballOneColor = [UIColor clearColor];
            loadintItem.ballTwoColor = [UIColor clearColor];
            
        }];
        return loadingView;
    }
    return nil;
}

@end
