//
//  UIImage+JOExtend.m
//  JOProjectBaseSDK
//
//  Created by 刘维 on 16/6/23.
//  Copyright © 2016年 刘维. All rights reserved.
//

#import "UIImage+JOExtend.h"
#import <ImageIO/ImageIO.h>
#import "CGGeometry+JOExtend.h"
#import "NSString+JOExtend.h"

typedef struct JOAttributeBox{
    
    int red;
    int green;
    int blue;
    int aplha;
    
} JORGBAIndexStruct;

static JORGBAIndexStruct rgbaIndexStruct = {3,2,1,0};

#ifndef JORGBAPixels
#define JORGBAPixels rgbaIndexStruct
#endif

@implementation UIImage(JOExtend)

#pragma mark - Resize Image

- (UIImage *)joStretchableImage {
    return [self joStretchableImageWithcapPoint:CGPointMake(self.size.width/2., self.size.height/2.)];
}

- (UIImage *)joStretchableImageWithcapPoint:(CGPoint)capPoint {
    return [self stretchableImageWithLeftCapWidth:capPoint.x topCapHeight:capPoint.y];
}

+ (UIImage *)joStretchableImageWithName:(NSString *)imageName {
    
    UIImage *stretchImage = [UIImage imageNamed:imageName];
    return [stretchImage joStretchableImage];
}

+ (UIImage *)joStretchableImageWithName:(NSString *)imageName capPoint:(CGPoint)capPoint{
    
    UIImage *stretchImage = [UIImage imageNamed:imageName];
    return [stretchImage joStretchableImageWithcapPoint:capPoint];
}

- (UIImage *)joResizeImageTile {
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(0., 0., 0., 0.) resizingMode:UIImageResizingModeTile];
}

+ (UIImage *)joResizeImageTileWithName:(NSString *)imageName {
    return [UIImage joResizeImageWithName:imageName capInsets:UIEdgeInsetsMake(0., 0., 0., 0.) mode:UIImageResizingModeTile];
}

+ (UIImage *)joResizeImageWithName:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets mode:(UIImageResizingMode)model {
    
    UIImage *resizeImage = [UIImage imageNamed:imageName];
    return [resizeImage resizableImageWithCapInsets:capInsets resizingMode:model];
}

#pragma mark - private

static inline void JOContextAddRoundedRectPath(CGContextRef context, CGRect rect, CGFloat radius) {

    if (radius == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    CGContextSaveGState(context);
//消除锯齿的,但是对图片的裁剪而言无效
//    CGContextSetAllowsAntialiasing(context, YES);
//    CGContextSetShouldAntialias(context, YES);
    
    CGContextMoveToPoint(context, 0. , radius);
    CGContextAddArc(context, radius, radius, radius, M_PI, 3*M_PI/2, NO);
    CGContextAddLineToPoint(context, width - radius, 0.);
    CGContextAddArc(context, width - radius, radius, radius, 3*M_PI/2, 2*M_PI, NO);
    CGContextAddLineToPoint(context, width , height - radius);
    CGContextAddArc(context, width - radius, height - radius, radius, 0., M_PI/2., NO);
    CGContextAddLineToPoint(context, radius, height);
    CGContextAddArc(context, radius, height - radius, radius,M_PI/2., M_PI , NO);
    CGContextAddLineToPoint(context, 0. , radius);
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

#pragma mark - Color Image

+ (UIImage *)joImageWithColor:(UIColor *)color {
    return [UIImage joImageWithColor:color size:CGSizeMake(1., 1.)];
}

+ (UIImage *)joImageWithColor:(UIColor *)color size:(CGSize)size {

    // http://stackoverflow.com/questions/1213790/how-to-get-a-color-image-in-iphone-sdk
    
    //创建一个适当大小的上下文context.
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (currentContext == NULL) return nil;
    
    CGRect fillRect = CGRectMake(0, 0, size.width, size.height);
    //设置填充颜色
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    //填充颜色
    CGContextFillRect(currentContext, fillRect);
    //获取context的图片
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭image的context
    UIGraphicsEndImageContext();
    
    return colorImage;
}

#pragma mark - rounded image

+ (UIImage *)joRoundedImage:(UIImage *)image size:(CGSize )size cornerRadius:(CGFloat)radius {

    CGFloat width = size.width;
    CGFloat height = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 8,
                                                 4 * width,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrderDefault);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    CGContextBeginPath(context);
    JOContextAddRoundedRectPath(context, rect, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    //一般create跟copy创建的对象,不需要的时候 都需要release or free
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}

+ (UIImage *)joRoundedImage:(UIImage *)image cornerRadius:(CGFloat)radius {
    return [UIImage joRoundedImage:image size:image.size cornerRadius:radius];
}

#pragma mark - draw text or image at image

- (UIImage *)joImageDrawnText:(NSString *)text atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font {

    UIGraphicsBeginImageContextWithOptions([self size], NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0., 0., self.size.width, self.size.height)];
    [color set];
    [text drawAtPoint:point withAttributes:@{NSFontAttributeName:font}];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)joImageDrawnTextWithName:(NSString *)imageName drawnText:(NSString *)text atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font {

    UIImage *image = [UIImage imageNamed:imageName];
    return [image joImageDrawnText:text atPoint:point color:color font:font];
}

- (UIImage *)joImageDrawnImage:(UIImage *)image inRect:(CGRect)rect {

    UIGraphicsBeginImageContextWithOptions([self size], NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0., 0., self.size.width, self.size.height)];
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)joImageDrawnImageWithName:(NSString *)imageName drawnImage:(UIImage *)image inRect:(CGRect)rect {
    
    UIImage *originalImage = [UIImage imageNamed:imageName];
    return [originalImage joImageDrawnImage:image inRect:rect];
}


