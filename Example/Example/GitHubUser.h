//
//  GitHubUser.h
//  Example
//
//  Created by zhangferry on 2021/3/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GitHubUser : NSObject

@property (nonatomic, assign) UInt64 userID;
@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, assign) BOOL siteAdmin;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, assign) UInt32 following;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSValue *test;
@property (nonatomic, strong) NSArray *customArray;
@property (nonatomic, strong) NSNumber *customNumber;
@property (nonatomic, strong) NSDictionary *customDic;
@property (nonatomic, strong) id customId;
@property (nonatomic, assign, readonly) NSInteger customInteger;
@end

NS_ASSUME_NONNULL_END
