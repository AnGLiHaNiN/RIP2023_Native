//
//  BasketCell.swift
//  lab7_rip
//
//  Created by Михаил on 31.01.2024.
//

import UIKit
import SnapKit
import KeychainSwift

class BasketCell: UICollectionViewCell {
    
    var uuid: String = ""
    var count: Int = 0
    
    struct DisplayData: Hashable {
        let uuid: String
        let title: String
        let subtitle: String
        let image: UIImage
        let count: Int
    }

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()
    private let addButton = UIButton(type: .system)
    private let removeButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 10
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        
        let buttonStack = UIStackView(arrangedSubviews: [addButton, removeButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 10
        
        let mainStack = UIStackView(arrangedSubviews: [imageView, textStack, buttonStack])
        mainStack.axis = .horizontal
        mainStack.spacing = 8
        mainStack.alignment = .center
        
        contentView.addSubview(mainStack)
        mainStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        addButton.setTitle("Добавить", for: .normal)
        addButton.backgroundColor = .systemBlue
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 5
        addButton.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        removeButton.setTitle("Удалить", for: .normal)
        removeButton.backgroundColor = .systemRed
        removeButton.setTitleColor(.white, for: .normal)
        removeButton.layer.cornerRadius = 5
        removeButton.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }
    
    @objc func addButtonTapped() {
        NetworkService.shared.addToMedicine(componentID: uuid) { result in
            print("Добавлено")

            
            
            
            DispatchQueue.main.async {
                self.subtitleLabel.text = "Количество: \(String(self.count + 1))"
                self.layoutSubviews()
                self.count += 1
            }
        }
    }
    
    @objc func removeButtonTapped() {
        NetworkService.shared.deleteFromMedicine(componentID: uuid) { result in
            self.isHidden = true
            print("Удалено")
        }
    }

    func configure(with displayData: DisplayData) {
        count = displayData.count
        uuid = displayData.uuid
        titleLabel.text = displayData.title
        subtitleLabel.text = "Количество: \(String(displayData.count))"
        imageView.image = displayData.image
        
        addButton.isHidden = KeychainSwift().get("authToken") == nil
        removeButton.isHidden = addButton.isHidden // Скрываем кнопку удаления, если скрыта кнопка добавления
    }
}
