//
//  UIImage+Additions.swift
//
//  Created by lichangan on 2017/9/7.
//  Copyright © 2017年 Beijing Dayi Alliance Health Management Co., Ltd. All rights reserved.
//

import UIKit
import CoreGraphics
import Accelerate

public extension UIImage {
    //MARK:圆形图片 borderWidth默认为nil borderColor默认为nil
    public func lca_roundImage(borderColor:UIColor? = nil,borderWidth:CGFloat? = nil)->UIImage {
        //1.开启一个比图片稍微大一点的图形上下文
        let margin = borderWidth ?? 0
        let ctxSize = CGSize(width: size.width + margin*2, height: size.height + margin*2)
        UIGraphicsBeginImageContextWithOptions(ctxSize, false, 0)
        let bigPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: ctxSize.width, height: ctxSize.height))
        borderColor?.set()
        bigPath.fill()
        
        let clipPath = UIBezierPath(ovalIn: CGRect(x: margin, y: margin, width: size.width, height: size.height))
        clipPath.addClip()
        
        draw(at: CGPoint(x: margin, y: margin))
        let roundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundImage!
    }
    
    //MARK:给图片设置圆角 默认border = 0 borderColor = nil corners:设置圆角的位置 [.topLeft,.topRight] 或者
   public func lca_roundCorner(radius:CGFloat,borderWidth:CGFloat = 0,borderColor:UIColor? = nil,borderLineJoin:CGLineJoin = .miter,corners:UIRectCorner)->UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        context!.scaleBy(x: 1, y: -1)
        context!.translateBy(x: 0, y: -rect.size.height)
        
        let minSize = min(size.width, size.height)
        if borderWidth < minSize/2 {
            
            let path = UIBezierPath(roundedRect:rect.insetBy(dx: borderWidth, dy: borderWidth), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: borderWidth))
            path.close()
            
            context?.saveGState()
            path.addClip()
            context?.draw(cgImage!, in: rect)
            context?.restoreGState()
        }
        
        if (borderColor != nil)&&(borderWidth < minSize / 2) && (borderWidth > 0) && (borderWidth > 0){
            let strokeInset = floor((borderWidth * scale) + 0.5) / scale
            let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
            let strokeRadius = radius > scale/2 ? (radius - scale/2) : 0
            let path = UIBezierPath(roundedRect: strokeRect, byRoundingCorners: corners, cornerRadii: CGSize(width: strokeRadius, height: borderWidth))
            path.close()
            
            path.lineWidth = borderWidth
            path.lineJoinStyle = borderLineJoin
            borderColor!.setStroke()
            path.stroke()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    //MARK:通过给定颜色生成一张1*1point的图片
   public class func lca_drawOnePointImage(color:UIColor)->UIImage {
        return lca_drawImage(color: color, size: CGSize(width:1,height:1))!
    }
    //MARK:通过给定颜色生成一张size的图片
   public class func lca_drawImage(color:UIColor,size:CGSize)->UIImage?{
        if size.width <= 0 || size.height <= 0 {return nil}
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    //MARK:调整图片方向
   public func lca_fixOrientation()->UIImage{
        //如果方向没有旋转直接返回
        if imageOrientation == .up {
            return self
        }
        var transform = CGAffineTransform.identity
        switch imageOrientation {
        case .down:
            fallthrough
        case .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: -CGFloat(Double.pi/2))
            break
        case .left:
            fallthrough
        case .right:
            fallthrough
        case .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -CGFloat(Double.pi/2))
            break
        default:
            break
        }
        
        switch imageOrientation {
        case .upMirrored:
            fallthrough
        case .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored:
            fallthrough
        case .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        default:
            break
        }
        
        let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0, space: cgImage!.colorSpace!, bitmapInfo: cgImage!.bitmapInfo.rawValue)
        ctx!.concatenate(transform)
        
        switch imageOrientation {
        case .left:
            fallthrough
        case .leftMirrored:
            fallthrough
        case .right:
            fallthrough
        case .rightMirrored:
            ctx?.draw(self.cgImage!, in:CGRect(x: 0, y: 0, width: size.height, height:size.width))
        default:
            ctx?.draw(self.cgImage!, in:CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        let cgImg = ctx!.makeImage()
        let image = UIImage(cgImage: cgImg!)
        
        return image
    }
    
    /**
     渲染图片的颜色
     
     - parameter image:     图片
     - parameter maskColor: 颜色
     
     - returns: 返回指定颜色的图片
     */
    //MARK:渲染图片的颜色
    public class func lca_imageMasked(_ image:UIImage,maskColor:UIColor)->UIImage{
        
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.translateBy(x: 0.0, y: -(imageRect.size.height))
        
        context?.clip(to: imageRect, mask: image.cgImage!)
        context?.setFillColor(maskColor.cgColor)
        context?.fill(imageRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImage!
    }
    //MARK:在指定区域绘制图片,需要在drawRect方法中调用
    /**
     Draws the entire image in the specified rectangle, content changed with
     the contentMode.
     
     @discussion This method draws the entire image in the current graphics context,
     respecting the image's orientation setting. In the default coordinate system,
     images are situated down and to the right of the origin of the specified
     rectangle. This method respects any transforms applied to the current graphics
     context, however.
     
     @param rect        The rectangle in which to draw the image.
     
     @param contentMode Draw content mode
     
     @param clips       A Boolean value that determines whether content are confined to the rect.
     */
   public func lca_drawIn(rect:CGRect,contentMode:UIViewContentMode,clipsToBounds:Bool){
        let drawRect = lca_fit(rect: rect, size: size, mode: contentMode)
        print(drawRect)
        if drawRect.size.width == 0 || drawRect.size.height == 0 {return}
        if clipsToBounds == true {
            let context = UIGraphicsGetCurrentContext()
            if (context != nil) {
                context?.saveGState()
                context?.addRect(rect)
                context?.clip()
                draw(in: drawRect)
                context?.restoreGState()
            }else {
                print("请先创建上下文或者在drawRect方法中调用")
            }
        }else {
            draw(in: drawRect)
        }
    }
    
    //MARK:缩放图片到指定大小
   public func lca_resize(size:CGSize)->UIImage? {
        if size.width <= 0 || size.height <= 0 {return nil}
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    //MARK:裁切图片
   public func lca_crop(rect:CGRect)->UIImage? {
        var tmpRect = rect
        tmpRect.origin.x *= scale
        tmpRect.origin.y *= scale
        tmpRect.size.width *= scale
        tmpRect.size.height *= scale
        
        if tmpRect.size.width <= 0 || tmpRect.size.height <= 0 {return nil}
        guard let imageRef = cgImage!.cropping(to: tmpRect)else {
            return nil
        }
        let image = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
        return image
    }
    //MARK:给图片加border
   public func lca_inset(insets:UIEdgeInsets,color:UIColor)->UIImage? {
        var tmpSize = size
        tmpSize.width -= insets.left + insets.right
        tmpSize.height -= insets.top + insets.bottom
        if tmpSize.width <= 0 || tmpSize.height <= 0 {return nil}
        let rect = CGRect(x: -insets.left, y: -insets.top, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(tmpSize, false, scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: tmpSize.width, height: tmpSize.height))
        path.addRect(rect)
        context?.addPath(path)
        context?.fillPath(using: .evenOdd)
        
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    //MARK:向左旋转90
   public func lca_rotateLeft90()->UIImage? {
        return lca_rorate(radians:  lca_degreesToRadians(degrees: 90), fitSize: true)
    }
    //MARK:向右旋转90
   public func lca_rotateRight90()->UIImage? {
        return lca_rorate(radians:  lca_degreesToRadians(degrees: -90), fitSize: true)
    }
    //MARK:旋转180
   public func lca_rotate180()->UIImage? {
        return lca_flip(horizontal: true, vertical: true)
    }
    //MARK:水平旋转
   public func lca_flipHorizontal()->UIImage? {
        return lca_flip(horizontal: true, vertical: false)
    }
    //MARK:垂直旋转
   public func lca_flipVertical()->UIImage? {
        return lca_flip(horizontal: false, vertical: true)
    }
    //MARK:旋转 水平或者垂直
   public func lca_flip(horizontal:Bool,vertical:Bool)->UIImage?{
        if cgImage == nil {
            return nil
        }
        let width = cgImage!.width
        let height = cgImage!.height
        let bytesPerRow = width * 4
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: Int(bytesPerRow), space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        if context == nil {
            return nil
        }
        
        context?.draw(cgImage!, in:  CGRect(x: 0, y: 0, width: width, height: height))
        let data = context!.data
        if data == nil {
            return nil
        }
        var src = vImage_Buffer(data: data, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: bytesPerRow)
        var dest = vImage_Buffer(data: data, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: bytesPerRow)
        if vertical {
            vImageVerticalReflect_ARGB8888(&src, &dest, vImage_Flags(kvImageBackgroundColorFill))
        }
        if horizontal {
            vImageHorizontalReflect_ARGB8888(&src, &dest, vImage_Flags(kvImageBackgroundColorFill))
        }
        
        let imgRef = context!.makeImage()
        let img = UIImage(cgImage: imgRef!, scale: scale, orientation: imageOrientation)
        return img
    }
    
    //MARK:旋转图片
    /**
     Returns a new rotated image (relative to the center).
     
     @param radians   Rotated radians in counterclockwise.⟲
     
     @param fitSize   YES: new image's size is extend to fit all content.
     NO: image's size will not change, content may be clipped.
     */
   public func lca_rorate(radians:CGFloat,fitSize:Bool)->UIImage?{
        let width = cgImage!.width
        let height = cgImage!.height
        
        let newRect = CGRect(x: 0, y: 0, width: width, height: height).applying( fitSize ? CGAffineTransform(rotationAngle: radians) : CGAffineTransform.identity)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: Int(newRect.size.width * CGFloat(4)), space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        if context == nil {
            return nil
        }
        
        context?.setShouldAntialias(true)
        context?.setAllowsAntialiasing(true)
        context?.interpolationQuality = CGInterpolationQuality.high
        
        context?.translateBy(x: newRect.size.width * 0.5, y: newRect.size.height * 0.5)
        context?.rotate(by: radians)
        
        context?.draw(cgImage!, in: CGRect(x: -Double(width)*0.5, y: -Double(height)*0.5, width: Double(width), height: Double(height)))
        
        let imgRef = context!.makeImage()
        let img = UIImage(cgImage: imgRef!, scale: scale, orientation: imageOrientation)
        
        return img
    }
    
   public func lca_fit(rect:CGRect,size:CGSize,mode:UIViewContentMode)->CGRect{
        var tmpRect = rect.standardized
        var tmpSize = size
        tmpSize.width = tmpSize.width < 0 ? -tmpSize.width : tmpSize.width
        tmpSize.height = tmpSize.height < 0 ? -tmpSize.height : tmpSize.height
        
        let center = CGPoint(x: tmpRect.midX, y: tmpRect.midY)
        switch mode {
        case .scaleAspectFit:
            fallthrough
        case .scaleAspectFill:
            if tmpRect.size.width < 0.01 || tmpRect.size.height < 0.01 || tmpSize.width < 0.01 || tmpSize.height < 0.01 {
                tmpRect.origin = center
                tmpRect.size = .zero
            }else {
                var scale:CGFloat = 0
                if mode == .scaleAspectFit {
                    if tmpSize.width / tmpSize.height < tmpRect.size.width / tmpRect.size.height {
                        scale = tmpRect.size.height / tmpSize.height
                    }else {
                        scale = tmpRect.size.width / tmpSize.width
                    }
                }else {
                    if tmpSize.width / tmpSize.height < tmpRect.size.width / tmpRect.size.height {
                        scale = tmpRect.size.width / tmpSize.width
                    }else{
                        scale = tmpRect.size.height / tmpSize.height
                    }
                }
                tmpSize.width *= scale
                tmpSize.height *= scale
                tmpRect.size = tmpSize
                tmpRect.origin = CGPoint(x:center.x - tmpSize.width * 0.5,y:center.y - tmpSize.height * 0.5)
            }
        case .center:
            tmpRect.size = tmpSize
            tmpRect.origin = CGPoint(x:center.x - tmpSize.width * 0.5,y:center.y - tmpSize.height * 0.5)
        case .top:
            tmpRect.origin.x = center.x - tmpSize.width * 0.5
            tmpRect.size = tmpSize
        case .bottom:
            tmpRect.origin.x = center.x - tmpSize.width * 0.5
            tmpRect.origin.y += tmpRect.size.height - tmpSize.height
            tmpRect.size = tmpSize
        case .left:
            tmpRect.origin.y = center.y - tmpSize.height * 0.5
            tmpRect.size = tmpSize
        case .right:
            tmpRect.origin.y = center.y - tmpSize.height * 0.5
            tmpRect.origin.x += tmpRect.size.width - tmpSize.width
            tmpRect.size = tmpSize
        case .topLeft:
            tmpRect.size = tmpSize
        case .topRight:
            tmpRect.origin.x += tmpRect.size.width - tmpSize.width
            tmpRect.size = tmpSize
        case .bottomLeft:
            tmpRect.origin.y += tmpRect.size.height - tmpSize.height
            tmpRect.size = tmpSize
        case .bottomRight:
            tmpRect.origin.x += tmpRect.size.width - tmpSize.width
            tmpRect.origin.y += tmpRect.size.height - tmpSize.height
            tmpRect.size = tmpSize
        case .scaleToFill:
            fallthrough
        case .redraw:
            fallthrough
        default: break
        }
        
        return tmpRect
    }
    
    //MARK: 度转弧度
   public func lca_degreesToRadians(degrees:CGFloat)->CGFloat {
        return degrees * CGFloat(Double.pi) / 180
    }
    //MARK:弧度转度
   public func lca_radiansToDegrees(radians:CGFloat)->CGFloat {
        return radians * 180 / CGFloat(Double.pi)
    }
    
}

//MARK:图片压缩
public extension UIImage {
    // 图片回调代理
   public typealias ImageBlock = (_ image:UIImage) -> Void
   public typealias ImageDataBlock = (_ image:Data) -> Void
    
    /**
     压缩图片
     - parameter image:      需要压缩的图片
     - parameter imageBytes: 压缩的大小
     - parameter block:      压缩后的回调
     */
    //MARK:压缩图片
   public class func lca_compressedImageFiles(_ image:UIImage!, maxSize:Int = 30,size:CGSize = CGSize(width: 1024, height: 1024), completion:@escaping ImageBlock){
        compress(image, maxSize: maxSize) { (imageData) in
            let image = UIImage(data: imageData)!
            completion(image)
        }
    }
    
    //MARK:压缩到指定大小
   public class func lca_compressWithSpesicSize(_ image:UIImage!, maxSize:Int,size:CGSize = CGSize(width: 1024, height: 1024),completion:@escaping ImageDataBlock) {
        DispatchQueue.global().async {
            //先判断当前质量是否满足要求，不满足再进行压缩
            var finallImageData = UIImageJPEGRepresentation(image,1.0)
            let sizeOrigin      = finallImageData?.count
            let sizeOriginKB    = sizeOrigin! / 1024
            if sizeOriginKB <= maxSize {
                DispatchQueue.main.async {
                    completion(finallImageData!)
                    return
                }
                return
            }
            var defaultSize = size
            //先调整分辨率
            let newImage = self.newSizeImage(size: defaultSize, source_image: image)
            
            finallImageData = UIImageJPEGRepresentation(newImage,1.0);
            
            //保存压缩系数
            let compressionQualityArr = NSMutableArray()
            let avg = CGFloat(1.0/250)
            var value = avg
            
            var i = 250
            repeat {
                i -= 1
                value = CGFloat(i)*avg
                compressionQualityArr.add(value)
            } while i >= 1
            
            
            /*
             调整大小
             说明：压缩系数数组compressionQualityArr是从大到小存储。
             */
            //思路：使用二分法搜索
            finallImageData = self.halfFuntion(arr: compressionQualityArr.copy() as! [CGFloat], image: newImage, sourceData: finallImageData!, maxSize: maxSize)
            //如果还是未能压缩到指定大小，则进行降分辨率
            while (finallImageData?.count ?? 0)/1024 > maxSize {
                //每次降100分辨率
                if defaultSize.width-100 <= 0 || defaultSize.height-100 <= 0 {
                    break
                }
                defaultSize = CGSize(width: defaultSize.width-100, height: defaultSize.height-100)
                let image = self.newSizeImage(size: defaultSize, source_image: UIImage.init(data: UIImageJPEGRepresentation(newImage, compressionQualityArr.lastObject as! CGFloat)!)!)
                finallImageData = self.halfFuntion(arr: compressionQualityArr.copy() as! [CGFloat], image: image, sourceData: UIImageJPEGRepresentation(image,1.0)!, maxSize: maxSize)
            }
            
            DispatchQueue.main.async {
                completion(finallImageData!)
                return
            }
        }
    }
    
    //MARK:大于maxSize的都进行压缩
   public class func compress(_ image:UIImage!, maxSize:Int, completion:@escaping ImageDataBlock) {
        DispatchQueue.global().async {
            //先判断当前质量是否满足要求，不满足再进行压缩
            var finallImageData = UIImageJPEGRepresentation(image,1.0)
            let sizeOrigin = finallImageData?.count
            let sizeOriginKB = sizeOrigin! / 1024
            finallImageData = UIImageJPEGRepresentation(image,1.0);
            //保存压缩系数
            let compressionQualityArr = NSMutableArray()
            let avg = CGFloat(1.0/250)
            var value = avg
            var i = 250
            repeat {
                i -= 1
                value = CGFloat(i)*avg
                compressionQualityArr.add(value)
            } while i >= 1
            
            /*
             调整大小
             说明：压缩系数数组compressionQualityArr是从大到小存储。
             */
            if sizeOriginKB <= maxSize {
                if  image.size.width > UIScreen.main.bounds.size.width*UIScreen.main.scale {
                    var defaultSize = CGSize(width: 1242, height: 2208)
                    if UIScreen.main.bounds.size.width*UIScreen.main.scale > 1242 {
                        defaultSize = CGSize(width: UIScreen.main.bounds.size.width*UIScreen.main.scale, height: UIScreen.main.bounds.size.height*UIScreen.main.scale)
                    }
                    let newImage = self.newSizeImage(size: defaultSize, source_image: UIImage.init(data: UIImageJPEGRepresentation(image, compressionQualityArr.lastObject as! CGFloat)!)!)
                    finallImageData = UIImagePNGRepresentation(newImage)
                }
                DispatchQueue.main.async {
                    completion(finallImageData!)
                    return
                }
                return
            }
            // 1242 2208 plus的分辨率 图片的分辨率太大没有用处
            var defaultSize = CGSize(width: 1242, height: 2208)
            if UIScreen.main.bounds.size.width*UIScreen.main.scale > 1242 {
                defaultSize = CGSize(width: UIScreen.main.bounds.size.width*UIScreen.main.scale, height: UIScreen.main.bounds.size.height*UIScreen.main.scale)
            }
            let newImage = self.newSizeImage(size: defaultSize, source_image: UIImage.init(data: UIImageJPEGRepresentation(image, compressionQualityArr.lastObject as! CGFloat)!)!)
            let data = UIImagePNGRepresentation(newImage)
            finallImageData = self.halfFuntion(arr: compressionQualityArr.copy() as! [CGFloat], image: image, sourceData: data!, maxSize: maxSize)
            DispatchQueue.main.async {
                completion(finallImageData!)
                return
            }
        }
    }
    
    // MARK: - 调整图片分辨率/尺寸（等比例缩放）
    //图片加载到iOS内存后是基本以原生形式保存的，也就是长*宽*4个字节（RGBA），因此分辨率很大的图片会占用相当大的内存
   public class func newSizeImage(size: CGSize, source_image: UIImage) -> UIImage {
        var newSize = CGSize(width: source_image.size.width, height: source_image.size.height)
        let tempHeight = newSize.height / size.height
        let tempWidth = newSize.width / size.width
        
        if tempWidth > 1.0 && tempWidth > tempHeight {
            newSize = CGSize(width: source_image.size.width / tempWidth, height: source_image.size.height / tempWidth)
        } else if tempHeight > 1.0 && tempWidth < tempHeight {
            newSize = CGSize(width: source_image.size.width / tempHeight, height: source_image.size.height / tempHeight)
        }
        
        UIGraphicsBeginImageContext(newSize)
        source_image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    // MARK: - 二分法
   public class func halfFuntion(arr: [CGFloat], image: UIImage, sourceData finallImageData: Data, maxSize: Int) -> Data? {
        var tempFinallImageData = finallImageData
        
        var tempData = Data.init()
        var start = 0
        var end = arr.count - 1
        var index = 0
        
        var difference = Int.max
        while start <= end {
            index = start + (end - start)/2
            
            tempFinallImageData = UIImageJPEGRepresentation(image, arr[index])!
            
            let sizeOrigin = tempFinallImageData.count
            let sizeOriginKB = sizeOrigin / 1024
            
            if sizeOriginKB > maxSize {
                start = index + 1
            } else if sizeOriginKB < maxSize {
                if maxSize-sizeOriginKB < difference {
                    difference = maxSize-sizeOriginKB
                    tempData = tempFinallImageData
                }
                end = index - 1
            } else {
                break
            }
        }
        tempData = tempFinallImageData
        return tempData
    }
    
}


//MARK:图片拉伸
public extension UIImage {
    
    /// 返回拉伸的图片，保证拉伸之后的图片不变形
    ///原理介绍:http://www.jianshu.com/p/a577023677c1
    /// - parameter name: 图片名字
    ///
    /// - returns: 拉伸之后的图片，
    //MARK: 拉伸图片
   public class func lca_resizeImage(_ name:String)->UIImage?{
        
        if let image = UIImage(named: name) {
            
            let halfWidth = image.size.width/2
            let halfHeight = image.size.height/2
            let resizeImage = image.resizableImage(withCapInsets: UIEdgeInsetsMake(halfHeight, halfWidth, halfHeight, halfWidth), resizingMode: .stretch)
            
            return resizeImage
        }
        
        return nil
    }
    //MARK: 拉伸图片
   public class func lca_resizeImage(_ originImage:UIImage,edgeTop:CGFloat,edgeBottom:CGFloat,edgeLeft:CGFloat,edgeRight:CGFloat)->UIImage {
        return originImage.resizableImage(withCapInsets: UIEdgeInsetsMake(edgeTop, edgeLeft, edgeBottom, edgeRight), resizingMode: .stretch)
    }
}
public extension UIImage {
   public convenience init?(lca_named:String){
        self.init(named: lca_named)
    }
}