- (UIImage *)joImageRotatedWithDegrees:(CGFloat)degrees
{
    //通过对一个view做旋转然后得到这个图片旋转之后需要的size大小.
    //transform之后的视图的大小会发生变化.
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(JORadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //平移旋转缩放为了将图片翻转成正常的状态
    //因为UIKit(左上为原点,右跟下为正方向)跟Core graphics(左下为原点,右跟上为正方向)坐标系不同 CGContext画出来的图片是颠倒的.
    CGContextTranslateCTM(context, rotatedSize.width/2, rotatedSize.height/2); //若不平移的话 则翻转的只能看见下半部分
    CGContextRotateCTM(context, JORadians(degrees));
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)joImageConvertToGrayScale {
    
    size_t imageWidth = (size_t)self.size.width;
    size_t imageHeight = (size_t)self.size.height;
    
    UIImage *grayscaledImage = nil;
    
    //两种方法都可以,可以随时切换该方法进行
    //通过计算代码运行的时间,第二种要优于第一种
#ifndef JOCovertToGrayScaleUsed 
#define JOCovertToGrayScaleUsed 0
#if JOCovertToGrayScaleUsed
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imageWidth,
                                                 imageHeight,
                                                 8,
                                                 imageWidth * 3,
                                                 colorSpace,
                                                 kCGImageAlphaNone | kCGBitmapByteOrderDefault);
    CGColorSpaceRelease(colorSpace);
    if (!context)
        return nil;
    
    //高质量的图片
    CGContextSetShouldAntialias(context, false);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextDrawImage(context, rect, self.CGImage);
    CGImageRef grayscaledImageRef = CGBitmapContextCreateImage(context);
    grayscaledImage = [UIImage imageWithCGImage:grayscaledImageRef scale:self.scale orientation:self.imageOrientation];
    
    CGImageRelease(grayscaledImageRef);
    CGContextRelease(context);
#else
    //为一个像素的RGBA值分配空间 4个字节的大小.
    uint32_t *pixels = (uint32_t *) malloc(imageWidth * imageHeight * sizeof(uint32_t));
    //指定填充一个固定的值,即清零
    memset(pixels, 0, imageWidth * imageHeight * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //创建位图的空间
    CGContextRef context = CGBitmapContextCreate(pixels,
                                                 imageWidth,
                                                 imageHeight,
                                                 8,
                                                 imageWidth * sizeof(uint32_t),
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), [self CGImage]);
    
    //对每个像素点都做一次灰度转换.
    for(int deep = 0; deep < imageHeight; deep++) {
        
        for(int row = 0; row < imageWidth; row++) {
            //pixels为4个字节大小数组 将其索引值赋值给一个1个字节的大小的数组 所以0的位置为pixels第1个字节 1的位置为pixels第2个字节...
            uint8_t *rgbaPixel = (uint8_t *) &pixels[deep * imageWidth + row];
            
            /*
             灰度图片: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
             运算的转换参考:http://blog.csdn.net/xdrt81y/article/details/8289963
             彩色转灰度著名的心理学公式：Gray = R*0.299 + G*0.587 + B*0.114
             为了避免低速的浮点运算和除法,采用整数位移算法
             采用16位的精度
             0.299 * 65536 = 19595.264 ≈ 19595
             0.587 * 65536 + (0.264) = 38469.632 + 0.264 = 38469.896 ≈ 38469
             0.114 * 65536 + (0.896) =   7471.104 + 0.896 = 7472
             得到的结果是: Gray = (R*19595 + G*38469 + B*7472) >> 16
             所以2至20位以内的精度
             Gray = (R*1 + G*2 + B*1) >> 2
             Gray = (R*2 + G*5 + B*1) >> 3
             Gray = (R*4 + G*10 + B*2) >> 4
             Gray = (R*9 + G*19 + B*4) >> 5
             Gray = (R*19 + G*37 + B*8) >> 6
             Gray = (R*38 + G*75 + B*15) >> 7
             Gray = (R*76 + G*150 + B*30) >> 8
             Gray = (R*153 + G*300 + B*59) >> 9
             Gray = (R*306 + G*601 + B*117) >> 10
             Gray = (R*612 + G*1202 + B*234) >> 11
             Gray = (R*1224 + G*2405 + B*467) >> 12
             Gray = (R*2449 + G*4809 + B*934) >> 13
             Gray = (R*4898 + G*9618 + B*1868) >> 14
             Gray = (R*9797 + G*19235 + B*3736) >> 15
             Gray = (R*19595 + G*38469 + B*7472) >> 16
             Gray = (R*39190 + G*76939 + B*14943) >> 17
             Gray = (R*78381 + G*153878 + B*29885) >> 18
             Gray = (R*156762 + G*307757 + B*59769) >> 19
             Gray = (R*313524 + G*615514 + B*119538) >> 20
             上面3跟4,7跟8,10跟11,13跟14,19跟20,他们的精度是一样的.
             其实RGB里面都是使用8位的精度来标示一个色值,所以采用8的精度来表示,但7跟8又是一致的的精度,所以下面采用7位的精度来运算.
             */
            uint32_t gray = (rgbaPixel[JORGBAPixels.red]*38 +  rgbaPixel[JORGBAPixels.green] * 75 +  rgbaPixel[JORGBAPixels.blue] * 15 )>>7;
            //将pixels中代表RGB的字节数都替换成灰度值
            rgbaPixel[JORGBAPixels.red] = gray;
            rgbaPixel[JORGBAPixels.green] = gray;
            rgbaPixel[JORGBAPixels.blue] = gray;
        }
    }
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    //转换结束后释放申请的内存空间
    free(pixels);
    
    grayscaledImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
#endif
#endif
    
    return grayscaledImage;
}

