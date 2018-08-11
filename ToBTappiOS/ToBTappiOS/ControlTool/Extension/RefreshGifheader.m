//
//  RefreshGifheader.m
//  Tapplock2
//
//  Created by TapplockiOS on 2018/5/21.
//  Copyright © 2018年 Tapplock. All rights reserved.
//

#import "RefreshGifheader.h"

@implementation RefreshGifheader

- (void)prepare {
    [super prepare];
 
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    
    UIImage *delimg = [UIImage imageNamed:@"gif_17"];
    NSArray *delarr = @[delimg];
    
    NSMutableArray *data = [NSMutableArray array];
    

    for (int i = 0; i < 41; i ++) {
        NSString *name = [NSString stringWithFormat:@"gif_%d",i];
        UIImage *img = [UIImage imageNamed: [NSString stringWithFormat:@"%@.png",name]];
        [data addObject:img];
    }
    
    [self setImages:delarr forState:MJRefreshStateIdle];
    [self setImages:data forState:MJRefreshStateRefreshing];
    [self setImages:delarr forState:MJRefreshStateWillRefresh];
    

}
@end
