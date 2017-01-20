//
//  JOClassInfo.m
//  JOKit
//
//  Created by 刘维 on 17/1/5.
//  Copyright © 2017年 Joshua. All rights reserved.
//

#import "JOClassInfo.h"

JOEncodingType JOEncodingGetType(const char *encodingType) {
    char *type = (char *)encodingType;
    if (!type || strlen(type) == 0) {
        return JOEncodingTypeUnknown;
    }
    
    //限定词可以是一个组合: - (in out void)test;   - (bycopy out void)test;
    JOEncodingType qualifierType = 0;
    BOOL qualifierEndstate = NO;
    while (!qualifierEndstate) {
        if (!memcmp(type,"r",1)) {
            qualifierType |= JOEncodingTypeQualifierConst;
            type++;
        }else if (!memcmp(type,"n",1)) {
            qualifierType |= JOEncodingTypeQualifierIn;
            type++;
        }else if (!memcmp(type,"N",1)) {
            qualifierType |= JOEncodingTypeQualifierInout;
            type++;
        }else if (!memcmp(type,"o",1)) {
            qualifierType |= JOEncodingTypeQualifierOut;
            type++;
        }else if (!memcmp(type,"O",1)) {
            qualifierType |= JOEncodingTypeQualifierBycopy;
            type++;
        }else if (!memcmp(type,"R",1)) {
            qualifierType |= JOEncodingTypeQualifierByref;
            type++;
        }else if (!memcmp(type,"V",1)) {
            qualifierType |= JOEncodingTypeQualifierOneway;
            type++;
        }else {
            qualifierEndstate = YES;
        }
    }
    
    if (strlen(type) == 0) {
        return JOEncodingTypeUnknown;
    }
    
    if (!memcmp(type, "c", 1)) return JOEncodingTypeInt8        | qualifierType;
    if (!memcmp(type, "C", 1)) return JOEncodingTypeUInt8       | qualifierType;
    if (!memcmp(type, "s", 1)) return JOEncodingTypeInt16       | qualifierType;
    if (!memcmp(type, "S", 1)) return JOEncodingTypeUInt16      | qualifierType;
    if (!memcmp(type, "i", 1)) return JOEncodingTypeInt32       | qualifierType;
    if (!memcmp(type, "I", 1)) return JOEncodingTypeUInt32      | qualifierType;
    if (!memcmp(type, "q", 1)) return JOEncodingTypeInt64       | qualifierType;
    if (!memcmp(type, "Q", 1)) return JOEncodingTypeUInt64      | qualifierType;
    if (!memcmp(type, "f", 1)) return JOEncodingTypeFloat       | qualifierType;
    if (!memcmp(type, "d", 1)) return JOEncodingTypeDouble      | qualifierType;
    if (!memcmp(type, "B", 1)) return JOEncodingTypeBool        | qualifierType;
    if (!memcmp(type, "v", 1)) return JOEncodingTypeVoid        | qualifierType;
    if (!memcmp(type, "*", 1)) return JOEncodingTypeCString     | qualifierType;
    if (!memcmp(type, "#", 1)) return JOEncodingTypeClass       | qualifierType;
    if (!memcmp(type, ":", 1)) return JOEncodingTypeSEL         | qualifierType;
    if (!memcmp(type, "[", 1)) return JOEncodingTypeCArray      | qualifierType;
    if (!memcmp(type, "{", 1)) return JOEncodingTypeStruct      | qualifierType;
    if (!memcmp(type, "(", 1)) return JOEncodingTypeUnion       | qualifierType;
    if (!memcmp(type, "^", 1)) return JOEncodingTypePointer     | qualifierType;
    if (!memcmp(type, "D", 1)) return JOEncodingTypeLongDouble  | qualifierType;
    if (!memcmp(type, "@", 1)) {
        if (strlen(type)==2 && !memcmp(type+1, "?", 1) ) {
            return JOEncodingTypeBlock  | qualifierType;
        }else {
            return JOEncodingTypeObject  | qualifierType;
        }
    }
    return JOEncodingTypeUnknown  | qualifierType;
}

