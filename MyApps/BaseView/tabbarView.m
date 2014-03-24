//
//  tabbarView.m
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "tabbarView.h"
#import "Default.h"

@implementation tabbarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:frame];
        //[self setBackgroundColor:[UIColor whiteColor]];
        [self layoutView];
    }
    return self;
}

-(void)layoutView
{
    //    _tabbarView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_mainbtn_bg"]];
    _tabbarView = [[UIImageView alloc]init];
    
    [_tabbarView setFrame:CGRectMake(0, 9, self.bounds.size.width, 41)];
    _tabbarView.backgroundColor=UIColorFromRGB(0x32394a);
    //_tabbarView.alpha=0.7;
    [_tabbarView setUserInteractionEnabled:YES];
    
    _tabbarViewCenter = [[UIImageView alloc]init];
    // _tabbarViewCenter.backgroundColor=[UIColor grayColor];
    
    [_tabbarViewCenter setFrame:CGRectMake(0, 0, 50, 50)];
    _tabbarViewCenter.center = CGPointMake(self.center.x, self.bounds.size.height/2.0);
    CALayer *layer=[_tabbarViewCenter layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:25.0];
    //设置边框线的宽
    [layer setBorderWidth:25];
    //设置边框线的颜色
    UIColor *color = UIColorFromRGB(0x32394a);
    [layer setBorderColor:[color CGColor]];
    [_tabbarViewCenter setUserInteractionEnabled:YES];
    
    _button_center = [UIButton buttonWithType:UIButtonTypeCustom];
    _button_center.adjustsImageWhenHighlighted = YES;
    [_button_center setBackgroundImage:[UIImage imageNamed:@"tabbar_mainbtn"] forState:UIControlStateNormal];
    
    [_button_center setFrame:CGRectMake(0, 0, 46, 46)];
    
    //    _button_center.center =CGPointMake(_tabbarViewCenter.bounds.size.width/2.0, _tabbarViewCenter.bounds.size.height/2.0 + 5) ;
    _button_center.center = CGPointMake(self.center.x, self.bounds.size.height/2.0);
    //[_tabbarViewCenter addSubview:_button_center];
    
    [self addSubview:_tabbarView];
    [self addSubview:_tabbarViewCenter];
    [self addSubview:_button_center];
    [self layoutBtn];
    
}

-(void)layoutBtn
{
    _button_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [_button_1 setBackgroundColor:[UIColor blueColor]];
    [_button_1 setFrame:CGRectMake(18, 6, 30, 30)];
    [_button_1 setTag:101];
    [_button_1 setTitle:@"P" forState:UIControlStateNormal];
    UIColor *color1=UIColorFromRGB(0x24b18e);
    [self initButton:_button_1 withColor:color1];
    
    _button_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_2 setFrame:CGRectMake(82, 6, 30, 30)];
    [_button_2 setTag:102];
    [_button_2 setTitle:@"O" forState:UIControlStateNormal];
    UIColor *color2=UIColorFromRGB(0xd9534f);
    [self initButton:_button_2 withColor:color2];
    
    //    CGRect pathFrame = CGRectMake(-CGRectGetMidX(_button_2.bounds), -CGRectGetMidY(_button_2.bounds), _button_2.bounds.size.width, _button_2.bounds.size.height);
    //    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:_button_2.layer.cornerRadius];
    //
    //    // accounts for left/right offset and contentOffset of scroll view
    //    CGPoint shapePosition = [self convertPoint:_button_2.center fromView:_tabbarView];
    //
    //    CAShapeLayer *circleShape = [CAShapeLayer layer];
    //    circleShape.path = path.CGPath;
    //    circleShape.position = shapePosition;
    //    circleShape.fillColor = [UIColor clearColor].CGColor;
    //    circleShape.opacity = 1;
    //    circleShape.strokeColor = color2.CGColor;
    //    circleShape.lineWidth = 1;
    //
    //    [layer2 addSublayer:circleShape];
    
    //
    //    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(15, 15) radius:15 startAngle:0 endAngle:2*M_PI clockwise:YES];
    //    CAShapeLayer* shape = [CAShapeLayer layer];
    //    shape.path = path.CGPath;
    //    shape.strokeColor=color2.CGColor;
    //    shape.lineWidth=1;
    //    shape.fillColor = [UIColor clearColor].CGColor;
    //    layer2.mask = shape;
    
    [_button_2 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_3 setFrame:CGRectMake(210, 6, 30, 30)];
    [_button_3 setTag:103];
    [_button_3 setTitle:@"P" forState:UIControlStateNormal];
    UIColor *color3=UIColorFromRGB(0x5bc0de);
    [self initButton:_button_3 withColor:color3];
    
    _button_4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_4 setFrame:CGRectMake(274, 6, 30, 30)];
    [_button_4 setTag:104];
    [_button_4 setTitle:@"O" forState:UIControlStateNormal];
    UIColor *color4=UIColorFromRGB(0xf0ad4e);
    [self initButton:_button_4 withColor:color4];
    
    //初始化第一button
    _button_1.selected = !_button_1.selected;
    _button_1.backgroundColor = color1;
    _button_0=_button_1;
    
    [_tabbarView addSubview:_button_1];
    [_tabbarView addSubview:_button_2];
    [_tabbarView addSubview:_button_3];
    [_tabbarView addSubview:_button_4];
    
}

-(void)initButton:(UIButton *) button withColor:(UIColor *) color
{
    [button setTitleColor: color forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.tintColor=color;
    CALayer *layer=[button layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:15.0];
    //设置边框线的宽
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[color CGColor]];
    layer.shouldRasterize = YES;
    layer.rasterizationScale = [UIScreen mainScreen].scale;
    [button addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)btn1Click:(id)sender
{
    
    if(_button_0!=nil)
    {
        _button_0.selected = !_button_0.selected;
        _button_0.backgroundColor = nil;
    }
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if(btn.selected)
    {
        btn.backgroundColor = btn.tintColor;
    }else{
        btn.backgroundColor = nil;
    }
    _button_0 = btn;
    switch (btn.tag) {
        case 101:
        {
            //            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_0"]];
            [self.delegate touchBtnAtIndex:0];
            
            break;
        }
        case 102:
        {
            //            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_1"]];
            [self.delegate touchBtnAtIndex:1];
            break;
        }
        case 103:
            [self.delegate touchBtnAtIndex:2];
            //            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_3"]];
            break;
        case 104:
            [self.delegate touchBtnAtIndex:3];
            //            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_4"]];
            break;
        default:
            break;
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
