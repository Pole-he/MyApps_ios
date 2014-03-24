//
//  PoTableViewHeader.h
//  MyApps
//
//  Created by Nathan-he on 14-2-20.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoTableViewHeader : UIView<UIScrollViewDelegate>
{
    int TimeNum;
    BOOL Tend;
    NSArray *imageArray;
    NSTimer *_timer;
}
@property (retain, nonatomic) UIScrollView *sv;
@property (retain, nonatomic) UIPageControl *PageControl;

- (void)configAdvert:(NSArray *) imgArray;
- (void)configUserInterface;
@end
