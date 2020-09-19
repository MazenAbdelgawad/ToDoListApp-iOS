//
//  ItemDetailsViewController.m
//  TODO List App
//
//  Created by Mazen on 12/22/19.
//  Copyright © 2019 Mazen. All rights reserved.
//

#import "ItemDetailsViewController.h"

@interface ItemDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *typeLable;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UILabel *piriorityLable;
@property (weak, nonatomic) IBOutlet UILabel *dateOfCreateLable;

@end

@implementation ItemDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleLable.text = _item.title;
    _typeLable.text = _item.type;
    _piriorityLable.text = _item.piriority;
    _descTextView.text = _item.desc;
    _dateOfCreateLable.text = [NSDateFormatter localizedStringFromDate:_item.dateOfCreated
                                                             dateStyle:NSDateFormatterShortStyle
                                                             timeStyle:NSDateFormatterShortStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
