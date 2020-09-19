//
//  DoneTableViewController.m
//  TODO List App
//
//  Created by Mazen on 12/23/19.
//  Copyright © 2019 Mazen. All rights reserved.
//

#import "DoneTableViewController.h"
#import "ItemViewController.h"
#import "ItemDetailsViewController.h"
#import "Item.h"


@interface DoneTableViewController ()

@end

@implementation DoneTableViewController
{
    ItemViewController *newItemview;
    NSUserDefaults *userDefaults;
    NSMutableArray *itemArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self loadView];  // Why and How this here !???? clickMoved change cell color!!
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([userDefaults objectForKey:@"items"])
    {
        printf("**=== Found.......");
        itemArray=[[userDefaults objectForKey:@"items"]mutableCopy];
    }
    else{
        printf("**=== NotFound.....");
        itemArray=[NSMutableArray new];
    }
    /*   ///////////////////////////////
     Item *item =[Item new];
     NSData *data = [NSData new];
     data = [itemArray objectAtIndex:1];
     item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
     */   //////////////////////////////
    
    //[_tableview reloadData];
    
    [self.tableView reloadData];
    newItemview = [self.storyboard instantiateViewControllerWithIdentifier:@"itemview"];
    [newItemview setFlagEditing:YES];
    printf("**==+++ viewWillAppear Todo");
    //[_tableview beginUpdates];
    //[_tableview endUpdates];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [itemArray count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat f = 44.0;
    
    Item *item =[Item new];
    NSData *data = [NSData new];
    data = [itemArray objectAtIndex:indexPath.row];
    item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if([item.type  isEqual: @"Done"])
        f= 44.0;
    else
        f=0.0;
    
    return f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    Item *item =[Item new];
    NSData *data = [NSData new];
    data = [itemArray objectAtIndex:indexPath.row];
    item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if([item.type  isEqual: @"Done"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell_done" forIndexPath:indexPath];
        cell.textLabel.text=item.title;
        cell.imageView.image = [UIImage imageNamed:@"Done.png"];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell_done_empty" forIndexPath:indexPath];
        cell.hidden=YES;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    printf("**== Select");
    //[newItemview setFlagEditing:YES];
    [newItemview setItemEditingIndexInDefaultsArray:indexPath.row];
    [newItemview setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:newItemview animated:YES completion:nil];
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    printf("ACEss= %li",(long)indexPath.row);
    ItemDetailsViewController *itemDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"itemdetails"];
    
    Item *item =[Item new];
    NSData *data = [NSData new];
    
    data = [itemArray objectAtIndex:indexPath.row];
    item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [itemDetailsView setItem:item];
    
    [self presentViewController:itemDetailsView animated:YES completion:nil];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@" Delete Item..! " message:@"Are you sure that you want to delete this item ? " preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertActionNo = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){ [self.tableView reloadData]; }];
    
    UIAlertAction *alertActionYes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [itemArray removeObjectAtIndex:indexPath.row];
        NSInteger is= indexPath.row;
        printf("**==+++ row = %ld\n",(long)indexPath.row);
        [userDefaults setObject:itemArray forKey:@"items"];
        [userDefaults synchronize];
        [self.tableView reloadData];
    }];
    [alert addAction:alertActionNo];
    [alert addAction:alertActionYes];
    [self presentViewController:alert animated:YES completion:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
