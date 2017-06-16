//
//  TableContrroler.m
//  my3dtouch_demo
//
//  Created by spartawhy on 2017/6/8.
//  Copyright © 2017年 spartawhy. All rights reserved.
//

#import "TableContrroler.h"
#include "DetailViewController.h"



@interface TableContrroler ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerPreviewingDelegate>

@property (nonatomic,copy)NSArray *items;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) CGRect sourceRect;       //手势点位置，对应需要突出显示的rect
@property (nonatomic, strong) NSIndexPath *indexPath;  //手势点位置，对应cell的indexPath
@end

@implementation TableContrroler

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.items=@[@"1",@"2",@"3"];
    
    
    //if not support
    if(![self check3DTouchAvailable])
    {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"warnning" message:@"3dtouch not support" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    
   
    
    
}

-(BOOL)check3DTouchAvailable
{
    if(self.traitCollection.forceTouchCapability==UIForceTouchCapabilityAvailable)
    {
        [self registerForPreviewingWithDelegate:(id)self sourceView:self.tableView];
        return YES;
        
    }
    else
        return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - table delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier=@"SimpleTableIndentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    cell.textLabel.text=self.items[indexPath.row];
    
    return cell;
    
}

#pragma mark -peek手势
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    CGPoint p=[self.tableView convertPoint:location fromView:self.view];
    self.indexPath=[self.tableView indexPathForRowAtPoint:p];
    
    //判断是否越界
    if (![self getShouldShowRectAndIndexPathWithLocation:location]) return nil;
    //设置选中size
    previewingContext.sourceRect = self.sourceRect;
    
    
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:self.indexPath];
    
    DetailViewController *detail=[[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    
    detail.value=cell.textLabel.text;
    
    if(self.indexPath.row>[self.items count])
    {
        return nil;
    }
    
    return detail;
    
}
#pragma mark -pop手势
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    
    //this method will pop the whole table
    //[self showViewController:viewControllerToCommit sender:self];
    
    [self.tableView deselectRowAtIndexPath:self.indexPath animated:YES];
}

#pragma mark 判断是否越界，并计算cell的下标
- (BOOL)getShouldShowRectAndIndexPathWithLocation:(CGPoint)location {
    //获取第一cell的坐标
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    CGRect rect = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    //计算出选中哪个cell
    CGFloat height = 44;
    NSInteger row = (location.y - rect.origin.y)/height;
    self.sourceRect = CGRectMake(0, row * height + rect.origin.y, SCREEN_WIDTH, height);
    self.indexPath = [NSIndexPath indexPathForItem:row inSection:0];
    // 如果row越界了，返回NO 不处理peek手势
    return row >= self.items.count ? NO : YES;
}


@end
