//
//  DMFoldawayButton.m
//  DWButton
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 Dimon. All rights reserved.
//

#import "DMFoldawayButton.h"
#import "DMButton.h"
#import "UIView+Utils.h"
@interface DMFoldawayButton ()

@property (nonatomic, assign)   CGFloat     topDistance; //顶部距离
@property (nonatomic, assign)   CGFloat     bottomDistance; //底部距离
@property (nonatomic, assign)   CGRect      rect; //标记并存储view的大小
@property (nonatomic, copy)     NSString    *btnTitle;
@property (nonatomic, copy)     NSString    *selectTitle;
@property (nonatomic, strong)   UIColor     *btnColor;
@property (nonatomic, copy)     NSString    *btnImage;
@property (nonatomic, copy)     NSString    *btnSelectImage;
@property (nonatomic, strong)   UIButton    *mainBtn;
@property (nonatomic, strong)   UIButton    *coverBtn;
@property (nonatomic, strong)   NSArray     *colors;
@property (nonatomic, strong)   NSArray     *btnsArray;
@property (nonatomic, strong)   NSArray     *titlesArray;
@property (nonatomic, strong)   NSArray     *selectTitlesAarray;
@property (nonatomic, strong)   NSArray     *subBtnImages;
@property (nonatomic, strong)   NSArray     *subBtnSelectImages;
@property (nonatomic, strong)   NSArray     *subBtnHighLightImages;
@property (nonatomic, strong)   UIPanGestureRecognizer *pan;

@end


@implementation DMFoldawayButton

#pragma mark - 构造

- (instancetype)initWithRect:(CGRect)rect andFoldAwayModel:(DMFoldawayModel *)foldAwayModel {
    
    self = [super initWithFrame:rect];
    self.canBeMoved             = YES;
    self.showWithSpring         = YES;
    self.topDistance            = 0;
    self.bottomDistance         = 0;
    self.colors                 = foldAwayModel.subBtnColors;
    self.btnColor               = foldAwayModel.mainBtnColor;
    self.btnTitle               = foldAwayModel.mainBtnTitle;
    self.selectTitle            = foldAwayModel.mainBtnSelectTitle;
    self.btnImage               = foldAwayModel.mainBtnImage;
    self.btnSelectImage         = foldAwayModel.mainBtnSelectImage;
    self.titlesArray            = foldAwayModel.subBtnTitles;
    self.selectTitlesAarray     = foldAwayModel.subBtnSelectTitles;
    self.subBtnImages           = foldAwayModel.subBtnImages;
    self.subBtnSelectImages     = foldAwayModel.subBtnSelectImages;
    self.subBtnHighLightImages  = foldAwayModel.subBtnHighLightImages;
    [self setupLayout];
    
    return self;
}


- (instancetype)initWithRect:(CGRect)rect mainButtonTitle:(NSString *)title selectTitle:(NSString *)selectTitle mainButtonColor:(UIColor *)color titlesArray:(NSArray *)titlesArray selectTitlesArray:(NSArray *)selectTitlesArray colors:(NSArray *)colors {
    
    self = [super initWithFrame:rect];
    
    self.canBeMoved         = YES;
    self.showWithSpring     = YES;
    self.topDistance        = 0;
    self.bottomDistance     = 0;
    self.colors             = colors;
    self.btnColor           = color;
    self.btnTitle           = title;
    self.selectTitle        = selectTitle;
    self.titlesArray        = titlesArray;
    self.selectTitlesAarray = selectTitlesArray;
    [self setupLayout];
    
    return self;
}

- (instancetype)initWithRect:(CGRect)rect mainButtonTitle:(NSString *)title selectTitle:(NSString *)selectTitle mainButtonColor:(UIColor *)color titlesArray:(NSArray *)titlesArray colors:(NSArray *)colors {
    
    return [self initWithRect:rect mainButtonTitle:title selectTitle:selectTitle mainButtonColor:color titlesArray:titlesArray selectTitlesArray:nil colors:colors];
}

- (instancetype)initWithRect:(CGRect)rect mainButtonTitle:(NSString *)title mainButtonColor:(UIColor *)color titlesArray:(NSArray *)titlesArray colors:(NSArray *)colors {
    
    return [self initWithRect:rect mainButtonTitle:title selectTitle:nil mainButtonColor:color titlesArray:titlesArray colors:colors];
}

#pragma mark - set/get

- (void)setCanBeMoved:(BOOL)canBeMoved {
    
    _canBeMoved = canBeMoved;
    [self removeGestureRecognizer:self.pan];
    self.pan = nil;
}

- (CGFloat)disperseDistance {
    
    return _disperseDistance == 0 ? self.width + 30 : _disperseDistance;
}

