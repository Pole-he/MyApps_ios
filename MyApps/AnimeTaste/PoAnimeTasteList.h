//
//  PoAnimeTasteList.h
//  MyApps
//
//  Created by Nathan-he on 14-2-9.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoAnimeTasteList : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_animeList;
}
- (void)jsonParse;
@end