#pragma mark - Class Ivar Info

@implementation JOClassIvarInfo

- (instancetype)initWithIvar:(Ivar)ivar {

    if (!ivar) {
        return nil;
    }
    
    self = [super init];
    
    if (self) {
        
        const char *typeName = ivar_getName(ivar);
        const char *typeEncoding = ivar_getTypeEncoding(ivar);
        
        _ivar = ivar;
        _offset  = ivar_getOffset(ivar);
        
        if (typeName) {
            _name = [NSString stringWithUTF8String:typeName];
        }
        
        if (typeEncoding) {
            _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
            _encodingType = JOEncodingGetType(typeEncoding);
        }
    }
    return self;
}

@end

#pragma mark - Class Method Info

@implementation JOClassMethodInfo

- (instancetype)initWithMethod:(Method)method {

    if (!method) {
        return nil;
    }
    
    self = [super init];
    
    if (self) {
        _method = method;
        _sel = method_getName(method);
        _name = NSStringFromSelector(_sel);
        _imp = method_getImplementation(method);
        _argumentCount = method_getNumberOfArguments(method);
        const char *typeEncoding = method_getTypeEncoding(method);
        if (typeEncoding) {
            _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
        }else {
            _typeEncoding = @"";
        }
        
        char *returnTypeEncoding = method_copyReturnType(method);
        if (returnTypeEncoding) {
            
            //如果为R的话 需要从typeEncoding中取对应的类型
            if (!memcmp(returnTypeEncoding, "R", 1)) {
                
                size_t temp = 1;
                while (*(typeEncoding+temp) < '0' || *(typeEncoding+temp) > '9') {
                    temp++;
                }
                char tempTypeEncoding[temp];
                memcpy(tempTypeEncoding, typeEncoding, temp);
                _retunTypeEncoding = [NSString stringWithUTF8String:tempTypeEncoding];
                
            }else{
                _retunTypeEncoding = [NSString stringWithUTF8String:returnTypeEncoding];
            }
            
            free(returnTypeEncoding);
        }else {
           _retunTypeEncoding = @"";
        }
        
        _returnEncodingType = JOEncodingGetType(returnTypeEncoding);
        
        NSMutableArray *argTypes = [NSMutableArray array];
        for (int i = 0; i < _argumentCount; i++) {
            char *argType = method_copyArgumentType(method, i);
            NSString *type;
            if (argType) {
                type = [NSString stringWithUTF8String:argType];
                free(argType);
            }else {
                type = @"";
            }
            [argTypes addObject:type];
        }
        _argumentTypeEncodingArray = [argTypes copy];
    }
    
    return self;
}

@end

#pragma mark - Class Property Info

