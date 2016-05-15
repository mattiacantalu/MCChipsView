//
//  MCChipsView.m
//  Mattia Cantalù
//
//  Created by Mattia Cantalù on 21/04/16.
//  Copyright © 2016 Mattia Cantalù. All rights reserved.
//

#import "MCChipsView.h"

@interface MCChipsView () <TagsControlDelegate>
@property (nonatomic, strong) IBOutlet UIView *editTagControlContainerView;
@end

@implementation MCChipsView
- (instancetype)initWithFrame:(CGRect)frame withSelectedTags:(NSArray*)selectedTags withAvailableTags:(NSArray*)availableTags withDelegate:(id)delegate {

    self = [super init];
    
    if (self != nil) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"MCChipsView" owner:self options:nil] lastObject];

        [self setFrame:frame];
        
        _editTagControl.tags = [selectedTags mutableCopy];
        _editTagControl.tapDelegate = self;
        
        _listTagControl.tags = [availableTags mutableCopy];
        _listTagControl.mode = TagsControlModeList;
        _listTagControl.tapDelegate = self;

        [_optionalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_optionalButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _optionalButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        _delegate = delegate;
    }
    
    return self;
}

- (void) reloadAllTags {
    [self.editTagControl reloadTagSubviews];
    [self.listTagControl reloadTagSubviews];
}

-(void)tagsControl:(TagsControl *)tagsControl selectedItem:(NSString *)string
{
    // User tapped to available chips
    if (tagsControl.mode == TagsControlModeList)
    {
        // Add object to selected chips, then scroll to the end
        [self.editTagControl.tags addObject:string];
        [self.editTagControl reloadTagSubviews];
        [self.editTagControl setNeedScrolling:YES];
    }
    else
    {
        //Add object to available chips
        [self.listTagControl.tags insertObject:string atIndex:0];
        [self.listTagControl reloadTagSubviews];
    }

    if ([self.delegate respondsToSelector:@selector(chipsViewDidChange:)])
    {
        [self.delegate chipsViewDidChange:self.editTagControl];
    }
}

- (void) tagsControl:(TagsControl *)tagsControl typedText:(NSString *)string {
    
    //Do nothing - typed item is already added by default
    
    if ([self.delegate respondsToSelector:@selector(chipsViewDidChange:)])
    {
        [self.delegate chipsViewDidChange:self.editTagControl];
    }
}

- (void) tagsControlInputFieldDidBeginEditing:(UITextField *)textField {
    //Text input
    if ([self.delegate respondsToSelector:@selector(chipsViewDidBeginEditing:)])
    {
        [self.delegate chipsViewDidBeginEditing:textField];
    }
}

- (IBAction)optionalButtonTapped:(id)sender {
    //Refine button tapped
    if ([self.delegate respondsToSelector:@selector(chipsViewOptionalButtonTapped:)])
    {
        [self.delegate chipsViewOptionalButtonTapped:sender];
    }
}

@end

@interface TagsControl () <TagInputFieldDelegate, UIGestureRecognizerDelegate>
@property (nonatomic)         BOOL            needScrolling;
@property (nonatomic, strong) NSMutableArray *tagSubviews;
@end

@implementation TagsControl

@synthesize tapDelegate;

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame andTags:(NSArray *)tags withTagsControlMode:(TagsControlMode)mode {
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        [self commonInit];
        [self setTags:[[NSMutableArray alloc]initWithArray:tags]];
        [self setMode:mode];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)setNeedScrolling:(BOOL)needScrolling {
    _needScrolling = needScrolling;
}

- (void)commonInit {
    
    _tags = [NSMutableArray array];
    
    self.layer.cornerRadius = 5;
    
    self.tagSubviews = [NSMutableArray array];
    
    _tagInputField = [[TagInputField alloc] initWithFrame:self.frame];
    _tagInputField.layer.cornerRadius = 8;
    _tagInputField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tagInputField.backgroundColor = [UIColor whiteColor];
    _tagInputField.delegate = self;
    _tagInputField.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    _tagInputField.placeholder = @"Add tag";
    _tagInputField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    if (_mode == TagsControlModeEdit) {
        if (!_tagInputField)
            [self addSubview:_tagInputField];
    }
    
}

