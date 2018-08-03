//
//  FooterRefresh.m
//  Tapplock2
//
//  Created by TapplockiOS on 2018/7/2.
//  Copyright © 2018年 Tapplock. All rights reserved.
//

#import "FooterRefresh.h"

@implementation FooterRefresh

- (void)prepare {
    [super prepare];
    
//    self.stateLabel.hidden = YES;
    
    [self setTitle:@"" forState:MJRefreshStateIdle];
    [self setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [self setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"No more Data" forState:MJRefreshStateNoMoreData];
}
@end


