//
//  UIImage+JOExtend.h
//  JOProjectBaseSDK
//
//  Created by 刘维 on 16/6/23.
//  Copyright © 2016年 刘维. All rights reserved.
//

//DONE: 根据颜色生成单颜色的图片
//DONE: 生成圆角的图片
//TODO: 图片加水印图片跟文字
//TODO: 图片加水印文字
//TODO:

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger,JOImageScale) {
    
    JOImageGrayScale,           //灰度
    JOImageBlackWihteScale,     //黑白
    JOImageFilmScale,           //胶卷底片
    JOImageEmbossScale,         //浮雕
    JOImageBrownScale,          //棕色
};

/**
 重写image的metaData数据的block.

 @param metaDataInfo        图片原来的metaData的信息.
 @param compressionQuality  图片的压缩质量.
 */
typedef void(^JOImageMetaDataResetBlock) (NSMutableDictionary *__autoreleasing *metaDataInfo,CGFloat *compressionQuality);

@interface UIImage(JOExtend)

#pragma mark - Resize Image
/**
 取中间点的下一个点的像素图片根据具体情况去做复制填充图片.

 @return UIImage.
 */
- (UIImage *)joStretchableImage;
+ (UIImage *)joStretchableImageWithName:(NSString *)imageName;

/**
 根据给定点的像素图片依不同情况去做复制填充图片.

 @param capPoint 给定的坐标点.
 @return UIImage.
 */
- (UIImage *)joStretchableImageWithcapPoint:(CGPoint)capPoint;
+ (UIImage *)joStretchableImageWithName:(NSString *)imageName capPoint:(CGPoint)capPoint;

/**
 平铺显示的图片. capInsets默认为 {0,0,0,0,}

 @return UIImage.
 */
- (UIImage *)joResizeImageTile;
+ (UIImage *)joResizeImageTileWithName:(NSString *)imageName;

/**
 根据不同情况重新设置图片大小.

 @param imageName   图片的大小.
 @param capInsets   不失真的区域.由其构成的四个角为不失真的区域,即不受变化的影响.
 @param model       重新设置的类型:平铺,拉伸.
 @return UIImage.
 */
+ (UIImage *)joResizeImageWithName:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets mode:(UIImageResizingMode)model;

#pragma mark - color image

/**
 生成指定大小的单色图片.默认大小为size(1,1)大小.

 @param color   颜色.
 @param size    大小.
 @return UIImage.
 */
+ (UIImage *)joImageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)joImageWithColor:(UIColor *)color;

#pragma mark - rounded image

/**
 将图片转换成指定大小跟圆角的图片.

 @param image   图片.
 @param size    指定的大小. 未指定则使用image的size.
 @param radius  圆角.
 @return UIImage.
 */
+ (UIImage *)joRoundedImage:(UIImage *)image size:(CGSize )size cornerRadius:(CGFloat)radius;
+ (UIImage *)joRoundedImage:(UIImage *)image cornerRadius:(CGFloat)radius;

#pragma mark - draw text or image at image

/**
 在image上面drawn文字.

 @param text 文字.
 @param point 指定drawn的坐标.
 @param color 文字的颜色.
 @param font 文字的字体.
 @return UIImage.
 */
- (UIImage *)joImageDrawnText:(NSString *)text atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font;
+ (UIImage *)joImageDrawnTextWithName:(NSString *)imageName drawnText:(NSString *)text atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font;

/**
 在image上面drawn一个image.

 @param image drawn的image.
 @param rect 指定的区域.
 @return UIImage.
 */
- (UIImage *)joImageDrawnImage:(UIImage *)image inRect:(CGRect)rect;
+ (UIImage *)joImageDrawnImageWithName:(NSString *)imageName drawnImage:(UIImage *)image inRect:(CGRect)rect;

#pragma mark - image operation

/**
 旋转图片的角度.

 @param degrees 旋转的角度(非弧度).
 @param angle   旋转的角度(弧度).
 @return UIImage.
 */
