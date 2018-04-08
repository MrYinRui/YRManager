//
//  NSObject+JsonStringFromMJmodel.m
//  HotelManager
//
//  Created by r on 17/6/23.
//  Copyright © 2017年 Xun. All rights reserved.
//

#import "NSObject+JsonStringFromMJmodel.h"
#import <objc/runtime.h>
#import "MJExtension.h"

@implementation NSObject (JsonStringFromMJmodel)

- (NSString *)jsonStringFromMJModel
{
    if ([self isKindOfClass:[NSArray class]])
    {
        return [self customMJ_jsonStringFromArray:(id)self];
    }
    else if ([self isKindOfClass:[NSDictionary class]])
    {
        return [self customMJ_jsonStringFromDictionary:(id)self];
    }
    else if([self isKindOfClass:[NSString class]])
    {
        return (NSString *)self;
    }
    else if ([self isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%@", self];
    }
    else if ([self isKindOfClass:[NSSet class]])
    {
        return [self customMJ_jsonStringFromSet:(id)self];
    }
    else
    {
        return [self customMJ_jsonStringFromModel:(id)self];
    }
}

#pragma mark 对象转JSON

- (NSString *)customMJ_jsonStringFromDictionary:(NSDictionary *)dict
{
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    //
    //    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableString * jsonStr = [NSMutableString stringWithString:@"{"];
    
    for (NSString *key  in dict.allKeys)
    {
        NSMutableString *dictStr = [NSMutableString new];
        
        if ([dict[key] isKindOfClass:[NSNull class]])
        {
            continue;
        }
        else if ([dict[key] isKindOfClass:[NSDictionary class]])
        {
            [dictStr appendFormat:@"\"%@\":%@, ", key, [self customMJ_jsonStringFromDictionary:dict[key]]];
        }
        else if([dict[key] isKindOfClass:[NSArray class]])
        {
            [dictStr appendFormat:@"\"%@\":%@, ", key, [self customMJ_jsonStringFromArray:dict[key]]];
        }
        else if([dict[key] isKindOfClass:[NSSet class]])
        {
            [dictStr appendFormat:@"\"%@\":%@, ", key, [self customMJ_jsonStringFromSet:dict[key]]];
        }
        else if ([dict[key] isKindOfClass:[NSString class]])
        {
            [dictStr appendFormat:@"\"%@\":\"%@\", ", key, dict[key]];
        }
        else if([dict[key] isKindOfClass:[NSNumber class]])
        {
            [dictStr appendFormat:@"\"%@\":%@, ", key, dict[key]];
        }
        else
        {
            [dictStr appendFormat:@"\"%@\":%@, ", key, [self customMJ_jsonStringFromModel:dict[key]]];
        }
        
        [jsonStr appendString:dictStr.length?dictStr:@""];
    }
    
    NSRange range = [jsonStr rangeOfString:@"," options:NSBackwardsSearch];
    
    if (range.location != NSNotFound)
    {
        [jsonStr replaceCharactersInRange:range withString:@"}"];
    }
    else
    {
        [jsonStr appendString:@"}"];
    }
    
    return jsonStr;
}

- (NSString *)customMJ_jsonStringFromArray:(NSArray *)array
{
    return [self customMJ_jsonStringFromSet:(id)array];
}

- (NSString *)customMJ_jsonStringFromSet:(NSSet *)set
{
    NSMutableString *str = [NSMutableString stringWithString:@"["];
    
    for (id obj in set)
    {
        
        NSString *tempStr = nil;
        
        if ([obj isKindOfClass:[NSNull class]])
        {
            continue;
        }
        else if ([obj isKindOfClass:[NSArray class]])
        {
            tempStr = [NSString stringWithFormat:@"%@, ", [self customMJ_jsonStringFromArray:obj]];
        }
        else if ([obj isKindOfClass:[NSDictionary class]])
        {
            tempStr = [NSString stringWithFormat:@"%@, ", [self customMJ_jsonStringFromDictionary:obj]];
        }
        else if ([obj isKindOfClass:[NSSet class]])
        {
            tempStr = [NSString stringWithFormat:@"%@, ", [self customMJ_jsonStringFromSet:obj]];
        }
        else if ([obj isKindOfClass:[NSString class]])
        {
            tempStr = [NSString stringWithFormat:@"\"%@\", ", obj];
        }
        else if ([obj isKindOfClass:[NSNumber class]])
        {
            tempStr = [NSString stringWithFormat:@"%@, ", obj];
        }
        else
        {
            tempStr = [NSString stringWithFormat:@"%@, ", [self customMJ_jsonStringFromModel:obj]];
        }
        
        [str appendString:tempStr.length?tempStr:@""];
    }
    
    NSRange range = [str rangeOfString:@", " options:NSBackwardsSearch];
    
    if (range.location != NSNotFound)
    {
        [str replaceCharactersInRange:range withString:@"]"];
    }
    else
    {
        [str appendString:@"]"];
    }
    
    return str;
}

- (NSString *)customMJ_jsonStringFromModel:(id)model
{
    NSMutableString *str = [NSMutableString stringWithString:@"{"];
    
    for (NSString *property in [model customMJ_propertyList])
    {
        NSString *keyValueStr = nil;
        
        id value = [model valueForKey:property];
        
        NSString *key = [[model class] customMJ_getServerKeyFromProperty:property];
        
        if ([value isKindOfClass:[NSNull class]] || value == nil)
        {
            continue;
        }
        else if ([value isKindOfClass:[NSArray class]])
        {
            if ([value count] > 0)
            {
                keyValueStr = [NSString stringWithFormat:@"\"%@\":%@, ", key, [self customMJ_jsonStringFromArray:value]];
            }
        }
        else if ([value isKindOfClass:[NSDictionary class]])
        {
            keyValueStr = [NSString stringWithFormat:@"\"%@\":%@, ", key, [self customMJ_jsonStringFromDictionary:value]];
        }
        else if ([value isKindOfClass:[NSSet class]])
        {
            keyValueStr = [NSString stringWithFormat:@"\"%@\":%@, ", key, [self customMJ_jsonStringFromSet:value]];
        }
        else if ([value isKindOfClass:[NSString class]])
        {
            keyValueStr = [NSString stringWithFormat:@"\"%@\":\"%@\", ", key, value];
        }
        else if ([value isKindOfClass:[NSNumber class]])
        {
            keyValueStr = [NSString stringWithFormat:@"\"%@\":%@, ", key, value];
        }
        else
        {
            keyValueStr = [NSString stringWithFormat:@"\"%@\":%@, ", key, [self customMJ_jsonStringFromModel:value]];
        }
        [str appendString:keyValueStr.length?keyValueStr:@""];
    }
    
    NSRange range = [str rangeOfString:@", " options:NSBackwardsSearch];
    
    if (range.location == NSNotFound)
    {
        [str appendString:@"}"];
    }
    else
    {
        [str replaceCharactersInRange:range withString:@"}"];
    }
    
    return str;
}

#pragma mark 获取对象属性列表

- (NSArray *)customMJ_propertyList
{
    unsigned count = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertyList = [NSMutableArray new];
    
    for (int i = 0; i < count; i++)
    {
        [propertyList addObject:[NSString stringWithUTF8String:property_getName(properties[i])]];
    }
    
    free(properties);
    
    return propertyList;
}

+ (NSString *)customMJ_getServerKeyFromProperty:(NSString *)property
{
    if (![self respondsToSelector:@selector(mj_replacedKeyFromPropertyName)]) {
        return property;
    }
    
    NSDictionary *dict = [self mj_replacedKeyFromPropertyName];
    
    NSString *_property = nil;
    
    if ([dict.allKeys containsObject:property])
    {
        for (NSString * value in dict.allValues)
        {
            if ([[dict valueForKey:property] isEqualToString:value])
            {
                _property = value;
                break;
            }
        }
        return _property;
    }
    else
    {
        return property;
    }
}

@end
