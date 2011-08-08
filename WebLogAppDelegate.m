//
//  WebLogAppDelegate.m
//  WebLog
//
//  Created by Joshua Garnham on 22/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebLogAppDelegate.h"

@implementation WebLogAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
	
	[statusItem setupView];
	
	[statusItem setTitle:@"⭐★"];
	[statusItem setMenu:statusMenu];
	[statusItem setHighlightMode:YES];
		
	[statusItem setViewDelegate:self];
	[[statusItem view] registerForDraggedTypes:[NSArray arrayWithObjects:NSPasteboardTypeHTML, NSURLPboardType, nil]];
	
	menuItems = [[[NSMutableArray alloc] init] retain];
	
	[self loadItems];
}

- (void)openPage:(id)sender {
	NSUInteger flags = [[NSApp currentEvent] modifierFlags];
	
	if (flags & NSCommandKeyMask) {
		[statusMenu removeItem:sender];
		[menuItems removeObject:sender];
		if (menuItems == nil) {
			NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"No Items" action:NULL keyEquivalent:@""];
			[statusMenu insertItem:item atIndex:0];
		}
		[self saveItems];
	} else {
		[[NSWorkspace sharedWorkspace] openURL:[(NSMenuItem *)sender representedObject]];
	}
}

- (void)saveItems {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *dictionaryOfItems = [[NSMutableArray alloc] init];
	
	for (NSMenuItem *item in menuItems) {
		NSDictionary *itemDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:item.title, [item.representedObject absoluteString], nil] forKeys:[NSArray arrayWithObjects:@"title", @"object", nil]];
		[dictionaryOfItems insertObject:itemDictionary atIndex:0];
	}
	
	[prefs setObject:dictionaryOfItems forKey:@"menuItems"];
}

- (void)loadItems {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSArray *itemsDictionarys = [prefs arrayForKey:@"menuItems"];
	
	if (itemsDictionarys.count != 0)
		[statusMenu removeItemAtIndex:0];
	
	for (NSDictionary *itemDictionary in itemsDictionarys) {
		NSMenuItem *newURL = [[NSMenuItem alloc] initWithTitle:[itemDictionary valueForKey:@"title"] action:@selector(openPage:) keyEquivalent:@""];	
		[newURL setRepresentedObject:[NSURL URLWithString:[itemDictionary valueForKey:@"object"]]];
		[statusMenu insertItem:newURL atIndex:0];
		[menuItems addObject:newURL];
	}
}

#pragma mark -
#pragma mark Drag Operations

- (NSDragOperation)statusItemView:(BCStatusItemView *)view draggingEntered:(id <NSDraggingInfo>)info
{
    NSLog(@"draggine entered");
	return NSDragOperationCopy;
}

- (void)statusItemView:(BCStatusItemView *)view draggingExited:(id <NSDraggingInfo>)info
{

}

- (BOOL)statusItemView:(BCStatusItemView *)view prepareForDragOperation:(id <NSDraggingInfo>)info
{
	return YES;
}

- (BOOL)statusItemView:(BCStatusItemView *)view performDragOperation:(id <NSDraggingInfo>)info
{
	NSPasteboard *pb = [info draggingPasteboard];
	
	NSArray *pasteboardItems = [pb pasteboardItems];  // Count should only be 1.
	NSPasteboardItem *item = [pasteboardItems objectAtIndex:0];
	
	NSString *urlString = [item stringForType:(NSString *)kUTTypeURL];	
	NSURL *url = [NSURL URLWithString:urlString];
	
	NSString *title = [[[[urlString componentsSeparatedByString:@"http://"] objectAtIndex:1] componentsSeparatedByString:@"/"] objectAtIndex:0];
	
	if ([title isEqualToString:@"www"]) {
		title = [[[[urlString componentsSeparatedByString:@"http://www."] objectAtIndex:1] componentsSeparatedByString:@"/"] objectAtIndex:0];
	}
	
	if (menuItems.count == 0)
		[statusMenu removeItemAtIndex:0];
	
	NSLog(@"menu items = %@", menuItems);
	
	NSMenuItem *newURL = [[NSMenuItem alloc] initWithTitle:title action:@selector(openPage:) keyEquivalent:@""];	
	[newURL setRepresentedObject:url];
	[statusMenu insertItem:newURL atIndex:0];
	
	[menuItems addObject:newURL];
	
	[self saveItems];
	
	return YES;
}

@end
