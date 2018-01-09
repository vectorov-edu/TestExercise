
import UIKit
import CoreData

protocol SavedUserDataProtocol {
    var id : Int? {get set}
    var name: String? {get set}
    var username : String? {get set}
    var phone : String? {get set}
    var latitude : Double? {get set}
    var longitude : Double? {get set}
    var comment : String? {get set}
}


class SavedUserData: NSManagedObject {
    
    static func GetAll(from context: NSManagedObjectContext) throws  -> [SavedUserData] {
        
        let request: NSFetchRequest<SavedUserData> = SavedUserData.fetchRequest()
        //request.predicate = NSPredicate(format: "id == %@", tweetInfo.id)
        let idSortDescr = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [idSortDescr]

        do {
            let matches = try context.fetch(request)
            
            return matches
        } catch {
            throw error
        }
    }
    
    static func createOrUpdate(userData: SavedUserDataProtocol, in context: NSManagedObjectContext) throws {

        let request: NSFetchRequest<SavedUserData> = SavedUserData.fetchRequest()
        do {
            request.predicate = try NSPredicate(format: "id = %ld", userData.id!)
        } catch {
            throw error
        }
        

        func fillData( userData : SavedUserDataProtocol, saveUserData: inout SavedUserData) {
            saveUserData.id = Int64(userData.id!)
            saveUserData.userName = userData.username
            saveUserData.name = userData.name
            saveUserData.phone = userData.phone
            if let lat = userData.latitude {
                saveUserData.latitude = lat
            }
            if let long = userData.longitude {
                saveUserData.longitude = long
            }
            saveUserData.comment = userData.comment
        }
        
        do {
            let matches = try context.fetch(request)
            assert(matches.count <= 1, "Oops, too much entries")
            if matches.count == 1 {
                var saveUserData = matches[0]
                
                fillData(userData: userData, saveUserData: &saveUserData)
            }
        } catch {
            throw error
        }

        var saveUserData = SavedUserData(context: context)
        fillData(userData: userData, saveUserData: &saveUserData)
    }
}
