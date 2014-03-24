//
//  PSBroView.m
//  BroBoard
//
//  Created by Peter Shih on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 This is an example of a subclass of PSCollectionViewCell
 */

#import "PSBroView.h"

#define MARGIN 0.0

@interface PSBroView ()

@property (nonatomic, retain) UIImageView *imageView;
//@property (nonatomic, retain) UILabel *captionLabel;

@end

@implementation PSBroView

//@synthesize
//imageView = _imageView;
//captionLabel = _captionLabel;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        
//        self.captionLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
//        self.captionLabel.font = [UIFont boldSystemFontOfSize:14.0];
//        self.captionLabel.numberOfLines = 0;
//        [self addSubview:self.captionLabel];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
 //   self.captionLabel.text = nil;
}

- (void)dealloc {
    self.imageView = nil;
 //   self.captionLabel = nil;
 //   [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width - MARGIN * 2;
    CGFloat top = MARGIN;
    CGFloat left = MARGIN;
    
    // Image
    CGFloat objectWidth = [[self.object objectForKey:@"picture_width"] floatValue];
    CGFloat objectHeight = [[self.object objectForKey:@"picture_height"] floatValue];
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    self.imageView.frame = CGRectMake(left, top, width, scaledHeight);
    
//    // Label
//    CGSize labelSize = CGSizeZero;
//    labelSize = [self.captionLabel.text sizeWithFont:self.captionLabel.font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:self.captionLabel.lineBreakMode];
//    top = self.imageView.frame.origin.y + self.imageView.frame.size.height + MARGIN;
//    
//    self.captionLabel.frame = CGRectMake(left, top, labelSize.width, labelSize.height);
}

- (void)fillViewWithObject:(id)object {
    [super fillViewWithObject:object];
    
    NSURL *URL = [NSURL URLWithString:[object objectForKey:@"picture_small_url"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        self.imageView.image = [UIImage imageWithData:data];
    }];
    
   // self.captionLabel.text = [object objectForKey:@"user_name"];
}

+ (CGFloat)heightForViewWithObject:(id)object inColumnWidth:(CGFloat)columnWidth {
    CGFloat height = 0.0;
    CGFloat width = columnWidth - MARGIN * 2;
    
    height += MARGIN;
    
    // Image
    CGFloat objectWidth = [[object objectForKey:@"picture_width"] floatValue];
    CGFloat objectHeight = [[object objectForKey:@"picture_height"] floatValue];
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    height += scaledHeight;
    
//    // Label
//    NSString *caption = [object objectForKey:@"user_name"];
//    CGSize labelSize = CGSizeZero;
//    UIFont *labelFont = [UIFont boldSystemFontOfSize:14.0];
//    labelSize = [caption sizeWithFont:labelFont constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
//    height += labelSize.height;
//    
//    height += MARGIN;
    
    return height;
}

@end
