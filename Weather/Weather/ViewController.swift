//
//  ViewController.swift
//  Weather
//
//  Created by даниил on 29.06.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var temperatureLableF: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate=self
    }
}


    extension ViewController:UISearchBarDelegate{
        
        func searchBarSearchButtonClicked (_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            
            let urlString = "https://api.weatherapi.com/v1/current.json?key=fef6508b2b0440cba0d155432233006&q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20") )"
            let url = URL(string: urlString)
            
            
            var locationName:String?
            var temperature:Double?
            var temperatureF:Double?
            var errorHasOccured:Bool=false
            var iconP:Data?
            var iconString:String?
            
            
            let task = URLSession.shared.dataTask(with: url!){[weak self](data,respones,error) in
               do {
                   let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                   
                   if let _ = json["error"]{
                       errorHasOccured=true
                   }
                   
                   if let location=json["location"] {
                       locationName=location["name"] as? String
                   }
                   
                   if let current = json["current"]{
                       temperature=current["temp_c"] as? Double
                   }
                   if let current = json["current"]{
                       temperatureF=current["temp_f"] as? Double
                   }
                   
                   if let current = json["current"]{
                       if let condition = current["condition"] as? AnyObject{
                            iconString=condition["icon"]as? String
                           iconString = "https:" +  iconString!
                           let iconurl = URL(string: iconString!)
                           let icondata = try! Data(contentsOf: iconurl!)
                           iconP = icondata
                           
                           
                       }
                   }
                   
                   
               
                   
                
                   DispatchQueue.main.async {
                       if errorHasOccured{
                           self?.temperatureLabel.isHidden=true
                           self?.temperatureLableF.isHidden=true
                           self?.ImageView.isHidden=true
                           self?.locationLabel.text="Not Found"
                       }
                       else{
                           self?.temperatureLabel.isHidden=false
                           self?.temperatureLableF.isHidden=false
                           self?.ImageView.isHidden=false
                           self?.locationLabel.text=locationName
                           self?.temperatureLableF.text="°F \(temperatureF!)"
                           self?.temperatureLabel.text="°C \(temperature!)"
                           self?.ImageView.image=UIImage(data: iconP!)
                           
                       }
                       
                   }
                   
            }
                catch let jsonError{print(jsonError)}
            }
         
            task.resume()
        }
    }


