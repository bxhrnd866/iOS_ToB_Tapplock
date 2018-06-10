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
    
    UIImage *delimg = [UIImage imageNamed:@"1_00025"];
    NSArray *delarr = @[delimg];
    
    NSMutableArray *data = [NSMutableArray array];
    

    for (int i = 0; i < 50; i ++) {
        NSString *name = [NSString stringWithFormat:@"1_000%d",i];
        NSString *path = [[NSBundle mainBundle] pathForResource: name ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [data addObject:image];
    }
    
    [self setImages:delarr forState:MJRefreshStateIdle];
    [self setImages:data forState:MJRefreshStatePulling];
    [self setImages:data forState:MJRefreshStateRefreshing];
    [self setImages:delarr forState:MJRefreshStateWillRefresh];
    

}
@end
