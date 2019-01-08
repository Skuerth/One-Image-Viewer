//
//  ViewController.swift
//  One-Image Viewer
//
//  Created by Skuerth on 2019/1/8.
//  Copyright © 2019 Skuerth. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var button: UIButton!
    var bottomView: UIView!
    var imageWidth: CGFloat = 0.0
    var imageHeight: CGFloat = 0.0
    var imageViewContainer: UIView!

    var minZoom: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        bottomView = UIView()
        bottomView.frame = .zero
        bottomView.backgroundColor = UIColor(red: 247/255, green: 218/255, blue: 21/255, alpha: 1)

        button = UIButton()
        button.frame = .zero
        button.setTitle("Pick an Image", for:
            UIControl.State.normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1).cgColor
        button.addTarget(self, action: #selector(pressedPickButton(sender:)), for: .touchUpInside)


        bottomView.addSubview(button)
        view.addSubview(bottomView)

        setupScrollView()
        scrollView.contentSize = imageView.bounds.size
        imageWidth = imageView.bounds.width
        imageHeight = imageView.bounds.height



        bottomView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
//        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bottomView.heightAnchor.constraint(equalToConstant: 77),

            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 180),


            button.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor, constant: 0),
            button.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 0),

            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0),

//            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: 0),
//            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0),

        ])

    }

    override func viewWillAppear(_ animated: Bool){

        imageView.contentMode = .scaleAspectFit

//        imageView.center = CGPoint(x: scrollView.frame.width * CGFloat(0.5), y:  scrollView.frame.height * CGFloat(0.5))
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        updateMinZoomScaleForSize(view.bounds.size)
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {

        let subView = scrollView.subviews[0]

        let offsetX = max(((scrollView.bounds.size.width - scrollView.contentSize.width) * CGFloat(0.5)) , CGFloat(0.0))

        let offsetY = max(((scrollView.bounds.size.height - scrollView.contentSize.height) * CGFloat(0.5)), CGFloat(0.0))

        subView.center = CGPoint(x: scrollView.contentSize.width * CGFloat(0.5) + offsetX, y:  scrollView.contentSize.height * CGFloat(0.5) + offsetY)
    }

    func setupScrollView() {


        imageView = UIImageView(image: UIImage (named: "icon_photo")?.withRenderingMode(.alwaysTemplate))

//        imageView = UIImageView(image: UIImage (named: "architecture"))


        imageView.tintColor = UIColor.white

        imageView.contentMode = .scaleAspectFit
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 77))

        scrollView.backgroundColor = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 1)

        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        scrollView.delegate = self
        scrollView.maximumZoomScale = 2.0
        scrollView.zoomScale = 1.0
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {

        return imageView
    }


    @objc func pressedPickButton(sender: UIButton) {

        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = .savedPhotosAlbum
        imageController.allowsEditing = false

        present(imageController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            DispatchQueue.main.async{

                self.imageWidth = image.size.width
                self.scrollView.contentSize = image.size
                self.imageView.bounds.size = image.size
                self.updateMinZoomScaleForSize(self.view.bounds.size)
                self.imageView.image = image
            }
        }

        dismiss(animated: true, completion: nil)
    }

    func updateMinZoomScaleForSize(_ size: CGSize) {

        scrollView.minimumZoomScale = size.width / imageWidth

        print("minimumZoomScale", size.width / imageWidth)
    }
}

