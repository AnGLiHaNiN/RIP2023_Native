//
//  CollectionViewExtention.swift
//  lab7_rip
//
//  Created by Михаил on 31.01.2024.
//

import UIKit

extension UICollectionViewLayout {
    static func listCollectionViewLayout(estimatedHeight: CGFloat, interGroupSpacing: CGFloat = 0, leftRightInset: CGFloat = 0) -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(estimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)

        section.contentInsets = .init(
            top: .zero,
            leading: leftRightInset,
            bottom: .zero,
            trailing: leftRightInset
        )
        section.interGroupSpacing = interGroupSpacing

        return UICollectionViewCompositionalLayout(section: section)
    }
}
