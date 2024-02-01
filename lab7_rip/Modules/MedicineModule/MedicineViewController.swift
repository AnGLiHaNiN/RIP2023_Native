//
//  MedicineViewController.swift
//  yourProjectName
//
//  Created by Mikhail on 11.12.2023.
//

import UIKit

class MedicineViewController: UIViewController {
    private let  titleLabel = UILabel()
    private let  descriptionaLabel = UILabel()
    private let  factoryLabel = UILabel()
    private let photoImageView = CustomImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemRed.withAlphaComponent(0.5)
        [photoImageView,descriptionaLabel,titleLabel,factoryLabel].forEach {
            view.addSubview($0)
        }
        
        setVisualAppearance()
        setupImage()
        setDescriptionLabel()
        setfactoryLabel()
        setTitleLabel()
    }
}

//MARK: - methods
extension MedicineViewController {
    func datailConfigure(with model: ComponentUIModel) {

//        print(model.imageUrl.replacingOccurrences(of: "localhost", with: "172.20.10.2"))
        guard let photoUrl = URL(string: "http://\(model.imageUrl)") else {
            print("Не получилось создать url")
            return
        }

        photoImageView.loadImage(with: photoUrl)
        titleLabel.text = model.name
        descriptionaLabel.text = String(model.amount)
        factoryLabel.text = model.worldName
    }
}

//MARK: - private methods
private extension MedicineViewController {
    func setVisualAppearance() {
        view.backgroundColor = .systemBackground
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.clipsToBounds = true
        [factoryLabel, descriptionaLabel, titleLabel].forEach {
            $0.numberOfLines = 0
            $0.font = UIFont(name: "Times New Roman", size: 20)
        }
    }

    func setupImage() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 15).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        titleLabel.sizeToFit()
    }

    func setDescriptionLabel() {
        descriptionaLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionaLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50).isActive = true
        descriptionaLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        descriptionaLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        descriptionaLabel.sizeToFit()
    }
    
    func setfactoryLabel() {
        factoryLabel.translatesAutoresizingMaskIntoConstraints = false
        factoryLabel.topAnchor.constraint(equalTo: descriptionaLabel.bottomAnchor, constant: 50).isActive = true
        factoryLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        factoryLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        factoryLabel.sizeToFit()
    }
}
