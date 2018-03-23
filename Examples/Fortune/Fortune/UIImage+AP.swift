//
//  UIImage+AP.swift
//  Fortune
//
//  Created by Edward on 2/12/18.
//  Copyright © 2018 Branch. All rights reserved.
//

import UIKit

extension CGRect {

    func rectCenteredOver(rect: CGRect) -> CGRect {
        return CGRect(
            x:      rect.origin.x + ((rect.size.width - self.size.width)/2.0),
            y:      rect.origin.y + ((rect.size.height - self.size.height)/2.0),
            width:  self.size.width,
            height: self.size.height
        )
    }

    func rectAspectFitIn(rect: CGRect) -> CGRect {
        if rect.width <= 0 || rect.height <= 0 || self.width <= 0 || self.height <= 0 {
            return CGRect.zero.rectCenteredOver(rect: rect)
        }
        var r: CGRect = .zero
        if self.width < self.height {
            r = CGRect(
                x: 0.0,
                y: 0.0,
                width:  rect.width * rect.height / self.height,
                height: rect.height
            )
        } else {
            r = CGRect(
                x: 0.0,
                y: 0.0,
                width:  rect.width,
                height: rect.height * rect.width / self.width
            )
        }
        return r.rectCenteredOver(rect: rect)
    }
}

extension UIImage {

    class func imageWith(color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(
            origin: .zero,
            size:   size
        )
        var image: UIImage? = nil
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        if let context: CGContext = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor);
            context.fill(rect);
            image = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
        return image;
    }

    func imageWithAspectFit(size: CGSize) -> UIImage? {
        if size.height <= 0.0 || size.width <= 0.0 { return nil }

        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, self.scale);
        guard let context = UIGraphicsGetCurrentContext()
        else { return nil }

        //    Orient the image correctly --
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -rect.size.height)

        //    Set the color --
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(rect)

        //  d.w / d.h  = s.w / s.h
        //  d.h / d.w  = s.h / s.w

        var destRect = CGRect.zero
        if size.width < size.height {
            destRect.size.width  = size.width;
            destRect.size.height = self.size.height / self.size.width * destRect.size.width;
        } else {
            destRect.size.height = size.height;
            destRect.size.width  = self.size.width / self.size.height * destRect.size.height;
        }
        destRect = destRect.rectCenteredOver(rect: rect)
        if let image = self.cgImage {
            context.draw(image, in: destRect)
        }

        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return image;
    }
}
