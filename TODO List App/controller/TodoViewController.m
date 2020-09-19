//
//  TodoViewController.m
//  TODO List App
//
//  Created by Mazen on 12/15/19.
//  Copyright © 2019 Mazen. All rights reserved.
//

#import "TodoViewController.h"
#import "ItemViewController.h"
#import "Item.h"
#import "ItemDetailsViewController.h"

@interface TodoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation TodoViewController
{
    ItemViewController *newItemview;
    NSUserDefaults *userDefaults;
    NSMutableArray *itemArray;
    NSMutableArray *searchArray;
    NSMutableArray *searchArrayIndex;
    bool searchflage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //newItemview = [self.storyboard instantiateViewControllerWithIdentifier:@"itemview"];
    userDefaults = [NSUserDefaults standardUserDefaults];
    printf("**== didload Todo");
    
    searchflage = NO;
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
    printf("**== viewWillAppear Todo");
    
    
    _searchBar.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    printf("**== numberOfRowsInSection");
    if(searchflage == YES)
        return [searchArray count];
    else
        return [itemArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell_todo"];
    
    Item *item =[Item new];
    NSData *data = [NSData new];
    
    if(searchflage == YES)
        item = [searchArray objectAtIndex:indexPath.row];
    else
    {
        data = [itemArray objectAtIndex:indexPath.row];
        item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
        cell.textLabel.text=item.title;
    
    if([item.type  isEqual: @"TODO"])
        cell.imageView.image = [UIImage imageNamed:@"Todo.png"];
    else if ([item.type  isEqual: @"In Progress"])
        cell.imageView.image = [UIImage imageNamed:@"inprogress.png"];
    else if ([item.type  isEqual: @"Done"])
        cell.imageView.image = [UIImage imageNamed:@"Done.png"];
        
    printf("**== cellForRowAtIndexPath");

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    printf("**== Select");
    [newItemview setFlagEditing:YES];
    
    if(searchflage == YES)
    {
        int i= [searchArrayIndex[indexPath.row] intValue];
        [newItemview setItemEditingIndexInDefaultsArray:i];
    }
    else
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
    
    if(searchflage == YES)
       item = [searchArray objectAtIndex:indexPath.row];

    else
    {
        data = [itemArray objectAtIndex:indexPath.row];
        item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    [itemDetailsView setItem:item];
  
    [self presentViewController:itemDetailsView animated:YES completion:nil];
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@" Delete Item..! " message:@"Are you sure that you want to delete this item ? " preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertActionNo = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){ [_tableview reloadData]; }];
    
    UIAlertAction *alertActionYes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        if(searchflage == YES)
        {
            int i= [searchArrayIndex[indexPath.row] intValue];
            [itemArray removeObjectAtIndex:i];
            [searchArray removeObjectAtIndex:indexPath.row];
            [searchArrayIndex removeObjectAtIndex:indexPath.row];
        }
        else
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


- (IBAction)AddButton:(id)sender {
    [newItemview setFlagEditing:NO];
    [newItemview setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:newItemview animated:YES completion:nil];
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
    {
        searchflage = NO;
        [searchBar endEditing:YES];
    }
    else
    {
        searchflage = YES;
        searchArray = [[NSMutableArray alloc]init];
        searchArrayIndex = [[NSMutableArray alloc]init];
        for (int i=0; i<itemArray.count; i++)
        {
            Item *item =[Item new];
            NSData *data = [NSData new];
            data = itemArray[i];
            item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            NSRange range =[item.title rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(range.location != NSNotFound)
            {
                [searchArray addObject:item];
                [searchArrayIndex addObject: [NSNumber numberWithInt:i]];
            }
        }
    }
    [_tableview reloadData];
}


@end
