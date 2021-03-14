//
//  NSObject+DefaultValue.m
//  Example
//
//  Created by zhangferry on 2021/3/14.
//

#import "NSObject+DefaultValue.h"
#import <objc/runtime.h>

@implementation NSObject (DefaultValue)

static const char *getPropertyType(objc_property_t property) {
    //这里也可以利用YYClassPropertyInfo获取对应数据
    unsigned int attrCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
    
    NSLog(@"name=%s, vlaue=%s", attrs[0].name, attrs[0].value);
    if (attrs[0].name[0] == 'T') {
        return attrs[0].value;
    }
    return "";
}

/**
 类型编码可以查看这里： https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
 编码值   含意
 c     代表char类型
 i     代表int类型
 s     代表short类型
 l     代表long类型，在64位处理器上也是按照32位处理
 q     代表long long类型
 C     代表unsigned char类型
 I     代表unsigned int类型
 S     代表unsigned short类型
 L     代表unsigned long类型
 Q     代表unsigned long long类型
 f     代表float类型
 d     代表double类型
 B     代表C++中的bool或者C99中的_Bool
 v     代表void类型
 *     代表char *类型
 @     代表对象类型
 #     代表类对象 (Class)
 :     代表方法selector (SEL)
 */
YYPropertyType tranformPropertyType(const char * propertyTypeName) {
    // 不同类型的字符串表示，目前只是简单检查字符串、数字、数组
    static const char *PROPERTY_TYPE_NSSTRING = "@\"NSString\"";
    static const char *PROPERTY_TYPE_NSNUMBER = "@\"NSNumber\"";
    static const char *PROPERTY_TYPE_NSARRAY = "@\"NSArray\"";
    static const char *PROPERTY_TYPE_NSINTERGER = "q"; // long long int
    if (strncmp(PROPERTY_TYPE_NSSTRING, propertyTypeName, strlen(PROPERTY_TYPE_NSSTRING)) == 0) {
        return YYPropertyTypeNSString;
    } else if (strncmp(PROPERTY_TYPE_NSNUMBER, propertyTypeName, strlen(PROPERTY_TYPE_NSNUMBER)) == 0) {
        return YYPropertyTypeNSNumber;
    } else if (strncmp(PROPERTY_TYPE_NSARRAY, propertyTypeName, strlen(PROPERTY_TYPE_NSARRAY)) == 0) {
        return YYPropertyTypeNSArray;
    } else if (strncmp(PROPERTY_TYPE_NSINTERGER, propertyTypeName, strlen(PROPERTY_TYPE_NSINTERGER)) == 0) {
        return YYPropertyTypeNSInterger;
    } else {
        return YYPropertyTypeNone;
    }
}

- (void)configValueDefault:(YYPropertyType)propertyType {
    unsigned int numberOfProperties = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &numberOfProperties);
    for (NSUInteger i = 0; i < numberOfProperties; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        const char *propertyTypeName = getPropertyType(property);
        id propertyValue = [self valueForKey:propertyName];
        
        if (!propertyValue) {
            if (propertyType & tranformPropertyType(propertyTypeName)) {
                [self.customDefaultValueMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    NSNumber *keyNumber = (NSNumber *)key;
                    if (tranformPropertyType(propertyTypeName) & [keyNumber unsignedIntValue]) {
                        [self setValue:obj forKey:propertyName];
                    }
                }];
            }
        }
    }
}

- (YYPropertyType)provideDefaultValueType {
    return YYPropertyTypeNone;
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [self configValueDefault:self.provideDefaultValueType];
    return YES;
}
//字典的限制，不能填充非对象类型
- (NSDictionary *)customDefaultValueMap {
    return @{@(YYPropertyTypeNSString): @"",
             @(YYPropertyTypeNSNumber): @0,
             @(YYPropertyTypeNSArray): @[],
    };
}

@end
