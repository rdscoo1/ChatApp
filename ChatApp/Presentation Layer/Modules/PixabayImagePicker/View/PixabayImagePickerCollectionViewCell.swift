//
//  PixabayImagePickerCollectionViewCell.swift
//  ChatApp
//
//  Created by Roman Khodukin on 23.04.2021.
//

import UIKit

class PixabayImagePickerCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "PixabayImagePickerCollectionViewCell"

    // MARK: - UI
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: .placeholder)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setPlaceholderImage()
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        let theme = Themes.current
        imageView.tintColor = theme.colors.profile.name
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setPlaceholderImage() {
        imageView.image = .placeholder
    }
}

// MARK: - IConfigurableView

extension PixabayImagePickerCollectionViewCell: ConfigurableView {
    func configure(with model: PixabayImageCellModel) {
        if let image = model.image {
            imageView.image = image
        } else {
            setPlaceholderImage()
        }
    }
}