#pragma mark - layout stuff

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize contentSize = self.contentSize;
    CGRect frame = CGRectMake(0, 0, 100, self.frame.size.height);
    CGRect tempViewFrame;
    NSInteger tagIndex = 0;
    for (UIView *view in self.tagSubviews) {
        tempViewFrame = view.frame;
        NSInteger index = [self.tagSubviews indexOfObject:view];
        if (index != 0) {
            UIView *prevView = self.tagSubviews[index - 1];
            tempViewFrame.origin.x = prevView.frame.origin.x + prevView.frame.size.width + 4;
        } else {
            tempViewFrame.origin.x = 3;
        }
        tempViewFrame.origin.y = frame.origin.y;
        view.frame = tempViewFrame;
        
        tagIndex++;
    }
    
    if (self.mode == TagsControlModeEdit) {
        frame = self.tagInputField.frame;
        frame.size.height = self.frame.size.height;
        frame.origin.y = 0;
        
        if (self.tagSubviews.count == 0) {
            frame.origin.x = 3;
        } else {
            UIView *view = self.tagSubviews.lastObject;
            frame.origin.x = view.frame.origin.x + view.frame.size.width + 4;
        }
        
        if (self.frame.size.width - self.tagInputField.frame.origin.x > 100) {
            frame.size.width = self.frame.size.width - frame.origin.x - 12;
        } else {
            frame.size.width = 100;
        }
        self.tagInputField.frame = frame;
    } else {
        UIView *lastTag = self.tagSubviews.lastObject;
        if (lastTag != nil) {
            frame = lastTag.frame;
            frame.size.height = lastTag.frame.size.height - 5;
        } else {
            frame.origin.x = 7;
        }
    }
    
    contentSize.width = frame.origin.x + frame.size.width;
    contentSize.height = self.frame.size.height;
    
    self.contentSize = contentSize;
    
    if (self.mode == TagsControlModeEdit)
        self.tagInputField.placeholder = (self.tagPlaceholder == nil) ? @"Add tag" : self.tagPlaceholder;
    
    if (tagIndex == self.tagSubviews.count && self.needScrolling) {
        [self scrollRectToVisible:self.tagInputField.frame animated:YES];
        self.needScrolling = NO;
    }
}

- (void)addTag:(NSString *)tag {
    tag = tag.uppercaseString;
    
    for (NSString *oldTag in self.tags) {
        if ([oldTag isEqualToString:tag]) {
            UIView *tagFrame = (UIView*)[self.tagSubviews objectAtIndex:[self.tags indexOfObject:tag]];
            [self scrollRectToVisible:tagFrame.frame animated:YES];
            return;
        }
    }
    
    [self.tags addObject:tag];
    [self reloadTagSubviews];
    
    CGSize contentSize = self.contentSize;
    CGPoint offset = self.contentOffset;
    
    if (contentSize.width > self.frame.size.width) {
        if (self.mode == TagsControlModeEdit) {
            offset.x = self.tagInputField.frame.origin.x + self.tagInputField.frame.size.width - self.frame.size.width;
        } else {
            UIView *lastTag = self.tagSubviews.lastObject;
            offset.x = lastTag.frame.origin.x + lastTag.frame.size.width - self.frame.size.width;
        }
    } else {
        offset.x = 0;
    }
    
    self.contentOffset = offset;
    
    //Call delegate to add typed item to other control
    if ([tapDelegate respondsToSelector:@selector(tagsControl:typedText:)])
    {
        [tapDelegate tagsControl:self typedText:tag];
    }
}

