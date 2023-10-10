//
//  ViewController.swift
//  MARS
//
//  Created by Olena Makhobei on 03/10/2023.
//

import UIKit
import Alamofire
import SwiftyJSON
import moa
import CoreData
import Foundation

class ViewController: UIViewController,UINavigationBarDelegate,NavBarLisener,CellLisener{
    
    //MARK: - Outlet's
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var contentTable: UITableView!
    

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cellsArray: [InfoCell] = []
    let dateFormatterForFilter = DateFormatter()
    let dateFormatterForLabel = DateFormatter()
    var emptyView:UIImageView? = nil
    
    
    //MARK: - Observing income parameters
    

    var dateValue: Date?{
        didSet{
            let passedDate = dateFormatterForFilter.string(from: dateValue ?? Date())
            loadNetworkData(rover: roversFltr ?? "curiosity", camera: cameraFltr ?? "rhaz", choodesDate: passedDate)
        }
    }
    
    
    var roversFltr: String?{
        didSet{
            let passedDate = dateFormatterForFilter.string(from: dateValue ?? Date())
            loadNetworkData(rover: roversFltr ?? "curiosity", camera: cameraFltr ?? "rhaz", choodesDate: passedDate)
        }
    }
    
    var cameraFltr: String?{
        didSet{
            let passedDate = dateFormatterForFilter.string(from: dateValue ?? Date())
            loadNetworkData(rover: roversFltr ?? "curiosity", camera: cameraFltr ?? "rhaz", choodesDate: passedDate)
        }
    }
    
    
    var model: NASAResponse?{
        didSet{
            cellsArray.removeAll()
            model?.photos.forEach{
                let cell = InfoCell(rover: $0.rover.name, date: $0.earth_date, camera: $0.camera.full_name, imageURL: $0.img_src)
                cellsArray.append(cell)
            }
            print("DataSource count is ", cellsArray.count)
        }
    }
    
    
    
