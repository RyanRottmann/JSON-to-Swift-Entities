//
//  MainViewController.swift
//  JSONSerialization
//
//  Created by Ryan Rottmann on 9/5/19.
//

import UIKit
import Foundation

struct Photo {
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
struct Response<Element>{
    enum Status: String{
        case ok
        case error
    }
    var status: Response.Status
    var photos: [Element]
    init(_ dictionary: [String: Any]){
        self.status = dictionary["status"] as? Response.Status ?? Response.Status.error
        self.photos = dictionary["photos"] as? [Element] ?? []
    }
}

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            try getData()
        } catch{
            print(error.localizedDescription)
        }
    }// end of viewDidLoad
    
    func getData() throws{
        let url = "https://dalemusser.com/code/examples/data/nocaltrip/photos.json"
        let urlObj = URL(string: url)
        
        URLSession.shared.dataTask(with: urlObj!){(data, response, error) in
            guard let dataResponse = data,
            error == nil else{
                print(error?.localizedDescription ?? "Response Error")
                return
            }
            do{
                guard let json = try? JSONSerialization.jsonObject(with: dataResponse, options: []),
                    let root = json as? [String: Any] else{
                        throw error1.error2("parsing error")
                }
                if let status = root["status"]{
                    if let status = status as? Response<Photo>.Status{
                        if status == Response<Photo>.Status.error{
                            throw error1.error2("errorStatus")
                        }
                    }
                }
                var photoArray = [Photo]()
                if let photos = root["photos"] as? [[String: Any]]{
                    for photo in photos{
                        if let image = photo["image"] as? String,
                        let title = photo["title"] as? String,
                            let latitude = photo["latitude"] as? Double,
                            let longitude = photo["longitude"] as? Double,
                            let description = photo["description"] as? String,
                            let date = photo["date"] as? String {
                            
                            photoArray.append(Photo(image: image, title: title, description: description, latitude:latitude, longitude: longitude, date: date))// adds
                            print (photo)// prints photo after being appended to array
                        }// for loop to add photo to photoArray
                    }
                }
            } catch{
                print ("error", error1.self)
            }
        }.resume()// end of URLSession
    }

}
