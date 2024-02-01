//
//  ComponentCell.swift
//  lab7_rip
//
//  Created by Михаил on 31.01.2024.
//

import UIKit
import SnapKit
import KeychainSwift

class ComponentCell: UICollectionViewCell {
    
    var uuid: String = ""
    
    struct DisplayData: Hashable {
        let uuid: String
        let title: String
        let subtitle: String
        let image: UIImage
    }

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()
    private let addButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        
        let contentStack = UIStackView(arrangedSubviews: [imageView, titleLabel, subtitleLabel, addButton])
        contentStack.axis = .vertical
        contentStack.spacing = 8
        contentStack.alignment = .center
        contentView.addSubview(contentStack)
        
        contentStack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
        }
        
        // Настройка заголовка с большим шрифтом
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20) // Увеличенный размер шрифта
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center // Выравнивание по центру
//        contentView.addSubview(titleLabel)

        // Настройка подзаголовка с большим шрифтом
        subtitleLabel.font = UIFont.systemFont(ofSize: 18) // Увеличенный размер шрифта
        subtitleLabel.textColor = .darkGray
        subtitleLabel.textAlignment = .center // Выравнивание по центру
//        contentView.addSubview(subtitleLabel)

        // Настройка изображения
        imageView.contentMode = .scaleAspectFill // Заполнение содержимым с сохранением пропорций
        imageView.clipsToBounds = true // Обрезка по границам
//        contentView.addSubview(imageView)
        
        
        addButton.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalTo(120)
        }
        addButton.backgroundColor = .blue
        addButton.setTitle("Добавить", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        
    }
    
    @objc func addButtonTapped() {
        NetworkService.shared.addToMedicine(componentID: uuid) { result in
            print("Доавили")
        }
    }


    func configure(with displayData: DisplayData) {
        uuid = displayData.uuid
        titleLabel.text = displayData.title
        subtitleLabel.text = displayData.subtitle
        imageView.image = displayData.image
        
        if KeychainSwift().get("authToken") != nil {
            addButton.isHidden = false
        } else {
            addButton.isHidden = true
        }
    }
}
