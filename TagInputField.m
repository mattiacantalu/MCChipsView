//
//  TagInputField.m
//  MCChipsDemo
//
//  Created by Mattia Cantalù on 14/05/16.
//  Copyright © 2016 Mattia Cantalù. All rights reserved.
//

#import "TagInputField.h"

@implementation TagInputField

- (void)deleteBackward {
    if ([self.delegate respondsToSelector:@selector(textFieldDidDelete)]) {
        [self.delegate performSelector:@selector(textFieldDidDelete)];
    }
    [super deleteBackward];
}
@end

