//
//  ItemViewController.m
//  TODO List App
//
//  Created by Mazen on 12/15/19.
//  Copyright © 2019 Mazen. All rights reserved.
//

#import "ItemViewController.h"
#import "Item.h"

@interface ItemViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControlTodo;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTitle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segementControlPiriority;
@property (weak, nonatomic) IBOutlet UITextView *TextVIewDescription;

@end

@implementation ItemViewController
{
    NSUserDefaults *userDefaults;
    NSMutableArray *itemArray;
    NSMutableData *data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    itemArray = [NSMutableArray new];
    //_flagEditing = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if([userDefaults objectForKey:@"items"])
    {
        printf("**=== Found.......");
        itemArray=[[userDefaults objectForKey:@"items"] mutableCopy]; // User Default Return Immutable so Casting it
        
        
    }
    else{
        printf("**=== NotFound.....");
        itemArray=[NSMutableArray new];
        
    }
    
    
    if (_flagEditing == YES)
    {
        Item *item =[Item new];
        NSData *datatemp = [NSData new];
        
        datatemp = [itemArray objectAtIndex:_itemEditingIndexInDefaultsArray];
        _itemEditing = [NSKeyedUnarchiver unarchiveObjectWithData:datatemp];
        
        _textFieldTitle.text = _itemEditing.title;
        _TextVIewDescription.text = _itemEditing.desc;
        
        NSInteger indexPiriority =0;
        if([_itemEditing.piriority isEqualToString:@"Mideum"])
            indexPiriority = 1;
        else if([_itemEditing.piriority isEqualToString:@"Low"])
            indexPiriority = 2;
        [_segementControlPiriority setSelectedSegmentIndex:indexPiriority];
        
        NSInteger indexType =0;
        if([_itemEditing.type isEqualToString:@"In Progress"])
            indexType = 1;
        else if([_itemEditing.type isEqualToString:@"Done"])
            indexType = 2;
        [_segmentControlTodo setSelectedSegmentIndex:indexType];
        
        
        if([_segmentControlTodo selectedSegmentIndex] == 1)
            [_segmentControlTodo setEnabled:NO forSegmentAtIndex:0];
        
        else if([_segmentControlTodo selectedSegmentIndex] == 2)
        {
            [_segmentControlTodo setEnabled:NO forSegmentAtIndex:0];
            [_segmentControlTodo setEnabled:NO forSegmentAtIndex:1];
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveButton:(id)sender {
    
    if(![_textFieldTitle.text isEqualToString:@""])
    {
        Item *item =[Item new];
        item.title = _textFieldTitle.text;
        item.desc = _TextVIewDescription.text;;
        item.type = [_segmentControlTodo titleForSegmentAtIndex:[_segmentControlTodo selectedSegmentIndex]];
        item.piriority = [_segementControlPiriority titleForSegmentAtIndex:[_segementControlPiriority selectedSegmentIndex]];
        item.dateOfCreated = [NSDate date];
        //[itemArray addObject:item];
        
        data=[NSKeyedArchiver archivedDataWithRootObject:item];
        
        
        if(_flagEditing == NO)
            [itemArray addObject:data];
        else
            itemArray[_itemEditingIndexInDefaultsArray] = data;
        
        
        [userDefaults setObject:itemArray forKey:@"items"];
        [userDefaults synchronize];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (IBAction)buttonCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
