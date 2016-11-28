//
//  NSObject+JOExtend.h
//  JOProjectBaseSDK
//
//  Created by 刘维 on 16/3/18.
//  Copyright © 2016年 刘维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JOMacro.h"

@interface NSObject (JOThreadPerformExtend)

/**
 *  执行一个SEL,可以传入多个参数。注意保持SEL里面的方法参数的数量与后面给定的参数的一致性(个数,参数类型)
 */
- (id)joPerformSelector:(SEL)selector arguments:(id)parameter,...;
- (id)joPerformSelector:(SEL)selector afterDelay:(NSTimeInterval)delay arguments:(id)parameter,...;
- (id)joPerformSelectorOnMainThread:(SEL)selector waitUntilDone:(BOOL)wait arguments:(id)parameter,...;
- (id)joPerformSelector:(SEL)selector onThread:(NSThread *)thr  waitUntilDone:(BOOL)wait arguments:(id)parameter,...;
- (id)joPerformSelectorInBackground:(SEL)selector arguments:(id)parameter,...;

/**
 *  执行一个block
 */
- (void)joPerformBlock:(void(^)(void))block;
- (void)joPerformBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay;

@end

@interface NSObject(JOSwizzle)

#pragma mark - Swizzling 交换两个方法的IMP

/**
 *  交换同一个类的对象方法中两个方法的IMP. 此方法应用于在交换类中实现了方法并交换.而不可以在其他类中实现一个方法进行交换
 *
 *  @param sel    对象方法SEL.
 *  @param newSel 需要交换的对象方法SEL.
 *
 *  @return 交换成功的状态.
 */
+ (BOOL)joSwizzleInstanceMethod:(SEL)sel withMehtod:(SEL)newSel;

/**
 *  交换类方法中两个方法的IMP
 *
 *  @param sel    类方法SEL.
 *  @param newSel 需要交换的类方法SEL.
 *
 *  @return 交换成功的状态.
 */
+ (BOOL)joSwizzleClassMethod:(SEL)sel withMehtod:(SEL)newSel;

/**
 *  交换两个实例方法的IMP.使用情况:可以在别的类中实现一个方法并与交换类中的某一个方法进行交换
 *
 *  @param fromClass    新增加的方法来自哪个类
 *  @param fromSel      新增加的方法
 *  @param swizzleClass 交换的类
 *  @param swizzleSEL   交换的方法
 *
 *  @return 交换成功的状态
 */
JO_EXTERN BOOL JOSwizzleInstanceMethod(Class fromClass, SEL fromSel, Class swizzleClass, SEL swizzleSEL);

/**
 *  交换两个类方法的IMP.使用情况:可以在别的类中实现一个方法并与交换类中的某一个方法进行交换
 *
 *  @param fromClass    新增加的方法来自哪个类
 *  @param fromSel      新增加的方法
 *  @param swizzleClass 交换的类
 *  @param swizzleSEL   交换的方法
 *
 *  @return 交换成功的状态
 */
JO_EXTERN BOOL JOSwizzleClassMethod(Class fromClass, SEL fromSel, Class swizzleClass, SEL swizzleSEL);

@end

@interface NSObject(JORuntimeExtend)

/**
 *  动态添加实例方法. 通过performSelector去调用
 *
 *  @param fromClass 添加的方法来自来个类.
 *  @param fromSel   添加的方法的SEL.
 *  @param toClass   添加到哪个类.
 *
 *  @return 添加成功与否的状态.
 */
JO_EXTERN BOOL JOAddInstanceMethod(Class fromClass, SEL fromSel, Class toClass);

/**
 *  动态添加类方法.  ps:如果需要调用这个动态添加的类方法: #import <objc/message.h>  
 *  objc_msgSend(boy, @selector(testtt),nil);  必须使用objc_msgSend去调用 
 *  项目的-->targets-> Enable Strict Checking of objc_msgSend Calls 设置为NO 即可以使用objc_msgSend
 *
 *  @param fromClass 添加的方法来自来个类.
 *  @param fromSel   添加的方法的SEL.
 *  @param toClass   添加到哪个类.
 *
 *  @return 添加成功与否的状态.
 */
JO_EXTERN BOOL JOAddClassMethod(Class fromClass, SEL fromSel, Class toClass);


/*
 往方法里面注入自己的block需要注意的:
 现在只支持只有三个参数的方法,多了的话,也只会给你传回3个参数让使用,还可能会出未知的问题
 PS:切记只能支持参数类型为id跟SEL的类型（id包括那些可以用id表示的类型）
 嵌入的block的写法 :
 e.g: - (void)test:(NSString *)str sizeValue:(NSValue *)sizeValue;
 那么对应的block应该是 void(^)(void *obj,NSString **str,NSValue **sizeValue) {
    //其中obj是对象本身  固定在第一个未知
    //后面的参数类型应该跟方法里面的一一对应 因为要在Block里面更改参数的值,需要传入指针的对象才行
    //这样你在自己的Block里面可以随意使用
 }
 */
