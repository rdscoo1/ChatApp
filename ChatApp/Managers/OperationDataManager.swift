//
//  OperationDataManager.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/18/21.
//

import UIKit

class OperationDataManager: DataManager {
    
    // MARK: - Private properties
    
    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .utility
        return queue
    }()
    
    // MARK: - DataManager methods
    
    func loadUserData(completion: @escaping (UserViewModel?) -> ()) {
        let operation = LoadUserDataOperation(completion: completion)
        operationQueue.addOperation(operation)
    }
    
    func saveUserData(_ user: UserViewModel, completion: ((Bool) -> ())? = nil) {
        let operation = SaveUserDataOperation(userViewModel: user, completion: completion)
        operationQueue.addOperation(operation)
    }
    
    // MARK: - Operation classes
    
    class LoadUserDataOperation: Operation {
        var completion: (UserViewModel?) -> ()
        
        init(completion: @escaping (UserViewModel?) -> ()) {
            self.completion = completion
        }
        
        override func main() {
            guard !isCancelled,
                  let data = FileManagement.readFromDisk(fileName: Constants.userDataFileName),
                  let user = try? JSONDecoder().decode(User.self, from: data)
            else { return completion(nil) }
            
            guard !isCancelled else { return completion(nil) }
            
            var image: UIImage? = nil
            if let profileImageUrl = user.profileImageUrl,
               let imageData = FileManagement.read(url: profileImageUrl) {
                image = UIImage(data: imageData)
            }
            
            completion(.init(fullName: user.fullName, description: user.description, profileImage: image))
        }
    }
    
    class SaveUserDataOperation: Operation {
        
        private var userViewModel: UserViewModel
        private var completion: ((Bool) -> ())?
        
        init(userViewModel: UserViewModel, completion: ((Bool) -> ())? = nil) {
            self.userViewModel = userViewModel
            self.completion = completion
        }
        
        override func main() {
            var imageSavedSuccessfully = false
            var dataSavedSuccessfully = false
            
            var imageUrl: URL? = nil
            if let imageData = userViewModel.profileImage?.pngData() {
                (imageSavedSuccessfully, imageUrl) =
                    FileManagement.writeToDisk(data: imageData, fileName: Constants.userImageFileName)
            } else if userViewModel.profileImage == nil {
                imageSavedSuccessfully = true
            }
            
            let user = User(fullName: userViewModel.fullName, description: userViewModel.description, profileImageUrl: imageUrl)
            
            if let data = try? JSONEncoder().encode(user),
               FileManagement.writeToDisk(data: data, fileName: Constants.userDataFileName).isSuccessful {
                dataSavedSuccessfully = true
            }
            
            if let completion = completion {
                completion(imageSavedSuccessfully && dataSavedSuccessfully)
            }
        }
    }
}
