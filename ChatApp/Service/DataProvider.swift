//
//  DataProvider.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/27/21.
//

import UIKit

class DataProvider {

    func getConversations() -> [ConversationCellModel] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        return [
            .init(photo: UIImage(imageLiteralResourceName: "man1"),
                  name: "Roberto Benito",
                  message: "Good question - I am still trying to figure that out!",
                  date: Date(),
                  isOnline: true,
                  hasUnreadMessages: false),
            .init(photo: UIImage(imageLiteralResourceName: "man2"),
                  name: "Kris Meningem",
                  message: "If two wrongs don't make a right, try three.",
                  date: dateFormatter.date(from: "05-03-2021 00:01"),
                  isOnline: true,
                  hasUnreadMessages: true),
            .init(photo: UIImage(imageLiteralResourceName: "woman1"),
                  name: "Milton Berle",
                  message: "A committee is a group that keeps minutes and loses hours.",
                  date: Date(),
                  isOnline: false,
                  hasUnreadMessages: false),
            .init(photo: UIImage(imageLiteralResourceName: "man3"),
                  name: "Steve Martin",
                  message: "A day without sunshine is like, you know, night.",
                  date: dateFormatter.date(from: "02-02-2021 18:32"),
                  isOnline: false,
                  hasUnreadMessages: true),
            .init(photo: UIImage(imageLiteralResourceName: "woman2"),
                  name: "Jane Milner",
                  message: "It takes considerable knowledge just to realize the extent of your own ignorance.",
                  date: dateFormatter.date(from: "10-02-2021 20:40"),
                  isOnline: true,
                  hasUnreadMessages: true),
            .init(photo: UIImage(imageLiteralResourceName: "man4"),
                  name: "William Feather",
                  message: nil,
                  date: nil,
                  isOnline: false,
                  hasUnreadMessages: false),
            .init(photo: UIImage(imageLiteralResourceName: "man5"),
                  name: "James Pillment",
                  message: "You are a great example for others.",
                  date: dateFormatter.date(from: "20-01-2021 21:45"),
                  isOnline: true,
                  hasUnreadMessages: false),
            .init(photo: UIImage(imageLiteralResourceName: "man1"),
                  name: "James Pillment",
                  message: "You are a great example for others.",
                  date: dateFormatter.date(from: "20-01-2021 21:50"),
                  isOnline: true,
                  hasUnreadMessages: false),
            .init(photo: UIImage(imageLiteralResourceName: "man2"),
                  name: "Kelvin Pillment",
                  message: "You are a great example for others.",
                  date: dateFormatter.date(from: "20-01-2021 21:49"),
                  isOnline: true,
                  hasUnreadMessages: false),
            .init(photo: UIImage(imageLiteralResourceName: "man3"),
                  name: "Piter Pillment",
                  message: "You are a great example for others.",
                  date: dateFormatter.date(from: "21-01-2021 21:51"),
                  isOnline: true,
                  hasUnreadMessages: false),
            .init(photo: UIImage(imageLiteralResourceName: "woman3"),
                  name: "Messy Pinkman",
                  message: "When I grow up I want to be you!",
                  date: dateFormatter.date(from: "15-01-2021 22:50"),
                  isOnline: true,
                  hasUnreadMessages: true),
            .init(photo: UIImage(imageLiteralResourceName: "man3"),
                  name: "Terry Jones",
                  message: "How are you?",
                  date: dateFormatter.date(from: "31-12-2020 23:59"),
                  isOnline: true,
                  hasUnreadMessages: true),
            .init(photo: UIImage(imageLiteralResourceName: "man1"),
                  name: "Mathew Simons",
                  message: "",
                  date: nil,
                  isOnline: true,
                  hasUnreadMessages: false),
            .init(photo: UIImage(imageLiteralResourceName: "man3"),
                  name: "John Martin",
                  message: "A day without sunshine is like, you know, night.",
                  date: dateFormatter.date(from: "02-02-2021 18:31"),
                  isOnline: false,
                  hasUnreadMessages: true),
            .init(photo: UIImage(imageLiteralResourceName: "man5"),
                  name: "Kristian Martin",
                  message: "A day without sunshine is like, you know, night.",
                  date: dateFormatter.date(from: "14-02-2021 18:05"),
                  isOnline: false,
                  hasUnreadMessages: false),
            .init(photo: UIImage(imageLiteralResourceName: "man4"),
                  name: "Ben Pin",
                  message: "A day without sunshine is like, you know, night.",
                  date: dateFormatter.date(from: "12-02-2021 18:10"),
                  isOnline: false,
                  hasUnreadMessages: true),
            .init(photo: UIImage(imageLiteralResourceName: "man3"),
                  name: "Morty Molin",
                  message: "A day without sunshine is like, you know, night.",
                  date: dateFormatter.date(from: "05-02-2021 18:45"),
                  isOnline: false,
                  hasUnreadMessages: false),
            .init(photo: UIImage(imageLiteralResourceName: "man2"),
                  name: "Garry Lin",
                  message: "A day without sunshine is like, you know, night.",
                  date: dateFormatter.date(from: "03-02-2021 18:32"),
                  isOnline: false,
                  hasUnreadMessages: true),
            .init(photo: UIImage(imageLiteralResourceName: "man1"),
                  name: "Ken John",
                  message: "A day without sunshine is like, you know, night.",
                  date: dateFormatter.date(from: "07-02-2021 18:50"),
                  isOnline: false,
                  hasUnreadMessages: true),
            .init(photo: UIImage(imageLiteralResourceName: "woman2"),
                  name: "Molly Barnes",
                  message: nil,
                  date: nil,
                  isOnline: false,
                  hasUnreadMessages: false)
        ]
    }
    
    func getMessages() -> [MessageCellModel] {
        return [
            .init(text: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum",
                  direction: .incoming),
            .init(text: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis",
                  direction: .incoming),
            .init(text: "Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem.",
                  direction: .outgoing),
            .init(text: "Sed consequat",
                  direction: .incoming),
            .init(text: "Maecenas",
                  direction: .outgoing),
            .init(text: "Integer tincidunt. Cras dapibus.",
                  direction: .outgoing),
            .init(text: "Penatibus et magnis dis parturient montes, nascetur ridiculus mus",
                  direction: .incoming),
            .init(text: "Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec.",
                  direction: .incoming),
            .init(text: "Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac",
                  direction: .incoming),
            .init(text: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum",
                  direction: .incoming),
            .init(text: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis",
                  direction: .incoming),
            .init(text: "Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem.",
                  direction: .outgoing),
            .init(text: "Sed consequat",
                  direction: .incoming),
            .init(text: "Maecenas",
                  direction: .outgoing),
            .init(text: "Integer tincidunt. Cras dapibus.",
                  direction: .outgoing),
            .init(text: "Penatibus et magnis dis parturient montes, nascetur ridiculus mus",
                  direction: .incoming),
            .init(text: "Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec.",
                  direction: .incoming),
            .init(text: "Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac",
                  direction: .incoming),
            .init(text: "Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id.",
                  direction: .outgoing),
            .init(text: "Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc",
                  direction: .incoming),
            .init(text: "Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum.",
                  direction: .outgoing),
            .init(text: "Cras dapibus.",
                  direction: .outgoing),
            .init(text: "Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus.",
                  direction: .incoming),
        ]
    }
    
}
