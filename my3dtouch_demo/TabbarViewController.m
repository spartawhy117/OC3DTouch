//
//  TabbarViewController.m
//  my3dtouch_demo
//
//  Created by spartawhy on 2017/6/16.
//  Copyright © 2017年 spartawhy. All rights reserved.
//

#import "TabbarViewController.h"

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionWithShortcutItem:) name:@"Notice3DTouch" object:nil];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -notification
-(void)actionWithShortcutItem:(NSNotification *)notification
{
    NSString *type = notification.userInfo[@"type"];
    if(type!=nil)
    {
        
        
        //todo some viewcontroller transition
        if([type isEqualToString:@"openHome"])
        {
            self.selectedIndex=0;
            
        }
        if([type isEqualToString:@"openPush"])
        {
            self.selectedIndex=1;
        }
        if([type isEqualToString:@"openScanner"])
        {
            self.selectedIndex=2;
        }
        if([type isEqualToString:@"openSearch"])
        {
            self.selectedIndex=3;
        }
        
        
    }
}

-(void)dealloc
{
    NSLog(@"销毁观察者");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"First" object:nil];
}
@end
