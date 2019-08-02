//
//  SlideshowViewController.swift
//  Notes
//
//  Created by Николай Спиридонов on 21/07/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import UIKit

class SlideshowViewController: UIViewController {
    var scroll: UIScrollView!
    var images = imagesInStorage.images
    var pageNumber: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        settingScrollView()
        settingImages()
        goToPage()
        
        navigationController?.hidesBarsOnTap = true
    }
    
    func settingScrollView() {
        scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scroll.isPagingEnabled = true
        self.view.addSubview(scroll)
        
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        scroll.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        scroll.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        scroll.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    }
    
    func settingImages() {
        for (number, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: CGFloat(number) * self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height / 2)
     
            imageView.contentMode = .scaleAspectFit
            scroll.addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.removeConstraints(imageView.constraints)

            imageView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
            imageView.centerYAnchor.constraint(equalTo: scroll.centerYAnchor, constant: -20).isActive = true
            if number == 0 {
                imageView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 0).isActive = true
            } else if number == images.count - 1 {
                imageView.leadingAnchor.constraint(equalTo: scroll.subviews[number - 1].trailingAnchor, constant: 0).isActive = true
                imageView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: 0).isActive = true
            } else {
                imageView.leadingAnchor.constraint(equalTo: scroll.subviews[number - 1].trailingAnchor, constant: 0).isActive = true
            }
        }
    }
    
  
    func goToPage() {
        guard let page = pageNumber else { return }
        scroll.contentOffset = CGPoint(x: CGFloat(page) * self.view.frame.width, y: 0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let numberOfPicture = Int((scroll.contentOffset.x + 50) / self.view.frame.width)
        
        for (number, imageView) in scroll.subviews.enumerated() {
            imageView.removeConstraints(imageView.constraints)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            
            
            if number == 0 {
                imageView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 0).isActive = true
            } else if number == images.count - 1 {
                imageView.leadingAnchor.constraint(equalTo: scroll.subviews[number - 1].trailingAnchor, constant: 0).isActive = true
                imageView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: 0).isActive = true
            } else {
                imageView.leadingAnchor.constraint(equalTo: scroll.subviews[number - 1].trailingAnchor, constant: 0).isActive = true
            }
        }
        
        scroll.contentSize.width = size.width * CGFloat(images.count)
        scroll.layoutSubviews()
        scroll.contentOffset.x = size.width * CGFloat(numberOfPicture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.hidesBarsOnTap = false

    }
}

