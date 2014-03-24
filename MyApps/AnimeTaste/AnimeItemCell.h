//
//  AnimeItemCell.h
//  MyApps
//
//  Created by Nathan-he on 14-2-9.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoAnimeTasteItem.h"
@interface AnimeItemCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *ivPic;
@property (strong, nonatomic) IBOutlet UILabel *tvTitle;
@property (strong, nonatomic) IBOutlet UILabel *tvContent;

/**
 设置Cell
 */
-(void)setupCell:(PoAnimeTasteItem *)model;
@end
