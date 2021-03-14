//
//  NSObject+DefaultValue.h
//  Example
//
//  Created by zhangferry on 2021/3/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, YYPropertyType) {
    YYPropertyTypeNone         = 1 << 0,
    YYPropertyTypeNSString     = 1 << 1,
    YYPropertyTypeNSNumber     = 1 << 2,
    YYPropertyTypeNSArray      = 1 << 3,
    YYPropertyTypeNSInterger   = 1 << 4,
    YYPropertyTypeAll          = 0xFF
};

@interface NSObject (DefaultValue)

- (YYPropertyType)provideDefaultValueType;

@end

NS_ASSUME_NONNULL_END
