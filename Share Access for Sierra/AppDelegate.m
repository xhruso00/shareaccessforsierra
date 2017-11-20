#import "AppDelegate.h"
#import "SAWindowController.h"

@interface AppDelegate () {
    SAWindowController *_windowController;
}
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)awakeFromNib
{
    [[self window] setBackgroundColor:[NSColor whiteColor]];
    [self centerOnMainScreen];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
#ifdef DEBUG
#else
    system("pluginkit -e use -i com.hrubasko.Share-Access-for-Sierra");
#endif
    [self centerOnMainScreen];
    [[self window] makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:0x1];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed {
    return YES;
}

- (void)centerOnMainScreen
{
    NSRect screenRect = [[NSScreen mainScreen] frame];
    NSRect windowRect = [[self window] frame];
    [[self window] setFrameOrigin:NSMakePoint((NSWidth(screenRect) - NSWidth(windowRect))/2, (NSHeight(screenRect) - NSHeight(windowRect))/2)];
}

- (IBAction)share:(NSURL *)URL
{
    if (!_windowController) {
        _windowController = [[SAWindowController alloc] initWithWindowNibName:@"FinderSync"];
    }
    [_windowController setFileURL:URL];
    [_windowController showWindow:self];
    [[self window] close];
    
}

- (IBAction)quit:(id)sender
{
    [NSApp terminate:self];
}

- (IBAction)revealExtensions:(id)sender
{
    NSURL *URL = [NSURL fileURLWithPath:@"/System/Library/PreferencePanes/Extensions.prefPane" isDirectory:YES];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

- (IBAction)sendFeedback:(id)sender
{
    NSString *URLString = @"https://github.com/xhruso00/shareaccessforsierra/issues";
    NSURL *URL = [NSURL URLWithString:URLString];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end
