// Part of iOSAppTemplate http://foundationk.it

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
            return @"|V|";
            
        case FKLogLevelInfo:
            return @"|I|";
            
        case FKLogLevelWarning:
            return @"|W|";
            
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
NS_INLINE void FKLogWithLevel(FKLogLevel logLevel, NSString *logMessage) {
    if (logLevel >= kFKLogLevel) {
        NSLog(@"%@ %@", logMessage, FKLogLevelDescription(logLevel));
    }
}

// Shortcuts for logging with the given log levels
#define FKLogVerbose(...)       FKLogWithLevel(FKLogLevelVerbose, FKLogToString(__VA_ARGS__))
#define FKLogInfo(...)          FKLogWithLevel(FKLogLevelInfo, FKLogToString(__VA_ARGS__))
#define FKLogWarning(...)       FKLogWithLevel(FKLogLevelWarning, FKLogToString(__VA_ARGS__))
#define FKLogError(...)         FKLogWithLevel(FKLogLevelError, FKLogToString(__VA_ARGS__))

// Logs the function/method that got entered
#define FKLogEntry()            { NSString *enteredFunction = [NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding]; FKLogInfo(enteredFunction); }
// Logs that this method is not implemented and aborts
#define FKLogNotImplemented()   do { FKLogError(@"Not implemented yet."); [self doesNotRecognizeSelector:_cmd];} while(0)