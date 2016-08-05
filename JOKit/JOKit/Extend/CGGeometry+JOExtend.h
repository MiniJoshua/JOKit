//
//  CGGeometry+JOExtend.h
//  JOKit
//
//  Created by 刘维 on 16/8/3.
//  Copyright © 2016年 Joshua. All rights reserved.
//


#ifndef CGGeometry_JOExtend_h
#define CGGeometry_JOExtend_h
#import <Foundation/Foundation.h>
#import "JOMacro.h"

JO_STATIC_INLINE CGSize JOSize(CGFloat width,CGFloat height)            { return CGSizeMake(width,height);}
#define JOMaxSize JOSize(HUGE,HUGE)
#define JOMinSize JOSize(CGFLOAT_MIN,CGFLOAT_MIN)

#endif /* CGGeometry_JOExtend_h */
