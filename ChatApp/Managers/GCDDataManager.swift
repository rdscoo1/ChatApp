//
//  GCDDataManager.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/18/21.
//

import UIKit

class GCDDataManager: DataManager {

    // MARK: - DataManager methods
    
    func loadUserData(completion: @escaping (UserViewModel?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            
            guard let data = FileManagement.readFromDisk(fileName: Constants.userDataFileName),
                  let user = try? JSONDecoder().decode(User.self, from: data)
            else { return completion(nil) }
  
            var image: UIImage? = nil
            if let profileImageUrl = user.profileImageUrl,
                let imageData = FileManagement.read(url: profileImageUrl) {
                image = UIImage(data: imageData)
            }
            
            completion(.init(fullName: user.fullName, description: user.description, profileImage: image))
        }
    }
    
    func saveUserData(_ userViewModel: UserViewModel, completion: ((Bool) -> ())? = nil) {
        DispatchQueue.global(qos: .utility).async {
            var imageSavedSuccessfully = false
            var dataSavedSuccessfully = false
            
            var imageUrl: URL? = nil
            if let imageData = userViewModel.profileImage?.pngData() {
                (imageSavedSuccessfully, imageUrl) =
                    FileManagement.writeToDisk(data: imageData, fileName: Constants.userImageFileName)
            } else if userViewModel.profileImage == nil {
                imageSavedSuccessfully = true
            }
            
            let person = User(fullName: userViewModel.fullName, description: userViewModel.description, profileImageUrl: imageUrl)
            
            if let data = try? JSONEncoder().encode(person),
               FileManagement.writeToDisk(data: data, fileName: Constants.userDataFileName).isSuccessful {
                dataSavedSuccessfully = true
            }
            
            if let completion = completion {
                completion(imageSavedSuccessfully && dataSavedSuccessfully)
            }
        }
    }
}

