//
//  ChapOrderDownView.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/15.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChapOrderDownView.h"

@implementation ChapOrderDownView

+ (ChapOrderDownView *)chapOrderDownView {
    UINib *nib = [UINib nibWithNibName:@"ChapOrderDownView" bundle:nil];
    
    return [nib instantiateWithOwner:nil options:nil][0];
}

@end
