// Part of iOSAppTemplate http://foundationk.it

#import "FKLog.h"

/**
 Enum defining possible log levels
 */
typedef enum {
    FKLogLevelVerbose = 0,
    FKLogLevelInfo,
    FKLogLevelWarning,
    FKLogLevelError,
    FKLogLevelNone
} FKLogLevel;


// In Debug-Mode we log everything form LogLevel Info up,
// else we only log warnings and errors
#if DEBUG
static FKLogLevel kFKLogLevel = FKLogLevelInfo;
#else
static FKLogLevel kFKLogLevel = FKLogLevelWarning;
#endif

/**
 This function transforms a log level into a string representation
 */
NS_INLINE NSString* FKLogLevelDescription(FKLogLevel logLevel) {
    switch (logLevel) {
        case FKLogLevelVerbose:
            return @"<V>";
            
        case FKLogLevelInfo:
            return @"<I>";
            
        case FKLogLevelWarning:
            return @"<W>";
            
        case FKLogLevelError:
            return @"!E!";
            
        case FKLogLevelNone:
        default:
            return @"";
    }
}

/**
 This function logs the log message, if the given logLevel is greater or equal
 to the currently defined global logLevel kFKLogLevel
 */
NS_INLINE void FKLogWithLevel(FKLogLevel logLevel, NSString *file, unsigned int line, NSString *logMessage) {
    if (logLevel >= kFKLogLevel) {
        NSLog(@"[%@:%u] %@ %@", file, line, logMessage, FKLogLevelDescription(logLevel));
    }
}

// Shortcuts for logging with the given log levels
#define FKLogVerbose(...)       FKLogWithLevel(FKLogLevelVerbose, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#define FKLogInfo(...)          FKLogWithLevel(FKLogLevelInfo, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#define FKLogWarning(...)       FKLogWithLevel(FKLogLevelWarning, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#define FKLogError(...)         FKLogWithLevel(FKLogLevelError, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:__VA_ARGS__])

// Logs variables with log level Info
#define FKLogVariables(...)          do { if (FKLogLevelInfo >= kFKLogLevel) { FKLog(__VA_ARGS__)} } while(0)
// Logs variables with log level error
#define FKLogErrorVariables(...)     do { if (FKLogLevelError >= kFKLogLevel) { FKLog(__VA_ARGS__)} } while(0)

// Logs the function/method that got entered
#define FKLogEntry()            do { NSString *enteredFunction = [NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding]; FKLog(enteredFunction); } while(0)
// Logs that this method is not implemented and aborts
#define FKLogNotImplemented()   do { NSString *enteredFunction = [NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding]; FKLogError(@"Not implemented yet.", enteredFunction); [self doesNotRecognizeSelector:_cmd];} while(0)
