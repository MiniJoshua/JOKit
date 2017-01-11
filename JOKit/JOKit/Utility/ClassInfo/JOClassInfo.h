//
//  JOClassInfo.h
//  JOKit
//
//  Created by 刘维 on 17/1/5.
//  Copyright © 2017年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JOMacro.h"

typedef NS_OPTIONS(NSUInteger, JOEncodingType) {
    
    //属性的类型 ivar type
    JOEncodingTypeMask             = 0XFF,
    JOEncodingTypeUnknown           = 0,    //unknown
    JOEncodingTypeInt8              = 1,    //char----------->c
    JOEncodingTypeUInt8             = 2,    //unsigned char----------->C
    JOEncodingTypeInt16             = 3,    //short----------->s
    JOEncodingTypeUInt16            = 4,    //unsigned short----------->S
    JOEncodingTypeInt32             = 5,    //int----------->i
    JOEncodingTypeUInt32            = 6,    //unsigned int----------->I
    JOEncodingTypeInt64             = 7,    //long long----------->q
    JOEncodingTypeUInt64            = 8,    //unsigned long long----------->Q
    JOEncodingTypeFloat             = 9,    //float----------->f
    JOEncodingTypeDouble            = 10,   //double----------->d
    JOEncodingTypeBool              = 11,   //bool  ----> C++ bool or a C99 _Bool----------->B
    JOEncodingTypeVoid              = 12,   //void----------->v
    JOEncodingTypeCString           = 13,   //char *----------->*
    JOEncodingTypeObject            = 14,   //id NSObject----------->@
    JOEncodingTypeClass             = 15,   //Class----------->#
    JOEncodingTypeSEL               = 16,   //SEL----------->:
    JOEncodingTypeCArray            = 17,   //char[3] / char *c[3] / int[3]----------->[]
    JOEncodingTypeStruct            = 18,   //struct----------->{}
    JOEncodingTypeUnion             = 19,   //union----------->()
    JOEncodingTypePointer           = 20,   //void *----------->^v (e.g:void* --> ^v  int* -->^i 类推 PS:char* -->*)
    JOEncodingTypeBlock             = 21,   //block----------->@?
    
    JOEncodingTypeChar              = JOEncodingTypeInt8,
    JOEncodingTypeUChar             = JOEncodingTypeUInt8,
    JOEncodingTypeShort             = JOEncodingTypeInt16,
    JOEncodingTypeUShort            = JOEncodingTypeUInt16,
    JOEncodingTypeLong              = JOEncodingTypeInt32,  //long类型在64位系统中按32位来对待
    JOEncodingTypeULong             = JOEncodingTypeUInt32,
    JOEncodingTypeLongLong          = JOEncodingTypeInt64,
    JOEncodingTypeULongLong         = JOEncodingTypeUInt64,
    JOEncodingTypeCharPointer       = JOEncodingTypeCString,
    JOEncodingTypeId                = JOEncodingTypeObject,
    JOEncodingTypeLongDouble        = 22,   //longDouble ------>D
    
    //property的属性
    JOEncodingTypePropertyMask          = 0XFF00,
    JOEncodingTypePropertyReadonly      = 1 << 8,   //readonly
    JOEncodingTypePropertyCopy          = 1 << 9,   //copy
    JOEncodingTypePropertyReatin        = 1 << 10,  //reatin strong
    JOEncodingTypePropertyNonatomic     = 1 << 11,  //nonatomic
    JOEncodingTypePropertyCustomGetter  = 1 << 12,  //getter =
    JOEncodingTypePropertyCustomSetter  = 1 << 13,  //setter =
    JOEncodingTypePropertyDynamic       = 1 << 14,  //@dynamic
    JOEncodingTypePropertyWeak          = 1 << 15,  //weak
    
    JOEncodingTypePropertyStrong        = JOEncodingTypePropertyReatin,
    
    //函数返回值的限定语
    JOEncodingTypeQualifierMask     = 0XFF0000,
    JOEncodingTypeQualifierConst    = 1 << 16,   //const------>r
    JOEncodingTypeQualifierIn       = 1 << 17,   //in------>n
    JOEncodingTypeQualifierInout    = 1 << 18,  //inout------>N
    JOEncodingTypeQualifierOut      = 1 << 19,  //out------>o
    JOEncodingTypeQualifierBycopy   = 1 << 20,  //bycopy------>O
    JOEncodingTypeQualifierByref    = 1 << 21,  //byref------>R
    JOEncodingTypeQualifierOneway   = 1 << 22,  //oneway------>V
};

