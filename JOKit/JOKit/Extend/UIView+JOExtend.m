//
//  UIView+JOExtend.m
//  JOProjectBaseSDK
//
//  Created by 刘维 on 16/6/23.
//  Copyright © 2016年 刘维. All rights reserved.
//

#import "UIView+JOExtend.h"

@implementation UIView(Extend)

+ (instancetype)newAutoLayoutView {
    
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

- (instancetype)initForAutoLayout {
    
    self = [self init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (UIImage *)joViewImage {

    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)removeAllSubviews {

    for (UIView *view in self.subviews) {
        [view setHidden:YES];
        [view removeFromSuperview];
    }
}

@end
