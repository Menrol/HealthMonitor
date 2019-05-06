//
//  ParentModel.h
//  HealthMonitor
//
//  Created by WRQ on 2019/5/6.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChildModel, ChapModel;

NS_ASSUME_NONNULL_BEGIN

@interface ParentModel : NSObject
@property(assign,nonatomic) NSInteger               age;
@property(strong,nonatomic) NSString                *birthday;
@property(strong,nonatomic) NSArray<ChildModel *>   *childList;
@property(strong,nonatomic) NSArray<ChapModel *>    *escortList;
@property(strong,nonatomic) NSString                *gender;
@property(assign,nonatomic) NSInteger               healthStatus;
@property(assign,nonatomic) NSInteger               userID;
@property(strong,nonatomic) NSString                *imageUrl;
@property(assign,nonatomic) NSInteger               medicine;
@property(strong,nonatomic) NSString                *name;
@property(strong,nonatomic) NSString                *nickname;
@property(strong,nonatomic) NSString                *parentCode;
@property(strong,nonatomic) NSString                *password;

@end

NS_ASSUME_NONNULL_END
