//
//  TableViewCell.swift
//  MARS
//
//  Created by Olena Makhobei on 03/10/2023.
//

import UIKit
import Foundation

class MarsTableViewCell: UITableViewCell {
    
    var delegateOfViewController:CellLisener?

    @IBOutlet weak var backgrndView: UIView!
    
    @IBOutlet weak var roverData: UILabel!
        
    @IBOutlet weak var cardImage: UIImageView!
    
    @IBOutlet weak var cameraLabelForShortName: UILabel!
    
    @IBOutlet weak var capturedInfoCamera: UILabel!
    
    @IBOutlet weak var capturedDate: UILabel!
        
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        delegateOfViewController?.onImageTapped(url: cardImage.moa.url)
    }
 
    
    func  setUpUI(){
        cardImage.layer.cornerRadius = 20
        backgrndView.layer.cornerRadius = 20
        backgrndView.layer.masksToBounds = false
        backgrndView.layer.shadowColor = UIColor.black.cgColor
        backgrndView.layer.shadowOffset = CGSize(width: 0, height: 5)
        backgrndView.layer.shadowOpacity = 0.1
        backgrndView.layer.shadowRadius = 8
    }
    
    func addGRToImage(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cardImage.isUserInteractionEnabled = true
        cardImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
        addGRToImage()
     

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        }
    
}



