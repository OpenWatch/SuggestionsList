//
//  OWAutocompletionViewController.h
//  AutoComplete
//
//  Modified by Chris Ballinger on 12/11/2011
//
//  Based on SuggestionsList.h
//  Created by Wojciech Mandrysz on 19/09/2011.
//  Copyright 2011 http://tetek.me . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPopoverController.h"

@protocol OWAutocompletionDelegate <NSObject>
@optional
- (void) didSelectString:(NSString*)string forTextField:(UITextField*)textField;
@end

@interface OWAutocompletionViewController : UITableViewController

-(void)showSuggestionsForTextField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string;
-(void)showAllSuggestionsForTextField:(UITextField*)textField;

@property (nonatomic, strong) NSArray *suggestionStrings;
@property (nonatomic, strong) NSArray *matchedStrings;
@property (nonatomic, strong) WEPopoverController *popOver;
@property (nonatomic) CGSize popoverSize;
@property (nonatomic, weak) UITextField *activeTextField;
@property (nonatomic, weak) id<OWAutocompletionDelegate> delegate;
@property (nonatomic, weak) UIView *viewForAutocompletionPopover;

@end
