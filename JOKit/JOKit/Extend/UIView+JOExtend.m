//
//  UIView+JOExtend.m
//  JOProjectBaseSDK
//
//  Created by 刘维 on 16/6/23.
//  Copyright © 2016年 刘维. All rights reserved.
//

#import "UIView+JOExtend.h"

@implementation UIView(JOExtend)

+ (instancetype)newAutoLayoutView {
    
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

- (instancetype)initAutoLayout {
    
    self = [self init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (UIImage *)joViewSnapshotImage {

    //第一个参数表示大小。第二个参数表示是否是非透明的。YES 不需要显示半透明效果 NO 需要显示半透明效果。第三个参数是屏幕密度
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIViewController *)joViewController {

    for (UIView *view in self.subviews) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)removeAllSubviews {
    
    //[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (UIView *view in self.subviews) {
        [view setHidden:YES];
        [view removeFromSuperview];
    }
}

- (void)joViewCornerRadius:(CGFloat)radius {
    
    [[self layer] setCornerRadius:radius];
    [[self layer] setMasksToBounds:YES];
}

- (void)joViewBorderWidth:(CGFloat)width color:(UIColor *)color {
    
    CGFloat borderWidth = [[UIScreen mainScreen] scale] > 2.0 ? width / [[UIScreen mainScreen] scale] : width;
    [[self layer] setBorderWidth:borderWidth];
    [[self layer] setBorderColor:color.CGColor];
}

- (void)joViewBlurWithEffectStyle:(UIBlurEffectStyle)style {
    
    [self setBackgroundColor:[UIColor clearColor]];
    UIBlurEffect *blurEffect=[UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *visualEffectView=[[UIVisualEffectView alloc]initWithEffect:blurEffect];
//    effectView.contentView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    [visualEffectView setFrame:self.bounds];
    [self addSubview:visualEffectView];
}

@end

@implementation UIView(JOFrameExtend)

//JO_DYNAMIC_PROPERTY_CTYPE(origin,setOrigin,CGPoint);

- (CGFloat)y {
    return JOViewY(self);
}

- (void)setY:(CGFloat)y {
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x {
    return JOViewX(self);
}

- (void)setX:(CGFloat)x {
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)bottomY {
    return JOViewBottomY(self);
}

- (void)setBottomY:(CGFloat)bottomY {
    
    CGRect frame = self.frame;
    frame.origin.y = bottomY - frame.size.height;
    self.frame = frame;
}

- (CGFloat)rightX {
    return JOViewRightX(self);
}

- (void)setRightX:(CGFloat)rightX {
    
    CGRect frame = self.frame;
    frame.origin.x = rightX - frame.size.width;
    self.frame = frame;
}

- (UIEdgeInsets)edge {
    return UIEdgeInsetsMake(self.y, self.x, self.bottomY, self.rightX);
}

- (void)setEdge:(UIEdgeInsets)edge {
    
    [self setY:edge.top];
    [self setX:edge.left];
    [self setBottomY:edge.bottom];
    [self setRightX:edge.right];
}

- (CGFloat)width {
    return JOViewWidth(self);
}

- (void)setWidth:(CGFloat)width {
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return JOViewHeight(self);
}

- (void)setHeight:(CGFloat)height {
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return JOViewCenterX(self);
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.centerY);
}

- (CGFloat)centerY {
    return JOViewCenterY(self);
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.centerX, centerY);
}

- (CGPoint)origin {
    return JOViewOrigin(self);
}

- (void)setOrigin:(CGPoint)origin {
    
    CGRect newFrame = self.frame;
    newFrame.origin = origin;
    self.frame = newFrame;
}

- (CGSize)size {
    return JOViewSize(self);
}

- (void)setSize:(CGSize)size {

    CGRect newFrame = self.frame;
    newFrame.size = size;
    self.frame = newFrame;
}

- (void)joViewMoveByPoint:(CGPoint)point {
    self.center = CGPointMake(self.centerX+point.x, self.centerY+point.y);
}

- (void)joViewScale:(CGFloat)scale {
    [self setSize:CGSizeMake(self.width*scale, self.height*scale)];
}

- (void)joSizeToFit:(CGSize)size {
    CGSize viewSize = self.size;
    CGFloat scale = MIN(size.width/viewSize.width, size.height/viewSize.height);
    [self joViewScale:scale];
}

@end

@implementation UIView(JOMotionEffectExtend)

JO_DYNAMIC_PROPERTY_OBJECT(motionEffectGroup, setMotionEffectGroup, RETAIN, UIMotionEffectGroup *);

- (void)joAddMotionEffectWithXAxisOffset:(CGFloat)offsetX YAxisOffset:(CGFloat)offsetY {
    
    [self joRemoveMotionEffectExtend];
    
    self.motionEffectGroup = [UIMotionEffectGroup new];
    
    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xAxis.minimumRelativeValue = @(-fabs(offsetX));
    xAxis.maximumRelativeValue = @(fabs(offsetX));
    
    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yAxis.minimumRelativeValue = @(-fabs(offsetY));
    yAxis.maximumRelativeValue = @(fabs(offsetY));
    
    self.motionEffectGroup.motionEffects = @[xAxis,yAxis];
    
    [self addMotionEffect:self.motionEffectGroup];
    
}

- (void)joRemoveMotionEffectExtend {
    if (self.motionEffectGroup) {
        [self removeMotionEffect:self.motionEffectGroup];
        self.motionEffectGroup = nil;
    }
}

@end

@implementation UIView(JOAnimationExtend)

- (void)joAnimationWithDuration:(NSTimeInterval)duration
                      animation:(JOAnimation)animation
                      direction:(JODirection)direction
                 animationCurve:(JOAnimationCurve)animationCurve {
    
    NSString *animationType = @"";
    switch (animation) {
        case JOAnimationFade:{
            animationType = kCATransitionFade;
        }
            break;
        case JOAnimationPush:{
            animationType = kCATransitionPush;
        }
            break;
        case JOAnimationReveal:{
            animationType = kCATransitionReveal;
        }
            break;
        case JOAnimationMoveIn:{
            animationType = kCATransitionMoveIn;
        }
            break;
        case JOAnimationCube:{
            animationType = @"cube";
        }
            break;
        case JOAnimationOglFlip:{
            animationType = @"oglFlip";
        }
            break;
        case JOAnimationSuckEffect:{
            animationType = @"suckEffect";
        }
            break;
        case JOAnimationRippleEffect:{
            animationType = @"rippleEffect";
        }
            break;
        case JOAnimationPageCurl:{
            animationType = @"pageCurl";
        }
            break;
        case JOAnimationUnPageCurl:{
            animationType = @"pageUnCurl";
        }
            break;
        case JOAnimationCameraIrisHollowOpen:{
            animationType = @"cameraIrisHollowOpen";
        }
            break;
        case JOAnimationCameraIrisHollowClose:{
            animationType = @"cameraIrisHollowClose";
        }
            break;
        default:{
            animationType = @"";
        }
            break;
    }
    
    NSString *animationSubType = @"";
    switch (direction) {
        case JODirectionRight:{
            animationSubType = kCATransitionFromRight;
        }
            break;
        case JODirectionLeft:{
            animationSubType = kCATransitionFromLeft;
        }
            break;
        case JODirectionTop:{
            animationSubType = kCATransitionFromTop;
        }
            break;
        case JODirectionBottom:{
            animationSubType = kCATransitionFromBottom;
        }
            break;
        default:
            break;
    }
    
    if ([animationType length]) {
        
        CAMediaTimingFunction *fuction = nil;
        switch (animationCurve) {
            case JOAnimationCurveEaseInOut:{
                fuction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            }
                break;
            case JOAnimationCurveEaseIn:{
                fuction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            }
                break;
            case JOAnimationCurveEaseOut:{
                fuction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            }
                break;
            case JOAnimationCurveLinear:{
                fuction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            }
                break;
            default:
                break;
        }
        
        [self animationTransitionWithType:animationType subType:animationSubType duration:duration timingFunction:fuction];
        
    }else {
        
        UIViewAnimationTransition transition = UIViewAnimationTransitionFlipFromLeft;
        switch (animation) {
            case JOAnimationCurlDown:{
                transition = UIViewAnimationTransitionCurlDown;
            }
                break;
            case JOAnimationCurlUp:{
                transition = UIViewAnimationTransitionCurlUp;
            }
                break;
            case JOAnimationFlipFromLeft:{
                transition = UIViewAnimationTransitionFlipFromLeft;
            }
                break;
            case JOAnimationFlipFromRight:{
                transition = UIViewAnimationTransitionFlipFromRight;
            }
                break;
            default:
                break;
        }
        
        UIViewAnimationCurve animationCurve = UIViewAnimationCurveEaseInOut;
        switch (animationCurve) {
            case JOAnimationCurveEaseInOut:{
                animationCurve = UIViewAnimationCurveEaseInOut;
            }
                break;
            case JOAnimationCurveEaseIn:{
                animationCurve = UIViewAnimationCurveEaseIn;
            }
                break;
            case JOAnimationCurveEaseOut:{
                animationCurve = UIViewAnimationCurveEaseOut;
            }
                break;
            case JOAnimationCurveLinear:{
                animationCurve = UIViewAnimationCurveLinear;
            }
                break;
            default:
                break;
        }
        
        [self animationWithTransition:transition duration:duration curve:animationCurve];
    }
}

- (void)joAnimationWithDuration:(NSTimeInterval)duration
                      animation:(JOAnimation)animation
                      direction:(JODirection)direction {
    [self joAnimationWithDuration:duration animation:animation direction:direction animationCurve:JOAnimationCurveEaseInOut];
}

- (void)joAnimationWithDuration:(NSTimeInterval)duration animation:(JOAnimation)animation {
    [self joAnimationWithDuration:duration animation:animation direction:JODirectionLeft];
}

- (void)joAnimationWithAnimation:(JOAnimation)animation {
    [self joAnimationWithDuration:0.5f animation:animation];
}

- (void)animationTransitionWithType:(NSString *)type
                            subType:(NSString *)subType
                           duration:(NSTimeInterval)duration
                     timingFunction:(CAMediaTimingFunction *)timingFunction {
    
    CATransition *animation = [CATransition animation];
    animation.fillMode = kCAFillModeForwards;
    animation.duration = duration;
    animation.type = type;
    animation.subtype = subType;
    animation.timingFunction = timingFunction;
    [self.layer addAnimation:animation forKey:@"animation"];
    [UIView commitAnimations];
}

- (void)animationWithTransition:(UIViewAnimationTransition)transition
                       duration:(NSTimeInterval)duration
                          curve:(UIViewAnimationCurve)curve {
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationTransition:transition forView:self cache:YES];
    [UIView commitAnimations];
}

@end
