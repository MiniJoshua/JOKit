//
//  UIView+JOExtend.m
//  JOProjectBaseSDK
//
//  Created by 刘维 on 16/6/23.
//  Copyright © 2016年 刘维. All rights reserved.
//

#import "UIView+JOExtend.h"
 #import <objc/runtime.h>

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
