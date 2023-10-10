//
//  Custom Navigation Bar.swift
//  MARS
//
//  Created by Olena Makhobei on 03/10/2023.
//

import Foundation
import UIKit

@IBDesignable

class CustomNavigationBar: UIView{
 
    var delegate: NavBarLisener?
 
    @IBOutlet weak var customeView: UIView!
    
    @IBOutlet weak var roverFltr: UIButton!
    
    @IBOutlet weak var cameraFltr: UIButton!
    
    @IBOutlet weak var calendar: UIButton!
    
    @IBOutlet weak var saveFltr: UIButton!
    
    @IBOutlet weak var dateLBl: UILabel!
    
    @IBOutlet weak var MARSName: UILabel!
    
    
    @IBAction func onCalendarPressed(_ sender: Any) {
          delegate?.onCalendarPressed()
    
    }
    
    @IBAction func onSavePressed(_ sender: Any) {
        delegate?.onSaveFiltrButtnPressed()
    }
    
    @IBAction func onCameraPressed(_ sender: Any) {
        delegate?.onCameraFltrPressed(sender: "Camera")
        
    }
    
    @IBAction func onRoverPressed(_ sender: Any) {
        delegate?.onCameraFltrPressed(sender: "CPU")

    }
        
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           commonInit()
       }
    
    
   func  addAttributeToButtons(){
       let iconForSaveFilter = UIImage(named: "add-circle")
       saveFltr.setImage(iconForSaveFilter, for: .normal)
       saveFltr.imageView?.contentMode = .scaleAspectFit
       saveFltr.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)

       
       let iconForCameraFilter = UIImage(named:"camera")
       cameraFltr.setImage(iconForCameraFilter, for: .normal)
       cameraFltr.imageView?.contentMode = .scaleAspectFit
       cameraFltr.imageEdgeInsets = UIEdgeInsets(top: 0, left: -45, bottom: 0, right: 0)

    
       let iconForRoverFilter = UIImage(named:"cpu")
       roverFltr.setImage(iconForRoverFilter, for: .normal)
       roverFltr.imageView?.contentMode = .scaleAspectFit
       roverFltr.imageEdgeInsets = UIEdgeInsets(top: 0, left: -45, bottom: 0, right: 0)
       
       cameraFltr.layer.cornerRadius = 10
       roverFltr.layer.cornerRadius = 10
       calendar.layer.cornerRadius = 10
       saveFltr.layer.cornerRadius = 10
       
   }
    
    private func commonInit() {
         let bundle = Bundle(for: CustomNavigationBar.self)
         bundle.loadNibNamed("CustomNavigationBar", owner: self, options: nil)
         addSubview(customeView)
         addAttributeToButtons()
        
        customeView.frame = self.bounds
        customeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
     }

    
}
