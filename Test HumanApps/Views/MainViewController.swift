//
//  MainViewController.swift
//  Test HumanApps
//
//  Created by Dulin Gleb on 2.5.24..
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func presentPicker(picker: UIImagePickerController)
    func dismissPicker()
    func setImage(image: UIImage)
}

class MainViewController: UIViewController {
    var viewModel: MainViewModelProtocol?
    
    private let multiplyCropRect = 0.7
    
    private var renderRect: CGRect = .zero
    private var lastRotation: CGFloat = 0
    private var lastScale: CGFloat = 1
    private var panGestureAnchorPoint: CGPoint?
    
    
    lazy var addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.configuration = .filled()
        btn.setTitle("Choose photo", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var mainContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var cropContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var bwSegment: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.isHidden = true
        uiSwitch.isOn = false
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    
    lazy var bwImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCropContainer()
    }
    
}

private extension MainViewController {
    func setupViews() {
        view.addSubview(mainContainer)
        mainContainer.addSubview(imageView)
        view.addSubview(addButton)
        view.addSubview(cropContainer)
        view.addSubview(bwSegment)
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        bwSegment.addTarget(self, action: #selector(bwSwitched(_:)), for: .valueChanged)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        imageView.addGestureRecognizer(pinchRecognizer)
        
        let rotateRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(_:)))
        imageView.addGestureRecognizer(rotateRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        imageView.addGestureRecognizer(panRecognizer)
        
        pinchRecognizer.delegate = self
        rotateRecognizer.delegate = self
        panRecognizer.delegate = self
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            
            mainContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainContainer.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor),
            
            bwSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bwSegment.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -40),
        ])
    }
    
    func setupCropContainer() {
        cropContainer.frame = view.safeAreaLayoutGuide.layoutFrame
        renderRect = CGRect(
            x: CGFloat(cropContainer.frame.width / 2) - (cropContainer.frame.width * multiplyCropRect) / 2,
            y: CGFloat(cropContainer.frame.height / 2) - (cropContainer.frame.height * multiplyCropRect) / 2,
            width: cropContainer.frame.width * multiplyCropRect,
            height: cropContainer.frame.height * multiplyCropRect
        )
        let pathBigRect = UIBezierPath(rect: cropContainer.bounds)
        let pathSmallRect = UIBezierPath(rect: renderRect)
        
        pathBigRect.append(pathSmallRect)
        pathBigRect.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = pathBigRect.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = UIColor.systemGray5.cgColor
        fillLayer.opacity = 0.6
        cropContainer.layer.addSublayer(fillLayer)
    }
    
    @objc func addButtonTapped() {
        viewModel?.didAddButtonTapped()
    }
    
    @objc func saveButtonTapped() {
        guard let image = viewModel?.renderImage(container: mainContainer, renderRect: renderRect) else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alertMessagePopUpBox = UIAlertController(title: title, message: "Image saved succesfully", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alertMessagePopUpBox.addAction(okButton)
        self.present(alertMessagePopUpBox, animated: true)
        print("Save finished!")
    }
    
    @objc func bwSwitched(_ sender: UISwitch!) {
        if sender.isOn {
            guard let image = imageView.image else { return }
            let bwImage = viewModel?.convertToGrayScale(image: image)
            imageView.image = bwImage
        } else {
            guard let image = viewModel?.getOriginalImage() else { return }
            imageView.image = image
        }
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    @objc func handlePinch(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
            sender.scale = lastScale
        case .changed:
            sender.view?.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale).rotated(by: lastRotation)
            lastScale = sender.scale
        case .ended:
            lastScale = sender.scale
        default:
            break
        }
    }
    
    @objc func handleRotate(_ sender: UIRotationGestureRecognizer) {
        var originalRotation = CGFloat()
        switch sender.state {
            case .began:
                    sender.rotation = lastRotation
                    originalRotation = sender.rotation
            case .changed:
                let newRotation = sender.rotation + originalRotation
                sender.view?.transform = CGAffineTransform(rotationAngle: newRotation).scaledBy(x: lastScale, y: lastScale)
                lastRotation = sender.rotation
            case .ended:
                lastRotation = sender.rotation
            default:
                break
        }
        
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
            case .began:
                panGestureAnchorPoint = sender.location(in: imageView)
            case .changed:
                let translation = sender.translation(in: view)
                guard let gestureView = sender.view else {  return }

                  gestureView.center = CGPoint(
                    x: gestureView.center.x + translation.x,
                    y: gestureView.center.y + translation.y
                  )

                  sender.setTranslation(.zero, in: view)
            case .ended:
                panGestureAnchorPoint = nil
            default: break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

extension MainViewController: MainViewControllerProtocol {
    func presentPicker(picker: UIImagePickerController) {
        self.present(picker, animated: true)
    }
    
    func dismissPicker() {
        self.addButton.isHidden = true
        self.cropContainer.isHidden = false
        self.bwSegment.isHidden = false
        navigationItem.rightBarButtonItem?.isEnabled = true
        self.dismiss(animated: true)
    }
    
    func setImage(image: UIImage) {
        self.imageView.image = image
    }
}
