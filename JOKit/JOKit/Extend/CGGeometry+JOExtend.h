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

/*角度与弧度之间的转换*/
JO_STATIC_INLINE CGFloat JOConvetDegreesToRadians(CGFloat degrees)  { return degrees * M_PI / 180.; }
JO_STATIC_INLINE CGFloat JOConvetRadiansToDegrees(CGFloat radians)  { return radians * 180. / M_PI; }
#define JORadians(degrees) JOConvetDegreesToRadians(degrees)
#define JODegrees(radians) JOConvetRadiansToDegrees(radians)

/*Size相关*/
JO_STATIC_INLINE CGSize JOSize(CGFloat width,CGFloat height)        { return CGSizeMake(width,height); }
#define JOMaxWidthSize(h)   JOSize(HUGE,h)
#define JOMaxHeightSize(w)  JOSize(w,HUGE)
#define JOMaxSize           JOSize(HUGE,HUGE)
#define JOMinWidthSize(h)   JOSize(CGFLOAT_MIN,h)
#define JOMinHeightSize(w)  JOSize(w,CGFLOAT_MIN)
#define JOMinSize           JOSize(CGFLOAT_MIN,CGFLOAT_MIN)

/*替换or增加Size中的某些值*/
JO_STATIC_INLINE CGSize JOSizeNewWidth(CGSize size,CGFloat w)       { return JOSize(w,size.height); }
JO_STATIC_INLINE CGSize JOSizeNewHeight(CGSize size,CGFloat h)      { return JOSize(size.width,h); }
JO_STATIC_INLINE CGSize JOSizeAddWidth(CGSize size,CGFloat w)       { return JOSize(size.width+w,size.height); }
JO_STATIC_INLINE CGSize JOSizeAddHeight(CGSize size,CGFloat h)      { return JOSize(size.width,size.height+h); }

/*替换or增加Point中的某些值*/
JO_STATIC_INLINE CGPoint JOPointNewX(CGPoint p,CGFloat x)           { return CGPointMake(x,p.y); }
JO_STATIC_INLINE CGPoint JOPointNewY(CGPoint p,CGFloat y)           { return CGPointMake(p.x,y); }
JO_STATIC_INLINE CGPoint JOPointMoveX(CGPoint p,CGFloat x)          { return CGPointMake(p.x+x,p.y); }
JO_STATIC_INLINE CGPoint JOPointMoveY(CGPoint p,CGFloat y)          { return CGPointMake(p.x,p.y+y); }
JO_STATIC_INLINE CGPoint JOPointMove(CGPoint p,CGPoint offset)      { return CGPointMake(p.x+offset.x,p.y+offset.y); }

/*根据point跟Size生成一个Rect*/
JO_STATIC_INLINE CGRect JORect(CGPoint p,CGSize size)               { return CGRectMake(p.x,p.y,size.width,size.height); }

/*获取Rect的中心点坐标*/
JO_STATIC_INLINE CGPoint JORectCenter(CGRect rect)                  { CGPoint cPoint; cPoint.x = CGRectGetMidX(rect); cPoint.y = CGRectGetMidY(rect); return cPoint; }

/*替换or增加Rect的Origin中的某些值*/
JO_STATIC_INLINE CGRect JORectNewOrigin(CGRect rect, CGPoint p)     { return JORect(p,rect.size); }
JO_STATIC_INLINE CGRect JORectNewX(CGRect rect, CGFloat x)          { return JORectNewOrigin(rect,JOPointNewX(rect.origin,x)); }
JO_STATIC_INLINE CGRect JORectNewY(CGRect rect, CGFloat y)          { return JORectNewOrigin(rect,JOPointNewY(rect.origin,y)); }
JO_STATIC_INLINE CGRect JORectMoveX(CGRect rect, CGFloat x)         { return JORectNewOrigin(rect,JOPointMoveX(rect.origin,x)); }
JO_STATIC_INLINE CGRect JORectMoveY(CGRect rect, CGFloat y)         { return JORectNewOrigin(rect,JOPointMoveY(rect.origin,y)); }
JO_STATIC_INLINE CGRect JORectMove(CGRect rect, CGPoint offset)     { return JORectNewOrigin(rect,JOPointMove(rect.origin,offset)); }

/*替换or增加Rect中Size中的某些值*/
JO_STATIC_INLINE CGRect JORectNewSize(CGRect rect, CGSize size)     { return JORect(rect.origin,size); }
JO_STATIC_INLINE CGRect JORectNewWidth(CGRect rect, CGFloat w)      { return JORectNewSize(rect,JOSizeNewWidth(rect.size,w)); }
JO_STATIC_INLINE CGRect JORectNewHeight(CGRect rect, CGFloat h)     { return JORectNewSize(rect,JOSizeNewHeight(rect.size,h)); }
JO_STATIC_INLINE CGRect JORectAddWidth(CGRect rect, CGFloat w)      { return JORectNewSize(rect,JOSizeAddWidth(rect.size,w)); }
JO_STATIC_INLINE CGRect JORectAddHeight(CGRect rect, CGFloat h)     { return JORectNewSize(rect,JOSizeAddHeight(rect.size,h)); }

#define JOEdgeInsetZero UIEdgeInsetsMake(0., 0., 0., 0.)

#endif /* CGGeometry_JOExtend_h */