/**
 动态的在一个方法注入一个自己的block.

 @param selector 需要注入的方法的SEL
 @param block JO_argcBlock_t
 @param beforeState YES 则在方法执行之前注入 NO 则在方法执行之后注入
 */
- (void)addBlockToSelector:(SEL)selector block:(JOAttributeNoescape JO_argcBlock_t)block beforeState:(BOOL)state;

/**
 动态的在一个方法执行之前注入一个自己的block.

 @param selector 需要注入的方法的SEL
 @param block 嵌入的Block
 */
- (void)addBlockToSelector:(SEL)selector beforeBlock:(JOAttributeNoescape JO_argcBlock_t)block;

/**
 动态在一个方法执行之后注入一个自己的block. 不过这种情况用起来意义不大

 @param selector 需要注入的方法的SEL
 @param block 嵌入的Block
 */
- (void)addBlockToSelector:(SEL)selector afterBlock:(JOAttributeNoescape JO_argcBlock_t)block;

/**
 *  获取该类中所有的实例方法的SEL:仅获取本身类的方法(包括私有的方法),不会获取父类的方法
 *
 *  @return 所有SEL的方法的集合:数组中存的是字符串的对象(NSStringFromSelector).
 */
+ (NSArray *)joSelectors;

/**
 *  获取该类中所有的实例方法的SEL(包括父类的,NSObject除外)
 *
 *  @return 所有SEL的方法的集合:数组中存的是字符串的对象(NSStringFromSelector).
 */
+ (NSArray *)joAllSelectors;

/**
 *  获取本类中所有的property属性.
 *
 *  @return 所有的property属性的字符串的array.
 */
+ (NSArray *)joPropertys;
/**
 *  获取该类中所有property的属性(包括父类的,NSObject除外).
 *
 *  @return 所有的property属性名的字符串的array.
 */
+ (NSArray *)joAllPropertys;

/**
 *  获取本类中所有的属性跟值的键值对.
 *
 *  @return 本类中所有的属性跟值的键值对.(如果value为nil的话,则不会在其中)
 */
- (NSDictionary *)joPropertyDics;

/**
 *  获取本类中所有的属性跟值的键值对:可以根据mapper提供的dic替换返回回来的dic中的key的值
 *  e.g: mapper = @{@"id":@"changID"} 那么该类中的id的属性在返回的字典类型将会被替换成changeID来作为Key值
 *
 *  @param mapper 需要替换的Mapper值:原来的值作为key value作为新的key
 *
 *  @return 本类中所有的属性跟值的键值对.
 */
- (NSDictionary *)joPropertyDicsWithKeyMapper:(NSDictionary *)mapper;

/**
 *  获取该类中所有的property的属性名跟值的键值对(包括父类的,NSObject除外)
 *
 *  @return 所有该类中的属性值作为key,值作为value的字典类型(如果value为nil的话,则不会在其中)
 */
- (NSDictionary *)joAllPropertyDics;

/**
 *  获取该类中所有的property的属性名跟值的键值对(包括父类的,NSObject除外).可以根据mapper提供的dic替换返回回来的dic中的key的值
 *  e.g: mapper = @{@"id":@"changID"} 那么该类中的id的属性在返回的字典类型将会被替换成changeID来作为Key值
 *
 *  @return 所有该类中的属性值作为key,值作为value的字典类型(如果value为nil的话,则不会在其中)
 */
- (NSDictionary *)joAllPropertyDicsWithKeyMapper:(NSDictionary *)mapper;

/**
 *  获取该类中所有的变量名(不包含父类的).
 *
 *  @return 所有未声明成Property的变量名和已经申明成Property的变量名name则会得到_name(字符串类型)
 */
+ (NSArray *)joIvars;

/**
 *  获取该类中所有的变量名(包括父类的,NSObject除外).
 *
 *  @return 所有未声明成Property的变量名和已经申明成Property的变量名name则会得到_name(字符串类型)
 */
+ (NSArray *)joAllIvars;

/**
 *  获取本类中所有的属性跟值的键值对.(包含未生成名propetry的也会获取到)(不包括父类的)
 *
 *  @return 本类中所有的属性跟值的键值对.(如果value为nil的话,则不会在其中)
 */
- (NSDictionary *)joIvarDics;

/**
 *  获取该类中所有的变量名(包括父类的,NSObject除外)(包含未生成名propetry的也会获取到).
 *
 *  @return 所有该类中的属性值作为key,值作为value的字典类型(如果value为nil的话,则不会在其中)
 */
- (NSDictionary *)joAllIvarDics;

/**
 *  所有类中所支持的协议.
 *
 *  @return 所有该类中所支持的协议的字符串.
 */
+ (NSArray *)joAllProtocols;

@end
