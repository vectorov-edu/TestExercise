import Foundation
import Moya

class UserListDataController {
    let repository : CoreDataRepository
    
    init(repo : CoreDataRepository){
        repository = repo
    }
    
    func GetDataForViewController(completion : @escaping ([UserDataModel]) -> ()) {
        
        if repository.GetSavedUserCount() > 0 {
            let userDatas = repository.GetUsersData()
            completion(userDatas)
        }else {
            GetDataFromNet(completion: completion)
        }
    }
    
    func GetDataFromNet(completion : @escaping ([UserDataModel]) -> ()){
        let request = MoyaProvider<UsersApiService>()
        request.request(UsersApiService()) { [weak self, completion] result in
            switch result {
            case let .success(moyaResponse):
                //let data = moyaResponse.data
                
                if let users = try? moyaResponse.map([UserDataJsonModel].self) {//JSONDecoder().decode([UserDataJsonModel].self, from: data) {
                    var userList = [UserDataModel]()
                    for user in users {
                        let comment = String(repeating: user.username!, count: Int(arc4random_uniform(20)))
                        userList.append(
                            UserDataModel(id: user.id!,
                                          name: user.name!,
                                          username: user.username!,
                                          phone: user.phone!,
                                          latitude: user.address?.geo?.lat ?? 0,
                                          longitude: user.address?.geo?.lng ?? 0,
                                          comment: comment))
                    }
                    self?.repository.SaveUsersData(users: userList)
                    completion(userList)
                }
                
            case let .failure(error):
                break
            }
            
        }
    }
}
