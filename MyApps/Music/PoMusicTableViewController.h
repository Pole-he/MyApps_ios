//
//  PoMusicTableViewController.h
//  MyApps
//
//  Created by Nathan-he/Users/pole-he/开发/MyApps/MyApps/MyApps/Music/PoMusicCell.h on 14-2-26.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"
@interface PoMusicTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *_musicList;
    NSMutableArray *_songList;
    AudioPlayer *_audioPlayer;
    
}
@property (strong , nonatomic) UITableView *tableView;
@end
