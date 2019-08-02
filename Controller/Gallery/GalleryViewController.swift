//
//  GalleryViewController.swift
//  Notes
//
//  Created by Николай Спиридонов on 19/07/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images = imagesInStorage.images
    let reuseIdentifier = "imageCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Gallery"
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = item
    }
    
    @objc func addButtonPressed() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let slideshow = SlideshowViewController()
        slideshow.pageNumber = indexPath.row
        navigationController?.pushViewController(slideshow, animated: true)
    }
    
}

extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let newImage = info[.editedImage] as? UIImage else { return }
        images.append(newImage)
        imagesInStorage.images.append(newImage)
        let insertIndexPath = IndexPath(item: images.count - 1, section: 0)
        collectionView.insertItems(at: [insertIndexPath])
        
        dismiss(animated: true, completion: nil)
    }
  
}
