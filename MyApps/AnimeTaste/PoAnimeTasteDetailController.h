//
//  PoAnimeTasteDetailController.h
//  MyApps
//
//  Created by Nathan-he on 14-3-5.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoAnimeTasteItem.h"
#import "tabbarViewController.h"
@interface PoAnimeTasteDetailController : UIViewController

@property(nonatomic,strong) PoAnimeTasteItem *item;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *ivPlay;
@property (weak, nonatomic) IBOutlet UIImageView *coverDetail;
@property (nonatomic, weak) tabbarViewController *controller;
@end
