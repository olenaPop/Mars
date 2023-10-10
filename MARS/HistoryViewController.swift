//
//  HistoryViewController.swift
//  MARS
//
//  Created by Olena Makhobei on 05/10/2023.
//

import UIKit
import Foundation
import CoreData


class HistoryViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var arrayOfSavedParams: [HistorySeacrhParam]?
    var delegateOfViewController: ViewController?
    
    let backButton = UIButton()
    var values = 0
    @IBOutlet weak var customNavView: CustomNavigationBar!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    
    @objc private func backToMainVC(){
     dismiss(animated: true)
    }
    
    func fetchHistoryData(){
  
        do{
            let request = HistorySeacrhParam.fetchRequest() as NSFetchRequest<HistorySeacrhParam>
            self.arrayOfSavedParams = try context.fetch(request)
            
        }
        catch{}
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        fetchHistoryData()
        historyTableView.register(UINib(nibName: "HistoryTableViewcell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewcell")

        historyTableView.dataSource = self
        historyTableView.delegate = self
    }
}


extension HistoryViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrayOfSavedParams = arrayOfSavedParams else{
            addImageToViewIfListEmpty()
            return 0}
        return arrayOfSavedParams.count
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let arrayOfSavedParams = arrayOfSavedParams else{ return UITableViewCell()}

        let selectedParameters = arrayOfSavedParams[indexPath.row]
        let cell  = historyTableView.dequeueReusableCell(withIdentifier: "HistoryTableViewcell")  as! HistoryTableViewcell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"

        cell.cameraDate.text = cell.transformCodeCameraValueToName(value: selectedParameters.camera ?? "")
        cell.dateData.text = dateFormatter.string(from: selectedParameters.date!)
        cell.roverData.text = selectedParameters.rover?.capitalized
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let arrayOfSavedParams = arrayOfSavedParams else{ return}
        let selectedFiltrParam = arrayOfSavedParams[indexPath.row]

        let alert = UIAlertController(title: "Menu Filter",
                                      message: "",
                                      preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Use",
                                      style: .default,
                                      handler: { _ in print("Use tap")
            
        self.delegateOfViewController?.passSavedFltrParamenetrs(date: selectedFiltrParam.date!, camera: selectedFiltrParam.camera!, rover: selectedFiltrParam.rover!)
            
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"

        self.delegateOfViewController?.customNavigationBar.dateLBl.text =  dateFormatter.string(from: selectedFiltrParam.date ?? Date())
        self.delegateOfViewController?.contentTable.reloadData()
        self.dismiss(animated: true)

            
        }))
        alert.addAction(UIAlertAction(title: "Delete",
                                      style: .destructive,
                                      handler: { _ in print("Delete tap")
            
            
            self.context.delete(selectedFiltrParam)
            do{
                try self.context.save()
            }
            catch {}
            self.fetchHistoryData()
            self.historyTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: { _ in print("Cancel tap") }))

        present(alert, animated: true, completion: nil)
    }
    
    
    func addImageToViewIfListEmpty(){
        let imageView = UIImageView()
        imageView.image = UIImage(named: "title")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 180),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
       
    }
    
    func setUpUI(){
       
        customNavView.customeView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        customNavView.calendar.isHidden = true
        customNavView.cameraFltr.isHidden = true
        customNavView.roverFltr.isHidden = true
        customNavView.saveFltr.isHidden = true
        customNavView.MARSName.isHidden = true
        customNavView.dateLBl.isHidden = true
        
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backToMainVC), for: .touchUpInside)
        
        customNavView.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 38),
            backButton.heightAnchor.constraint(equalToConstant: 38),
            backButton.leadingAnchor.constraint(equalTo: customNavView.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: customNavView.topAnchor, constant: 68)
        ])
        
        
        let label = UILabel()
        label.text = "HISTORY"
        label.font = label.font.withSize(20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        customNavView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: customNavView.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 20),
            label.topAnchor.constraint(equalTo: customNavView.topAnchor, constant: 77)
            
        ])
        
    }
    
  
    
}
