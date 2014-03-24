//
//  PoCollectionCell.m
//  MyApps
//
//  Created by Nathan-he on 14-2-25.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import "PoCollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation PoCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
/**
 设置Cell
 */
-(void)setPic:(NSString *)model{
    //self.imageView1.contentMode =  UIViewContentModeCenter;
    [self.imageView1 setImageWithURL:model];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
