//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSMessagesViewController
//
//
//  The MIT License
//  Copyright (c) 2014 Jesse Squires
//  http://opensource.org/licenses/MIT
//

#import "JSQMessagesAvatarFactory.h"

@interface JSQMessagesAvatarFactory ()

+ (UIImage *)jsq_circularImage:(UIImage *)image withDiamter:(NSUInteger)diameter;

@end



@implementation JSQMessagesAvatarFactory

#pragma mark - Public

+ (UIImage *)avatarWithImage:(UIImage *)originalImage diameter:(NSUInteger)diameter
{
    return [JSQMessagesAvatarFactory jsq_circularImage:originalImage withDiamter:diameter];
}

+ (UIImage *)avatarWithUserInitials:(NSString *)userInitials
                    backgroundColor:(UIColor *)backgroundColor
                          textColor:(UIColor *)textColor
                               font:(UIFont *)font
                           diameter:(NSUInteger)diameter
{
    CGRect frame = CGRectMake(0.0f, 0.0f, diameter, diameter);
    
    NSString *text = [userInitials uppercaseString];
    
    NSDictionary *attributes = @{ NSFontAttributeName : font,
                                  NSForegroundColorAttributeName : textColor };
    
    CGRect textFrame = [text boundingRectWithSize:frame.size
                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                       attributes:attributes
                                          context:nil];
    
    CGPoint frameMidPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    CGPoint textFrameMidPoint = CGPointMake(CGRectGetMidX(textFrame), CGRectGetMidY(textFrame));
    
    CGFloat dx = frameMidPoint.x - textFrameMidPoint.x;
    CGFloat dy = frameMidPoint.y - textFrameMidPoint.y;
    CGPoint drawPoint = CGPointMake(dx, dy);
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, frame);
    [text drawAtPoint:drawPoint withAttributes:attributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    
    return [JSQMessagesAvatarFactory jsq_circularImage:image withDiamter:diameter];
}

#pragma mark - Private

+ (UIImage *)jsq_circularImage:(UIImage *)image withDiamter:(NSUInteger)diameter
{
    CGRect frame = CGRectMake(0.0f, 0.0f, diameter, diameter);
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIBezierPath *imgPath = [UIBezierPath bezierPathWithOvalInRect:frame];
    [imgPath addClip];
    [image drawInRect:frame];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    return newImage;
}

@end
