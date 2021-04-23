//
//  PixabayImagePickerCollectionViewDataSource.swift
//  ChatApp
//
//  Created by Roman Khodukin on 23.04.2021.
//

import UIKit

class PixabayImagePickerCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Private properties
    
    private let pixabayService: IPixabayService?
    private var imageCellModels: [PixabayImageCellModel] = []
    private let didLoadImage: (PixabayImageCellModel, Int) -> Void
    
    // MARK: - Initializer
    
    init(pixabayService: IPixabayService?,
         didLoadImage: @escaping (PixabayImageCellModel, Int) -> Void) {
        self.pixabayService = pixabayService
        self.didLoadImage = didLoadImage
        super.init()
    }
    
    // MARK: - Public methods
    
    func setImageCellModels(models: [PixabayImageCellModel]) {
        imageCellModels = models
    }
    
    func updateImageCellModel(model: PixabayImageCellModel, number: Int) {
        imageCellModels[number] = model
    }
    
    func getFullUrl(number: Int) -> String? {
        return imageCellModels[number].fullUrl
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PixabayImagePickerCollectionViewCell.reuseId,
                                                            for: indexPath) as? PixabayImagePickerCollectionViewCell else { return UICollectionViewCell() }
        let model = imageCellModels[indexPath.item]
        cell.configure(with: model)
        didLoadImage(model, indexPath.item)
        
        return cell
    }
}
