// Part of iOSKit http://foundationk.it

#import "FKTableViewCell.h"

@interface FKGenericTableViewCell : FKTableViewCell

+ (CGFloat)neededHeightForHeaderText:(NSString *)headerText
                          detailText:(NSString *)detailText
                          footerText:(NSString *)footerText
                        imageVisible:(BOOL)imageVisible
                  constrainedToWidth:(CGFloat)width;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *headerText;
@property (nonatomic, copy) NSString *detailText;
@property (nonatomic, copy) NSString *footerText;

- (void)setImageURL:(NSURL *)imageURL;

@end
