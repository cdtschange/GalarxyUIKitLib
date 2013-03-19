//
//  JCDemo6.m
//  JCGridMenu
//
//  Created by Joseph Carney on 20/07/2012.
//  Copyright (c) 2012 North of the Web. All rights reserved.
//

#import "JCDemo6.h"

@interface JCDemo6 ()

@end

@implementation JCDemo6

#define GM_TAG        1002
@synthesize gmDemo = _gmDemo;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setView:[[JCUIViewTransparent alloc] initWithFrame:CGRectMake(0, 0, 320, 480)]];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Initialise

- (id)init
{
    self = [super init];
    if (self) {

        // Favourites
        
        JCGridMenuColumn *favouriteView = [[JCGridMenuColumn alloc] 
                                           initWithButtonImageTextLeft:CGRectMake(0, 0, 76, 44) 
                                           image:@"jcgrid_FavouriteSmall" 
                                           selected:@"jcgrid_FavouriteSmallSelected" 
                                           text:@"Event"];
        [favouriteView.button setBackgroundColor:[UIColor blackColor]];
        [favouriteView setCloseOnSelect:NO];
        
        JCGridMenuColumn *favouriteObject = [[JCGridMenuColumn alloc] 
                                             initWithButtonImageTextLeft:CGRectMake(0, 0, 80, 44) 
                                             image:@"jcgrid_FavouriteSmall" 
                                             selected:@"jcgrid_FavouriteSmallSelected" 
                                             text:@"Object"];
        [favouriteObject.button setBackgroundColor:[UIColor blackColor]];
        [favouriteObject setCloseOnSelect:NO];
        
        JCGridMenuRow *favourites = [[JCGridMenuRow alloc] 
                                     initWithImages:@"jcgrid_Favourite" 
                                     selected:@"jcgrid_FavouriteSelected" 
                                     highlighted:@"jcgrid_FavouriteSelected" 
                                     disabled:@"jcgrid_Favourite"];
        [favourites setColumns:[[NSMutableArray alloc] initWithObjects:favouriteView, favouriteObject, nil]];
        [favourites setIsExpanded:NO];
        [favourites setIsModal:YES];
        [favourites setHideAlpha:0.8f];
        [favourites.button setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4f]];
        
        
        // Share
        
        JCGridMenuColumn *twitter = [[JCGridMenuColumn alloc] 
                                     initWithButtonAndImages:CGRectMake(0, 0, 44, 44) 
                                     normal:@"jcgrid_Twitter" 
                                     selected:@"jcgrid_TwitterSelected" 
                                     highlighted:@"jcgrid_TwitterSelected" 
                                     disabled:@"jcgrid_Twiiter"];
        [twitter.button setBackgroundColor:[UIColor blackColor]];
        
        JCGridMenuColumn *email = [[JCGridMenuColumn alloc] 
                                   initWithButtonAndImages:CGRectMake(0, 0, 44, 44) 
                                   normal:@"jcgrid_Email" 
                                   selected:@"jcgrid_EmailSelected" 
                                   highlighted:@"jcgrid_EmailSelected" 
                                   disabled:@"jcgrid_Email"];
        [email.button setBackgroundColor:[UIColor blackColor]];
        
        JCGridMenuColumn *pocket = [[JCGridMenuColumn alloc] 
                                    initWithButtonAndImages:CGRectMake(0, 0, 44, 44) 
                                    normal:@"jcgrid_Pocket" 
                                    selected:@"jcgrid_PocketSelected" 
                                    highlighted:@"jcgrid_PocketSelected" 
                                    disabled:@"jcgrid_Pocket"];
        [pocket.button setBackgroundColor:[UIColor blackColor]];
        
        JCGridMenuColumn *facebook = [[JCGridMenuColumn alloc] 
                                      initWithButtonAndImages:CGRectMake(0, 0, 44, 44) 
                                      normal:@"jcgrid_Facebook" 
                                      selected:@"jcgrid_FacebookSelected" 
                                      highlighted:@"jcgrid_FacebookSelected" 
                                      disabled:@"jcgrid_Facebook"];
        [facebook.button setBackgroundColor:[UIColor blackColor]];
        
        JCGridMenuRow *share = [[JCGridMenuRow alloc] initWithImages:@"jcgrid_Share" selected:@"jcgrid_ShareSelected" highlighted:@"jcgrid_ShareSelected" disabled:@"jcgrid_Share"];
        [share setColumns:[[NSMutableArray alloc] initWithObjects:pocket, twitter, facebook, email, nil]];
        [share setIsModal:YES];
        [share.button setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4f]];
        
        
        // Comments
        
        JCGridMenuRow *comments = [[JCGridMenuRow alloc] initWithImages:@"jcgrid_Comments" selected:@"jcgrid_CommentsSelected" highlighted:@"jcgrid_CommentsSelected" disabled:@"jcgrid_Comments"];
        [comments setHideAlpha:0.1f];
        [comments setIsSeperated:YES];
        [comments setIsModal:YES];
        [comments.button setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4f]];
        
        
        // Spam
        
        JCGridMenuRow *spam = [[JCGridMenuRow alloc] initWithImages:@"jcgrid_Spam" selected:@"jcgrid_SpamSelected" highlighted:@"jcgrid_SpamSelected" disabled:@"jcgrid_Spam"];
        [spam setIsSeperated:NO];
        [spam setIsSelected:YES];
        [spam setHideAlpha:1.0f];
        [spam.button setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4f]];
        
        
        // Rows...
        
        NSArray *rows = [[NSArray alloc] initWithObjects:favourites, share, comments, spam, nil];
        _gmDemo = [[JCGridMenuController alloc] initWithFrame:CGRectMake(0,200,240,(44*[rows count])+[rows count]) rows:rows tag:GM_TAG];
        [_gmDemo setDelegate:self];
        [_gmDemo.view setClipsToBounds:NO];
        [self.view addSubview:_gmDemo.view];
    }
    return self;
}


