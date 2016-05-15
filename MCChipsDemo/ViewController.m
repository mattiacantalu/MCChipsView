//
//  ViewController.m
//  MCChipsDemo
//
//  Created by Mattia Cantalù on 14/05/16.
//  Copyright © 2016 Mattia Cantalù. All rights reserved.
//

#import "ViewController.h"
#import "MCChipsView.h"

@interface ViewController ()
@property (nonatomic, strong) MCChipsView *tagControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Setup
    self.tagControl = [[MCChipsView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 90)
                                        withSelectedTags:@[]
                                       withAvailableTags:@[@"APPLE", @"HTC", @"NOKIA", @"LG", @"SAMSUNG", @"HUAWEI"]
                                            withDelegate:self];
    [self setupSelectedChips];
    [self setupAvailableChips];
    [self.tagControl reloadAllTags];
    
    [self.view addSubview:self.tagControl];
}

-(void)setupSelectedChips
{
    self.tagControl.editTagControl.tagsBorderColor = [UIColor blackColor];
    self.tagControl.editTagControl.tagPlaceholder = @"Search";
    self.tagControl.editTagControl.tagInputField.backgroundColor = [UIColor clearColor];
    self.tagControl.editTagControl.tagsBackgroundColor = [UIColor blackColor];
    self.tagControl.editTagControl.tagsDeleteButtonColor = [UIColor whiteColor];
    self.tagControl.editTagControl.tagsTextColor = [UIColor whiteColor];
}

-(void)setupAvailableChips
{
    self.tagControl.listTagControl.tagsBorderColor = [UIColor blackColor];
    self.tagControl.listTagControl.tagsBackgroundColor = [UIColor whiteColor];
    self.tagControl.listTagControl.tagsDeleteButtonColor = [UIColor blackColor];
    self.tagControl.listTagControl.tagsTextColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
