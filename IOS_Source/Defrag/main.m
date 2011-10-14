//
//  main.m
//  Defrag
//
//  Created by swarren on 6/21/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    //redirect log output to file
    //NSString *logPath = @"/Users/stevewarren/xcodelog.txt"; 
    //freopen([logPath fileSystemRepresentation], "a", stderr);
    
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    
    return retVal;
}
