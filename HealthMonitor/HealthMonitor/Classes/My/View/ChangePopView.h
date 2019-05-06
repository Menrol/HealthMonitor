//
//  ChangePopView.h
//  HealthMonitor
//
//  Created by WRQ on 2019/5/5.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ChangePopViewType) {
    ChangePopViewTypeDefult = 0,
    ChangePopViewTypeName,
    ChangePopViewTypeSex,
    ChangePopViewTypeDate,
    ChangePopViewTypeHealth,
    ChangePopViewTypeMedicine,
    ChangePopViewTypeBinding,
};

@protocol ChangePopViewDelegate <NSObject>

- (void)changePopViewDidClickConfirmWithText:(NSString *_Nonnull)text type:(ChangePopViewType)type;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ChangePopView : UIView

@property (weak,nonatomic) id<ChangePopViewDelegate>  delegate;

+ (instancetype)changePopViewWithTip:(NSString *)tip
                                type:(ChangePopViewType)type
                                text:(NSString *_Nullable)text;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