- (UIImage *)joImageConvertedWithImageScale:(JOImageScale)imageScale {

    size_t imageWidth = (size_t)self.size.width;
    size_t imageHeight = (size_t)self.size.height;
    
    UIImage *scaledImage = nil;
    
    //为一个像素的RGBA值分配空间 4个字节的大小.
    uint32_t *pixels = (uint32_t *) malloc(imageWidth * imageHeight * sizeof(uint32_t));
    //指定填充一个固定的值,即清零
    memset(pixels, 0, imageWidth * imageHeight * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //创建位图的空间
    CGContextRef context = CGBitmapContextCreate(pixels,
                                                 imageWidth,
                                                 imageHeight,
                                                 8,
                                                 imageWidth * sizeof(uint32_t),
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), [self CGImage]);
    
    //对每个像素点都做一次灰度转换.
    for(int deep = 0; deep < imageHeight; deep++) {
        
        for(int row = 0; row < imageWidth; row++) {
            //pixels为4个字节大小数组 将其索引值赋值给一个1个字节的大小的数组 所以0的位置为pixels第1个字节 1的位置为pixels第2个字节...
            uint8_t *rgbaPixel = (uint8_t *) &pixels[deep * imageWidth + row];
            
            uint8_t r;
            uint8_t g;
            uint8_t b;
            
            switch (imageScale) {
                case JOImageGrayScale: {
                    //灰度
                    //Gray = R*0.299 + G*0.587 + B*0.114
                        uint8_t gray = (rgbaPixel[JORGBAPixels.red]*38 +  rgbaPixel[JORGBAPixels.green] * 75 +  rgbaPixel[JORGBAPixels.blue] * 15 )>>7;
                        r = g = b = gray;
                    }
                    break;
                case JOImageBlackWihteScale: {
                    //黑白
                    //(R+G+B)/3 与100做比较 低于100为置为0,高于100置为255.
                        uint8_t blackValue = (rgbaPixel[JORGBAPixels.red]*85 +  rgbaPixel[JORGBAPixels.green] * 85 +  rgbaPixel[JORGBAPixels.blue] * 86 )>>8;
                        (blackValue >= 100)?(blackValue = 255.):(blackValue = 0.);
                        r = g = b = blackValue;
                    }
                    break;
                case JOImageFilmScale: {
                    //底片胶卷
                    //R' = 255 – R; G' = 255 – G; B' = 255 – B;
                    r = 0xFF + (~rgbaPixel[JORGBAPixels.red] + 1);
                    g = 0xFF + (~rgbaPixel[JORGBAPixels.green] + 1);
                    b = 0xFF + (~rgbaPixel[JORGBAPixels.blue] + 1);
                    }
                    break;
                case JOImageEmbossScale: {
                    //浮雕
                    //下一个像素点与当前像素点的差值+128  最后灰度模式
                    //R' = nR - cr + 128
                    uint8_t *nextRgbaPixel;
                    if (row < imageWidth) {
                        //非每行最后一个像素点
                        nextRgbaPixel = (uint8_t *) &pixels[deep * imageWidth + row +1];
                    }else {
                        //每行最后一个像素点
                        nextRgbaPixel = (uint8_t *) &pixels[deep * imageWidth + row];
                    }
                    r =0x81 + nextRgbaPixel[JORGBAPixels.red] + (~rgbaPixel[JORGBAPixels.red]);//0x80
                    g =0x81 + nextRgbaPixel[JORGBAPixels.green] + (~rgbaPixel[JORGBAPixels.green]);
                    b =0x81 + nextRgbaPixel[JORGBAPixels.blue] + (~rgbaPixel[JORGBAPixels.blue]);
                    
                    uint8_t gray = (r*38 +  g * 75 +  b * 15 )>>7;
                    r = g = b = gray;
                    }
                    break;
                case JOImageBrownScale: {
                    //棕色的处理
                    //g' = g*0.6  b' = b*0.4
                    r = rgbaPixel[JORGBAPixels.red];
                    g = (rgbaPixel[JORGBAPixels.green] *153) >> 8;
                    b = (rgbaPixel[JORGBAPixels.blue] * 103) >> 8;
                    }
                    break;
                default:
                    break;
            }
            //将pixels中代表RGB的值替换成不同模式下面的值
            rgbaPixel[JORGBAPixels.red] = r;
            rgbaPixel[JORGBAPixels.green] = g;
            rgbaPixel[JORGBAPixels.blue] = b;
        }
    }
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    //转换结束后释放申请的内存空间
    free(pixels);
    
    scaledImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    return scaledImage;
}

