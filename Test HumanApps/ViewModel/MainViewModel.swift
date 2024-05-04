//
//  MainViewModel.swift
//  Test HumanApps
//
//  Created by Dulin Gleb on 2.5.24..
//

import Foundation
import UIKit

protocol MainViewModelProtocol: AnyObject {
    func viewLoaded()
    func didAddButtonTapped()
    func convertToGrayScale(image: UIImage) -> UIImage?
    func renderImage(container: UIView, renderRect: CGRect) -> UIImage
    func getOriginalImage() -> UIImage?
}

final class MainViewModel: NSObject{
    weak var view: MainViewControllerProtocol?
    
    private var originalImage: UIImage?
}

extension MainViewModel: MainViewModelProtocol {
    func viewLoaded() {
        
    }
    
    func didAddButtonTapped() {
        let picker = UIImagePickerController()
        //picker.allowsEditing = true
        picker.delegate = self
        view?.presentPicker(picker: picker)
    }
    
    func convertToGrayScale(image: UIImage) -> UIImage? {
        let imageRect:CGRect = CGRect(x:0, y:0, width:image.size.width, height: image.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        if let cgImg = image.cgImage {
            context?.draw(cgImg, in: imageRect)
            if let makeImg = context?.makeImage() {
                let imageRef = makeImg
                let newImage = UIImage(cgImage: imageRef)
                return newImage
            }
        }
        return UIImage()
    }
    
    func renderImage(container: UIView, renderRect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: renderRect)
        let image = renderer.image { ctx in
            container.layer.render(in: ctx.cgContext)
        }
        
        return image
    }
    
    func getOriginalImage() -> UIImage? {
        return self.originalImage
    }
}

extension MainViewModel: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }

        view?.dismissPicker()
        view?.setImage(image: image)
        self.originalImage = image
    }
}
