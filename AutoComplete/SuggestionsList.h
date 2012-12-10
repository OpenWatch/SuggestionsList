//
//  SuggestionMenu.h
//  AutoComplete
//
//  Created by Wojciech Mandrysz on 19/09/2011.
//  Copyright 2011 http://tetek.me . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPopoverController.h"

@interface SuggestionsList : UITableViewController 

-(void)showSuggestionsFor:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string;

@property (nonatomic, strong) NSArray *suggestionStrings;
@property (nonatomic, strong) NSArray *matchedStrings;
@property (nonatomic, strong) WEPopoverController *popOver;
@property (nonatomic, weak) UITextField *activeTextField;
@end
