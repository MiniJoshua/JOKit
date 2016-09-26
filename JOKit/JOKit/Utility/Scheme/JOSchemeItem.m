//
//  JOSchemeItem.m
//  JOKit
//
//  Created by 刘维 on 16/9/5.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOSchemeItem.h"
#import "JOExceptionHelper.h"

#define FormatAssert(format) \
if (!format || ![format length]) { \
    JOException(@"JOSchemeItem exception.",@"map: format不能为空"); \
    return; \
} \

@interface JOSchemeItem()

@property (nonatomic, copy) NSString *scheme; //
@property (nonatomic, assign) BOOL modelState; //默认为NO 若为YES 则代表使用模态的方式添加一个视图

@property (nonatomic, copy) NSArray *params; //参数
@property (nonatomic, copy) NSArray *paramsValue; //参数的值
@property (nonatomic, strong) NSMutableDictionary *paramDics;//参数的key-value

@property (nonatomic, strong) Class bindClass;

@end

@implementation JOSchemeItem

- (void)itemMap:(NSString *)format bindClass:(Class)bindClass {

    [self itemMap:format bindClass:bindClass isModel:NO];
}

- (void)itemMap:(NSString *)format bindClass:(Class)bindClass isModel:(BOOL)modelState {

    FormatAssert(format);
    
    _modelState = modelState;
    [self parserFormat:format];
    self.bindClass = bindClass;
}

- (void)parserFormat:(NSString *)format {

    NSArray *schemeArray = [format componentsSeparatedByString:@":"];
    
    if ([schemeArray count] == 1){
        self.scheme = nil;
        self.scheme = [schemeArray firstObject];
        
        self.params = [NSArray array];
        
    }else if ([schemeArray count] == 2){
        self.scheme = nil;
        self.scheme = [schemeArray firstObject];
        
        JOBlock_Variable BOOL correctState = YES;
        NSArray *paramsArray = [[schemeArray lastObject] componentsSeparatedByString:@"/"];
        [paramsArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!obj || ![obj length]) {

                correctState = NO;
                *stop = YES;
            }
        }];
        
        if (correctState) {
            
            self.params = nil;
            self.params = [paramsArray copy];
        }
        
    }else {
       JOException(@"JOSchemeItem exception.",@"parserFormat: format仅支持obj:param1/param2/param3 or obj:param1 or obj: or obj");
    }
}

- (UIViewController *)viewController {
    
    SEL initSelector = sel_registerName("initWithSchemeParams:");
    
    UIViewController *viewController = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([_bindClass instancesRespondToSelector:initSelector]) {
        viewController = [[_bindClass alloc] performSelector:initSelector withObject:_paramDics];
    }
#pragma clang diagnostic pop
    
    if (_modelState) {
        //模态的形式展现
        return [[UINavigationController alloc] initWithRootViewController:viewController];
    }else {
        //非模态的形式展现
        return viewController;
    }
}

- (void)itemOpenWithparams:(NSArray *)params {
    
    self.paramDics = [NSMutableDictionary dictionary];

    if ([_params count] == [params count]) {
        [_params enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_paramDics setObject:params[idx] forKey:obj];
        }];
    }else {
        JOException(@"JOSchemeItem exception.", @"itemOpen: params的数量与Map中给定的params数量不一致");
    }

}

@end
