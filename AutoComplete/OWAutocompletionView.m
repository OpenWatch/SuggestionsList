//
//  OWAutocompletionView.m
//  AutoComplete
//
//  Modified by Chris Ballinger on 12/11/2011
//
//  Based on SuggestionsList.m
//  Created by Wojciech Mandrysz on 19/09/2011.
//  Copyright 2011 http://tetek.me . All rights reserved.
//

#import "OWAutocompletionView.h"

#define DEFAULT_POPOVER_WIDTH 250
#define DEFAULT_POPOVER_HEIGHT 120

@implementation OWAutocompletionView

@synthesize suggestionStrings;
@synthesize  matchedStrings = _matchedStrings;
@synthesize popOver = _popOver;
@synthesize activeTextField = _activeTextField;
@synthesize delegate;
@synthesize popoverSize;

-(id)init
{
    self = [super init];
    if (self) {
        
        self.matchedStrings = [NSArray array];
        
        //Initializing PopOver
        self.popOver = [[WEPopoverController alloc] initWithContentViewController:self];
        self.popOver.containerViewProperties = [self improvedContainerViewProperties];
        self.popoverSize = CGSizeMake(DEFAULT_POPOVER_WIDTH, DEFAULT_POPOVER_HEIGHT);
    }
    return self;
}
#pragma mark Main Suggestions Methods
-(void)matchString:(NSString *)letters {
    self.matchedStrings = nil;
    
    if (suggestionStrings == nil) {
        return;
    }
    
    self.matchedStrings = [suggestionStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self beginswith[cd] %@",letters]];
    [self.tableView reloadData];
}
-(void)showPopOverListFor:(UITextField*)textField{
    UIPopoverArrowDirection arrowDirection = UIPopoverArrowDirectionUp;
    self.popOver.popoverContentSize = popoverSize;
    if ([self.matchedStrings count] == 0) {
        [_popOver dismissPopoverAnimated:YES];
    }
    else if(!_popOver.isPopoverVisible){
        [_popOver presentPopoverFromRect:textField.frame inView:textField.superview permittedArrowDirections:arrowDirection animated:YES];
        
    }
}
-(void)showSuggestionsForTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *rightText;
    
    if (textField.text) {
        rightText = [NSMutableString stringWithString:textField.text];
        [rightText replaceCharactersInRange:range withString:string];
    }
    else {
        rightText = [NSMutableString stringWithString:string];
    }
    
    [self matchString:rightText];
    [self showPopOverListFor:textField];
    self.activeTextField = textField;
}

- (void) showAllSuggestionsForTextField:(UITextField *)textField {
    self.matchedStrings = suggestionStrings;
    [self.tableView reloadData];
    [self showPopOverListFor:textField];
    self.activeTextField = textField;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.matchedStrings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.matchedStrings objectAtIndex:indexPath.row];
    
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *matchedString = [self.matchedStrings objectAtIndex:indexPath.row];
    if ([delegate respondsToSelector:@selector(didSelectString:forTextField:)]) {
        [delegate didSelectString:matchedString forTextField:self.activeTextField];
    } else {
        [self.activeTextField setText:matchedString];
    }
    [self.popOver dismissPopoverAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

/**
 Thanks to Paul Solt for supplying these background images and container view properties
 */
- (WEPopoverContainerViewProperties *)improvedContainerViewProperties {
	
	WEPopoverContainerViewProperties *props = [[WEPopoverContainerViewProperties alloc] init];
	NSString *bgImageName = nil;
	CGFloat bgMargin = 0.0;
	CGFloat bgCapSize = 0.0;
	CGFloat contentMargin = 4.0;
	
	bgImageName = @"popoverBg.png";
	
	// These constants are determined by the popoverBg.png image file and are image dependent
	bgMargin = 13; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13
	bgCapSize = 31; // ImageSize/2  == 62 / 2 == 31 pixels
	
	props.leftBgMargin = bgMargin;
	props.rightBgMargin = bgMargin;
	props.topBgMargin = bgMargin;
	props.bottomBgMargin = bgMargin;
	props.leftBgCapSize = bgCapSize;
	props.topBgCapSize = bgCapSize;
	props.bgImageName = bgImageName;
	props.leftContentMargin = contentMargin;
	props.rightContentMargin = contentMargin - 1; // Need to shift one pixel for border to look correct
	props.topContentMargin = contentMargin;
	props.bottomContentMargin = contentMargin;
	
	props.arrowMargin = 4.0;
	
	props.upArrowImageName = @"popoverArrowUp.png";
	props.downArrowImageName = @"popoverArrowDown.png";
	props.leftArrowImageName = @"popoverArrowLeft.png";
	props.rightArrowImageName = @"popoverArrowRight.png";
	return props;
}

@end
