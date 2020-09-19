//
//  ItemViewController.h
//  TODO List App
//
//  Created by Mazen on 12/15/19.
//  Copyright © 2019 Mazen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface ItemViewController : UIViewController

@property Item *itemEditing;
@property BOOL flagEditing;
@property NSInteger itemEditingIndexInDefaultsArray;
@end
