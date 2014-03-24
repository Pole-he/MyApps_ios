//
//  PoAnimeTasteItem.m
//  MyApps
//
//  Created by Nathan-he on 14-2-9.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import "PoAnimeTasteItem.h"

@implementation PoAnimeTasteItem
-(id) initWithItemID:(NSInteger)Id itemName:(NSString *)name itemVideoUrl:(NSString *)VideoUrl itemVideoSource:(NSString *)VideoSource itemAuthor:(NSString *)Author itemBrief:(NSString *)Brief itemHomePic:(NSString *)HomePic itemDetailPic:(NSString *)DetailPic
{
    self = [super init];
    if(self)
    {
        self.Name =name;
        self.Id =Id;
        self.VideoUrl = VideoUrl;
        self.VideoSource = VideoSource;
        self.Author=Author;
        self.Brief=Brief;
        self.HomePic=HomePic;
        self.DetailPic=DetailPic;
    }
    return  self;
}
@end
