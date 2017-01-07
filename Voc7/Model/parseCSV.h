/*
 * Max Scheurer
 *
 */
#import <UIKit/UIKit.h>

@interface CSVParser : NSObject {
	int fileHandle;
	int bufferSize;
	char delimiter;
	NSStringEncoding encoding;
}

-(id)init;
-(BOOL)openFile:(NSString*)fileName;
-(void)closeFile;
-(char)autodetectDelimiter;
-(char)delimiter;
-(void)setDelimiter:(char)newDelimiter;
-(void)setBufferSize:(int)newBufferSize;
-(NSMutableArray*)parseFile;
-(void)setEncoding:(NSStringEncoding)newEncoding;

@end
