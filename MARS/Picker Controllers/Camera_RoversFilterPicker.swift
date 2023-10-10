//
//  CameraFilterPicker.swift
//  MARS
//
//  Created by Olena Makhobei on 04/10/2023.
//

import UIKit



class Camera_RoversFilterPicker: UIViewController {
    
    var delegateOfViewContrllr:ViewController?
    var identifier: String?
    var choosedString: String?
    
    let arraysOfCameras: [String] = ["Front Hazard Avoidance Camera",
                                  "Rear Hazard Avoidance Camera",
                                  "Mast Camera",
                                  "Chemistry and Camera Complex",
                                  "Mars Hand Lens Imager",
                                  "Mars Hand Lens Imager",
                                  "Navigation Camera",
                                  "Panoramic Camera",
                                  "Miniature Thermal Emission Spectrometer (Mini-TES)"]
    
    
    let arrayOfRovers: [String] = ["Curiosity","Opportunity","Spirit"]
    
    @IBOutlet weak var pickersName: UILabel!
    
    @IBOutlet weak var customView: UIView!
    
    @IBOutlet weak var pickerData: UIPickerView!

    @IBAction func onClosePressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onSavePressed(_ sender: Any) {
        switch identifier{
        case "Camera":
            if let choosedString = choosedString {
               let parametrToSending =  getValueFromSelectedParam(value: choosedString)
               delegateOfViewContrllr?.cameraFltr = parametrToSending
               delegateOfViewContrllr?.onFltrPicked(str: choosedString, ident: "Camera")
            }
        case "CPU":
            if let choosedString = choosedString {
                let parametrToSending = choosedString.lowercased()
                delegateOfViewContrllr?.roversFltr = parametrToSending
                delegateOfViewContrllr?.onFltrPicked(str: choosedString, ident: "CPU")
            }
        default:
            delegateOfViewContrllr?.cameraFltr = "No param"
        }
        dismiss(animated: true)
    }
 
    
    
    func setPickersName(){
        switch (identifier){
        case "Camera":
            pickersName.text = "Camera"
        case "CPU":
            pickersName.text = "Rover"
        default:
            pickersName.text = "Rover"

        }
    }
    
    
    //Transform selected camera param from picker to param which we will send to request
    func getValueFromSelectedParam(value: String) -> String{
        var returnedValue = ""
        switch (value){
        case "Front Hazard Avoidance Camera":
            returnedValue = "FHAZ"
        case "Rear Hazard Avoidance Camera":
            returnedValue = "RHAZ"
        case "Mast Camera":
            returnedValue = "MAST"
        case "Chemistry and Camera Complex":
            returnedValue = "CHEMCAM"
        case "Mars Hand Lens Imager":
            returnedValue = "MAHLI"
        case "Mars Descent Imager":
            returnedValue = "MARDI"
        case "Navigation Camera":
            returnedValue = "NAVCAM"
        case "Panoramic Camera":
            returnedValue = "PANCAM"
        case "Miniature Thermal Emission Spectrometer (Mini-TES)":
            returnedValue = "MINITES"
        default:
            returnedValue = "FHAZ"
        }
        return returnedValue
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setPickersName()
        
        pickerData.delegate = self
        pickerData.dataSource = self
        customView.layer.cornerRadius = 20
    }
}

extension Camera_RoversFilterPicker:UIPickerViewDataSource,UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch (identifier){
        case "Camera":
            return arraysOfCameras.count
        case "CPU":
            return arrayOfRovers.count
        default:
            return 1
        }
            }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch identifier{
        case "Camera":
        return arraysOfCameras[row]
        case "CPU":
            return arrayOfRovers[row]
        default:
            return "No data"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch identifier{
        case "Camera":
            choosedString = arraysOfCameras[row]
        case "CPU":
            choosedString = arrayOfRovers[row]
        default:
            choosedString = "__"
        }
    }
    

    
}