#pragma mark - Open and Close

- (void)open
{
    [_gmDemo open];   
}

- (void)close
{
    [_gmDemo close];   
}



#pragma mark - JCGridMenuController Delegate

- (void)jcGridMenuRowSelected:(NSInteger)indexTag indexRow:(NSInteger)indexRow isExpand:(BOOL)isExpand
{
    if (isExpand) {
        NSLog(@"jcGridMenuRowSelected %i %i isExpand", indexTag, indexRow);
    } else {
        NSLog(@"jcGridMenuRowSelected %i %i !isExpand", indexTag, indexRow);
    }
    
    if (indexTag==GM_TAG) {
        JCGridMenuRow *rowSelected = (JCGridMenuRow *)[_gmDemo.rows objectAtIndex:indexRow];
        [[rowSelected button] setSelected:![rowSelected button].selected];
    }
    
}

- (void)jcGridMenuColumnSelected:(NSInteger)indexTag indexRow:(NSInteger)indexRow indexColumn:(NSInteger)indexColumn
{
    NSLog(@"jcGridMenuColumnSelected %i %i %i", indexTag, indexRow, indexColumn);
    
    if (indexTag==GM_TAG) {
        
        if (indexRow==0) {
            // Favourites
            UIButton *selected = (UIButton *)[[[_gmDemo.gridCells objectAtIndex:indexRow] buttons] objectAtIndex:indexColumn];
            [selected setSelected:![selected isSelected]];
            BOOL hasSelected = NO;
            
            for (int i=0; i<[[[_gmDemo.gridCells objectAtIndex:indexRow] buttons] count]; i++) {
                
                if ([[[[_gmDemo.gridCells objectAtIndex:indexRow] buttons] objectAtIndex:i] isSelected]) {
                    hasSelected = YES;
                    break;
                }
                
            }
            
            [[[_gmDemo.gridCells objectAtIndex:indexRow] button] setSelected:hasSelected];
        } else if (indexRow==2) {
            [[[_gmDemo.gridCells objectAtIndex:indexRow] button] setSelected:NO];
        }
        
        [_gmDemo setIsRowModal:NO];
    }
    
}


@end
