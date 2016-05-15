//
//  MCChipsView.h
//  Mattia Cantalù
//
//  Created by Mattia Cantalù on 21/04/16.
//  Copyright © 2016 Mattia Cantalù. All rights reserved.
//
//  Override
//  TLTagControl
//  Created by Антон Кузнецов on 11.02.15.
//  Copyright (c) 2015 TheLightPrjg. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TagInputField.h"

typedef NS_ENUM(NSUInteger, TagsControlMode) {
    TagsControlModeEdit,
    TagsControlModeList,
    TagsControlModeEditSearch,
};


@class TagsControl;

@protocol TagsControlDelegate <NSObject>
//- (void)tagsControl:(TagsControl *)tagsControl tappedAtIndex:(NSInteger)index;
-(void)tagsControl:(TagsControl *)tagsControl selectedItem:(NSString *)string;
-(void)tagsControl:(TagsControl *)tagsControl typedText:(NSString *)string;
-(void)tagsControlInputFieldDidBeginEditing:(UITextField*)textField;
@end

@interface TagsControl : UIScrollView

@property (nonatomic, assign) id<TagsControlDelegate> tapDelegate;

@property (nonatomic, strong) UIColor             *tagsBackgroundColor;
@property (nonatomic, strong) UIColor             *tagsTextColor;
@property (nonatomic, strong) UIColor             *tagsDeleteButtonColor;
@property (nonatomic, strong) UIColor             *tagsBorderColor;

@property (nonatomic, strong) NSMutableArray      *tags;
@property (nonatomic, strong) NSString            *tagPlaceholder;
@property (nonatomic)         TagsControlMode     mode;
@property (nonatomic, strong) TagInputField         *tagInputField;


- (void)addTag:(NSString *)tag;
- (void)reloadTagSubviews;

- (void) textFieldDidDelete;
- (void) setNeedScrolling:(BOOL)needScrolling;

@end

@protocol MCChipsViewDelegate <NSObject>
- (void) chipsViewDidChange:(TagsControl *)tagsControl;
- (void) chipsViewDidBeginEditing:(UITextField*)textField;
- (void) chipsViewOptionalButtonTapped:(UIButton*)button;
@end

@interface MCChipsView : UIView
@property (nonatomic, strong) IBOutlet TagsControl *listTagControl;
@property (nonatomic, strong) IBOutlet TagsControl *editTagControl;
@property (nonatomic, strong) IBOutlet UIButton *optionalButton;

- (instancetype)initWithFrame:(CGRect)frame withSelectedTags:(NSArray*)selectedTags withAvailableTags:(NSArray*)availableTags withDelegate:(id)delegate;

- (void) reloadAllTags;

@property (assign, nonatomic) id<MCChipsViewDelegate> delegate;

@end