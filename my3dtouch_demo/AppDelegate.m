//
//  AppDelegate.m
//  my3dtouch_demo
//
//  Created by spartawhy on 2017/6/6.
//  Copyright © 2017年 spartawhy. All rights reserved.
//
#import <CoreSpotlight/CoreSpotlight.h>
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIApplicationShortcutItem *item=[launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
    [self actionWithShortcutItem:item];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        
        [self setCoreSpotlight];
    }
    
    
    return YES;
}

-(BOOL)application:(UIApplication* )application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray * _Nullable))restorationHandler
{
    if([userActivity.activityType isEqualToString:CSSearchableItemActionType])
    {
        NSString *identifier=userActivity.userInfo[CSSearchableItemActivityIdentifier];
        
        UITabBarController *rootController=(UITabBarController *)self.window.rootViewController;
        
        if([identifier isEqualToString:@"homeItem"])
        {
            rootController.selectedIndex=0;
        }
        else if ([identifier isEqualToString:@"newThingsItem"])
            
        {
            rootController.selectedIndex=1;
        }

        
        return YES;
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -quick actions delegate
-(void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler
{
    
   if(shortcutItem)
   {
       [self actionWithShortcutItem:shortcutItem];
   }
    
    if(completionHandler)
    {
        completionHandler(YES);
    }
    
    
}

-(void)actionWithShortcutItem:(UIApplicationShortcutItem *)item
{
    if(item!=nil)
    {
        UITabBarController *rootController=(UITabBarController *)self.window.rootViewController;
        
        //todo some viewcontroller transition
        if([item.type isEqualToString:@"openHome"])
        {
            rootController.selectedIndex=0;
            
        }
        if([item.type isEqualToString:@"openPush"])
        {
            rootController.selectedIndex=1;
        }
        if([item.type isEqualToString:@"openScanner"])
        {
            rootController.selectedIndex=2;
        }
        if([item.type isEqualToString:@"openSearch"])
        {
            rootController.selectedIndex=3;
        }
       

    }
}

#pragma mark -corespotlight
-(void)setCoreSpotlight
{
    //多少个页面就要创建多少个set 每个set对应一个item
    CSSearchableItemAttributeSet *newThingsSet=[[CSSearchableItemAttributeSet alloc]initWithItemContentType:@"newThingsSet"];
    newThingsSet.title=@"新鲜事";
    newThingsSet.contentDescription=@"快捷入口：我的世界-新鲜事";
    newThingsSet.keywords=@[@"新鲜事",@"我的世界",@"MC",@"Minecraft"];
    //todo 设定相关图片
    //newThingsSet.thumbnailData=UIImagePNGRepresentation([UIImage imageNamed:@""]);
    
    CSSearchableItemAttributeSet *homeSet=[[CSSearchableItemAttributeSet alloc]initWithItemContentType:@"homeSet"];
    newThingsSet.title=@"个人主页";
    newThingsSet.contentDescription=@"快捷入口：我的世界-个人主页";
    newThingsSet.keywords=@[@"新鲜事",@"我的世界",@"MC",@"Minecraft"];
    
    
    
    //UniqueIdentifier每个搜索都有一个唯一标示，当用户点击搜索到得某个内容的时候，系统会调用代理方法，会将这个唯一标示传给你，以便让你确定是点击了哪一，方便做页面跳转
    //domainIdentifier搜索域标识，删除条目的时候调用的delegate会传过来这个值
    CSSearchableItem *homeItem=[[CSSearchableItem alloc]initWithUniqueIdentifier:@"homeItem" domainIdentifier:@"home" attributeSet:homeSet];
    CSSearchableItem *newThingsItem=[[CSSearchableItem alloc]initWithUniqueIdentifier:@"newThingsItem" domainIdentifier:@"newThings" attributeSet:newThingsSet];
    
    //还可以设置过期时间
    //newThingsItem.expirationDate=[NSDate dateWithTimeIntervalSinceNow:3600];
    
    
    NSArray *itemArray=[NSArray arrayWithObjects:homeItem,newThingsItem, nil];
    [[CSSearchableIndex defaultSearchableIndex]indexSearchableItems:itemArray completionHandler:^(NSError *error)
     {
         if(error)
         {
             NSLog(@"spolight设置失败 %@",error);
         }
         
     }];
    
}


@end
