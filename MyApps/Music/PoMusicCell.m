//
//  PoMusicCell.m
//  MyApps
//
//  Created by Nathan-he on 14-2-26.
//  Copyright (c) 2014年 Pole-he. All rights reserved.
//

#import "PoMusicCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation PoMusicCell

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        
//    }
//    return self;
//}

-(void)setBackground{
    
    //    CAGradientLayer *gradient = [CAGradientLayer layer];
    //
    //    gradient.frame = self.backgroundImage.frame;
    //
    //    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0].CGColor,
    //
    //                       (id)[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0].CGColor,
    //
    //                       (id)[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1.0].CGColor,nil];
    //
    //    [self.backgroundImage.layer insertSublayer:gradient atIndex:0];
    if(self.backgroundImage.layer.sublayers.count==1)
    {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.backgroundImage.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor],
                           (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] CGColor]
                           ,(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] CGColor], nil]; // 由上到下由白色渐变为黑色
        gradient.locations = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.4],
                              [NSNumber numberWithFloat:0.7],
                              [NSNumber numberWithFloat:1.0],
                              nil];
        // self.backgroundImage.alpha = 1;
        [self.backgroundImage.layer insertSublayer:gradient atIndex:0];
    }
}

-(void)setData:(NSDictionary *)dic
{
    
    self.coverImage.contentMode = UIViewContentModeRedraw;
    
    [self.coverImage setImageWithURL:((NSArray *)[dic objectForKey:@"pics"])[0] placeholderImage:[UIImage imageNamed:@"social_music_circle_bkg.jpg"]];
    
    [self.userPic setImageWithURL:[[dic objectForKey:@"user"]objectForKey:@"pic" ]];
    //创建圆形遮罩，把用户头像变成圆形
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20) radius:20 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer* shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    self.userPic.layer.mask = shape;
    
    [self.userName setText:[[dic objectForKey:@"user"]objectForKey:@"nick_name" ]];
    [self.title setText:[dic objectForKey:@"songlistname"]];
    
    [self.commentText setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"comment_count"]==nil?@"0":[dic objectForKey:@"comment_count"]]];
    [self.collectionText setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"favorite_count"]==nil?@"0":[dic objectForKey:@"favorite_count"]]];
    [self.shareText setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"repost_count"]==nil?@"0":[dic objectForKey:@"repost_count"]]];
    [self.publicTime setText:[self friendlyTime:[self changeSpToTime:[dic objectForKey:@"create_at"]]]];
    
    //头像显示动画
    self.userPic.transform = CGAffineTransformMakeScale(0.01f, 0.01f);//将要显示的view按照正常比例显示出来
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; //InOut 表示进入和出去时都启动动画
    [UIView setAnimationDuration:1.0f];//动画时间
    self.userPic.transform=CGAffineTransformMakeScale(1.0f, 1.0f);//先让要显示的view最小直至消失
    [UIView commitAnimations]; //启动动画
    
    //[self.content setText:[dic objectForKey:@"tweet"]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//将时间戳转换成NSDate
-(NSDate *)changeSpToTime:(NSString*)spString{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[spString intValue]];
    return confromTimesp;
}

-(NSString *)friendlyTime:(NSDate *)datetime
{
    time_t current_time = time(NULL);
    
//    static NSDateFormatter *dateFormatter =nil;
//    if (dateFormatter == nil) {
//        dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
//    }
    
   // NSDate *date = [dateFormatter dateFromString:datetime];
    NSDate *date = datetime;
    time_t this_time = [date timeIntervalSince1970];
    
    time_t delta = current_time - this_time;
    
    if (delta <= 0) {
        return @"刚刚";
    }
    else if (delta <60)
        return [NSString stringWithFormat:@"%ld秒前", delta];
    else if (delta <3600)
        return [NSString stringWithFormat:@"%ld分钟前", delta /60];
    else {
        struct tm tm_now, tm_in;
        localtime_r(&current_time, &tm_now);
        localtime_r(&this_time, &tm_in);
        NSString *format = nil;
        
        if (tm_now.tm_year == tm_in.tm_year) {
//            if (tm_now.tm_yday == tm_in.tm_yday)
//                return [NSString stringWithFormat:@"%ld小时前",delta  /3600];
//                //format = @"今天 %-H:%M";
//            else if(tm_now.tm_yday-tm_in.tm_yday<11)
//                return [NSString stringWithFormat:@"%d天前",tm_now.tm_yday-tm_in.tm_yday];
//                //format = @"%-m月%-d日 %-H:%M";
            if(delta<3600*24)
            {
                return [NSString stringWithFormat:@"%ld小时前",delta  /3600];
            }else if(delta<3600*240)
            {
                return [NSString stringWithFormat:@"%ld天前",delta  /(3600*24)];
            }
        }
        else
            format = @"%Y年%-m月%-d日";
           // format = @"%Y年%-m月%-d日 %-H:%M";
        
        char buf[256] = {0};
        strftime(buf, sizeof(buf), [format UTF8String], &tm_in);
        return [NSString stringWithUTF8String:buf];
    }
}


- (void)configurePlayerButton
{
    // use initWithFrame to drawRect instead of initWithCoder from xib
    self.audioButton = [[AudioButton alloc] initWithFrame:CGRectMake(144, 122, 40, 40)];
    [self.contentView addSubview:self.audioButton];
}


@end
