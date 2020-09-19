//
//  PiriortyViewController.m
//  TODO List App
//
//  Created by Mazen on 12/25/19.
//  Copyright © 2019 Mazen. All rights reserved.
//

#import "PiriortyViewController.h"
#import "ItemViewController.h"
#import "Item.h"
#import "ItemDetailsViewController.h"

@interface PiriortyViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segementControlPiriority;

@end

@implementation PiriortyViewController
{
    ItemViewController *newItemview;
    NSUserDefaults *userDefaults;
    NSMutableArray *itemArray;
    NSInteger indexPiriority;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    printf("**== didload Todo");
}


-(void)viewWillAppear:(BOOL)animated
{
    if([userDefaults objectForKey:@"items"])
    {
        printf("**=== Found.......");
        itemArray=[[userDefaults objectForKey:@"items"]mutableCopy];
    }
    else{
        printf("**=== NotFound.....");
        itemArray=[NSMutableArray new];
    }
    
    [_tableview reloadData];
    
    newItemview = [self.storyboard instantiateViewControllerWithIdentifier:@"itemview"];
    [newItemview setFlagEditing:YES];
    printf("**== viewWillAppear Todo");
    
    //self.tabBarItem.image = [UIImage imageNamed:@"inprogress.png"];
    //self.title=@"TODOOOO";
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
    
    indexPiriority =0;
    if([item.piriority isEqualToString:@"Mideum"])
        indexPiriority = 1;
    else if([item.piriority isEqualToString:@"Low"])
        indexPiriority = 2;
    
    NSUInteger nn =  [_segementControlPiriority selectedSegmentIndex];
    if(indexPiriority == [_segementControlPiriority selectedSegmentIndex])
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
    
    indexPiriority =0;
    if([item.piriority isEqualToString:@"Mideum"])
        indexPiriority = 1;
    else if([item.piriority isEqualToString:@"Low"])
        indexPiriority = 2;

    if(indexPiriority == [_segementControlPiriority selectedSegmentIndex])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell_piriorty" forIndexPath:indexPath];
        cell.textLabel.text=item.title;
        
        if([item.type  isEqual: @"TODO"])
            cell.imageView.image = [UIImage imageNamed:@"Todo.png"];
        else if ([item.type  isEqual: @"In Progress"])
            cell.imageView.image = [UIImage imageNamed:@"inprogress.png"];
        else if ([item.type  isEqual: @"Done"])
            cell.imageView.image = [UIImage imageNamed:@"Done.png"];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell_piriorty_empty" forIndexPath:indexPath];
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
    
    UIAlertAction *alertActionNo = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){ [_tableview reloadData]; }];
    
    UIAlertAction *alertActionYes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [itemArray removeObjectAtIndex:indexPath.row];
        NSInteger is= indexPath.row;
        printf("**==+++ row = %ld\n",(long)indexPath.row);
        [userDefaults setObject:itemArray forKey:@"items"];
        [userDefaults synchronize];
        [_tableview reloadData];
    }];
    [alert addAction:alertActionNo];
    [alert addAction:alertActionYes];
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)segmentPiriortyChanged:(id)sender {
    [_tableview reloadData];
}



@end
