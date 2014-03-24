//
//  AnimeItemCell.m
//  MyApps
//
//  Created by Nathan-he on 14-2-9.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import "AnimeItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation AnimeItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 设置Cell
 */
-(void)setupCell:(PoAnimeTasteItem *)model{
    [self.ivPic setImageWithURL:model.HomePic];
   // self.lblYear.text       = model.paperYear;
    self.tvTitle.text   = model.Name;
    self.tvContent.text      = model.Brief;
}
@end
