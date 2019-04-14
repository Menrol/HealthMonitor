//
//  MessageView.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/14.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "MessageView.h"

@implementation MessageView

+ (MessageView *)messageView {
    UINib *nib = [UINib nibWithNibName:@"MessageView" bundle:nil];
    
    return [nib instantiateWithOwner:nil options:nil][0];
}

@end
