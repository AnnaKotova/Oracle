//
//  History.h
//  Oracle
//
//  Created by Ann Kotova on 12/1/16.
//  Copyright © 2016 Bmuse. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface History : NSManagedObject

@property NSInteger identifier;
@property NSDate * date;
@property NSString * name;
@property NSString * note;
@property NSInteger result_key;
@property NSString * imagePath;

@end
