//
//  ZQLabel.m
//  ZQMusicDemo
//
//  Created by 肖兆强 on 2017/9/7.
//  Copyright © 2017年 BTV. All rights reserved.
//

#import "ZQLabel.h"

@implementation ZQLabel


-(void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [[UIColor greenColor] setFill];
    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width *self.progress, rect.size.height);
     UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
}



@end
