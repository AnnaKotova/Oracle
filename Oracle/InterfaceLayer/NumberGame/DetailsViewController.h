//
//  DetailsViewController.h
//  Oracle
//
//  Created by Ann Kotova on 12/14/16.
//  Copyright © 2016 Anna Kotova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class History;

@interface DetailsViewController : BaseViewController

- (instancetype)initWithInfo:(History *)info;

@end
