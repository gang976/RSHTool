//
//  ZZCXUUIDTool.h
//  ZZCXDriver
//
//  Created by 李志强 on 5/7/19.
//  Copyright © 2019 qnchuxing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZCXUUIDTool : NSObject
//唯一标识
+ (NSString *)getPhoneIdentifier;
+ (void)deleteIdentifier:(NSString *)service;
@end

NS_ASSUME_NONNULL_END
