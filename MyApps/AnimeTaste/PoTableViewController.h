//
//  PoTableVIewController.h
//  MyApps
//
//  Created by Nathan-he on 14-2-16.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoBaseViewController.h"
#import "tabbarViewController.h"
@interface PoTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_animeList;

}

@property (retain , nonatomic) UITableView *tableView;
@property (nonatomic, weak) tabbarViewController *controller;
- (NSString *)md5:(NSString *)str;
-(NSString *) getUrl;


@end