- (UIImage *)joImageColorCubeFilterWithLUTImage:(UIImage *)lutImage dimension:(NSInteger)dimension {

    size_t lutImageWidth = (size_t)lutImage.size.width;
    size_t lutImageHeight = (size_t)lutImage.size.height;
    //每一个平面依次从左到右将像素点的坐标读入到相应的Data里面
    //每行多少个z的平面
    NSInteger rowNum = lutImageWidth/dimension;
    //每列多少个z平面
    NSInteger columnNum = lutImageHeight/dimension;
    //确保传进来的lutImage的图片大小是dimension个dimension*dimension的正方形
    if ((lutImageWidth % dimension != 0) || (lutImageHeight % dimension != 0) || rowNum*columnNum != dimension) {
        return nil;
    }
    
    uint32_t *pixels = (uint32_t *) malloc(lutImageWidth * lutImageHeight * sizeof(uint32_t));
    memset(pixels, 0, lutImageWidth * lutImageHeight * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //创建lut的位图的空间
    CGContextRef context = CGBitmapContextCreate(pixels,
                                                 lutImageWidth,
                                                 lutImageHeight,
                                                 8,
                                                 lutImageWidth * sizeof(uint32_t),
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, lutImageWidth, lutImageHeight), [lutImage CGImage]);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    uint32_t *newOrderPixels = (uint32_t *) malloc(dimension * dimension * dimension * sizeof(uint32_t));
    memset(newOrderPixels, 0, dimension * dimension * dimension * sizeof(uint32_t));
    
    
    //需要将lutImage里面每个像素点的颜色放到新的newOrderPixels数组中去:
    //规则是按多少条边的正方形为尺寸为依据,第一次放进的是第一个正方形的像素点的RGB的数据,从左到右,从上到下.正方形的也是从左到右,从上到下
    
    for (int deep = 0; deep < lutImageHeight; deep ++) {
        
        for (int column = 0; column < lutImageWidth; column ++) {
            
            uint8_t *rgbaPixel = (uint8_t *) &pixels[deep * lutImageWidth + column];
            
            uint8_t r = rgbaPixel[JORGBAPixels.red];
            uint8_t g = rgbaPixel[JORGBAPixels.green];
            uint8_t b = rgbaPixel[JORGBAPixels.blue];
            uint8_t a = rgbaPixel[JORGBAPixels.aplha];
            
            u_long newOrderPixelOffset = (deep /dimension) * dimension *dimension * columnNum   + (column / dimension) * dimension *dimension + (deep%dimension) * dimension + (column % dimension);
            
            uint8_t *rgbaPixelss = (uint8_t *) &newOrderPixels[newOrderPixelOffset];
            rgbaPixelss[JORGBAPixels.red] = r;
            rgbaPixelss[JORGBAPixels.green] = g;
            rgbaPixelss[JORGBAPixels.blue] = b;
            rgbaPixelss[JORGBAPixels.aplha] = a;
        }
    }
    
    free(pixels);
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorCube"];
    [filter setValue:[NSData dataWithBytesNoCopy:newOrderPixels length:dimension * dimension * dimension * sizeof(uint32_t) freeWhenDone:YES] forKey:@"inputCubeData"];
    [filter setValue:[NSNumber numberWithInteger:dimension] forKey:@"inputCubeDimension"];
    CIImage *inputImage = [[CIImage alloc] initWithImage: self];
    [filter setValue:inputImage forKey:@"inputImage"];
    CIContext *filterContext = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:(__bridge id)(CGColorSpaceCreateDeviceRGB()) forKey:kCIContextWorkingColorSpace]];
    
    //无须再次释放newOrderPixels 因为:dataWithBytesNoCopy:length:freeWhenDone已经释放掉了
    UIImage *newImage = [UIImage imageWithCGImage:[filterContext createCGImage:[filter outputImage] fromRect:inputImage.extent]];
    return newImage;
}