#pragma mark - UI

- (void)setupLayout {
    
 
    if (self.canBeMoved) {
        
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:self.pan];
    }
    //比较装逼的写法；封面btn，相当于蒙版；
    UIButton *coverBtn = ({
        
        coverBtn = [[UIButton alloc] initWithFrame:self.bounds];
        coverBtn.backgroundColor = [UIColor clearColor];
        [coverBtn addTarget:self action:@selector(clickCoverBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:coverBtn];
        self.coverBtn = coverBtn;
        coverBtn;
    });

    //主按钮;
    UIButton *btn = ({
        btn = [[UIButton alloc] initWithFrame:self.bounds];
        btn.backgroundColor = self.btnColor;
        [btn setTitle:self.btnTitle forState:UIControlStateNormal];
        [btn setTitle:self.selectTitle forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:self.btnImage] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:self.btnSelectImage] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = btn.height * 0.5;
        btn.layer.masksToBounds = YES;
        [self addSubview:btn];
        self.mainBtn = btn;
        btn;
    });
    //保证所有数据一一对应，不会出现为空的情况；
    self.colors = [self checkedWithArray:self.colors];
    self.subBtnImages = [self checkedWithArray:self.subBtnImages];
    self.subBtnSelectImages = [self checkedWithArray:self.subBtnSelectImages];
    
    NSInteger count = self.titlesArray.count > 0 ? self.titlesArray.count : self.subBtnImages.count;
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:self.titlesArray.count];
    
    //创建弹出的button;
    for (int i = 0; i < count; i++) {
        
        DMButton *subBtn = ({
            subBtn = [[DMButton alloc] initWithFrame:self.bounds];
            subBtn.backgroundColor = self.colors[i];
            [subBtn setBackgroundImage:[UIImage imageNamed:self.subBtnImages[i]] forState:UIControlStateNormal];
            [subBtn setBackgroundImage:[UIImage imageNamed:self.subBtnSelectImages[i]] forState:UIControlStateSelected];
            [subBtn setBackgroundImage:[UIImage imageNamed:self.subBtnHighLightImages[i]] forState:UIControlStateHighlighted];
            [subBtn setTitle:self.titlesArray[i] forState:UIControlStateNormal];
            [subBtn setTitle:self.selectTitlesAarray[i] forState:UIControlStateSelected];
            [subBtn addTarget:self action:@selector(clickSubBtn:) forControlEvents:UIControlEventTouchUpInside];
            subBtn.layer.cornerRadius = btn.height * 0.5;
            subBtn.layer.masksToBounds = YES;
            subBtn.index = i;
            [self insertSubview:subBtn belowSubview:btn];
            subBtn;
        });
        [tempArray addObject:subBtn];
    }
    self.btnsArray = tempArray.copy;
}

- (NSArray *)checkedWithArray:(NSArray *)array {
    
    if (self.titlesArray.count){

        if (array.count == 0) {
            return nil;
        }
        else if (array.count == 1) {
            NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:self.titlesArray.count];
            for (int i = 0; i < self.titlesArray.count; i++) {
                [arrayM addObject:array.firstObject];
            }
            return arrayM.copy;
        }
        else {
            //抛出异常;
            NSAssert(self.titlesArray.count == array.count, @"数组中值不一一对应");
            return array;
        }
    }
    else {
        NSAssert(self.subBtnImages.count == self.subBtnSelectImages.count, @"数组中值不一一对应");
        return array;
    }
}
//自动显示方向
- (void)showInView:(UIView *)view {
    
    [view addSubview:self];
    
    if (self.automaticShowDirection) {
        [self automaticChangeShowDirection];
    }
}
//如果有TabBar和NavigationBar需要自己调节了;
- (void)showInView:(UIView *)view navigationBar:(BOOL)haveNavigationBar tabBar:(BOOL)haveTabBar {
    
    self.topDistance = haveNavigationBar ? 64 : 0;
    self.bottomDistance = haveTabBar ? 49 : 0;
    [view addSubview:self];
    if (self.automaticShowDirection) {
        [self automaticChangeShowDirection];
    }
}
//显示
- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    if (self.automaticShowDirection) {
        [self automaticChangeShowDirection];
    }
}

- (void)remove {
    
    [self removeFromSuperview];
}

#pragma mark - 事件
//其他外部按钮点击转你
- (void)clickCoverBtn:(UIButton *)btn {
    
    if (self.mainBtn.selected) {
        
        [self clickBtn:self.mainBtn];
    }
}

/**
 *  点击主按钮
 */
