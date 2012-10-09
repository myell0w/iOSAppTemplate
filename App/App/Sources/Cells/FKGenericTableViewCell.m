#import "FKGenericTableViewCell.h"
#import "FKIncludes.h"
#import "UIImageView+AFNetworking.h"


#define kFKMinHeight                            44.f
#define kFKPaddingXLeft                         5.f
#define kFKPaddingXRight                        25.f
#define kFKPaddingYOutside                      5.f
#define kFKPaddingYInside                       2.f
#define kFKPaddingYImage                        kFKPaddingYOutside + kFKPaddingYInside
#define kFKHeaderLineBreakMode                  UILineBreakModeWordWrap
#define kFKDetailTextLineBreakMode              UILineBreakModeWordWrap
#define kFKFooterLineBreakMode                  UILineBreakModeWordWrap
#define kFKImageViewRect                        CGRectMake(kFKPaddingXLeft, kFKPaddingYImage, 55.f, 55.f)

#define kFKHeaderColor                          [UIColor blackColor]
#define kFKDetailTextColor                      [UIColor blackColor]
#define kFKFooterColor                          [UIColor darkGrayColor]

#define kFKHeaderHighlightedColor               [UIColor blackColor]
#define kFKDetailTextHighlightedColor           [UIColor darkGrayColor]
#define kFKFooterHighlightedColor               [UIColor darkGrayColor]


static UIFont *headerFont = nil;
static UIFont *detailFont = nil;
static UIFont *footerFont = nil;
static UIImage *placeholderImage = nil;


@interface FKGenericTableViewCell ()

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *footerLabel;
@property (nonatomic, readonly) BOOL imageVisible;

- (UILabel *)labelWithFont:(UIFont *)font
                 textColor:(UIColor *)textColor
      highlightedTextColor:(UIColor *)highlightedTextColor
             lineBreakMode:(UILineBreakMode)lineBreakMode;

- (void)layoutLabels;

@end


@implementation FKGenericTableViewCell

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
        _headerLabel = [self labelWithFont:headerFont
                                 textColor:kFKHeaderColor
                      highlightedTextColor:kFKHeaderHighlightedColor
                             lineBreakMode:kFKHeaderLineBreakMode];
        [self.contentView addSubview:_headerLabel];
        
        _detailLabel = [self labelWithFont:detailFont
                                 textColor:kFKDetailTextColor
                      highlightedTextColor:kFKDetailTextHighlightedColor
                             lineBreakMode:kFKDetailTextLineBreakMode];
        [self.contentView addSubview:_detailLabel];
        
        _footerLabel = [self labelWithFont:footerFont
                                 textColor:kFKFooterColor
                      highlightedTextColor:kFKFooterHighlightedColor
                             lineBreakMode:kFKFooterLineBreakMode];
        [self.contentView addSubview:_footerLabel];
        
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
    CGFloat innerWidth = width - kFKPaddingXLeft - kFKPaddingXRight;
    
    if (imageVisible) {
        innerWidth -= CGRectGetWidth(kFKImageViewRect) + kFKPaddingXLeft;
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
    
    CGFloat neededHeight = imageVisible ? MAX(computedHeight, CGRectGetHeight(kFKImageViewRect) + 2*kFKPaddingYImage) : computedHeight;
    
    return MAX(kFKMinHeight, neededHeight);
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
    
    [self layoutLabels];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewCell
////////////////////////////////////////////////////////////////////////

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self hideLoadingIndicator];
    
    self.cellImageView.hidden = YES;
    self.cellImageView.image = nil;
    _headerText = nil;
    _detailText = nil;
    _footerText = nil;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - FKGenericTableViewCell
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
                                           __strong FKGenericTableViewCell *strongSelf = weakSelf;
                                           
                                           if (strongSelf != nil) {
                                               [strongSelf.cellImageView setImage:image animated:YES];
                                           }
                                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           __strong FKGenericTableViewCell *strongSelf = weakSelf;
                                           
                                           if (strongSelf != nil) {
                                               strongSelf.cellImageView.image = placeholderImage;
                                           }
                                       }];
}

- (void)setSelectedBackgroundColor:(UIColor *)color {
    UIView *view = [[UIView alloc] initWithFrame:self.frame];
    
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = color;
    
    self.selectedBackgroundView = view;
}

- (void)setHeaderText:(NSString *)headerText {
    if (self.headerLabel.text != headerText) {
        self.headerLabel.text = headerText;
        [self setNeedsLayout];
    }
}

