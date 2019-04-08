//
//  MainViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/8.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "MainViewController.h"
#import "OldHomeViewController.h"
#import "OldChapViewController.h"
#import "OldMyViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.tintColor = [UIColor blackColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addchildViewControllers];
}

- (void)addchildViewControllers {
    if (self.userType == 0) {
        [self addchildViewController:[[OldHomeViewController alloc] init] WithImageName:@"home" title:@"首页"];
        [self addchildViewController:[[OldChapViewController alloc] init] WithImageName:@"pen" title:@"陪护"];
        [self addchildViewController:[[OldMyViewController alloc] init] WithImageName:@"user" title:@"我的"];
    }
}

- (void)addchildViewController:(UIViewController *)childViewController
                 WithImageName:(NSString *)imageName
                         title:(NSString *)title {
    childViewController.title = title;
    childViewController.tabBarItem.image = [UIImage imageNamed:imageName];
    UINavigationController *nvi = [[UINavigationController alloc] initWithRootViewController:childViewController];
    [self addChildViewController:nvi];
}

@end
