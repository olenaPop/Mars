//
//  ImageViewController.swift
//  MARS
//
//  Created by Olena Makhobei on 05/10/2023.
//

import Foundation
import UIKit
import  moa
class ImageViewController: UIViewController{
    
    var urlString: String? = nil
    let buttonClose = UIButton(type: .custom)

   
    @IBOutlet weak var detailedImg: UIImageView!
    
    @objc private func closePicker(){
        view.backgroundColor = .white.withAlphaComponent(0.08)
        dismiss(animated: true)
    }
    
    func closeBttn(){
        buttonClose.translatesAutoresizingMaskIntoConstraints = false
        buttonClose.setImage(UIImage(named: "close_light"), for: .normal)
        buttonClose.addTarget(self, action: #selector(closePicker), for: .touchUpInside)
        buttonClose.superview?.bringSubviewToFront(buttonClose)
        buttonClose.setTitleColor(.white, for: .normal)

        view.addSubview(buttonClose)
        
        NSLayoutConstraint.activate([
            buttonClose.heightAnchor.constraint(equalToConstant: 40),
            buttonClose.widthAnchor.constraint(equalToConstant: 40),
            buttonClose.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            buttonClose.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailedImg.moa.url  = urlString
        closeBttn()
    }
}
