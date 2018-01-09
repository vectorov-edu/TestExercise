//
//  CoreDataRepository.swift
//  TestExercise
//
//  Created by Admin on 06.01.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataRepository {
    let container = AppDelegate.persistentContainer
    
    func GetUsersData() -> [UserDataModel] {
        let savedUserData = try? SavedUserData.GetAll(from: container.viewContext)
            
        var users = [UserDataModel]()
        users = (savedUserData?.map{
            return UserDataModel(id: Int($0.id), name: $0.name!, username: $0.userName!, phone: $0.phone!, latitude: $0.latitude, longitude: $0.longitude, comment: $0.comment!)
            })!
        
        return users
    }

    func GetSavedUserCount() -> Int {
        guard let count = try? container.viewContext.count(for: SavedUserData.fetchRequest()) else {return 0}
        
        return count
    }
    
    func SaveUsersData(users : [UserDataModel]) {
        container.performBackgroundTask{[users] context in
            for user in users {
                try? SavedUserData.createOrUpdate(userData: user, in: context)
            }
            try? context.save()
        }
    }
}
