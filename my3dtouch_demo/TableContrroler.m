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
@property (nonatomic, strong) NSIndexPath *indexPath;

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
-(void)viewDidAppear:(BOOL)animated
{
    
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

#pragma mark -previewing delegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    CGPoint p=[self.tableView convertPoint:location fromView:self.view];
    self.indexPath=[self.tableView indexPathForRowAtPoint:p];
    
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:self.indexPath];
    
    DetailViewController *detail=[[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    
    detail.value=cell.textLabel.text;
    
    if(self.indexPath.row>[self.items count])
    {
        return nil;
    }
    
    return detail;
    
}

-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    
    //this method will pop the whole table
    //[self showViewController:viewControllerToCommit sender:self];
    
    [self.tableView deselectRowAtIndexPath:self.indexPath animated:YES];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
