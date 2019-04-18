//
//  CurOrderDownView.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/12.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "CurOrderDownView.h"

@implementation CurOrderDownView

+ (CurOrderDownView *)oldOrderDownView {
    UINib *nib = [UINib nibWithNibName:@"CurOrderDownView" bundle:nil];
    
    return [nib instantiateWithOwner:nil options:nil][0];
}

@end
