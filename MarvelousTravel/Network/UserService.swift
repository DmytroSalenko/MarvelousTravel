//
//  UserService.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/2/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

extension Encodable {
  var dictionaryValue:[String: Any?]? {
      guard let data = try? JSONEncoder().encode(self), let dictionary = try? JSONSerialization.jsonObject(with: data,                                                           options: .allowFragments) as? [String: Any] else {
      return nil
    }
    return dictionary
  }
}

class UserService {
    private var urlSession: URLSession
    private lazy var jsonDecoder = JSONDecoder()

    public init(config:URLSessionConfiguration) {
        urlSession = URLSession(configuration: config)
    }
    
    func logIn(_ loginModel: SignInData, onSuccess: @escaping (AuthToken) -> (), onError: @escaping (Error?) -> ()) throws {
        var request = URLRequest(url:
              URL(string:"http://localhost:3000/api/sign")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField:
                  "Content-Type")
        let payloadData = try? JSONSerialization.data(withJSONObject: loginModel.dictionaryValue!, options: [])
        request.httpBody = payloadData
        
        let task = self.urlSession.dataTask(with: request) {
            (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                do {
                    let _data = data ?? Data()
                    if (200...399).contains(statusCode) {
                        let objs = try self.jsonDecoder.decode(AuthToken.self, from: _data)
                        onSuccess(objs)
                    } else {
                        onError(error)
                    }
                } catch {
                    onError(error)
                }
            }
        }
        task.resume()
    }

    func checkEmailAvailability(email: String, onCompletion: @escaping (Bool) -> ()) {
        var request = URLRequest(url:
              URL(string:"http://localhost:3000/api/check_email")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField:
                  "Content-Type")
        let payloadDict = ["email": email]
        let payloadData = try? JSONSerialization.data(withJSONObject: payloadDict, options: [])
        request.httpBody = payloadData
        let task = self.urlSession.dataTask(with: request) {
            (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if (200...399).contains(statusCode) {
                    onCompletion(true)
                } else {
                    onCompletion(false)
                }
            }
        }
        task.resume()
    }
    
    func registerUser(_ signUpModel: SignUpData, onSuccess: @escaping (User) -> (), onError: @escaping (Error?) -> ()) throws {
        var request = URLRequest(url:
              URL(string:"http://localhost:3000/api/users")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField:
                  "Content-Type")
        let payloadData = try? JSONSerialization.data(withJSONObject: signUpModel.dictionaryValue!, options: [])
        request.httpBody = payloadData
        
        let task = self.urlSession.dataTask(with: request) {
            (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                do {
                    let _data = data ?? Data()
                    if (200...399).contains(statusCode) {
                        let objs = try self.jsonDecoder.decode(User.self, from: _data)
                        let defaults = UserDefaults.standard
                        defaults.set(objs._id, forKey: "user_id")
                        onSuccess(objs)
                    } else {
                        onError(error)
                    }
                } catch {
                    onError(error)
                }
            }
        }
        task.resume()
    }
    
    func sendUserIcon(_ iconToSend: UIImage, onSuccess: @escaping (User)->(), onError: @escaping (Error?) -> ()) throws {
        let defaults = UserDefaults.standard
        let user_id = defaults.object(forKey: "user_id")
        guard let id = user_id else { return }
        var request = URLRequest(url: URL(string:"http://localhost:3000/api/upload/icon/\(id)")!)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBody(parameters: [:],
                                      boundary: boundary,
                                      data: iconToSend.jpegData(compressionQuality: 0.9)!,
                                      mimeType: "image/jpg",
                                      filename: "hello.jpg")
        
        let task = self.urlSession.dataTask(with: request) {
            (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                do {
                    let _data = data ?? Data()
                    if (200...399).contains(statusCode) {
                        let objs = try self.jsonDecoder.decode(User.self, from: _data)
                        onSuccess(objs)
                    } else {
                        onError(error)
                    }
                } catch {
                    onError(error)
                }
            }
        }
        task.resume()
    }
    
    func updateUserCity(_ cityModel: City, onSuccess: @escaping (User)->(), onError: @escaping (Error?) -> ()) throws {
        let defaults = UserDefaults.standard
        let user_id = defaults.object(forKey: "user_id")
        guard let id = user_id else { return }
        var request = URLRequest(url:
            URL(string:"http://localhost:3000/api/users/\(id)")!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let payloadDict = ["city_of_living": cityModel]
        let payloadData = try? JSONSerialization.data(withJSONObject: payloadDict, options: [])
        request.httpBody = payloadData
    }
    
    func createBody(parameters: [String: String],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    func getSingleUser(completion : @escaping (User?, NSError?) -> Void) {
            
        guard let url = URL(string: "http://localhost:3000/api/users/5e39f1743c545b2ce181f20d") else {return}
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
    //        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {return}
           // request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    if let json = try? JSON(data: data) {
                        let user = User()
                        user._id = json["_id"].stringValue
                        user.email = json["email"].stringValue
                        user.first_name = json["first_name"].stringValue
                        user.last_name = json["last_name"].stringValue
                        for item in json["chats"].arrayValue {
                            user.chats.append(item.stringValue)
                        }
                        for item in json["trips"].arrayValue {
                            user.trips.append(item.stringValue)
                        }
                        completion(user, nil)
                    }
                }else {
                    completion(nil, error as! NSError)
                }
            }.resume()
            
        }
    
    
    func getMiniPicture(completion : @escaping (UIImage?, NSError?) -> Void) {
            
            guard let url = URL(string: "http://localhost:3000/api/users/icon/5e45f3e5124afa2403d92a9e") else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let session = URLSession.shared
            session.dataTask(with: request) {(data, response, error) in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    let image = UIImage(data: data)
                    guard let mini = image else {return}
                    completion(mini, nil)
                } else {
                    completion(nil, error as! NSError)
                }
                
            }.resume()
            
        }
    }

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