#pragma mark - image metaData

- (NSMutableDictionary *)joImageMetaDataInfo {

    NSData *imageData = UIImageJPEGRepresentation(self, 1.);
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    @JOExitExcute{
        CFRelease(imageSource);
    };
    if (!imageSource) {
        JOThrowException(@"-joImageMetaData exception!", @"获取imageSource失败.");
        return nil;
    }
    
    CFDictionaryRef imageCFMetaData = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
    
    if (imageCFMetaData) {
        NSMutableDictionary *imageMetaDataInfo = [NSMutableDictionary dictionaryWithDictionary:(__bridge NSDictionary *)imageCFMetaData];
        CFRelease(imageCFMetaData);
        return imageMetaDataInfo;
    }
    return nil;
}

- (NSData *)joImageResetMetaDataInfo:(NSMutableDictionary *)newMetaDataInfo compressionQuality:(CGFloat)compressionQuality {

    //获取这个图片的imageData compressionQuality计算传1转换后得到的imageData再转换成image都不会再是原图,因为这个UIImageJPEGRepresentation方法只是尽可能的去高质量的图片数据
    NSData *imageData = UIImageJPEGRepresentation(self, compressionQuality);
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    @JOExitExcute{
        CFRelease(imageSource);
    };
    if (!imageSource) {
        JOThrowException(@"-joImageResetMetaDataInfo:compressionQuality: exception!", @"获取imageSource失败.");
        return nil;
    }
    
    //获取图片的类型:public.jpeg  or  com.apple.icns
    CFStringRef UTI = CGImageSourceGetType(imageSource);
    NSMutableData *newImageData = [NSMutableData data];
    
    //重写image的metaData数据的过程
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)newImageData, UTI, 1, NULL);
    if (!destination) {
        JOThrowException(@"-joImageResetMetaDataInfo:compressionQuality: exception!", @"无法创建该图片的destination");
        return nil;
    }
    
    CGImageDestinationAddImageFromSource(destination, imageSource, 0, (__bridge CFDictionaryRef)newMetaDataInfo);
    BOOL success = CGImageDestinationFinalize(destination);
    if (!success) {
        JOThrowException(@"-joImageResetMetaDataInfo:compressionQuality: exception!", @"无法创建该图片的destination");
    }
    
    CFRelease(destination);
    return newImageData;
}

