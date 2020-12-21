//
//  MultiPhotosPicker.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/17.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI
import YPImagePicker

struct MultiPhotosPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var maxNumberOfItems = 3
    var receiveBlock: ([UIImage]) -> Void
    
    func makeUIViewController(context: Context) -> YPImagePicker {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = maxNumberOfItems
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                print("Picker was canceled")
                presentationMode.wrappedValue.dismiss()
            }
            var images = [UIImage]()
            for item in items {
                switch item {
                case .photo(let photo):
                    images.append(photo.image)
                    print(photo)
                case .video(v: _):
                    break
                }
            }
            receiveBlock(images)
            presentationMode.wrappedValue.dismiss()
        }
        return picker
    }
    
    func updateUIViewController(_ uiViewController: YPImagePicker, context: Context) {
        
    }
}

