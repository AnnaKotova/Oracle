//
//  History.h
//  Oracle
//
//  Created by Ann Kotova on 12/1/16.
//  Copyright © 2016 Bmuse. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface History : NSManagedObject

@property NSString * identifier;
@property NSDate * date;
@property NSString * name;
@property NSString * note;
@property NSNumber * resultKey;
@property NSString * imagePath;

+ (instancetype)createNoteInHistory;

@end
