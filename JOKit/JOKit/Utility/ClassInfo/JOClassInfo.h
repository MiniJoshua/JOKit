//
//  JOClassInfo.h
//  JOKit
//
//  Created by 刘维 on 17/1/5.
//  Copyright © 2017年 Joshua. All rights reserved.
//

/*
 参考YYKit中的实现
 */

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
    JOEncodingTypePropertyReadonly      = 1 << 8,   //readonly  -------->R
    JOEncodingTypePropertyCopy          = 1 << 9,   //copy  -------->C
    JOEncodingTypePropertyReatin        = 1 << 10,  //reatin strong  -------->&
    JOEncodingTypePropertyNonatomic     = 1 << 11,  //nonatomic  -------->N
    JOEncodingTypePropertyCustomGetter  = 1 << 12,  //getter = -------->G
    JOEncodingTypePropertyCustomSetter  = 1 << 13,  //setter = -------->S
    JOEncodingTypePropertyDynamic       = 1 << 14,  //@dynamic -------->D
    JOEncodingTypePropertyWeak          = 1 << 15,  //weak  -------->W
    
    JOEncodingTypePropertyStrong        = JOEncodingTypePropertyReatin,
    
    
    /**
     https://stackoverflow.com/questions/5609564/objective-c-in-out-inout-byref-byval-and-so-on-what-are-they
     http://www.informit.com/articles/article.aspx?p=1438422&seqNum=2
     */
    //函数参数以及返回类型的限定词
    JOEncodingTypeQualifierMask     = 0XFF0000,
    JOEncodingTypeQualifierConst    = 1 << 16,   //const------>r  可以针对返回值跟参数
    /**
     argument is an input argument only and won’t be referenced later
     */
    JOEncodingTypeQualifierIn       = 1 << 17,   //in------>n     仅针对参数  貌似也能对函数返回值做限定 不会报错 也能被解析出来
    JOEncodingTypeQualifierInout    = 1 << 18,  //inout------>N   仅针对参数 默认的  貌似也能对函数返回值做限定 不会报错 也能被解析出来
    /**
     argument is an output argument only, used to return a value by reference
     */
    JOEncodingTypeQualifierOut      = 1 << 19,  //out------>o     仅针对参数   貌似也能对函数返回值做限定 不会报错 也能被解析出来
    
    
    JOEncodingTypeQualifierBycopy   = 1 << 20,  //bycopy------>O  针对返回值跟参数
    /**
     不是传入地址的约束
     */
    JOEncodingTypeQualifierByref    = 1 << 21,  //byref------>R   针对返回值跟参数  默认的
    
    /**
     不需要中断等待这个函数执行完在继续,因为没必要, 如果你想对立面的某种状态进行捕捉的话就不能加该约束
     */
    JOEncodingTypeQualifierOneway   = 1 << 22,  //oneway------>V  仅针对返回值 且返回值为void
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

#pragma mark - Ivar

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

#pragma mark - Method

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

/* Method */
@property (nonatomic, assign, readonly) Method method;
/* 方法名字 */
@property (nonatomic, strong, readonly) NSString *name;
/* SEL */
@property (nonatomic, assign, readonly) SEL sel;
/* IMP */
@property (nonatomic, assign, readonly) IMP imp;
/* 参数的个数 */
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
/**方法返回的类型
 PS:对于 -(byref union JOUnion)byrefFunUnion;  得到的返回类型就直接为R 而非是R(...)
    对于 -(inout union JOUnion)funUnion; 得到的返回的类型就为正常的 N(...)
    只要是byref修饰的 都只返回R 后面不会有返回类型,不知道是这个byref的特殊性还是啥原因
    查了相关byref的资料:这是一个默认的属性 貌似解释的是一个proxy可以在远端被创建.并不是用来限定必须传入对象的引用
                    你可以通过一个代理事件来获取该对象,而不是非要等到他被加载了之后才行.
    bycopy的话,说明这个参数必须遵循NSCodying的协议
    
    所以在针对byref的特殊情况返回的时候,我会通过typeEncoding中去截取R后面的内容最为retunTypeEncoding的值
 */
@property (nonatomic, strong, readonly) NSString *retunTypeEncoding;
/*方法返回的JOEncodingType包含了返回前面的修饰词(in out inout bycopy oneway...)*/
@property (nonatomic, assign, readonly) JOEncodingType returnEncodingType;
/**
 所有的参数类型字符串的数组
 第一个为返回的类型
 第二个为消息的接受者 id
 第三个为消息的SEL
 第四个开始才是传入的参数.
 */
@property (nonatomic, strong, readonly) NSArray <NSString *> *argumentTypeEncodingArray;

/**
 初始化方法.

 @param method Method.
 @return JOClassMethodInfo 也可能是nil.
 */
