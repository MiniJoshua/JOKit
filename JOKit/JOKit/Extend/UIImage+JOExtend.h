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

/**
 图片的样式.
 */
typedef NS_ENUM(NSUInteger,JOImageScale) {
    
    JOImageGrayScale,           //灰度
    JOImageBlackWihteScale,     //黑白
    JOImageFilmScale,           //胶卷底片
    JOImageEmbossScale,         //浮雕
    JOImageBrownScale,          //棕色
};

/**
 重写image的metaData数据的block.

 @param metaDataInfo        图片原来的metaData的信息的指针.
 @param compressionQuality  图片的压缩质量指针.
 */
typedef void(^JOImageMetaDataResetBlock) (NSMutableDictionary *__autoreleasing *metaDataInfo,CGFloat *compressionQuality);

/**
 给image做滤镜操作的Block.

 @param filter  filter的指针.
 @param context context的指针
 */
typedef void(^JOImageFilterHandler) (CIFilter *__autoreleasing *filter, CIContext *__autoreleasing *context);

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

 @param text    文字.
 @param point   指定drawn的坐标.
 @param color   文字的颜色.
 @param font    文字的字体.
 @return UIImage.
 */
- (UIImage *)joImageDrawnText:(NSString *)text atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font;
+ (UIImage *)joImageDrawnTextWithName:(NSString *)imageName drawnText:(NSString *)text atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font;

/**
 在image上面drawn一个image.

 @param image   drawn的image.
 @param rect    指定的区域.
 @return UIImage.
 */
- (UIImage *)joImageDrawnImage:(UIImage *)image inRect:(CGRect)rect;
+ (UIImage *)joImageDrawnImageWithName:(NSString *)imageName drawnImage:(UIImage *)image inRect:(CGRect)rect;

#pragma mark - image operation

/**
 翻转图片.

 @param horizontal 水平翻转.
 @param vertical 竖直翻转.
 @return 翻转后的图片.
 */
- (UIImage *)joImageFlipHorizontal:(BOOL)horizontal vertical:(BOOL)vertical;
- (UIImage *)joImageRotatePI;                                                   //旋转180度(PI), 即horizontal =YES vertical = YES
- (UIImage *)joImageFlipHorizontal;                                             //水平翻转
- (UIImage *)joImageFlipVertical;                                               //竖直翻转

/**
 旋转图片的角度.

 @param degrees 旋转的角度(非弧度).
 @param angle   旋转的角度(弧度).
 @return UIImage.
 */
- (UIImage *)joImageRotatedWithDegrees:(CGFloat)degrees fitState:(BOOL)state;
- (UIImage *)joImageRotatedWithAngle:(CGFloat)angle fitState:(BOOL)state;

/**
 生成指定模式类型的图片

 @param imageScale JOImageScale
 @return UIImage
 */
- (UIImage *)joImageConvertedWithImageScale:(JOImageScale)imageScale;
- (UIImage *)joImageConvertToGrayScale DEPRECATED_MSG_ATTRIBUTE("请使用-joImageConvertedWithImageScale:");

#pragma mark - image filter

/*
 如果滤镜的计算不是在GPU而是在CPU的话,最好的实现方式应该把滤镜计算的方法放到一个单独的线程中去做,等他处理完再通知主线程更新界面.
 e.g:
     UIImage *images = [UIImage imageNamed:@"sunflower.jpg"];
    //开启了一个golbal线程去处理这个滤镜的计算
     JODispatch_global_async(DISPATCH_QUEUE_PRIORITY_DEFAULT, ^{
     
    //滤镜的处理
     UIImage *filterImage = [images joImageColorCubeFilterWithLUTImage:[UIImage imageNamed:@"colorLUTProcessed.png"] dimension:64];
    //处理完得到新的滤镜的image在通过主线程去更新界面
     JODispatchMainQueue_async(^{
     [imageView setImage:filterImage];
     });
     });
 */

/**
 根据提供的colorLut图生成新的image.
 具体的解释请查看:https://joshuadev.wordpress.com/2016/12/13/cifilte-zhicicolorcube/

 @param lutImage    用来做颜色映射表的图片.
 @param dimension   边数.
 @return UIImage
 */
