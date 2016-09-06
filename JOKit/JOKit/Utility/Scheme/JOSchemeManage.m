//
//  JOSchemeManage.m
//  JOKit
//
//  Created by 刘维 on 16/9/5.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOSchemeManage.h"
#import "JOExceptionHelper.h"
#import "JOSchemeItem.h"

@interface JOSchemeManage()

@property (nonatomic, strong) UINavigationController *baseNavigationController;
@property (nonatomic, strong) NSMutableDictionary *maps;

@end

@implementation JOSchemeManage

+ (instancetype)sharedScheme {

    static JOSchemeManage *_sharedSchemeManage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSchemeManage = [[JOSchemeManage alloc] init];
    });
    return _sharedSchemeManage;
}

- (instancetype)init {

    self = [super init];
    if (self) {
        self.maps = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)mapPlistPath:(NSString *)plistPath {

    NSArray *maps = [NSArray arrayWithContentsOfFile:plistPath];
    
    @weakify(self);
    [maps enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    @strongify(self);
        [self map:[obj objectForKey:kMapKey] blindClass:[NSClassFromString([obj objectForKey:kClassKey]) class] isModel:[[obj objectForKey:kModelKey] boolValue]];
    }];
}

#pragma mark - map

- (void)map:(NSString *)format blindClass:(Class)bindClass {
    [self map:format blindClass:bindClass isModel:NO];
}

- (void)map:(NSString *)format blindClass:(Class)bindClass isModel:(BOOL)modelState {

    JOSchemeItem *item = [JOSchemeItem new];
    [item itemMap:format bindClass:bindClass isModel:modelState];
    
    NSArray *schemeArray = [format componentsSeparatedByString:@":"];
    if ([schemeArray count]) {
        [_maps setObject:item forKey:[schemeArray firstObject]];
    }else {
        JOException(@"JOSchemeManage exception",@"map: format仅支持obj:param1/param2/param3 or obj:param1 or obj: or obj");
    }
}

#pragma mark - open

- (void)open:(NSString *)format {

    NSString *keyString = @"";
    NSArray *schemeArray = [format componentsSeparatedByString:@":"];
    if ([schemeArray count]) {
        keyString = [schemeArray firstObject];
    }else {
        JOException(@"JOSchemeManage exception",@"open: format仅支持obj:param1/param2/param3 or obj:param1 or obj: or obj");
    }
    
    JOSchemeItem *item = [_maps objectForKey:keyString];
    [item itemOpen:format];
    
    if (!self.baseNavigationController) {
        JOException(@"JOSchemeManage exception",@"请先设置NavigationController");
        return;
    }
    
    //如果是模态的状态需要先disMiss后再操作
    if (self.baseNavigationController.presentedViewController) {
        [self.baseNavigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
    //根据返回的ViewController是否是UINavigationController的类来判断是否需要模态显示该视图
    UIViewController *toViewController = [item viewController];
    if ([toViewController isKindOfClass:[UINavigationController class]]) {
        [self.baseNavigationController presentViewController:toViewController animated:YES completion:nil];
    }else {
    
        [self.baseNavigationController pushViewController:toViewController animated:YES];
    }
}

- (void)openExternal:(NSString *)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark - pop

- (void)pop {
    [self popAnimated:YES];
}

- (void)popAnimated:(BOOL)animatedState {

    //如果是模态的状态需要先disMiss后再操作
    if (self.baseNavigationController.presentedViewController) {
        [self.baseNavigationController dismissViewControllerAnimated:animatedState completion:nil];
    }else{
        [self.baseNavigationController popViewControllerAnimated:animatedState];
    }
}

- (void)popToRoot {
    [self popToRootAnimated:YES];
}

- (void)popToRootAnimated:(BOOL)animatedState {

    if (self.baseNavigationController.presentedViewController) {
        [self.baseNavigationController dismissViewControllerAnimated:animatedState completion:nil];
    }
    [self.baseNavigationController popToRootViewControllerAnimated:animatedState];
}

- (void)setNavigationController:(UINavigationController *)navigationController {

    self.baseNavigationController = nil;
    self.baseNavigationController = navigationController;
}

@end