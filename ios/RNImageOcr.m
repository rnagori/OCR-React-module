
#import "RNImageOcr.h"
#import <G8Tesseract.h>
#import <UIImage+G8Filters.h>

#define ID @"ID:"
#define ID_LENGTH 11
#define DOB @"DOB:"
#define DOB_LENGTH 8
#define ISSUED @"ISSUED:"
#define ISSUED_LENGTH 8
#define EXPIRES @"EXPIRES:"
#define EXPIRES_LENGTH 8
#define SEX @"SEX:"
#define SEX_LENGTH 1

@implementation RNImageOcr

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(getStringFromUrl:(NSString *)imageURL resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    
    resolve([self getStringfromUrl:imageURL]);
}

- (NSString*)getStringfromUrl:(NSString*) Url{
    
    NSURL *url = [NSURL URLWithString:Url];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *ret = [UIImage imageWithData:imageData];
    
    
    G8Tesseract* tesseract4 = [[G8Tesseract alloc] initWithLanguage:@"eng"];
    
    tesseract4.engineMode = G8OCREngineModeTesseractCubeCombined;
    tesseract4.pageSegmentationMode = G8PageSegmentationModeAuto;
    tesseract4.maximumRecognitionTime = 60.0;
    tesseract4.charWhitelist = @"-:0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //[tesseract4 setImage:[[ret g8_blackAndWhite ] g8_grayScale]];
    [tesseract4 setImage:ret];
    tesseract4.sourceResolution = 2400;
    [tesseract4 recognize];
    NSString *srr = [self getFormatedStringfromString:[[tesseract4.recognizedText stringByReplacingOccurrencesOfString:@": " withString:@":"] stringByReplacingOccurrencesOfString:@"lSSUED" withString:@"ISSUED"]];
    srr = [srr stringByReplacingOccurrencesOfString:@":" withString:@": "];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:tesseract4.recognizedText,@"raw",srr,@"format", nil];
    return tesseract4.recognizedText;
}
- (NSString*)getFormatedStringfromString:(NSString*)str {
    NSMutableString *orgStr = [[NSMutableString alloc] init];
    
    [orgStr appendString:[self findPatternInString:str withPattern:ID withLength:ID_LENGTH]];
    [orgStr appendString:[self findPatternInString:str withPattern:DOB withLength:DOB_LENGTH]];
    [orgStr appendString:[self findPatternInString:str withPattern:SEX withLength:SEX_LENGTH]];
    [orgStr appendString:[self findPatternInString:str withPattern:ISSUED withLength:ISSUED_LENGTH]];
    [orgStr appendString:[self findPatternInString:str withPattern:EXPIRES withLength:EXPIRES_LENGTH]];
    
    return orgStr;
}
- (NSString *)findPatternInString:(NSString *)value withPattern:(NSString*)pattern withLength:(int)length
{
    if([value containsString:pattern]) {
        NSRange firstInstance = [value rangeOfString:pattern];
        NSString *final = [value substringWithRange:NSMakeRange(firstInstance.location, firstInstance.length+length)];
        
        return [NSString stringWithFormat:@"%@\n",final];
    }
    else {
        return @"";
    }
    
}
@end


  
