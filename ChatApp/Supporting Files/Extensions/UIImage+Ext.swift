//
//  UIImage+Ext.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/26/21.
//

import UIKit

extension UIImage {
    func tinted(color: UIColor) -> UIImage? {
        let image = withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color

        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            imageView.layer.render(in: context)
            let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return tintedImage
        } else {
            return self
        }
    }
    
    func isEqual(to toImage: UIImage?) -> Bool {
        guard let data1 = self.pngData(),
        let data2 = toImage!.pngData()
            else { return false}
        
        return data1.elementsEqual(data2)
    }
}
