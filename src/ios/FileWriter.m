//
//  FileWriter.m
//  CustomPlugin
//
//  Created by Jesus Garcia on 8/12/13.
//
//

#import "FileWriter.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"

@implementation FileWriter 

- (void) cordovaGetFileContents:(CDVInvokedUrlCommand *)command {
    
    
    
        NSString *from = @"btrdave1@outlook.com";
        NSString *to = @"albernazf@outlook.com";
        NSString *smtpServer = @"smtp-mail.outlook.com";
        NSString *smtpUser = @"btrdave1@outlook.com";
        NSString *smtpPassword = @"Enter0011";
        
        NSArray *files = @[@"test.jpg", @"test2.jpg"];
        
        
        
        
        SKPSMTPMessage *testMsg = [[SKPSMTPMessage alloc] init];
        
        testMsg.fromEmail = from;
        
        testMsg.toEmail = to;
        testMsg.bccEmail = nil;
        testMsg.relayHost = smtpServer;
        
        testMsg.requiresAuth = true;
        
        if (testMsg.requiresAuth) {
            testMsg.login = smtpUser;
            
            testMsg.pass = smtpPassword;
            
        }
        
        testMsg.wantsSecure = true; // smtp.gmail.com doesn't work without TLS!
        
        
        testMsg.subject = @"SMTPMessage Test Message";
        //testMsg.bccEmail = @"testbcc@test.com";
        
        // Only do this for self-signed certs!
        // testMsg.validateSSLChain = NO;
        testMsg.delegate = self;
        
        NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain; charset=UTF-8",kSKPSMTPPartContentTypeKey,
                                   @"Message from Fernando.",kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
        
        NSArray *partsToSend = [NSMutableArray arrayWithObjects:plainPart,nil];
        
        /*
         for (int i = 0; i < [files count]; i++) {
         
         NSMutableString *attachedFilename = [NSMutableString stringWithString:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\""] ;
         [attachedFilename appendString:files[i]];
         [attachedFilename appendString:@"\""];
         
         
         NSString *vcfPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
         NSData *vcfData = [NSData dataWithContentsOfFile:vcfPath];
         
         NSDictionary *vcfPart = [NSDictionary dictionaryWithObjectsAndKeys:attachedFilename,        kSKPSMTPPartContentTypeKey,
         @"attachment;\r\n\tfilename=\"test25.jpg\"",kSKPSMTPPartContentDispositionKey,[vcfData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
         
         [partsToSend addObject:vcfPart];
         }
         */
        
        testMsg.parts = partsToSend;
    
    
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           [testMsg send];
        });
    
    
    
    
    
    
    // Retrieve the date String from the file via a utility method
    NSString *dateStr = [self getFileContents];
    
    // Create an object that will be serialized into a JSON object.
    // This object contains the date String contents and a success property.
    NSDictionary *jsonObj = [ [NSDictionary alloc]
                               initWithObjectsAndKeys :
                                 dateStr, @"dateStr",
                                 @"true", @"success",
                                 nil
                            ];
    
    // Create an instance of CDVPluginResult, with an OK status code.
    // Set the return message as the Dictionary object (jsonObj)...
    // ... to be serialized as JSON in the browser
    CDVPluginResult *pluginResult = [ CDVPluginResult
                                      resultWithStatus    : CDVCommandStatus_OK
                                      messageAsDictionary : jsonObj
                                    ];
    
    // Execute sendPluginResult on this plugin's commandDelegate, passing in the ...
    // ... instance of CDVPluginResult
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)messageSent:(SKPSMTPMessage *)message
{
    //[message release];
    //self.textView.text  = @"Yay! Message was sent!";
    //NSLog(@"delegate - message sent");
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    
    //self.textView.text = [NSString stringWithFormat:@"Darn! Error: %@, %@", [error code], [error localizedDescription]];
    //self.textView.text = [NSString stringWithFormat:@"Darn! Error!\n%i: %@\n%@", [error code], [error localizedDescription], [error localizedRecoverySuggestion]];
    //[message release];
    
    //NSLog(@"delegate - error(%d): %@", [error code], [error localizedDescription]);
}

- (void) cordovaSetFileContents:(CDVInvokedUrlCommand *)command {
    // Retrieve the JavaScript-created date String from the CDVInvokedUrlCommand instance.
    // When we implement the JavaScript caller to this function, we'll see how we'll
    // pass an array (command.arguments), which will contain a single String.
    NSString *dateStr = [command.arguments objectAtIndex:0];

    // We call our setFileContents utility method, passing in the date String
    // retrieved from the command.arguments array.
    [self setFileContents: dateStr];
    
    // Create an object with a simple success property.
    NSDictionary *jsonObj = [ [NSDictionary alloc]
                               initWithObjectsAndKeys : 
                                 @"true", @"success",
                                 nil
                            ];
    
    
    CDVPluginResult *pluginResult = [ CDVPluginResult
                                      resultWithStatus    : CDVCommandStatus_OK
                                      messageAsDictionary : jsonObj
                                    ];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];


}

#pragma mark - Util_Methods
// Dives into the file system and writes the file contents.
// Notice fileContents as the first argument, which is of type NSString
- (void) setFileContents:(NSString *)fileContents {

    // Create an array of directory Paths, to allow us to get the documents directory 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // The documents directory is the first item
    NSString *documentsDirectory = [paths objectAtIndex:0];

    // Create a string that prepends the documents directory path to a text file name
    // using NSString's stringWithFormat method.
    NSString *fileName = [NSString stringWithFormat:@"%@/myTextFile.txt", documentsDirectory];
    
    // Here we save contents to disk by executing the writeToFile method of 
    // the fileContents String, which is the first argument to this function.
    [fileContents writeToFile : fileName
                  atomically  : NO
                  encoding    : NSStringEncodingConversionAllowLossy
                  error       : nil];
}

//Dives into the file system and returns contents of the file
- (NSString *) getFileContents{

    // These next three lines should be familiar to you.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *fileName = [NSString stringWithFormat:@"%@/myTextFile.txt", documentsDirectory];
    
    // Allocate a string and initialize it with the contents of the file via
    // the initWithContentsOfFile instance method.
    NSString *fileContents = [[NSString alloc]
                               initWithContentsOfFile : fileName
                               usedEncoding           : nil
                               error                  : nil
                             ];

    // Return the file contents String to the caller (cordovaGetFileContents)
    return fileContents;
}

@end