- (instancetype)initWithMethod:(Method)method;

@end

#pragma mark - Property

/*---------------------property的相关信息-----------------------*/

/**
 typedef struct {
 const char *name;          // The name of the attribute
 const char *value;          // The value of the attribute (usually empty)
} objc_property_attribute_t;
 
 objc_class的struct中没有包含objc_property的对象,
 猜想其原因应该是:property的属性的变量在编译期间会被转换成set get ivar分别保存,所有没必要再保存吧
 */

@interface JOClassPropertyInfo : NSObject

@property (nonatomic, assign, readonly) objc_property_t property;
/* property的名字 */
@property (nonatomic, strong, readonly) NSString *name;
/**
 property对应的ivar的名字,一般默认是在前面加上 _
 @synthesize 可以使用这个改变property对应的名字
 */
@property (nonatomic, strong, readonly) NSString *ivarName;
/**
 property的attributes的属性.
 e.g: T@"JOObject<myProtocol>",R,&,N,V_non_retain_readonly_protocol_object
 */
@property (nonatomic, strong, readonly) NSString *propertyAttributes;
/* property的类型 即上面的T对应的值:@"JOObject<myProtocol>" */
@property (nonatomic, strong, readonly) NSString *typeEncoding;
/** 
 JOEncodingType 包含了所有的property的相关属性以及类型
 取类型: encodingType & JOEncodingTypeMask 即可获得类型部分在与具体的类型做&操作 就能得到是否属于具体的类型.
 取属性(retain...): encodingType & JOEncodingTypePropertyMask  跟上面的一样的操作
 */
@property (nonatomic, assign, readonly) JOEncodingType encodingType;
/* Class类型 当不是一个object类型的时候为nil*/
@property (nonatomic, assign, readonly) Class cls;
/* get方法的SEL */
@property (nonatomic, assign, readonly) SEL getter;
/* set方法的SEL */
@property (nonatomic, assign, readonly) SEL setter;
/* 所有的protocols 不存在的时候为nil*/
@property (nonatomic, strong, readonly) NSArray<NSString *> *protocols;

/**
 初始化方法

 @param property objc_property_t
 @return JOClassPropertyInfo 或者 nil
 */
- (instancetype)initWithProperty:(objc_property_t)property;

@end

#pragma mark - Class Info

@interface JOClassInfo : NSObject

/* Class */
@property (nonatomic, assign, readonly) Class cls;
/* super class */
@property (nonatomic, assign, readonly) Class superCls;
/* metaCls */
@property (nonatomic, assign, readonly) Class metaCls;
/* 是否是元类 */
@property (nonatomic, assign, readonly) BOOL isMeta;
/* 父类的JOClassInfo的对象 */
@property (nonatomic, strong, readonly) JOClassInfo *superClassInfo;
/* 类名 */
@property (nonatomic, strong, readonly) NSString *name;
/* 类所支持的协议 */
@property (nonatomic, strong, readonly) NSArray <NSString *> *protocols;
/* ivar 的字典类型 key为ivar的名字  value为JOClassIvarInfo */
@property (nonatomic, strong, readonly) NSDictionary <NSString *, JOClassIvarInfo *> *ivarInfos;
/**
 method 的字典类型 key为method的名字  value为JOClassMethodInfo 
 PS:里面会包含所有catgory里面新增的方法.
 */
@property (nonatomic, strong, readonly) NSDictionary <NSString *, JOClassMethodInfo *> *methodInfos;
/* property 的字典类型 key为property的名字  value为JOClassPropertyInfo */
@property (nonatomic, strong, readonly) NSDictionary <NSString *, JOClassPropertyInfo *> *propertyInfos;

/**
 得到一个class的JOClassInfo的对象.
 在你第一次调用这个时候或者已经存下在缓存中,你必须确保class没有使用class_addMethod等方法为其添加新的方法或者ivar.
 如果更改该过你需要使用下面提供的classInfoUpdateWithClass去获取新的

 @param cls Class.
 @return JOClassInfo 或者 nil.
 */
+ (instancetype)classInfoWithClass:(Class)cls;
+ (instancetype)classInfoWithClassName:(NSString *)className;

/**
 得到一个class的JOClassInfo的对象.
 你的class使用class_addMethod等方法为其添加新的方法或者ivar.需要调用该方法去获取JOClassInfo的对象.
 在你没法确定其是否使用那些runtime的方法为其添加过方法或者ivar的时候,建议你也使用该方法去拿JOClassInfo该对象.

 @param cls Class.
 @return JOClassInfo 或者 nil.
 */
+ (instancetype)classInfoUpdateWithClass:(Class)cls;
+ (instancetype)classInfoUpdateWithClassName:(NSString *)className;

@end
