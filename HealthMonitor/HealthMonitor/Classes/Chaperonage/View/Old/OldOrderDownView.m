//
//  OldOrderDownView.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/12.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "OldOrderDownView.h"

@implementation OldOrderDownView

+ (OldOrderDownView *)oldOrderDownView {
    UINib *nib = [UINib nibWithNibName:@"OldOrderDownView" bundle:nil];
    
    return [nib instantiateWithOwner:nil options:nil][0];
}

@end
