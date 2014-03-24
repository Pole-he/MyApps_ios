//
//  PoAnimeTasteItem.h
//  MyApps
//
//  Created by Nathan-he on 14-2-9.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PoAnimeTasteItem : NSObject
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *VideoUrl;
@property (nonatomic, strong) NSString *VideoSource;
@property (nonatomic, strong) NSString *Author;
@property (nonatomic, strong) NSString *Brief;
@property (nonatomic, strong) NSString *HomePic;
@property (nonatomic, strong) NSString *DetailPic;

-(id)initWithItemID:(NSInteger) Id
           itemName:(NSString *)name
       itemVideoUrl:(NSString *)VideoUrl
    itemVideoSource:(NSString *)VideoSource
         itemAuthor:(NSString *)Author
          itemBrief:(NSString *)Brief
        itemHomePic:(NSString *)HomePic
      itemDetailPic:(NSString *)DetailPic;
@end
