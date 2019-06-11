//
//  MapViewController.swift
//  here-marker-demo
//
//  Created by Yachin Ilya on 30/05/2019.
//  Copyright © 2019 Yachin Ilya. All rights reserved.
//

import UIKit
import NMAKit

class MapViewController: UIViewController {
    private let pin1Button = UIButton()
    private let pin2Button = UIButton()
    private let pin3Button = UIButton()
    private var mapView = NMAMapView()
    private var displayedObjects: [NMAMapObject] = [] {
        didSet {
            print(self.displayedObjects)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.frame = self.view.bounds
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true

        mapView.set(geoCenter: randomLocation(), animation: .none)
        mapView.set(zoomLevel: 13, animation: .linear)
        mapView.copyrightLogoPosition = .bottomRight
        
        pin1Button.setImage(#imageLiteral(resourceName: "pin2"), for: .normal)
        pin2Button.setImage(#imageLiteral(resourceName: "pin1"), for: .normal)
        pin3Button.setImage(#imageLiteral(resourceName: "pin3"), for: .normal)
        
        pin1Button.backgroundColor = .white
        pin2Button.backgroundColor = .white
        pin3Button.backgroundColor = .white
        
        roundCorners(for: pin1Button)
        roundCorners(for: pin2Button)
        roundCorners(for: pin3Button)
        
        view.addSubview(pin1Button)
        view.addSubview(pin2Button)
        view.addSubview(pin3Button)
        
        pin1Button.translatesAutoresizingMaskIntoConstraints = false
        pin2Button.translatesAutoresizingMaskIntoConstraints = false
        pin3Button.translatesAutoresizingMaskIntoConstraints = false
        
        pin1Button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pin1Button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pin1Button.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        pin1Button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        pin2Button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pin2Button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pin2Button.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        pin2Button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        pin3Button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pin3Button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pin3Button.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        pin3Button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        pin1Button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        pin2Button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        pin3Button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
    }
    

    private func setPin(at point: NMAGeoCoordinates, icon: UIImage?){
        mapView.remove(objects: displayedObjects)
        displayedObjects.removeAll()

        guard let image: UIImage = icon else { return }

        let marker = NMAMapMarker()
        marker.coordinates = point
        marker.icon = image.adjustForMapMarker()
        marker.zIndex = 100

        if marker.icon != nil {
            mapView.add(marker)
            displayedObjects.append(marker)
                let zoom = mapView.zoomLevel
                mapView.set(geoCenter: point, zoomLevel: zoom, animation: .linear)
        }
        
    }
    
    private func randomLocation() -> NMAGeoCoordinates {
        return NMAGeoCoordinates(
            latitude: 90.0-(Double(arc4random_uniform(180_000)/1000)),
            longitude: 180.0-(Double(arc4random_uniform(360_000)/1000))
        )
    }
    
    private func roundCorners(for view: UIView, cornerRadius: CGFloat = 25) {
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = cornerRadius
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.masksToBounds = true
    }
    
    @objc
    func buttonClick(_ button: UIButton) {
        setPin(at: randomLocation(), icon: button.image(for: .normal))
    }

}


extension UIImage
{
    /**
     User defined max size for marker image.
     - note: Large images cover more visible map area.
     */
    struct maxImageSize {
        static let width: CGFloat = 30
        static let height: CGFloat = 30
    }

    /**
     This method is a simple example of runtime image adjustment (image size and color scheme)
     for mapMarker.
     - important: THIS IS NOT OPTIMAL WAY. For greater performance the image resources should be already adjusted before the execution.
     */
    func adjustForMapMarker() -> UIImage? {
        // Resize the image to render in map
        var resizedImage: UIImage?
        if self.size.width > maxImageSize.width || self.size.height > maxImageSize.height {
            // aspect ratio is not saved
            resizedImage = self.resizeImage(to: CGSize(width: maxImageSize.width,
                                                        height: maxImageSize.height),
                                             scale: UIScreen.main.scale)
        } else {
            resizedImage = self
        }

        // Convert monochrome colorspace to RGB
        var adjustedImage: UIImage? = resizedImage
        if let cs = resizedImage?.cgImage?.colorSpace, cs.model == CGColorSpaceModel.monochrome {
            adjustedImage = resizedImage?.asRGBImage()
        }

        return adjustedImage
    }


    /**
     Creates a new image with device dependent RGB color space from current monochrome image.
     - important: Only monochrome image with valid bpc and bpp can be converted.

     - returns: new UIImage with device dependent RGB color space, which is based on current image
     OR nil otherwise.
     */
    private func asRGBImage() -> UIImage? {
        guard let cgImage =  self.cgImage else {
            return nil
        }

        guard let cs = cgImage.colorSpace, cs.model == CGColorSpaceModel.monochrome else {
            return nil
        }

        // explicitly set RGB color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow

        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
            | CGBitmapInfo.byteOrder32Little.rawValue

        if let context = CGContext(data: nil,
                                   width: Int(size.width),
                                   height: Int(size.height),
                                   bitsPerComponent: bitsPerComponent,
                                   bytesPerRow: bytesPerRow,
                                   space: colorSpace,
                                   bitmapInfo: bitmapInfo)
        {
            context.interpolationQuality = .high

            context.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: size))
            if let newCGImage = context.makeImage() {
                let newImage = UIImage(cgImage: newCGImage)
                return newImage
            }
        }
        return nil
    }

    /**
     Creates a new resized image from current image.
     New image has defined size and screen scale.
     - important: New image doesn't keep aspect ratio of current image.

     - parameters:
        - newSize: The size of new image.
        - scale: The device screen scale factor applied on bitmap.
     - returns: new UIImage with given size and scale, which is based on current image
     OR nil otherwise.
     */
    private func resizeImage(to newSize: CGSize, scale: CGFloat) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(newSize, false, scale);

        let rect = CGRect(origin: CGPoint.zero, size: newSize)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return scaledImage
    }
}
