//
//  ChildModel.h
//  HealthMonitor
//
//  Created by WRQ on 2019/5/6.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ParentModel;

NS_ASSUME_NONNULL_BEGIN

@interface ChildModel : NSObject

@property(assign,nonatomic) NSInteger                  age;
@property(strong,nonatomic) NSString                   *gender;
@property(strong,nonatomic) NSString                   *childCode;
@property(assign,nonatomic) NSInteger                  userID;
@property(strong,nonatomic) NSString                   *imageUrl;
@property(strong,nonatomic) NSString                   *name;
@property(strong,nonatomic) NSString                   *nickname;
@property(strong,nonatomic) NSArray<ParentModel *>     *parentList;
@property(strong,nonatomic) NSString                   *password;

@end

NS_ASSUME_NONNULL_END
