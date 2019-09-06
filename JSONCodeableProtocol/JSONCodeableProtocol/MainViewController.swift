//
//  MainViewController.swift
//  JSONCodeableProtocol
//
//  Created by Ryan Rottmann on 9/5/19.
//  Copyright © 2019 Ryan Rottmann. All rights reserved.
//

import UIKit
import Foundation

struct Photo: Codable {
    let image: String
    let title: String
    let description: String
    let latitude: Double
    let longitude: Double
    let date: String
}

enum error1: Error{
    case error2(String)
}

struct Response<Element: Codable>: Codable {
    enum Status: String, Codable {
        case ok
        case error
    }
    var status: Response.Status
    var photos: [Element]
}

class MainViewController: UIViewController {
    
    var photoArray = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }// end of viewDidLoad
    
    func getData(){
        let url = "https://dalemusser.com/code/examples/data/nocaltrip/photos.json"
        let urlObj = URL(string: url)
        URLSession.shared.dataTask(with: urlObj!){(data, response, error) in
            guard let dataResponse = data, error == nil else{
                print(error?.localizedDescription ?? "Error loading URL")
                return
            }
            do{
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response<Photo>.self, from: dataResponse)
                if response.status == Response.Status.ok {
                    self.photoArray = response.photos
                } else{
                    throw error1.error2("error decoding")
                }
                for photo in self.photoArray{// for loop to print photoArray
                    print(photo)
                }
            } catch{
                print("error", error1.self)
            }
        }.resume()// end of URLSession
    }
}
