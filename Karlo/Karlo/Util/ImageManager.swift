//  Karlo - ImageManager.swift
//  Created by zhilly on 2023/09/18

import UIKit

final class ImageManager: NSObject {
    var errorHandler: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc
    func saveCompleted(
        _ image: UIImage,
        didFinishSavingWithError error: Error?,
        contextInfo: UnsafeRawPointer
    ) {
        if let error = error { errorHandler?(error) }
    }
}
