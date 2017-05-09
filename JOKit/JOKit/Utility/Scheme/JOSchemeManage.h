//
//  JOSchemeManage.h
//  JOKit
//
//  Created by 刘维 on 16/9/5.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//对应的是plist中的key
static NSString *const kMapKey = @"Map";
static NSString *const kParmasKey = @"Params";
static NSString *const kClassKey = @"Class";
static NSString *const kModelKey = @"Model";

@interface JOSchemeManage : NSObject

+ (instancetype)sharedScheme;

/**
 *  设置一个plist文件,会自动将plist文件中的匹配注入进来.
 *
 *  @param plistPath plist文件的路径.
 */
- (void)mapPlistPath:(NSString *)plistPath;

/**
 *  将一个ViewController与地址绑定在一起.
 *
 *  @param format     地址.
 *  @param bindClass  绑定的ViewController的类.
 */
- (void)map:(NSString *)format blindClass:(Class)bindClass;

/**
 *  将一个ViewController与地址绑定在一起.
 *
 *  @param format     地址.
 *  @param bindClass  绑定的ViewController的类.
 *  @param modelState 是否模态显示 默认为NO.
 */
- (void)map:(NSString *)format blindClass:(Class)bindClass isModel:(BOOL)modelState;

/**
 *  打开一个地址.
 *
 *  @param format 地址+参数类型 
 *  e.g:
 *  view:123/325,325/235  其中/之间用,分隔的 代表为数组 所以这三个参数为 123的字符串 325 325的数组  235的字符串
 *  view:123 代表只有一个参数 那就是123
 *  view:123/456 代表两个参数 123  456
 *  view:124,654  代表一个参数 为数组 里面的元素为 124 645
 */
- (void)open:(NSString *)format;

/**
 *  打开一个地址
 *
 *  @param format 地址 :viewMap.
 *  @param param1 参数 :现在可以是任何类型的参数形式. 顺序必须保持与map中给定的一致,不然你取的值可能错乱. plist里面Params里面的顺序跟这个需要保持一致.
 *                  PS: params如果传@"",代表该参数为nil，你在后面取到该值将会为nil
 */
- (void)open:(NSString *)format params:(id)param1,...;

/**
 *  打开一个外部的URL,类似于调用系统的电话,邮件,浏览器....
 *
 *  @param url 地址.
 */
- (void)openExternal:(NSString *)url;

//- (NSDictionary *)paramsWithSchemeName:(NSString *)scheme;

/**
 *  pop出一个视图,默认是按动画pop出去的
 */
- (void)pop;
- (void)popAnimated:(BOOL)animatedState;

/**
 *  pop到根视图,默认是按动画pop到根视图
 */
- (void)popToRoot;
- (void)popToRootAnimated:(BOOL)animatedState;

/**
 *  设置根的UINavigationController 一切都是基于该UINavigationController去做的操作(push pop present).
 *
 *  @param navigationController UINavigationController.
 */
- (void)setNavigationController:(UINavigationController *)navigationController;

@end
