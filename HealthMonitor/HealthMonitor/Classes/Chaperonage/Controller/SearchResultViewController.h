//
//  SearchResultViewController.h
//  HealthMonitor
//
//  Created by WRQ on 2019/4/21.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SearchResultViewControllerDelegate <NSObject>

- (void)didSelectTablViewWithAddress:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate;

@end

@interface SearchResultViewController : UIViewController
@property(strong,nonatomic) NSString                                *city;
@property(weak,nonatomic)id<SearchResultViewControllerDelegate>     delegate;

@end

NS_ASSUME_NONNULL_END