@implementation JOClassPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property {

    if (!property) {
        return nil;
    }
    
    self = [super init];
    
    if (self) {
        _property = property;
        const char *propertyName = property_getName(property);
        _name =(propertyName)?[NSString stringWithUTF8String:propertyName]:nil;
        const char *attribute = property_getAttributes(property);
        _propertyAttributes = (attribute)?[NSString stringWithUTF8String:attribute]:nil;
        
        JOEncodingType type = 0;
        uint attributeCount;
        objc_property_attribute_t *attributes = property_copyAttributeList(property, &attributeCount);
        
        @JOExitExcute{
            if (attributes) {
                free(attributes);
            }
        };
        
        for (int i = 0; i < attributeCount; i++) {
            const char *attributeName = attributes[i].name;
            const char *attributeValue = attributes[i].value;
            
            if (!(memcmp(attributeName, "T", 1))) {

                if (attributeValue) {
                    _typeEncoding = [NSString stringWithUTF8String:attributeValue];
                    type = JOEncodingGetType(attributeValue);
                    NSScanner *scanner = [NSScanner scannerWithString:_typeEncoding];
                    
                    if ([scanner scanString:@"@\"" intoString:NULL]) {
                        //获取Class的类型
                        NSString *className;
                        if ([scanner scanUpToCharactersFromSet:[NSMutableCharacterSet characterSetWithCharactersInString:@"\"<"] intoString:&className]) {
                            if ([className length]) {
                                _cls = NSClassFromString(className);
                            }
                        }
                    }
                    
                    //获取protocols
                    NSMutableArray *protocolArray = [NSMutableArray array];
                    while ([scanner scanString:@"<" intoString:NULL]) {
                        NSString *protocol;
                        if ([scanner scanUpToCharactersFromSet:[NSMutableCharacterSet characterSetWithCharactersInString:@">"] intoString:&protocol]) {
                            if ([protocol length]) {
                                [protocolArray addObject:protocol];
                            }
                        }
                        [scanner scanString:@">" intoString:NULL];
                    }
                    if ([protocolArray count]) {
                        _protocols = [protocolArray copy];
                    }
                }
            }else if (!(memcmp(attributeName, "R", 1))) {
                //readonly
                type |= JOEncodingTypePropertyReadonly;
            }else if (!(memcmp(attributeName, "C", 1))) {
                //copy
                type |= JOEncodingTypePropertyCopy;
            }else if (!(memcmp(attributeName, "&", 1))) {
                //retain
                type |= JOEncodingTypePropertyReatin;
            }else if (!(memcmp(attributeName, "N", 1))) {
                //nonatomic
                type |= JOEncodingTypePropertyNonatomic;
            }else if (!(memcmp(attributeName, "G", 1))) {
                //自定义的getter方法
                type |= JOEncodingTypePropertyCustomGetter;
                
                if (attributeValue) {
                    _getter = NSSelectorFromString([NSString stringWithUTF8String:attributeValue]);
                }
                
            }else if (!(memcmp(attributeName, "S", 1))) {
                //自定义的setter方法
                type |= JOEncodingTypePropertyCustomSetter;
                
                if (attributeValue) {
                    _setter = NSSelectorFromString([NSString stringWithUTF8String:attributeValue]);
                }
                
            }else if (!(memcmp(attributeName, "D", 1))) {
                //@dynamic
                type |= JOEncodingTypePropertyDynamic;
            }else if (!(memcmp(attributeName, "W", 1))) {
                //weak
                type |= JOEncodingTypePropertyWeak;
            }else if (!(memcmp(attributeName, "V", 1))) {
                //ivar name
                if (attributeValue) {
                    _ivarName = [NSString stringWithUTF8String:attributeValue];
                }
            }
        }
        
        _encodingType = type;
        
        if ([_name length]) {
            
            if (!_setter) {
                _setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@",[_name substringToIndex:1].uppercaseString,[_name substringFromIndex:1]]);
            }
            
            if (!_getter) {
                _getter = NSSelectorFromString(_name);
            }
        }
    }
    return self;
}

@end

#pragma mark - Class Info

@implementation JOClassInfo

- (instancetype)initWithClass:(Class)cls {

    if (!cls) {
        return nil;
    }
    
    self  = [super init];
    if (self) {
        
        _cls = cls;
        _superCls = class_getSuperclass(cls);
        _isMeta = class_isMetaClass(cls);
        if (!_isMeta) {
            _metaCls = objc_getMetaClass(class_getName(cls));
        }
        _name = NSStringFromClass(cls);
        [self updateClassInfo];
        
        _superClassInfo = [JOGetClass(self) classInfoWithClass:_superCls];
    }
    
    return self;
}

