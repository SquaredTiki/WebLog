//
//  WebLogAppDelegate.h
//  WebLog
//
//  Created by Joshua Garnham on 22/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BCStatusItemView.h"
#import "NSStatusItem+BCStatusItem.h"

@interface WebLogAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	NSStatusItem *statusItem;
	IBOutlet NSMenu *statusMenu;
	NSMutableArray *menuItems;
}

@property (assign) IBOutlet NSWindow *window;
- (void)loadItems;
- (void)saveItems;
@end
