#import "FKGenericTableViewCell.h"
#import "FKIncludes.h"
#import "UIImageView+AFNetworking.h"


#define kFKPaddingX                             5.f
#define kFKPaddingYOutside                      5.f
#define kFKPaddingYInside                       2.f
#define kFKPaddingYImage                        kFKPaddingYOutside + kFKPaddingYInside
#define kFKHeaderLineBreakMode                  UILineBreakModeWordWrap
#define kFKDetailTextLineBreakMode              UILineBreakModeWordWrap
#define kFKFooterLineBreakMode                  UILineBreakModeWordWrap
#define kFKImageViewRect                        CGRectMake(kFKPaddingX, kFKPaddingYImage, 55.f, 55.f)


static UIFont *headerFont = nil;
static UIFont *detailFont = nil;
static UIFont *footerFont = nil;
static UIImage *placeholderImage = nil;


@interface FKGenericTableViewCell ()

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, readonly) BOOL imageVisible;

@end


@implementation FKGenericTableViewCell

@synthesize headerText = _headerText;
@synthesize detailText = _detailText;
@synthesize footerText = _footerText;
@synthesize cellImageView = _cellImageView;

////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////

+ (void)initialize {
    if (self == [FKGenericTableViewCell class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            headerFont = [UIFont boldSystemFontOfSize:16.f];
            detailFont = [UIFont systemFontOfSize:14.f];
            footerFont = [UIFont italicSystemFontOfSize:13.f];
            // TODO: Set placeholder image
            placeholderImage = [UIImage imageNamed:@"IMAGE"];
        });
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _cellImageView = [[UIImageView alloc] initWithFrame:kFKImageViewRect];
        _cellImageView.clipsToBounds = YES;
        _cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        _cellImageView.hidden = YES;        
        
        [self addSubview:_cellImageView];
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Class Methods
////////////////////////////////////////////////////////////////////////

+ (CGFloat)neededHeightForHeaderText:(NSString *)headerText
                          detailText:(NSString *)detailText
                          footerText:(NSString *)footerText
                        imageVisible:(BOOL)imageVisible
                  constrainedToWidth:(CGFloat)width {
    NSInteger numberOfVisibleLabels = 0;
    CGFloat innerWidth = width - 2*kFKPaddingX;
    
    if (imageVisible) {
        innerWidth -= CGRectGetWidth(kFKImageViewRect) + kFKPaddingX;
    }
    
    CGSize constraint = CGSizeMake(innerWidth, CGFLOAT_MAX);
    
    CGSize sizeHeaderText = [headerText sizeWithFont:headerFont 
                                   constrainedToSize:constraint
                                       lineBreakMode:kFKHeaderLineBreakMode];
    CGSize sizeDetailText = [detailText sizeWithFont:detailFont
                                   constrainedToSize:constraint
                                       lineBreakMode:kFKDetailTextLineBreakMode];
    CGSize sizeFooterText = [footerText sizeWithFont:footerFont 
                                   constrainedToSize:constraint
                                       lineBreakMode:kFKFooterLineBreakMode];
    
    if (sizeHeaderText.height > 0.f) {
        numberOfVisibleLabels++;
    }
    
    if (sizeDetailText.height > 0.f) {
        numberOfVisibleLabels++;
    }
    
    if (sizeFooterText.height > 0.f) {
        numberOfVisibleLabels++;
    }
    
    CGFloat computedHeight = (sizeHeaderText.height
                              + sizeDetailText.height
                              + sizeFooterText.height
                              + (numberOfVisibleLabels-1)*kFKPaddingYInside
                              + 2*kFKPaddingYOutside);
    
    return imageVisible ? MAX(computedHeight, CGRectGetHeight(kFKImageViewRect) + 2*kFKPaddingYImage) : computedHeight;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIView
////////////////////////////////////////////////////////////////////////

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // show/hide ImageView
    if (self.cellImageView.image != nil) {
        self.cellImageView.hidden = NO;
    } else {
        self.cellImageView.hidden = YES;
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewCell
////////////////////////////////////////////////////////////////////////

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.cellImageView.hidden = YES;
    self.cellImageView.image = nil;
    _headerText = nil;
    _detailText = nil;
    _footerText = nil;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - FKTableViewCell
////////////////////////////////////////////////////////////////////////

- (void)drawContentViewInRect:(CGRect)rect highlighted:(BOOL)highlighted {
    CGContextRef context = UIGraphicsGetCurrentContext();
	UIColor *headerTextColor = [UIColor blackColor];
    UIColor *detailTextColor = [UIColor blackColor];
    UIColor *footerTextColor = [UIColor darkGrayColor];
    CGFloat textX = self.imageVisible ? self.cellImageView.frameRight + kFKPaddingX : kFKPaddingX;
    CGFloat textRightPadding = 25.f;
    CGFloat innerWidth = self.frameWidth - textX - textRightPadding;
    CGPoint p = CGPointMake(textX, kFKPaddingYOutside);
    
    // change colors when selected
	if (highlighted) {
        headerTextColor = [UIColor blackColor];
        detailTextColor = [UIColor darkGrayColor];
        footerTextColor = [UIColor darkGrayColor];
        
        // draw gradient
        CGGradientRef gradientRef = FKCreateGradientWithColors($array([UIColor whiteColor],
                                                                      [UIColor lightGrayColor]));
        FKDrawGradientInRect(context, gradientRef, rect);
        CGGradientRelease(gradientRef);
	} else {
        // Only draw gradient on fast devices
        if ([[UIDevice currentDevice] isCrappy]) {
            [[UIColor whiteColor] set];
            CGContextFillRect(context, rect);
        } else {
            CGGradientRef gradientRef = FKCreateGradientWithColors($array([UIColor whiteColor],
                                                                          [UIColor whiteColor]));
            FKDrawGradientInRect(context, gradientRef, rect);
            CGGradientRelease(gradientRef);
        }
    }
    
    // Draw Header Text
    [headerTextColor set];
    CGSize neededSize = [_headerText drawInRect:CGRectMake(p.x, p.y, innerWidth, CGFLOAT_MAX)
                                       withFont:headerFont
                                  lineBreakMode:kFKHeaderLineBreakMode
                                      alignment:UITextAlignmentLeft];
    
    p.y += neededSize.height + kFKPaddingYInside;
    
    if (!$empty(_detailText)) {
        // Draw Detail Text   
        [detailTextColor set];
        neededSize = [_detailText drawInRect:CGRectMake(p.x, p.y, innerWidth, CGFLOAT_MAX)
                                    withFont:detailFont
                               lineBreakMode:kFKDetailTextLineBreakMode
                                   alignment:UITextAlignmentLeft];
        
        p.y += neededSize.height + kFKPaddingYInside;
    }
    
    // Draw Footer Text?
    if (!$empty(_footerText)) { 
        [footerTextColor set];
        [_footerText drawInRect:CGRectMake(p.x, p.y, innerWidth, CGFLOAT_MAX)
                       withFont:footerFont
                  lineBreakMode:kFKFooterLineBreakMode
                      alignment:UITextAlignmentLeft];
        
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NDRTableViewCell
////////////////////////////////////////////////////////////////////////

- (void)setImage:(UIImage *)image {
    self.cellImageView.image = image;
}

- (UIImage *)image {
    return self.cellImageView.image;
}

- (void)setImageURL:(NSURL *)imageURL {
    __unsafe_unretained FKGenericTableViewCell *weakSelf = self;
    
    [self.cellImageView setImageWithURLRequest:[NSURLRequest requestWithURL:imageURL]
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           [weakSelf.cellImageView setImage:image animated:YES];
                                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           weakSelf.cellImageView.image = placeholderImage;
                                       }];
}

- (void)setHeaderText:(NSString *)headerText {
    if (_headerText != headerText) {
        _headerText = headerText;
        [self setNeedsDisplay];
    }
}

- (void)setDetailText:(NSString *)detailText {
    if (_detailText != detailText) {
        _detailText = detailText;
        [self setNeedsDisplay];
    }
}

- (void)setFooterText:(NSString *)footerText {
    if (_footerText != footerText) {
        _footerText = footerText;
        [self setNeedsDisplay];
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////

- (BOOL)imageVisible {
    return self.cellImageView.image != nil && self.cellImageView.hidden == NO;
}


@end