- (UIImage *)joImageColorCubeFilterWithLUTImage:(UIImage *)lutImage dimension:(NSInteger)dimension;

/**
 根据提供的filter生成新的滤镜图片.
 使用:
 UIImage *image = [UIImage imageNamed:@"***.jpg"];
 UIImage *filterImage = [image joImageWithFliterHandler:^(CIFilter *__autoreleasing *filter, CIContext *__autoreleasing *context) {
 
 //在这个Block里面设置滤镜filter的属性.
 //不需要设置kCIInputImageKey的属性,因为后面会自动添加.
 //context可以在这生成一个,若不设置则默认为[CIContext context].
 *filter = [CIFilter filterWithName:@"CIColorCube"];
 [*filter setValue:[NSData dataWithBytesNoCopy:newOrderPixels length:dimension * dimension * dimension * sizeof(uint32_t) freeWhenDone:YES] forKey:@"inputCubeData"];
 [*filter setValue:[NSNumber numberWithInteger:dimension] forKey:@"inputCubeDimension"];
 *context = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:(__bridge id)(CGColorSpaceCreateDeviceRGB()) forKey:kCIContextWorkingColorSpace]];
 }];

 @param handler JOImageFilterHandler
 @return UIImage.
 */
- (UIImage *)joImageWithFliterHandler:(JOImageFilterHandler)handler;

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

 @param date                时间.(如果你自己尝试写入的话,需要注意date转换后的格式必须是yyyy:MM:dd HH:mm:ss 其他格式将会写入失败).
 @param coordinate          经纬度.
 @param compressionQuality  图片的压缩质量.
 @return NSData.
 */
- (NSData *)joImageResetDate:(NSDate *)date compressionQuality:(CGFloat)compressionQuality;
- (NSData *)joImageResetCoordinate:(CLLocationCoordinate2D)coordinate compressionQuality:(CGFloat)compressionQuality;
- (NSData *)joImageResetDate:(NSDate *)date resetCoordinate:(CLLocationCoordinate2D)coordinate compressionQuality:(CGFloat)compressionQuality;

#pragma mark - image load async

/**
 异步加载一个图片.

 @param urlString   图片的地址.
 @param block       图片加载完成的Block,success的参数表示加载成功与否.
 */
+ (void)joImageLoadURLString:(NSString *)urlString completeBlock:(void(^)(UIImage *image ,BOOL success))block;

#pragma mark - image thumbnail

/**
 图片的缩略图.

 @param size 缩略图的大小.会用size里面的最大值与图片的长宽比例 得到最终缩略图的大小.
 如果图片的比例是 1：1 传入的size大小为(30，50) 则返回的大小是 50*50的.
 如果图片大小比例是1：2 传入size大小为(30,50)  则返回缩略图的大小是 25*50的大小
 
 @return 缩略图.
 */
- (UIImage *)joImageThumbnailWithSize:(CGSize)size;

/**
 网络图片的缩略图.

 @param urlString   图片的URL地址.
 @param size        缩略图的大小.
 @param handler     完成的block的回调. success为取得缩略图的状态.
 */
+ (void)joImageThumbnailWithImageURLString:(NSString *)urlString
                             thumbnailSize:(CGSize)size
                           completeHandler:(void(^)(UIImage *thumbnailImage,BOOL success))handler;

#pragma mark - image blur

/**
 图片的模糊效果.

 @param radius      模糊的半径.
 @param iterations  模糊的次数.
 @param tintColor   模糊之后的图片与该颜色做一个混合.
 @return UIImage
 */
- (UIImage *)joImageblurredWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

#pragma mark - image MIME

/**
 获取图片的MIMEType的类型

 @return MIMEType类型
 */
- (NSString *)joImageMIMEType;

/**
 根据imageData获取MIMEType类型

 @param imageData imageData.
 @return MIMEType类型
 */
+ (NSString *)joImageMIMETypeWithImageData:(NSData *)imageData;

#pragma mark - image gif



@end