- (void)clickBtn:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        //先记录下来原始的大小;
        self.rect = self.frame;
        //移除手势，拖动手势；
        
        if (self.pan) {
            [self removeGestureRecognizer:self.pan];
        }
        //弹性动画的动画;
        
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:self.showWithSpring ?  0.5 : 1.0 initialSpringVelocity:self.showWithSpring ? 10 : 0 options:UIViewAnimationOptionCurveLinear animations:^{
            //图片旋转的button;
            self.mainBtn.transform = CGAffineTransformMakeRotation(M_PI_4*3);
           
            if (self.showSuperViewCenter) {
                 //显示在父视图中央;
                self.center = self.superview.center;
                //绕一周的话，360/子button的个数；
                CGFloat angle = 2 * M_PI / self.btnsArray.count;
                for (int i = 0; i < self.btnsArray.count; i++) {
                    DMButton *btn = self.btnsArray[i];
                    //根据三角函数最基本的
                    /*
                     O(散开的button)
                    |\
                    | \
                    |  \
                    |   \
                    ---- \ O（这是mainButton）
                    
                     O的宽度加上距离是斜边；
                     x的值就是cos；
                     y的值就是sin
                     */
                    
                    btn.center = CGPointMake(self.mainBtn.centerX + cos(angle * i) * (self.width/2 + self.disperseDistance), self.mainBtn.centerY + sin(angle * i) * (self.height/2 + self.disperseDistance));
                }
            }
            else {
                //直线状态
                if (self.showType == showTypeOfLine) {
                    
                    [self lineShowButton];
                    
                }
                else {
                    //圆形状态;
                    [self circleShowButton];
                }
            }
        } completion:^(BOOL finished) {
            
            self.coverBtn.size = self.superview.size;
            self.coverBtn.origin = CGPointMake(-self.origin.x, -self.origin.y);
        }];
    }
    else {
        
        if (self.pan) {
            
            [self addGestureRecognizer:self.pan];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.mainBtn.transform = CGAffineTransformIdentity;
            self.frame = self.rect;
            self.coverBtn.size = self.size;
            self.coverBtn.center = self.mainBtn.center;
            
            for (DMButton *btn in self.btnsArray) {
                btn.center = self.mainBtn.center;
            }
        }];
    }
}

- (void)circleShowButton {
    //同在中央散开的；
    CGFloat angle = M_PI / (self.btnsArray.count - 1);
    
    for (int i = 0; i < self.btnsArray.count; i++) {
        
        DMButton *btn = self.btnsArray[i];
        
        switch (self.circleShowDirection) {
                
            case circleShowDirectionLeft:
                btn.center = CGPointMake(self.mainBtn.centerX - sin(angle * i) * self.disperseDistance, self.mainBtn.centerY - cos(angle * i) * self.disperseDistance);
                break;
            case circleShowDirectionRight:
                btn.center = CGPointMake(self.mainBtn.centerX + sin(angle * i) * self.disperseDistance, self.mainBtn.centerY + cos(angle * i) * self.disperseDistance);
                break;
            case circleShowDirectionUp:
            {
                self.centerX = self.superview.centerX;
                btn.center = CGPointMake(self.mainBtn.centerX + sin(angle * i + M_PI_2) * self.disperseDistance, self.mainBtn.centerY + cos(angle * i + M_PI_2) * self.disperseDistance);
            }
                break;
            case circleShowDirectionDown:
            {
                self.centerX = self.superview.centerX;
                btn.center = CGPointMake(self.mainBtn.centerX + sin(angle * i - M_PI_2) * self.disperseDistance, self.mainBtn.centerY + cos(angle * i - M_PI_2) * self.disperseDistance);
            }
                break;
            case circleShowDirectionRightDown:
            {
                angle = M_PI_2 / (self.btnsArray.count - 1);
                btn.center = CGPointMake(self.mainBtn.centerX + sin(angle * i) * self.disperseDistance, self.mainBtn.centerY + cos(angle * i) * self.disperseDistance);
            }
                break;
            case circleShowDirectionRightUp:
            {
                angle = M_PI_2 / (self.btnsArray.count - 1);
                btn.center = CGPointMake(self.mainBtn.centerX + sin(angle * i + M_PI_2) * self.disperseDistance, self.mainBtn.centerY + cos(angle * i + M_PI_2) * self.disperseDistance);
            }
                break;
            case circleShowDirectionLeftUp:
            {
                angle = M_PI_2 / (self.btnsArray.count - 1);
                btn.center = CGPointMake(self.mainBtn.centerX - sin(angle * i) * self.disperseDistance, self.mainBtn.centerY - cos(angle * i) * + self.disperseDistance);
            }
                break;
            case circleShowDirectionLeftDown:
            {
                angle = M_PI_2 / (self.btnsArray.count - 1);
                btn.center = CGPointMake(self.mainBtn.centerX - sin(angle * i + M_PI_2) * self.disperseDistance, self.mainBtn.centerY - cos(angle * i + M_PI_2) * self.disperseDistance);
            }
                break;
            default:
                break;
        }
    }
}

