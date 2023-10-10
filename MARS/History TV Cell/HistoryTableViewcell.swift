//
//  HistoryTableViewcell.swift
//  MARS
//
//  Created by Olena Makhobei on 05/10/2023.
//

import UIKit

class HistoryTableViewcell: UITableViewCell {
    
    @IBOutlet weak var backgrndView: UIView!
    @IBOutlet weak var cameraDate: UILabel!
    @IBOutlet weak var roverData: UILabel!
    @IBOutlet weak var dateData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func  setUpUI(){
        backgrndView.layer.cornerRadius = 20
        backgrndView.layer.masksToBounds = false
        backgrndView.layer.shadowColor = UIColor.black.cgColor
        backgrndView.layer.shadowOffset = CGSize(width: 0, height: 5)
        backgrndView.layer.shadowOpacity = 0.1
        backgrndView.layer.shadowRadius = 8
    }
    
  
    func transformCodeCameraValueToName(value: String) -> String{
        var returnedValue = ""
        switch (value){
        case "FHAZ":
            returnedValue = "Front Hazard Avoidance Camera"
        case "RHAZ" :
            returnedValue = "Rear Hazard Avoidance Camera"
        case  "MAST" :
            returnedValue = "Mast Camera"
        case "CHEMCAM" :
            returnedValue = "Chemistry and Camera Complex"
        case "MAHLI" :
            returnedValue = "Mars Hand Lens Imager"
        case "MARDI" :
            returnedValue = "Mars Descent Imager"
        case "NAVCAM" :
            returnedValue = "Navigation Camera"
        case "PANCAM":
            returnedValue = "Panoramic Camera"
        case "MINITES" :
            returnedValue = "Miniature Thermal Emission Spectrometer (Mini-TES)"
        default:
            returnedValue = "Front Hazard Avoidance Camera"
        }
        return returnedValue
    }
}
