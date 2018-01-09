//
//  UsersApiService.swift
//  TestExercise
//
//  Created by Admin on 04.01.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Moya

class UsersApiService : TargetType {
    var baseURL: URL {return URL(string: "https://jsonplaceholder.typicode.com")!}
    
    var path: String{ return "/users" }
    
    var method: Moya.Method {return .get}
    
    var sampleData: Data {return Data() }
    
    var task: Task {return .requestPlain}
    
    var headers: [String : String]? {return ["Content-type": "application/json"]}
    
}
