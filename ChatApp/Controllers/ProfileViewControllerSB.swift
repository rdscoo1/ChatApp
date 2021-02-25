//
//  ProfileViewControllerSB.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/24/21.
//

import UIKit

class ProfileViewControllerSB: UIViewController {

    // MARK: - Private variables
    
    @IBOutlet weak var logoImageView: ProfileLogoImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var geoLabel: UILabel!
    @IBOutlet weak var editButton: ActionButton!
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print("Frame кнопки Edit \(String(describing: editButton?.frame)) в методе \(#function)")
        //кнопка еще не проинициализирована
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Frame кнопки Edit \(editButton.frame) в методе \(#function)")
        //позиция кнопки еще не определена и она расположена там же, где и на сториборде
        
        configureUI()
        logoImageView.delegate = self
        logoImageView.setPlaceholderLetters(name: nameLabel.text)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("Frame кнопки Edit \(editButton.frame) в методе \(#function)")
        //позиция кнопки определена и она расположена в зависимости от размера экрана устройства
    }

    
    // MARK: - Private methods
    
    private func configureUI() {
        logoImageView.isUserInteractionEnabled = true
        logoImageView.delegate = self
        
        nameLabel.text = "Marina Dudarenko"
        nameLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        aboutLabel.text = "UX/UI designer, web-designer"
        aboutLabel.textAlignment = .center
        aboutLabel.font = .systemFont(ofSize: 16, weight: .regular)
        
        geoLabel.text = "Moscow, Russia"
        geoLabel.textAlignment = .center
        geoLabel.font = .systemFont(ofSize: 16, weight: .regular)
    }
}

// MARK: - ProfileLogoImageViewDelegate

extension ProfileViewControllerSB: ProfileLogoImageViewDelegate {
    func tappedProfileLogoImageView() {
        ImagePickerManager().pickImage(self) { image in
            self.logoImageView.image = image
            self.logoImageView.hidePlaceholderLetters()
        }
    }
}
