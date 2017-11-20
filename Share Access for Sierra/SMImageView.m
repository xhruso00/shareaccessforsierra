#import "SMImageView.h"
#import "AppDelegate.h"

@implementation SMImageView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    //registering direct drag from contacts or via file drag
    [self registerForDraggedTypes:@[(__bridge NSString *)kUTTypeFileURL]];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    BOOL acceptDragOperation = NO;
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if([[pboard types] containsObject:(__bridge NSString *)kUTTypeFileURL]){
        acceptDragOperation = YES;
    }
    
    return acceptDragOperation;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    NSData *data = [pboard dataForType:@"public.file-url"];
    NSString *path = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:path];
    [NSApp sendAction:@selector(share:) to:[NSApp delegate] from:URL];
    return YES;
}

- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender
{
    NSDragOperation operation = NSDragOperationNone;
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if([[pboard types] containsObject:(__bridge NSString *)kUTTypeFileURL]){
        operation = NSDragOperationCopy;
    }
    return operation;
}
@end

