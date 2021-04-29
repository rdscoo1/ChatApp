//
//  PixabayImagePickerCollectionViewDelegate.swift
//  ChatApp
//
//  Created by Roman Khodukin on 23.04.2021.
//

import UIKit

class PixabayImagePickerCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    // MARK: - Private properties
    
    private let didSelectCell: (Int) -> Void
    
    // MARK: - Initializer
    
    init(cellDidSelectBlock: @escaping (Int) -> Void) {
        self.didSelectCell = cellDidSelectBlock
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell(indexPath.item)
    }
}
