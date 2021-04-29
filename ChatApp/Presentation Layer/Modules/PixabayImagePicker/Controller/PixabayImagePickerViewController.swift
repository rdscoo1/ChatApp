//
//  PixabayImagePickerViewController.swift
//  ChatApp
//
//  Created by Roman Khodukin on 23.04.2021.
//

import UIKit

class PixabayImagePickerViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PixabayImagePickerCollectionViewCell.self,
                                forCellWithReuseIdentifier: PixabayImagePickerCollectionViewCell.reuseId)
        collectionView.dataSource = collectionViewDataSource
        collectionView.delegate = collectionViewDelegate
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = itemsSpacing
        layout.minimumInteritemSpacing = itemsSpacing
        layout.sectionInset = .init(top: itemsSpacing, left: itemsSpacing, bottom: itemsSpacing, right: itemsSpacing)
        let cellSize: CGFloat = view.bounds.width / itemsPerRow - itemsSpacing * 1.5
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        return layout
    }()
    
    // MARK: - Public Properties
    
    var pixabayService: IPixabayService?
    var didSelectImage: ((UIImage) -> Void)?
    
    // MARK: - Private Properties
    
    private lazy var collectionViewDataSource =
        PixabayImagePickerCollectionViewDataSource(pixabayService: pixabayService) { [weak self] (model, number) in
            self?.fetchImage(at: number, for: model)
        }
    private lazy var collectionViewDelegate = PixabayImagePickerCollectionViewDelegate(cellDidSelectBlock: { [weak self] number in
        self?.didSelectImage(at: number)
    })
    
    private var itemsPerRow: CGFloat = 3
    private let itemsSpacing: CGFloat = 8
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTheme()
        setupLayout()
        loadData()
    }
    
    // MARK: - Private Properties
    
    private func loadData() {
        activityIndicatorView.startAnimating()
        
        pixabayService?.getImageListUrls(completion: { [weak self] (result) in
            switch result {
            case .success(let imageLinkList):
                let imageViewModels = imageLinkList.map {
                    PixabayImageCellModel(image: nil, previewUrl: $0.previewUrl, fullUrl: $0.fullUrl)
                }
                DispatchQueue.main.async {
                    self?.collectionViewDataSource.setImageCellModels(models: imageViewModels)
                    self?.collectionView.reloadData()
                    self?.activityIndicatorView.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    private func fetchImage(at index: Int, for model: PixabayImageCellModel) {
        guard let url = model.previewUrl else { return }
        pixabayService?.loadImage(urlPath: url) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    self?.collectionViewDataSource.updateImageCellModel(model: PixabayImageCellModel(image: UIImage(data: data),
                                                                                                     previewUrl: nil,
                                                                                                     fullUrl: model.fullUrl),
                                                                        number: index)
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func didSelectImage(at number: Int) {
        activityIndicatorView.startAnimating()
        guard let url = collectionViewDataSource.getFullUrl(number: number) else {
            presentErrorAlert()
            activityIndicatorView.stopAnimating()
            return
        }
        
        pixabayService?.loadImage(urlPath: url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure:
                    self?.presentErrorAlert()
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        self?.presentErrorAlert()
                        return
                    }
                    self?.didSelectImage?(image)
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func presentErrorAlert() {
        AlertService().presentErrorAlert(vc: self, message: Constants.LocalizationKey.failedLoadingImage.string)
    }
    
    // MARK: - Setup UI
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .cancel,
                                                  target: self,
                                                  action: #selector(dismissVC))
        navigationItem.title = Constants.LocalizationKey.imagesFromPixabay.string
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupTheme() {
        let theme = Themes.current
        view.backgroundColor = theme.colors.navigationBar.background
        activityIndicatorView.backgroundColor = theme.colors.profile.name
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicatorView.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