- (NSData *)joImageResetMetaDataInfoBlock:(JOImageMetaDataResetBlock)block {

    NSMutableDictionary *metaDataInfo = [self joImageMetaDataInfo];
    CGFloat quality = 1.;
    !block?:block(&metaDataInfo,&quality);
    return [self joImageResetMetaDataInfo:metaDataInfo compressionQuality:quality];
}

- (NSData *)joImageResetDate:(NSDate *)date compressionQuality:(CGFloat)compressionQuality {

    return [self joImageResetMetaDataInfoBlock:^(NSMutableDictionary *__autoreleasing *metaDataInfo, CGFloat *compressionQuality) {
        
                NSMutableDictionary *exifInfo = [[*metaDataInfo objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
                if(!exifInfo) {
                    exifInfo = [NSMutableDictionary dictionary];
                }
                [exifInfo setValue:JODateFormat(date, @"yyyy:MM:dd HH:mm:ss") forKey:(__bridge NSString *)kCGImagePropertyExifDateTimeOriginal];
                [exifInfo setValue:JODateFormat(date, @"yyyy:MM:dd HH:mm:ss") forKey:(__bridge NSString *)kCGImagePropertyExifDateTimeDigitized];
                [*metaDataInfo setObject:exifInfo forKey:(__bridge NSString *)kCGImagePropertyExifDictionary];
    }];
}

- (NSData *)joImageResetCoordinate:(CLLocationCoordinate2D)coordinate compressionQuality:(CGFloat)compressionQuality {

    return [self joImageResetMetaDataInfoBlock:^(NSMutableDictionary *__autoreleasing *metaDataInfo, CGFloat *compressionQuality) {
        
                NSMutableDictionary *gpsInfo = [[*metaDataInfo objectForKey:(NSString *)kCGImagePropertyGPSDictionary] mutableCopy];
                if(!gpsInfo) {
                    gpsInfo = [NSMutableDictionary dictionary];
                }
                [gpsInfo setValue:[NSNumber numberWithFloat:coordinate.latitude] forKey:(__bridge NSString *)kCGImagePropertyGPSLatitude];
                [gpsInfo setValue:[NSNumber numberWithFloat:coordinate.longitude] forKey:(__bridge NSString *)kCGImagePropertyGPSLongitude];
                [*metaDataInfo setObject:gpsInfo forKey:(__bridge NSString *)kCGImagePropertyGPSDictionary];
    }];
}

- (NSData *)joImageResetDate:(NSDate *)date resetCoordinate:(CLLocationCoordinate2D)coordinate compressionQuality:(CGFloat)compressionQuality {

    return [self joImageResetMetaDataInfoBlock:^(NSMutableDictionary *__autoreleasing *metaDataInfo, CGFloat *compressionQuality) {
        
        NSMutableDictionary *exifInfo = [[*metaDataInfo objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
        if(!exifInfo) {
            exifInfo = [NSMutableDictionary dictionary];
        }
        [exifInfo setValue:JODateFormat(date, @"yyyy:MM:dd HH:mm:ss") forKey:(__bridge NSString *)kCGImagePropertyExifDateTimeOriginal];
        [exifInfo setValue:JODateFormat(date, @"yyyy:MM:dd HH:mm:ss") forKey:(__bridge NSString *)kCGImagePropertyExifDateTimeDigitized];
        [*metaDataInfo setObject:exifInfo forKey:(__bridge NSString *)kCGImagePropertyExifDictionary];
        
        NSMutableDictionary *gpsInfo = [[*metaDataInfo objectForKey:(NSString *)kCGImagePropertyGPSDictionary] mutableCopy];
        if(!gpsInfo) {
            gpsInfo = [NSMutableDictionary dictionary];
        }
        [gpsInfo setValue:[NSNumber numberWithFloat:coordinate.latitude] forKey:(__bridge NSString *)kCGImagePropertyGPSLatitude];
        [gpsInfo setValue:[NSNumber numberWithFloat:coordinate.longitude] forKey:(__bridge NSString *)kCGImagePropertyGPSLongitude];
        [*metaDataInfo setObject:gpsInfo forKey:(__bridge NSString *)kCGImagePropertyGPSDictionary];
    }];
}


@end
