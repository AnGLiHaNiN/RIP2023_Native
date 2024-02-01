//
//  MedecineCell.swift
//  lab7_rip
//
//  Created by Михаил on 01.02.2024.
//

import Foundation
import UIKit
import SnapKit

class MedicineItemCollectionViewCell: UICollectionViewCell {
    // Элементы UI
    private let statusLabel = UILabel()
    private let creationDateLabel = UILabel()
    private let formationDateLabel = UILabel()
    private let completionDateLabel = UILabel()
    private let moderatorLabel = UILabel()
    private let customerLabel = UILabel()
    private let nameLabel = UILabel()
    private let verificationStatusLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        statusLabel.font = .boldSystemFont(ofSize: 20)
        
        
        backgroundColor = .lightGray
        let labels = [statusLabel, creationDateLabel, formationDateLabel, completionDateLabel, moderatorLabel, customerLabel, nameLabel, verificationStatusLabel]
        var previousLabel: UILabel?

        labels.forEach { label in
            contentView.addSubview(label)
            label.numberOfLines = 0 // Разрешаем многострочный текст

            label.snp.makeConstraints { make in
                if let previous = previousLabel {
                    make.top.equalTo(previous.snp.bottom).offset(5)
                } else {
                    make.top.equalToSuperview().offset(5)
                }
                make.leading.equalToSuperview().offset(10)
                make.trailing.equalToSuperview().offset(-10)
            }

            previousLabel = label
        }

        // Последний элемент привязываем к нижней границе contentView
        previousLabel?.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func configure(with model: MedicineItemResponseModel) {
        statusLabel.text = "Статус: \(model.status)"
        creationDateLabel.text = "Дата создания: \(stringFromDate(dateFromString(model.creationDate)))"
        formationDateLabel.text = "Дата формирования: \(stringFromDate(dateFromString(model.formationDate)))"
        completionDateLabel.text = "Дата завершения: \(stringFromDate(dateFromString(model.completionDate)))"
        moderatorLabel.text = "Модератор: \(model.moderator ?? "Не указан")"
        customerLabel.text = "Клиент: \(model.customer)"
        nameLabel.text = "Название: \(model.name ?? "Не указано")"
        verificationStatusLabel.text = "Статус верификации: \(model.verificationStatus)"
    }
    
    func stringFromDate(_ date: Date?) -> String {
        guard let date = date else { return "Не указано" }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM yyyy, HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func dateFromString(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: dateString)
    }
}
