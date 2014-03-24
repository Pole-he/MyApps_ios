//
//  PoPlayVideoViewViewController.h
//  MyApps
//
//  Created by Nathan-he on 14-2-20.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PoMoviePlayerViewController.h"
@interface PoPlayVideoViewViewController : UIViewController
{
    PoMoviePlayerViewController *playerView;
}
- (NSString *)getDate;
-(void)videoPlayBackDidFinish:(NSNotification*)notification;
-(void)myMovieFinishedCallback:(NSNotification*)aNotification;
@property ( nonatomic , retain ) NSString *url;
//@property (retain, nonatomic) PoMoviePlayerViewController *moviePlayer;
@end
