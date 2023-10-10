//
//  CalendarPicker.swift
//  MARS
//
//  Created by Olena Makhobei on 04/10/2023.
//

import UIKit

class CalendarPicker: UIViewController {

    
    var delegateOfViewController: ViewController?
    let buttonSave = UIButton(type: .custom)
    let buttonClose = UIButton(type: .custom)
    let picker = UIDatePicker()
    let date = Date()
    let dateFormatter = DateFormatter()
    let pickersView = UIView()
    var dateToShow: Date?
    
    @IBOutlet weak var pickerView: UIView!
    
   
    @objc private func chooseDate(){
        let date = picker.date
        dateToShow = date
    }
    
    @objc private func saveDate(){
        guard let delegateOfViewController = delegateOfViewController else {return}
        delegateOfViewController.onDatePicked(value: dateToShow ?? Date())
        view.backgroundColor = .white.withAlphaComponent(0.08)
        dismiss(animated: true)
    }
    
    @objc private func closePicker(){
        view.backgroundColor = .white.withAlphaComponent(0.08)
        dismiss(animated: true)
    }
    
    
    func setUpUI(){
        
        buttonClose.translatesAutoresizingMaskIntoConstraints = false
        buttonClose.setImage(UIImage(named: "close"), for: .normal)
        buttonClose.backgroundColor = .white
        buttonClose.layer.cornerRadius =  25
        
        buttonSave.translatesAutoresizingMaskIntoConstraints = false
        buttonSave.setImage(UIImage(named: "save"), for: .normal)
        buttonSave.backgroundColor = .white
        buttonSave.layer.cornerRadius =  25
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .black
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        
        picker.addTarget(self, action: #selector(chooseDate), for: .valueChanged)
        buttonSave.addTarget(self, action: #selector(saveDate), for: .touchUpInside)
        buttonClose.addTarget(self, action: #selector(closePicker), for: .touchUpInside)
        
        view.addSubview(picker)
        
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor, constant: 10),
            picker.bottomAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 10),
            picker.trailingAnchor.constraint(equalTo: pickerView.trailingAnchor, constant: 10),
            picker.topAnchor.constraint(equalTo: pickerView.topAnchor, constant: 65)
        ])


        pickerView.addSubview(buttonClose)
        pickerView.addSubview(buttonSave)
        pickerView.addSubview(picker)


        NSLayoutConstraint.activate([
            buttonClose.heightAnchor.constraint(equalToConstant: 38),
            buttonClose.widthAnchor.constraint(equalToConstant: 38),
            buttonClose.topAnchor.constraint(equalTo: pickerView.topAnchor, constant: 10),
            buttonClose.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            buttonSave.heightAnchor.constraint(equalToConstant: 38),
            buttonSave.widthAnchor.constraint(equalToConstant: 38),
            buttonSave.topAnchor.constraint(equalTo: pickerView.topAnchor, constant: 10),
            buttonSave.trailingAnchor.constraint(equalTo: pickerView.trailingAnchor, constant: -10)
        ])

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        setUpUI()
        pickerView.layer.cornerRadius = 20
        pickerView.layer.applySketchShadow()
    }
}