    //MARK: - Protocol's methods
    func onSaveFiltrButtnPressed(){
        
        let alert = UIAlertController(title: "Save Filters",
                                      message: "The current filters and the date you have choosen can be saved to the filter history",
                                      preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Save",
                                      style: .default,
                                      handler: { _ in
            
                let searchingFilters = HistorySeacrhParam(context: self.context)
                searchingFilters.camera = self.cameraFltr ?? "fhaz"
                searchingFilters.date = self.dateValue ?? Date()
                searchingFilters.rover = self.roversFltr ?? "curiosity"
             
            try? self.context.save()
             print("Succes")
        }))

        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .default,
                                      handler: { _ in print("Cancel tap") }))

        present(alert, animated: true, completion: nil)
        
        
    }
    

    
    func passSavedFltrParamenetrs(date: Date, camera: String, rover: String){
        dateValue = date
        cameraFltr = camera
        roversFltr = rover
    }
    
    func onDatePicked(value:Date){
        dateValue = value
        customNavigationBar.dateLBl.text = dateFormatterForLabel.string(from: value )
    }
    
    //Changing title on Nav bar's button
    func onFltrPicked(str:String,ident: String){
        switch ident{
        case "Camera":
            customNavigationBar.cameraFltr.setTitle(str, for: .normal)
            customNavigationBar.cameraFltr.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case "CPU":
            customNavigationBar.roverFltr.setTitle(str, for: .normal)
            customNavigationBar.roverFltr.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            print("Error occur")
        }
        
    }
    
     func onImageTapped(url: String?){
                guard let imageVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController else {return}
                imageVC.urlString = url
                present(imageVC, animated: true)
    }
    
    
    //Present controller with date picker
    func onCalendarPressed() {
        guard  let dataPickerVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CalendarPicker") as? CalendarPicker else {return}
        dataPickerVC.delegateOfViewController = self
        present(dataPickerVC, animated: true)
    }
    
    
    //Present controller where user can add parameters for sorting
    func onCameraFltrPressed(sender: String){
        guard  let cameraFltrVC  = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CameraFilterPicker") as? Camera_RoversFilterPicker else {return}
        cameraFltrVC.delegateOfViewContrllr = self
        cameraFltrVC.identifier = sender
        present(cameraFltrVC, animated: true)
        
    }
    
    //Represent View controller that holding user searching history
    @objc private func openHistoryVC(){
        guard let historyVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController else {return}
        historyVC.delegateOfViewController = self
        present(historyVC, animated: true)
    }
    
    func addHistoryButton(){
        contentTable.separatorStyle = .none
        
        let button = UIButton()
        button.setImage(UIImage(named: "Box"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openHistoryVC), for: .touchUpInside)
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 75),
            button.heightAnchor.constraint(equalToConstant: 75),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
        ])
        
    }
    
    func loadNetworkData(rover:String , camera: String, choodesDate: String) {
        let params  = ["earth_date": choodesDate,
                      "camera": camera,
                      "api_key":"5qLHneXAddfxGzlB0RCf6MICji3e5GuzpagJDilf"]
                      
        
        print ("Rover is == ", rover, ", Camera is ==", camera, ", Choosed Date is ==", choodesDate)
        guard let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover)/photos") else {
            print("Returning")
        return}

        AF.request(url, method: .get,parameters: params).responseData { [self] response in
            switch response.result{
            case .success(_):
                do {
                    let jsonData = try JSON(data: response.data!)
                    debugPrint("Response",jsonData)
                    self.model  =   NASAResponse(jsonData)
                    self.contentTable.reloadData()
                    
                }catch{}
            case .failure(let err):
                print(err)
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        dateFormatterForFilter.dateFormat = "yyyy-MM-dd"
        dateFormatterForLabel.dateFormat = "MMMM d, yyyy"
        customNavigationBar.dateLBl.text = dateFormatterForLabel.string(from: dateValue ?? Date())

        let choosedData = dateFormatterForFilter.string(from: dateValue ?? Date())
        loadNetworkData(rover: roversFltr ?? "curiosity", camera: cameraFltr ?? "rhaz", choodesDate: choosedData)
        
        addHistoryButton()
        
        customNavigationBar.delegate = self
        contentTable.dataSource = self
        contentTable.delegate = self
        contentTable.register(UINib(nibName: "MarsTableViewCell", bundle: nil), forCellReuseIdentifier: "MarsTableViewCell")
        
        imageIfTableIsEmpty()
        
    }
}


    
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch cellsArray.count {
        case 0:
            emptyView?.isHidden = false
            return 0
        default:
            emptyView?.isHidden = true
            return cellsArray.count
        }

    

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedCell = cellsArray[indexPath.row]
        let cell = contentTable.dequeueReusableCell(withIdentifier: "MarsTableViewCell") as! MarsTableViewCell
        let cameraNameLenght = selectedCell.camera.split(separator: " ")
        
        cell.delegateOfViewController = self
        cell.roverData.text = selectedCell.rover
        cell.cardImage.moa.url = selectedCell.imageURL
        cell.capturedDate.text = selectedCell.transformDateToOtherFormat()
  
        if cameraNameLenght.count > 2 {
            cell.cameraLabelForShortName.isHidden = true
            cell.capturedInfoCamera.isHidden = false
            cell.capturedInfoCamera.text = selectedCell.camera
        }
        else if cameraNameLenght.count <= 2{
            cell.cameraLabelForShortName.isHidden = false
            cell.capturedInfoCamera.isHidden = true
            cell.cameraLabelForShortName.text = selectedCell.camera
            }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    
    func imageIfTableIsEmpty(){
        let emptyView = UIImageView()
        emptyView.image = UIImage(named: "title")
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([

            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 180),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        emptyView.isHidden = true
        self.emptyView = emptyView
    }
    
}


class InfoCell {
    var rover: String
    var date: String
    var camera: String
    var imageURL: String?
    
    init(rover: String, date: String, camera: String, imageURL: String) {
        self.rover = rover
        self.date = date
        self.camera = camera
        self.imageURL = imageURL
    }
    
    func transformDateToOtherFormat()-> String{
        var targetString = ""
        let originalDateString = date
        let originalFormatter = DateFormatter()
        originalFormatter.dateFormat = "yyyy-MM-dd"

        if let date = originalFormatter.date(from: originalDateString) {

            let targetFormatter = DateFormatter()
            targetFormatter.dateFormat = "MMMM d, yyyy"
            
            let targetDateString = targetFormatter.string(from: date)
            targetString = targetDateString
            print(targetDateString)
        }
        return targetString

    }
}
