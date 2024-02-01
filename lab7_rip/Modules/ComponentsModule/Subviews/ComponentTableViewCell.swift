//
//  ComponentTableViewCell.swift
//  yourProjectName
//
//  Created by Mikhail on 04.12.2023.
//

import UIKit

final class ComponentTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let photoImageView = CustomImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        [photoImageView, titleLabel, descriptionLabel].forEach {
            addSubview($0)
        }
        backgroundColor = .systemRed.withAlphaComponent(0.5)
        setVisualAppearance()
        setupImage()
        setupTitle()
        setupAlbumLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Life circle
extension ComponentTableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
}

//MARK: - methods
extension ComponentTableViewCell {
    func cellConfigure(with model: ComponentUIModel) {
        print("cellConfigure", model.imageUrl)
        guard let photoUrl = URL(string: "http://\(model.imageUrl)") else {
            print("Не получилось создать url 2")
            return
        }

        photoImageView.loadImage(with: photoUrl)
        titleLabel.text = model.name
//        descriptionLabel.text = model.calculationDescription
    }
}

//MARK: - private methods
private extension ComponentTableViewCell {
    func setVisualAppearance() {
        photoImageView.contentMode = .scaleAspectFit // обрезаем фото
        photoImageView.clipsToBounds = true
        [titleLabel, descriptionLabel].forEach {
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.font = UIFont(name: "Times New Roman", size: 17) // меняем шрифт
        }
    }

    func setupImage() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        photoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        photoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
    }

    func setupAlbumLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 15).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 50).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -50).isActive = true
        descriptionLabel.sizeToFit()
    }

    func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 50).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -50).isActive = true
        titleLabel.sizeToFit()
    }
}

