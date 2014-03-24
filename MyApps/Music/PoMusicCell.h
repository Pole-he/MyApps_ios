//
//  PoMusicCell.h
//  MyApps
//
//  Created by Nathan-he on 14-2-26.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioButton.h"
@interface PoMusicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *translateBg;
@property (weak, nonatomic) IBOutlet UIImageView *userPic;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *publicTime;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UIImageView *playButton;
@property (weak, nonatomic) IBOutlet UIView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIView *controllerBar;
@property (weak, nonatomic) IBOutlet UILabel *commentText;
@property (weak, nonatomic) IBOutlet UILabel *shareText;
@property (weak, nonatomic) IBOutlet UILabel *collectionText;
@property (strong, nonatomic) IBOutlet AudioButton *audioButton;
-(void)setBackground;
-(void)setData:(NSDictionary *) dic;
- (void)configurePlayerButton;
@end