- (void)lineShowButton {
    
    for (int i = 0; i < self.btnsArray.count; i++) {
        
        DMButton *btn = self.btnsArray[i];
        
        switch (self.lineShowDirection) {
                
            case lineShowDirectionLeft:
                btn.centerX = self.mainBtn.centerX - self.disperseDistance * (i + 1);
                break;
            case lineShowDirectionRight:
                btn.centerX = self.mainBtn.centerX + self.disperseDistance * (i + 1);
                break;
            case lineShowDirectionUp:
                btn.centerY = self.mainBtn.centerY - self.disperseDistance * (i + 1);
                break;
            case lineShowDirectionDown:
                btn.centerY = self.mainBtn.centerY + self.disperseDistance * (i + 1);
                break;
            default:
                break;
        }
    }
}
#pragma mark 点击弹出来的button
- (void)clickSubBtn:(DMButton *)btn {
    
    if (self.subBtnSelectImages.count > 0 || self.selectTitlesAarray.count > 0) {
        
        for (DMButton *button in self.btnsArray) {
            button.selected = btn == button ? button.selected : NO;
        }
        btn.selected = !btn.selected;
    }
    
    
    if (self.clickSubButtonBack) {
        [self clickCoverBtn:nil];
        self.clickSubButtonBack(btn.index, btn.titleLabel.text, btn.selected);
    }
}

/**
 *  拖拽
 */
- (void)pan:(UIGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:self.superview];
    
    self.center = point;
    
    if (gesture.state == UIGestureRecognizerStateChanged) {}
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        CGRect rect = self.frame;
        
        if (self.centerX > self.superview.width * 0.5) {
            rect.origin.x = self.superview.width - self.width;
        }
        else {
            rect.origin.x = 0;
        }
        
        if (self.frame.origin.y< self.topDistance) {
            rect.origin.y = self.topDistance;
        }
        
        if (self.frame.origin.y > self.superview.height - self.height - self.bottomDistance) {
            rect.origin.y = self.superview.height - self.height - self.bottomDistance;
        }
        
        self.frame = rect;
        
        if (self.automaticShowDirection) {
            [self automaticChangeShowDirection];
        }
    }
}

/**
 *  自动算出显示放向
 */
- (void)automaticChangeShowDirection {
    
    CGFloat halfWidth =self.superview.width * 0.5;
    CGFloat halfHeight = self.superview.height * 0.5;
    
    if (self.centerX > halfWidth && self.centerY < halfHeight) {
        self.circleShowDirection = self.centerY - self.topDistance > self.disperseDistance ? circleShowDirectionLeft : circleShowDirectionLeftDown;
        self.lineShowDirection = self.centerX < halfHeight * 2 - self.centerY ? lineShowDirectionDown : lineShowDirectionLeft;
    }
    else if (self.centerX > halfWidth && self.centerY > halfHeight) {
        self.circleShowDirection = (2 * halfHeight - self.centerY - self.bottomDistance) > self.disperseDistance ? circleShowDirectionLeft : circleShowDirectionLeftUp;
        self.lineShowDirection = self.centerX < self.centerY ? lineShowDirectionUp : lineShowDirectionLeft;
    }
    else if (self.centerX < halfWidth && self.centerY > halfHeight) {
        self.circleShowDirection = (2 * halfHeight - self.centerY - self.bottomDistance) > self.disperseDistance ? circleShowDirectionRight : circleShowDirectionRightUp;
        self.lineShowDirection = halfWidth * 2 - self.centerX < self.centerY ? lineShowDirectionUp : lineShowDirectionRight;
    }
    else if (self.centerX < halfWidth && self.centerY < halfHeight) {
        self.circleShowDirection = self.centerY - self.topDistance > self.disperseDistance ? circleShowDirectionRight: circleShowDirectionRightDown;
        self.lineShowDirection = halfWidth * 2 - self.centerX < halfHeight * 2 - self.centerY ? lineShowDirectionDown : lineShowDirectionRight;
    }
}

/**
 *  超出部分点击事件
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        
        for (UIView *v in self.subviews) {
            
            CGPoint tempoint = [v convertPoint:point fromView:self];
            if (CGRectContainsPoint(v.bounds, tempoint))
            {
                
                if (self.mainBtn.selected == YES) {
                     view = v;
                }else{
                //不晓得啥问题有时候蒙版会去不掉；
                    self.frame = self.rect;
                    self.coverBtn.size = self.size;
                    self.coverBtn.center = self.mainBtn.center;

                }
                
            }
        }
    }
    return view;
}

@end
