//
//  Item.m
//  TODO List App
//
//  Created by Mazen on 12/15/19.
//  Copyright © 2019 Mazen. All rights reserved.
//

#import "Item.h"

@implementation Item

//@synthesize title;


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.title=[aDecoder decodeObjectForKey:@"title"];
        self.type=[aDecoder decodeObjectForKey:@"type"];
        self.desc=[aDecoder decodeObjectForKey:@"desc"];
        self.piriority=[aDecoder decodeObjectForKey:@"piriority"];
        self.dateOfCreated=[aDecoder decodeObjectForKey:@"dateOfCreated"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_type forKey:@"type"];
    [aCoder encodeObject:_desc forKey:@"desc"];
    [aCoder encodeObject:_piriority forKey:@"piriority"];
    [aCoder encodeObject:_dateOfCreated forKey:@"dateOfCreated"];
}




@end
