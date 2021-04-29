//
//  GCDProfileDataManager.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/18/21.
//

import UIKit

class GCDProfileDataManager: IProfileDataManager {

    // MARK: - IProfileDataManager methods
    
    func loadUserData(completion: @escaping (UserViewModel?) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            
            guard let data = FileManagement.readFromDisk(fileName: Constants.userDataFileName),
                  let user = try? JSONDecoder().decode(User.self, from: data)
            else { return completion(nil) }
            
            var image: UIImage?
            if let imageData = FileManagement.read(fileName: Constants.userImageFileName) {
                image = UIImage(data: imageData)
            }
            
            completion(.init(fullName: user.fullName, description: user.description, profileImage: image))
        }
    }
    
    func saveUserData(_ userViewModel: UserViewModel, completion: ((Bool) -> Void)? = nil) {
        DispatchQueue.global(qos: .utility).async {
            var imageSavedSuccessfully = false
            var dataSavedSuccessfully = false
            
            if let imageData = userViewModel.profileImage?.pngData() {
                imageSavedSuccessfully = FileManagement.writeToDisk(data: imageData, fileName: Constants.userImageFileName)
            } else if userViewModel.profileImage == nil {
                imageSavedSuccessfully = true
            }
            
            let person = User(fullName: userViewModel.fullName, description: userViewModel.description, profileImageUrl: Constants.userImageFileName)
            
            if let data = try? JSONEncoder().encode(person),
               FileManagement.writeToDisk(data: data, fileName: Constants.userDataFileName) == true {
                dataSavedSuccessfully = true
            }
            
            if let completion = completion {
                completion(imageSavedSuccessfully && dataSavedSuccessfully)
            }
        }
    }
}
