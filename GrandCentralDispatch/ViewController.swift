//
//  ViewController.swift
//  GrandCentralDispatch
//
//  Created by Owen Duignan on 11/05/2017.
//  Copyright © 2017 Owen Duignan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition["title"]
        cell.detailTextLabel?.text = petition["body"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchJSON() {
                let urlString: String
        
                if navigationController?.tabBarItem.tag == 0 {
                    urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
                } else {
                    urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
                }
        
                    if let url = URL(string: urlString) {
                        if let data = try? Data(contentsOf: url) {
                            let json = JSON(data: data)
        
                            if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                                self.parse(json: json)
                                return
                            }
                        }
                }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    func parse(json: JSON) {
        for result in json["results"].arrayValue {
            let title = result["title"].stringValue
            let body = result["body"].stringValue
            let sigs = result["signatureCount"].stringValue
            let obj = ["title": title, "body": body, "sigs": sigs]
            petitions.append(obj)
        }
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    func showError() {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}





































































































































































