//
//  Data Structure.swift
//  MARS
//
//  Created by Olena Makhobei on 05/10/2023.
//


import SwiftyJSON
import UIKit
import Foundation


struct NASAResponse: Codable{
    
    var photos: [NASAPhoto]
    init(_ json: JSON){
        photos = json["photos"].arrayValue.map{NASAPhoto($0)}
    }
}

struct NASAPhoto: Codable{
    var id: Int
    var sol: Int
    var camera: Camera
    var img_src: String
    var earth_date: String
    var rover: Rover
    init(_ json: JSON){
        id = json["id"].intValue
        sol = json["sol"].intValue
        camera = Camera(json["camera"])
        img_src = json["img_src"].stringValue
        earth_date = json["earth_date"].stringValue
        rover = Rover(json["rover"])
    }
}


struct Camera: Codable{
    var id: Int
    var name: String
    var rover_id: Int
    var full_name: String
    
    init(_ json: JSON){
        id = json["id"].intValue
        name = json["name"].stringValue
        rover_id = json["rover_id"].intValue
        full_name = json["full_name"].stringValue
    }
    
}

struct Rover: Codable{
    var id: Int
    var name: String
    var landing_date: String
    var launch_date: String
    var status: String
    var max_sol: Int
    var  max_date: String
    var total_photos: Int
    var cameras: [CamerasList]
    
    init(_ json: JSON){
        id = json["id"].intValue
        name = json["name"].stringValue
        launch_date = json["launch_date"].stringValue
        landing_date = json["landing_date"].stringValue
        status = json["status"].stringValue
        max_sol = json["max_sol"].intValue
        max_date = json["max_date"].stringValue
        total_photos = json["total_photos"].intValue
        cameras = json["cameras"].arrayValue.map{CamerasList($0)}
    }
    
}


struct CamerasList: Codable{
    var name: String
    var full_name: String
    
    init(_ json: JSON){
        name = json["name"].stringValue
        full_name = json["full_name"].stringValue
        
    }
}