/**
 根据Encoding的char字符串获取对应的类型,包括方法的返回值中的修饰词
 可以查阅:
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html

 @param encodingType 类型的encoding的字符串
 @return JOEncodingType
 */
JO_EXTERN JOEncodingType JOEncodingGetType(const char *encodingType);

/*--------------------------------------关于Class的相关信息-----------------------------*/

/**
typedef struct objc_method *Method;  //method的结构体
typedef struct objc_ivar *Ivar;   //Ivar的结构体
typedef struct objc_category *Category;  //Category的结构体
typedef struct objc_property *objc_property_t;  //property的结构体

 Class的struct的定义 使用Class代替 struct objc_class *
struct objc_class {
    Class isa  OBJC_ISA_AVAILABILITY;
    
#if !__OBJC2__
    Class super_class                                        OBJC2_UNAVAILABLE;
    const char *name                                         OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
    struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
    struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
#endif
    
} OBJC2_UNAVAILABLE;
*/

/*---------------------Ivar的相关信息-----------------------*/
/**
 Ivar的struct定义
 struct objc_ivar {
 char *ivar_name; //ivar的名字
 char *ivar_type; //ivar的类型
 int ivar_offset; //ivar的offser
 #ifdef __LP64__
 int space;
 #endif
 } ;
 
 struct objc_ivar_list {
 int ivar_count ;
 #ifdef __LP64__
 int space ;
 #endif
 //variable length structure
struct objc_ivar ivar_list[1] ;
}
 */
@interface JOClassIvarInfo : NSObject

/*ivar*/
@property (nonatomic, assign, readonly) Ivar ivar;
/*变量名字*/
@property (nonatomic, strong, readonly) NSString *name;
/**
 ptrdiff_t 通常用来保存两个指针的减法的操作的结果,可以看做是位移.
 与size_t有点类似,都是与机器类型相关的类型.
 不同:size_t 是unsigned (正数) ptrdiff_t 是 signed (可以是负数)
 */
/*变量的位移*/
@property (nonatomic, assign, readonly) ptrdiff_t offset;
/*变量类型的string*/
@property (nonatomic, strong, readonly) NSString *typeEncoding;
/*变量的JOEncodingType类型*/
@property (nonatomic, assign, readonly) JOEncodingType encodingType;

/**
 初始化方法.

 @param ivar Ivar
 @return JOClassIvarInfo 也能是nil
 */
- (instancetype)initWithIvar:(Ivar)ivar;

@end

/*---------------------Method的相关信息-----------------------*/
/**
 Method的struct定义
struct objc_method {
    SEL method_name ; //方法的名字
    char *method_types; //方法的类型
    IMP method_imp; //方法的IMP
};

struct objc_method_list {
    struct objc_method_list *obsolete;
    
    int method_count ; 方法的数量
#ifdef __LP64__
    int space;
#endif
    struct objc_method method_list[1]; //可用的方法列表
}
*/

@interface JOClassMethodInfo : NSObject

/*Method*/
@property (nonatomic, assign, readonly) Method method;
/*方法名字*/
@property (nonatomic, strong, readonly) NSString *name;
/*SEL*/
@property (nonatomic, assign, readonly) SEL sel;
/*IMP*/
@property (nonatomic, assign, readonly) IMP imp;
/*参数的个数*/
@property (nonatomic, assign, readonly) size_t argumentCount;
/** 
 包括返回的类型跟参数的类型.
 e.g:   v24@0:8@16
 v24    v:返回值 24所有参数在调用栈中的size总和
 @0     @消息接受者 id类型  0:在栈中的偏移量
 :8     :SEL 选择器   8:偏移量
 @16    @参数类型      16:偏移量
 */
@property (nonatomic, strong, readonly) NSString *typeEncoding;
/*方法返回的类型*/
@property (nonatomic, strong, readonly) NSString *retunTypeEncoding;
/*方法返回的JOEncodingType包含了返回前面的修饰词(in out inout bycopy oneway...)*/
@property (nonatomic, assign, readonly) JOEncodingType returnEncodingType;
/*所有的参数类型字符串的数组*/
@property (nonatomic, strong, readonly) NSArray <NSString *> *argumentTypeEncodingArray;

/**
 初始化方法.

 @param method Method.
 @return JOClassMethodInfo 也可能是nil.
 */
- (instancetype)initWithMethod:(Method)method;

@end

@interface JOClassInfo : NSObject

@end
