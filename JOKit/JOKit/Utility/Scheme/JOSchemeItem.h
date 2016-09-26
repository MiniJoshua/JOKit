//
//  JOSchemeItem.h
//  JOKit
//
//  Created by 刘维 on 16/9/5.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//typedef void(^SchemeParamsBlock)(NSDictionary * params);

@interface JOSchemeItem : NSObject

/**
 *  绑定一个地址与ViewController一起.
 *
 *  @param format     地址.
 *  @param bindClass  ViewController.
 *  @param modelState 是否是模态的方式展现. 默认为NO.
 */
- (void)itemMap:(NSString *)format bindClass:(Class)bindClass;
- (void)itemMap:(NSString *)format bindClass:(Class)bindClass isModel:(BOOL)modelState;

/**
 *  获取已经生成的ViewController.
 *
 *  @return ViewController.
 */
- (UIViewController *)viewController;

/**
 *  打开一个地址相应的ViewController.
 *
 *  @param format 地址.
 */
- (void)itemOpenWithparams:(NSArray *)params;

@end
