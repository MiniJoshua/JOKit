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
    
    //返回值限定词可以是一个组合: - (in out void)test;   - (bycout out void)test; 
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
        
    }
    
    return self;
}

@end

#pragma mark - Class Info

@implementation JOClassInfo

@end
