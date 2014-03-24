//
//  PoDetailMoreViewController.h
//  MyApps
//
//  Created by Nathan-he on 14-3-5.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoAnimeTasteItem.h"
#import "PoAnimeTasteDetailController.h"
@interface PoDetailMoreViewController : UIView

@property (strong,nonatomic) PoAnimeTasteItem *data;
@property (weak, nonatomic) PoAnimeTasteDetailController *detailView;
@property (weak, nonatomic) IBOutlet UIImageView *ivPlayMore;
@property (weak, nonatomic) IBOutlet UILabel *titleMore;

@property (weak, nonatomic) IBOutlet UILabel *contentMore;
@end
