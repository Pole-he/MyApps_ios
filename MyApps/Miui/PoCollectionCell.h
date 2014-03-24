//
//  PoCollectionCell.h
//  MyApps
//
//  Created by Nathan-he on 14-2-25.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
-(void)setPic:(NSString *)model;
@end
