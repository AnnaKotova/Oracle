//
//  NSFileManagerExtension.h
//  Oracle
//
//  Created by Ann Kotova on 12/7/16.
//  Copyright © 2016 Anna Kotova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Directories)

- (NSString *)applicationDocumentsDirectory;
- (NSString *)imagesDirectory;

@end
