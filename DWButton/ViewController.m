//
//  ViewController.m
//  DWButton
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 Dimon. All rights reserved.
//

#import "ViewController.h"
#import "DMFoldawayButton.h"
#import "DMFoldawayModel.h"
// 屏幕宽度
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)

// 屏幕高度
#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)


#define WEAK_SELF __weak typeof(self)weakSelf = self;
#define STRONG_SELF __strong typeof(weakSelf)self = weakSelf;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DMFoldawayModel * model = [[DMFoldawayModel alloc]initWithmMainBtnTitle:@"" selectTitle:@""  backColor:[UIColor blueColor] image:@"add_icon" selectImage:@"add_icon"];
    
  
        model.subBtnTitles = @[@"", @"", @"", @"", @"", @""];
        model.subBtnImages = @[@"add_icon_refresh",@"add_icon_open",@"share_icon_pyq",@"share_icon_qq",@"share_icon_wechat",@"share_icon_weibo"];
    
    DMFoldawayButton *DMBtn = [[DMFoldawayButton alloc] initWithRect:CGRectMake(160, SCREEN_HEIGHT/2, 40, 40) andFoldAwayModel:model];
  //  DMBtn.showType = showTypeOfCircle;
    DMBtn.canBeMoved = YES;
    //DMBtn.circleShowDirection = circleShowDirectionUp;
     DMBtn.showSuperViewCenter = YES;
    DMBtn.disperseDistance = 90;
    [DMBtn showInView:self.view];
    
    DMBtn.clickSubButtonBack = ^(int index, NSString *title, BOOL select){
        
 
         };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
