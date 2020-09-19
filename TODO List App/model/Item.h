//
//  Item.h
//  TODO List App
//
//  Created by Mazen on 12/15/19.
//  Copyright © 2019 Mazen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject <NSCoding>

@property NSString *type;
@property NSString *title;
@property NSString *desc;
@property NSString *piriority;
@property NSDate *dateOfCreated;

@end
