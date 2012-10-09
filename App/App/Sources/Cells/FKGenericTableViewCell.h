// Part of iOSKit http://foundationk.it


@interface FKGenericTableViewCell : UITableViewCell

+ (CGFloat)neededHeightForHeaderText:(NSString *)headerText
                          detailText:(NSString *)detailText
                          footerText:(NSString *)footerText
                        imageVisible:(BOOL)imageVisible
                  constrainedToWidth:(CGFloat)width;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *headerText;
@property (nonatomic, copy) NSString *detailText;
@property (nonatomic, copy) NSString *footerText;

@property (nonatomic, strong) UIColor *headerTextColor;
@property (nonatomic, strong) UIColor *headerTextHighlightedColor;

@property (nonatomic, strong) UIColor *detailTextColor;
@property (nonatomic, strong) UIColor *detailTextHighlightedColor;

@property (nonatomic, strong) UIColor *footerTextColor;
@property (nonatomic, strong) UIColor *footerTextHighlightedColor;

- (void)setSelectedBackgroundColor:(UIColor *)color;
- (void)setImageURL:(NSURL *)imageURL;

@end
