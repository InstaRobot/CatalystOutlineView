//
//  BasicViewCell.swift
//  Example
//
//  Created by Vitaliy Podolskiy on 26.05.2020.
//  Copyright © 2020 DEVLAB Studio LLC. All rights reserved.
//

import UIKit
import CatalystOutlineView

class BasicViewCell: NodeCell {

    override init(currentLevel: Int, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(currentLevel: currentLevel, style: .default, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with string: String) {
        backgroundColor = .secondarySystemBackground

        let icon: UIImage?
        var offset: CGFloat = 0
        var tintColor: UIColor?

        switch currentLevel {
        case 1:
            icon = UIImage(systemName: "folder.circle.fill")
            offset = 20
            tintColor = .red
        case 2:
            icon = UIImage(systemName: "folder.circle")
            offset = 40
            tintColor = .orange
        case 3:
            icon = UIImage(systemName: "doc.circle")
            offset = 60
            tintColor = .brown
        default:
            return
        }

        let imageView: UIImageView = UIImageView(image: icon)
        addSubview(imageView)
        imageView.tintColor = tintColor
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.widthAnchor.constraint(equalToConstant: 30)
        ])

        let label = UILabel(frame: .infinite)
        label.textColor = .gray
        label.text = string
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }

}