- (UIImage *)joImageRotatedWithDegrees:(CGFloat)degrees;
- (UIImage *)joImageRotatedWithAngle:(CGFloat)angle;

/**
 生成指定模式类型的图片

 @param imageScale JOImageScale
 @return UIImage
 */
- (UIImage *)joImageConvertedWithImageScale:(JOImageScale)imageScale;
- (UIImage *)joImageConvertToGrayScale DEPRECATED_MSG_ATTRIBUTE("请使用-joImageConvertedWithImageScale:");

- (UIImage *)joImageColorCubeFilterWithLUTImage:(UIImage *)lutImage dimension:(NSInteger)dimension;

#pragma mark - image metaData

/*
 不要尝试将修改后的元数据转换成图片,然后再次读取他的元数据,你会发现元数据根本未修改,
 因为UIImage貌似会丢弃这些信息,正确的做法应该是将这个得到的Data写入一个文件中,
 使用的时候读取出来这个data转换成ImageSource去查看,不过你可以可以直接将这个data传给服务器.
 */

/**
 获取图片的元数据信息.

 @return NSMutableDictionary.
 */
- (NSMutableDictionary *)joImageMetaDataInfo;

/**
 重新修改图片的元数据.
 建议使用-joImageResetMetaDataInfoBlock去修改.

 @param newMetaDataInfo 这个必须是完整的元数据信息.即在-joImageMetaDataInfo里面获得完整的信息再去添加新的元数据信息.
 @param compressionQuality 图片压缩的质量.
 @return NSData.
 */
- (NSData *)joImageResetMetaDataInfo:(NSMutableDictionary *)newMetaDataInfo compressionQuality:(CGFloat)compressionQuality;

/**
 重新修改图片的元数据.
 用法(以修改时间为例):
 //完整的key值可以查阅头文件 CGImageProperties.h 获取
 //更多相关信息查阅:http://www.cppblog.com/lymons/archive/2010/02/23/108266.aspx#APP2
 e.g:
 [self joImageResetMetaDataInfoBlock:^(NSMutableDictionary *__autoreleasing *metaDataInfo, CGFloat *compressionQuality) {
 
     NSMutableDictionary *exifInfo = [[*metaDataInfo objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
     if(!exifInfo) {
     exifInfo = [NSMutableDictionary dictionary];
     }
     [exifInfo setValue:JODateFormat(date, @"yyyy:MM:dd HH:mm:ss") forKey:(__bridge NSString *)kCGImagePropertyExifDateTimeOriginal];
     [exifInfo setValue:JODateFormat(date, @"yyyy:MM:dd HH:mm:ss") forKey:(__bridge NSString *)kCGImagePropertyExifDateTimeDigitized];
     [*metaDataInfo setObject:exifInfo forKey:(__bridge NSString *)kCGImagePropertyExifDictionary];
 
     //还能修改图片的压缩质量(默认为1.0):
     *compressionQuality = 0.5;
 }];

 @param block JOImageMetaDataResetBlock.
 @return NSData.
 */
- (NSData *)joImageResetMetaDataInfoBlock:(JOImageMetaDataResetBlock)block;


/**
 修改元数据的exif的时间,经纬度等信息.

 @param date                时间.(注意date转换后的格式必须是yyyy:MM:dd HH:mm:ss 其他格式将会写入失败,如果你自己尝试写的话).
 @param coordinate          经纬度.
 @param compressionQuality  图片的压缩质量.
 @return NSData.
 */
- (NSData *)joImageResetDate:(NSDate *)date compressionQuality:(CGFloat)compressionQuality;
- (NSData *)joImageResetCoordinate:(CLLocationCoordinate2D)coordinate compressionQuality:(CGFloat)compressionQuality;
- (NSData *)joImageResetDate:(NSDate *)date resetCoordinate:(CLLocationCoordinate2D)coordinate compressionQuality:(CGFloat)compressionQuality;

@end
