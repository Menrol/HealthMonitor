//
//  ChapModel.h
//  HealthMonitor
//
//  Created by WRQ on 2019/5/6.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ParentModel;

NS_ASSUME_NONNULL_BEGIN

@interface ChapModel : NSObject
@property(assign,nonatomic) NSInteger                 age;
@property(strong,nonatomic) NSString                  *gender;
@property(assign,nonatomic) NSInteger                 userID;
@property(assign,nonatomic) NSInteger                 cardStatus;
@property(strong,nonatomic) NSString                  *imageUrl;
@property(strong,nonatomic) NSString                  *name;
@property(strong,nonatomic) NSString                  *nickname;
@property(strong,nonatomic) NSArray<ParentModel *>    *parentList;
@property(strong,nonatomic) NSString                  *password;
@property(strong,nonatomic) NSString                  *workExperience;
@property(strong,nonatomic) NSString                  *workTime;
@property(assign,nonatomic) NSInteger                 workType;

@end

NS_ASSUME_NONNULL_END