- (void)updateClassInfo {

    _protocols = [NSArray array];
    _ivarInfos = [NSDictionary dictionary];
    _methodInfos = [NSDictionary dictionary];
    _propertyInfos = [NSDictionary dictionary];
    
    //protocols
    uint protocolCount;
    Protocol * __unsafe_unretained *protocolList = class_copyProtocolList(_cls, &protocolCount);
    if (protocolList) {
        NSMutableArray *protocols = [NSMutableArray array];
        for (uint i = 0; i < protocolCount; i++) {
            const char *protocol = protocol_getName(protocolList[i]);
            if (protocol) {
                [protocols addObject:[NSString stringWithUTF8String:protocol]];
            }
        }
        _protocols = [protocols copy];
        free(protocolList);
    }
    
    //ivar info dic
    uint ivarCount;
    Ivar *ivarList = class_copyIvarList(_cls, &ivarCount);
    
    if (ivarList) {
        
        NSMutableDictionary *ivarInfos = [NSMutableDictionary dictionary];
        for (uint i = 0; i < ivarCount; i++) {
            JOClassIvarInfo *ivarInfo = [[JOClassIvarInfo alloc] initWithIvar:ivarList[i]];
            if (ivarInfo && ivarInfo.name) {
                [ivarInfos setObject:ivarInfo forKey:ivarInfo.name];
            }
        }
        _ivarInfos = [ivarInfos copy];
        free(ivarList);
    }
    
    //method info dic
    uint methodCount;
    Method *methodList = class_copyMethodList(_cls, &methodCount);
    
    if (methodList) {
        
        NSMutableDictionary *methodInfos = [NSMutableDictionary dictionary];
        for (uint i = 0; i< methodCount; i++) {
            JOClassMethodInfo *methodInfo = [[JOClassMethodInfo alloc] initWithMethod:methodList[i]];
            if (methodInfo && methodInfo.name) {
                [methodInfos setObject:methodInfo forKey:methodInfo.name];
            }
        }
        _methodInfos = [methodInfos copy];
        free(methodList);
    }
    
    //property info dic
    uint propertyCount;
    objc_property_t *propertyList = class_copyPropertyList(_cls, &propertyCount);
    
    if (propertyList) {
        
        NSMutableDictionary *propertyInfos = [NSMutableDictionary dictionary];
        for (uint i = 0; i < propertyCount; i++) {
            JOClassPropertyInfo *propertyInfo = [[JOClassPropertyInfo alloc] initWithProperty:propertyList[i]];
            if (propertyInfo && propertyInfo.name) {
                [propertyInfos setObject:propertyInfo forKey:propertyInfo.name];
            }
        }
        _propertyInfos = [propertyInfos copy];
        free(propertyList);
    }
}

+ (instancetype)classInfoWithClass:(Class)cls {

    return [JOClassInfo classInfoWithClass:cls update:NO];
}

+ (instancetype)classInfoUpdateWithClass:(Class)cls {

    return [JOClassInfo classInfoWithClass:cls update:YES];
}

+ (instancetype)classInfoWithClassName:(NSString *)className {
    
    return [JOClassInfo classInfoWithClass:NSClassFromString(className) update:NO];
}

+ (instancetype)classInfoUpdateWithClassName:(NSString *)className {
    
    return [JOClassInfo classInfoWithClass:NSClassFromString(className) update:YES];
}

+ (instancetype)classInfoWithClass:(Class)cls update:(BOOL)update{
    
    if (!cls) {
        return nil;
    }
    
    static CFMutableDictionaryRef classCache;
    static CFMutableDictionaryRef metaCache;
    static dispatch_semaphore_t lock;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        classCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        metaCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    //先从缓存里面去寻找
    JOClassInfo *classInfo = CFDictionaryGetValue(class_isMetaClass(cls)?metaCache:classCache, (__bridge const void *)(cls));
    if (classInfo && update) {
        [classInfo updateClassInfo];
    }
    dispatch_semaphore_signal(lock);
    
    if (!classInfo) {
        classInfo = [[JOClassInfo alloc] initWithClass:cls];
        if (classInfo) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            CFDictionarySetValue(class_isMetaClass(cls)?metaCache:classCache, (__bridge const void *)(cls), (__bridge const void *)(classInfo));
            dispatch_semaphore_signal(lock);
        }
    }
    
    return classInfo;
}

@end
