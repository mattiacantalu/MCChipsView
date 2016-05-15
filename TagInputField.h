//
//  TagInputField.h
//  MCChipsDemo
//
//  Created by Mattia Cantalù on 14/05/16.
//  Copyright © 2016 Mattia Cantalù. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TagInputFieldDelegate <UITextFieldDelegate>
-(void)textFieldDidDelete;
@end

@interface TagInputField : UITextField

@end