- (void)reloadTagSubviews {
    
    for (UIView *view in self.tagSubviews) {
        [view removeFromSuperview];
    }
    
    [self.tagSubviews removeAllObjects];
    
    UIColor *tagBackgrounColor = self.tagsBackgroundColor != nil ? self.tagsBackgroundColor : [UIColor whiteColor];
    UIColor *tagTextColor = self.tagsTextColor != nil ? self.tagsTextColor : [UIColor blackColor];
    UIColor *tagDeleteButtonColor = self.tagsDeleteButtonColor != nil ? self.tagsDeleteButtonColor : [UIColor blackColor];
    
    
    
    for (NSString *tag in self.tags) {
        float width = [tag boundingRectWithSize:CGSizeMake(3000, self.tagInputField.frame.size.height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{ NSFontAttributeName:self.tagInputField.font }
                                        context:nil].size.width;
        
        UIView *tagView = [[UIView alloc] initWithFrame:self.tagInputField.frame];
        CGRect tagFrame = tagView.frame;
        tagView.layer.cornerRadius = 8;
        tagFrame.origin.y = self.tagInputField.frame.origin.y;
        tagView.backgroundColor = tagBackgrounColor;
        
        if (self.tagsBorderColor) {
            tagView.layer.borderColor = self.tagsBorderColor.CGColor;
            tagView.layer.borderWidth = 0.5;
        }
        
        UILabel *tagLabel = [[UILabel alloc] init];
        CGRect labelFrame = tagLabel.frame;
        tagLabel.font = self.tagInputField.font;
        labelFrame.size.width = width + 16;
        labelFrame.size.height = self.tagInputField.frame.size.height;
        tagLabel.text = tag;
        tagLabel.textColor = tagTextColor;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.clipsToBounds = YES;
        tagLabel.layer.cornerRadius = 8;
        
        UIButton *deleteTagButton = [[UIButton alloc] initWithFrame:self.tagInputField.frame];
        CGRect buttonFrame = deleteTagButton.frame;
        [deleteTagButton.titleLabel setFont:self.tagInputField.font];
        [deleteTagButton addTarget:self action:@selector(deleteTagButton:) forControlEvents:UIControlEventTouchUpInside];
        buttonFrame.size.width = deleteTagButton.frame.size.height;
        buttonFrame.size.height = self.tagInputField.frame.size.height;
        [deleteTagButton setTag:self.tagSubviews.count];
        
        if (self.mode == TagsControlModeEdit)
            [deleteTagButton setTitle:@"✕" forState:UIControlStateNormal];
        if (self.mode == TagsControlModeList)
            [deleteTagButton setTitle:@"+" forState:UIControlStateNormal];
        
        [deleteTagButton setTitleColor:tagDeleteButtonColor forState:UIControlStateNormal];
        buttonFrame.origin.y = 0;
        buttonFrame.origin.x = labelFrame.size.width;
        
        deleteTagButton.frame = buttonFrame;
        tagFrame.size.width = labelFrame.size.width + buttonFrame.size.width;
        [tagView addSubview:deleteTagButton];
        labelFrame.origin.x = 0;
        
        [tagView addSubview:tagLabel];
        labelFrame.origin.y = 0;
        UIView *lastView = self.tagSubviews.lastObject;
        
        if (lastView != nil) {
            tagFrame.origin.x = lastView.frame.origin.x + lastView.frame.size.width + 4;
        }
        
        tagLabel.frame = labelFrame;
        tagView.frame = tagFrame;
        [self.tagSubviews addObject:tagView];
        [self addSubview:tagView];
    }
    
    
    if (self.mode == TagsControlModeEdit) {
        if (self.tagInputField.superview == nil) {
            [self addSubview:self.tagInputField];
        }
        CGRect frame = self.tagInputField.frame;
        if (self.tagSubviews.count == 0) {
            frame.origin.x = 7;
        } else {
            UIView *view = self.tagSubviews.lastObject;
            frame.origin.x = view.frame.origin.x + view.frame.size.width + 4;
        }
        self.tagInputField.frame = frame;
        
    } else {
        if (self.tagInputField.superview != nil) {
            [self.tagInputField removeFromSuperview];
        }
    }
    
    [self setNeedsLayout];
    
}

#pragma mark - buttons handlers

- (void)deleteTagButton:(UIButton *)sender
{
    [self removeChipAtIndex:[self.tagSubviews indexOfObject:sender.superview]];
}

-(void)removeChipAtIndex:(NSInteger)index
{
    NSString *tappedItem = [self.tags objectAtIndex:index];
    
    //Remove item from control in use
    [self.tags removeObjectAtIndex:index];
    
    //Call delegate to add item to other control
    if ([tapDelegate respondsToSelector:@selector(tagsControl:selectedItem:)])
    {
        [tapDelegate tagsControl:self selectedItem:tappedItem];
    }
    
    [self reloadTagSubviews];
}

#pragma mark - Textfield Delegate methods



- (void) textFieldDidDelete {
    if (self.tags.count > 0 && [self.tagInputField.text isEqualToString:@""])
    {
        [self removeChipAtIndex:[self.tags count] - 1];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0) {
        NSString *tag = textField.text;
        textField.text = @"";
        [self addTag:tag];
    }
    
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    if ([tapDelegate respondsToSelector:@selector(tagsControlInputFieldDidBeginEditing:)])
    {
        [tapDelegate tagsControlInputFieldDidBeginEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *resultingString;
    NSString *text = textField.text;
    
    if (range.length==1 && string.length==0)
        NSLog(@"backspace tapped");
    
    if (string.length == 1 && [string rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
        return NO;
    } else {
        if (!text || [text isEqualToString:@""]) {
            resultingString = string;
        } else {
            if (range.location + range.length > text.length) {
                range.length = text.length - range.location;
            }
            
            resultingString = [textField.text stringByReplacingCharactersInRange:range
                                                                      withString:string];
        }
        
        NSArray *components = [resultingString componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
        
        if (components.count > 2) {
            for (NSString *component in components) {
                if (component.length > 0 && [component rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location == NSNotFound) {
                    [self addTag:component];
                    break;
                }
            }
            
            return NO;
        }
        
        return YES;
    }
}

#pragma mark - setters

- (void)setMode:(TagsControlMode)mode {
    _mode = mode;
}

- (void)setTags:(NSMutableArray *)tags {
    _tags = tags;
}

- (void)setPlaceholder:(NSString *)tagPlaceholder {
    _tagPlaceholder = tagPlaceholder;
}

@end