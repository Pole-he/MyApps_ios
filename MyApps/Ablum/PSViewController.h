//
//  PSViewController.h
//  BroBoard
//
//  Created by Peter Shih on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PSCollectionView.h"
#import "PoBaseViewController.h"
@interface PSViewController : UIViewController <PSCollectionViewDelegate, PSCollectionViewDataSource>
-(NSString *) getUrl;
@end
