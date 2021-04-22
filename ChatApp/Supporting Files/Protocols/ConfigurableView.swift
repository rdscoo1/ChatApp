//
//  ConfigurableView.swift
//  ChatApp
//
//  Created by Roman Khodukin on 4/14/21.
//

import UIKit

protocol ConfigurableView where Self: UIView {
    associatedtype ConfigurationModel

    func configure(with model: ConfigurationModel)
}
