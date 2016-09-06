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
 *  @param modelState 是否模态显示 默认为NO.
 */
- (void)map:(NSString *)format blindClass:(Class)bindClass;
- (void)map:(NSString *)format blindClass:(Class)bindClass isModel:(BOOL)modelState;

/**
 *  打开一个地址.
 *
 *  @param format 地址.
 */
- (void)open:(NSString *)url;

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
