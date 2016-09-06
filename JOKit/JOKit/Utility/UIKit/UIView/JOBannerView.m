//
//  JOBannerView.m
//  JOKit
//
//  Created by 刘维 on 16/9/6.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOBannerView.h"
#import "JOKit.h"

static CGFloat const kDefaultBannerHeight = 67.f;
static NSTimeInterval const kDefaultDuration = 1.5f;
static NSTimeInterval const kDefaultAnimationTime = 0.5f;

@interface JOBannerView()

@property (nonatomic, copy) BannerTapBlock tapBlock;
@property (nonatomic, assign) NSTimeInterval duration;

@end

@implementation JOBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (void)initConfig {
    
    _bannerHeight = kDefaultBannerHeight;
    _duration = kDefaultDuration;
    
    self.messageLabel = [UILabel newAutoLayoutView];
    [_messageLabel setTextAlignment:NSTextAlignmentCenter];
    [_messageLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self addSubview:_messageLabel];
    
    [_messageLabel layoutEdge:UIEdgeInsetsMake(20., 0., 0., 0.) layoutItemHandler:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tapGesture];
}

- (void)tapAction {
    
    if (_tapBlock) {
        _tapBlock();
    }
}

+ (instancetype)showWithMessage:(NSString *)message {
    
    return [self showWithMessage:message duration:kDefaultDuration tapHandler:nil];
}

+ (instancetype)showWithMessage:(NSString *)message tapHandler:(BannerTapBlock)tapHandler {
    
    return [self showWithMessage:message duration:kDefaultDuration tapHandler:tapHandler];
}

+ (instancetype)showWithMessage:(NSString *)message duration:(NSTimeInterval)duration {
    
    return [self showWithMessage:message duration:duration tapHandler:nil];
}

+ (instancetype)showWithMessage:(NSString *)message duration:(NSTimeInterval)duration tapHandler:(BannerTapBlock)tapHandler {
    
    JOBannerView *bannerView = [JOBannerView newAutoLayoutView];
    [bannerView showWithMessage:message duration:duration tapHandler:tapHandler];
    return bannerView;
}

- (void)showWithMessage:(NSString *)message {
    
    [self showWithMessage:message duration:kDefaultDuration tapHandler:nil];
}

- (void)showWithMessage:(NSString *)message tapHandler:(BannerTapBlock)tapHandler {
    
    [self showWithMessage:message duration:kDefaultDuration tapHandler:tapHandler];
}

- (void)showWithMessage:(NSString *)message duration:(NSTimeInterval)duration {
    
    [self showWithMessage:message duration:duration tapHandler:nil];
}

- (void)showWithMessage:(NSString *)message duration:(NSTimeInterval)duration tapHandler:(BannerTapBlock)tapHandler {
    
    if (message && [message length]) {
        [_messageLabel setText:message];
        _duration = duration;
        _tapBlock = tapHandler;
        [self show];
    }
}

- (void)hidden {
    
    [self layoutTop:-_bannerHeight layoutItemHandler:nil];
    
    [UIView animateWithDuration:kDefaultAnimationTime
                     animations:^{
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [self setHidden:YES];
                         [self removeFromSuperview];
                     }];
}

- (void)show {
    
    UIView *view = [UIApplication sharedApplication].keyWindow;
    [view addSubview:self];
    
    [self layoutTop:-_bannerHeight layoutItemHandler:nil];
    [self layoutLeft:0. layoutItemHandler:nil];
    [self layoutRight:0. layoutItemHandler:nil];
    [self layoutHeight:_bannerHeight layoutItemHandler:nil];
    
    [view layoutIfNeeded];
    
    [self layoutTop:0 layoutItemHandler:nil];
    @weakify(self)
    [UIView animateWithDuration:kDefaultAnimationTime
                     animations:^{
                         [view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         @strongify(self)
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             [self hidden];
                         });
                     }];
}

@end
