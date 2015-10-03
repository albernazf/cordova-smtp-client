#import "HWPHello.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"

@implementation HWPHello

- (void)greet:(CDVInvokedUrlCommand*)command
{



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
















    NSString* callbackId = [command callbackId];
    NSString* name = [[command arguments] objectAtIndex:0];
    NSString* msg = [NSString stringWithFormat: @"Hello different, %@", name];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:msg];

    [self success:result callbackId:callbackId];
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

@end