//
//  Default.h
//  MyApps
//
//  Created by Nathan-he on 14-2-25.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#ifndef MyApps_Default_h
#define MyApps_Default_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#endif
