//
//  OperationProfileDataManager.swift
//  ChatApp
//
//  Created by Roman Khodukin on 3/18/21.
//

import UIKit

class OperationProfileDataManager: IUserStorageManager {
    
    // MARK: - Private properties
    
    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .utility
        return queue
    }()
    
    // MARK: - IUserStorageManager methods
    
    func loadUserData(completion: @escaping (UserViewModel?) -> Void) {
        let operation = LoadUserDataOperation(completion: completion)
        operationQueue.addOperation(operation)
    }
    
    func saveUserData(_ user: UserViewModel, completion: ((Bool) -> Void)? = nil) {
        let operation = SaveUserDataOperation(userViewModel: user, completion: completion)
        operationQueue.addOperation(operation)
    }
    
    // MARK: - Operation classes
    
    class LoadUserDataOperation: Operation {
        var completion: (UserViewModel?) -> Void
        
        init(completion: @escaping (UserViewModel?) -> Void) {
            self.completion = completion
        }
        
        override func main() {
            guard !isCancelled,
                  let data = FileManagement.readFromDisk(fileName: Constants.userDataFileName),
                  let user = try? JSONDecoder().decode(User.self, from: data)
            else { return completion(nil) }
            
            guard !isCancelled else { return completion(nil) }
            
            var image: UIImage?
            if let profileImageUrl = user.profileImageUrl,
               let imageData = FileManagement.read(fileName: profileImageUrl) {
                image = UIImage(data: imageData)
            }
            
            completion(.init(fullName: user.fullName, description: user.description, profileImage: image))
        }
    }
    
    class SaveUserDataOperation: Operation {
        
        private var userViewModel: UserViewModel
        private var completion: ((Bool) -> Void)?
        
        init(userViewModel: UserViewModel, completion: ((Bool) -> Void)? = nil) {
            self.userViewModel = userViewModel
            self.completion = completion
        }
        
        override func main() {
            var imageSavedSuccessfully = false
            var dataSavedSuccessfully = false
            
            if let imageData = userViewModel.profileImage?.pngData() {
                imageSavedSuccessfully = FileManagement.writeToDisk(data: imageData, fileName: Constants.userImageFileName)
            } else if userViewModel.profileImage == nil {
                imageSavedSuccessfully = true
            }
            
            let user = User(fullName: userViewModel.fullName, description: userViewModel.description, profileImageUrl: Constants.userImageFileName)
            
            if let data = try? JSONEncoder().encode(user),
               FileManagement.writeToDisk(data: data, fileName: Constants.userDataFileName) == true {
                dataSavedSuccessfully = true
            }
            
            if let completion = completion {
                completion(imageSavedSuccessfully && dataSavedSuccessfully)
            }
        }
    }
}
