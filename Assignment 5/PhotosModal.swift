//
//  PhotosModal.swift
//  Assignment 5
//
//  Created by Luca on 9/20/26.
//

import PhotosUI
import SwiftUI

struct PhotosModal: View {
  @Binding var card: Card
  @State private var showPicker = false

  var body: some View {
    Button {
      showPicker = true
    } label: {
      ToolbarButton(modal: .photoModal)
    }
    .sheet(isPresented: $showPicker) {
      PhotoPickerViewController(card: $card)
    }
  }
}

struct PhotoPickerViewController: UIViewControllerRepresentable {
  @Binding var card: Card
  @Environment(\.presentationMode) var presentationMode

  func makeUIViewController(context: Context) -> PHPickerViewController {
    var config = PHPickerConfiguration(photoLibrary: .shared())
    config.filter = .images
    config.selectionLimit = 0 // Allow multiple selection
    let picker = PHPickerViewController(configuration: config)
    picker.delegate = context.coordinator
    return picker
  }

  func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, PHPickerViewControllerDelegate {
    let parent: PhotoPickerViewController

    init(_ parent: PhotoPickerViewController) {
      self.parent = parent
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      parent.presentationMode.wrappedValue.dismiss()

      for result in results {
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
          result.itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
            if let uiImage = image as? UIImage {
              DispatchQueue.main.async {
                self.parent.card.addElement(uiImage: uiImage)
              }
            }
          }
        }
      }
    }
  }
}
