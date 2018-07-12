//
//  HeaderRefresh.m
//  Tapplock2
//
//  Created by TapplockiOS on 2018/7/2.
//  Copyright © 2018年 Tapplock. All rights reserved.
//

#import "HeaderRefresh.h"

@implementation HeaderRefresh

- (void)prepare {
    [super prepare];
    
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
}

@end