- (void)setDetailText:(NSString *)detailText {
    if (self.detailLabel.text != detailText) {
        self.detailLabel.text = detailText;
        [self setNeedsLayout];
    }
}

- (void)setFooterText:(NSString *)footerText {
    if (self.footerLabel.text != footerText) {
        self.footerLabel.text = footerText;
        [self setNeedsLayout];
    }
}

- (void)setHeaderTextColor:(UIColor *)headerTextColor {
    self.headerLabel.textColor = headerTextColor;
}

- (UIColor *)headerTextColor {
    return self.headerLabel.textColor;
}

- (void)setDetailTextColor:(UIColor *)detailTextColor {
    self.detailLabel.textColor = detailTextColor;
}

- (UIColor *)detailTextColor {
    return self.detailLabel.textColor;
}

- (void)setFooterTextColor:(UIColor *)footerTextColor {
    self.footerLabel.textColor = footerTextColor;
}

- (UIColor *)footerTextColor {
    return self.footerLabel.textColor;
}

- (void)setHeaderTextHighlightedColor:(UIColor *)headerTextHighlightedColor {
    self.headerLabel.highlightedTextColor = headerTextHighlightedColor;
}

- (UIColor *)headerTextHighlightedColor {
    return self.headerLabel.highlightedTextColor;
}

- (void)setDetailTextHighlightedColor:(UIColor *)detailTextHighlightedColor {
    self.detailLabel.highlightedTextColor = detailTextHighlightedColor;
}

- (UIColor *)detailTextHighlightedColor {
    return self.detailLabel.highlightedTextColor;
}

- (void)setFooterTextHighlightedColor:(UIColor *)footerTextHighlightedColor {
    self.footerLabel.highlightedTextColor = footerTextHighlightedColor;
}

- (UIColor *)footerTextHighlightedColor {
    return self.footerLabel.highlightedTextColor;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////

- (BOOL)imageVisible {
    return self.cellImageView.image != nil && self.cellImageView.hidden == NO;
}

- (UILabel *)labelWithFont:(UIFont *)font
                 textColor:(UIColor *)textColor
      highlightedTextColor:(UIColor *)highlightedTextColor
             lineBreakMode:(UILineBreakMode)lineBreakMode {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = textColor;
    label.highlightedTextColor = highlightedTextColor;
    label.lineBreakMode = lineBreakMode;
    label.numberOfLines = 0;
    
    return label;
}

- (void)layoutLabels {
    CGFloat textX = self.imageVisible ? self.cellImageView.frameRight + kFKPaddingXLeft : kFKPaddingXLeft;
    CGFloat innerWidth = self.contentView.frameWidth - textX - kFKPaddingXRight;
    CGPoint p = CGPointMake(textX, kFKPaddingYOutside);
    CGSize constraint = CGSizeMake(innerWidth, CGFLOAT_MAX);
    
    // Compute Sizes
    CGSize sizeHeaderText = [self.headerLabel.text sizeWithFont:self.headerLabel.font
                                              constrainedToSize:constraint
                                                  lineBreakMode:self.headerLabel.lineBreakMode];
    
    CGSize sizeDetailText = [self.detailLabel.text sizeWithFont:self.detailLabel.font
                                              constrainedToSize:constraint
                                                  lineBreakMode:self.detailLabel.lineBreakMode];
    
    CGSize sizeFooterText = [self.footerLabel.text sizeWithFont:self.footerLabel.font
                                              constrainedToSize:constraint
                                                  lineBreakMode:self.footerLabel.lineBreakMode];
    
    // Special case, only display header text (centered)
    if (sizeDetailText.height == 0.f && sizeFooterText.height == 0.f) {
        sizeHeaderText.height = MAX(kFKMinHeight - 2*kFKPaddingYOutside, sizeHeaderText.height);
    }
    
    self.headerLabel.frame = (CGRect){p, sizeHeaderText};
    p.y += sizeHeaderText.height + kFKPaddingYInside;
    
    if (sizeDetailText.height > 0.f) {
        self.detailLabel.hidden = NO;
        self.detailLabel.frame = (CGRect){p, sizeDetailText};
        p.y += sizeDetailText.height + kFKPaddingYInside;
    } else {
        self.detailLabel.hidden = YES;
    }
    
    if (sizeFooterText.height > 0.f) {
        self.footerLabel.hidden = NO;
        self.footerLabel.frame = (CGRect){p, sizeFooterText};
    } else {
        self.footerLabel.hidden = YES;
    }
}

@end
