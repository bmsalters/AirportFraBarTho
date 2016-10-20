//
//  PersonTableTableViewController.swift
//  SQLiteCRUD
//
//  Created by Diederich Kroeske on 06/10/2016.
//  Copyright © 2016 Diederich Kroeske. All rights reserved.
//

import UIKit

class PersonTableTableViewController: UITableViewController, UISearchBarDelegate, UIPickerViewDelegate {

    var airports : [Airport] = []
    var filtered:[Airport] = []
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
                airports = DataBaseHelper.sharedInstance.read()
        //pickerView.delegate = self;
        searchBar.delegate = self;
        //pickerView.dataSource = countries
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
         filtered = airports.filter() {
            if let iso_country = ($0 as Airport).iso_country! as String? {
                var found = iso_country.contains(searchText)
                if found {
                    return found
                }
                else
                {
                    if let name = ($0 as Airport).name! as String? {
                        return name.contains(searchText)
                    }
                }
            }
            
        }
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchActive) {
            return filtered.count
        }
        return airports.count;
    }
//        return DataBaseHelper.sharedInstance.read().count
//    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)

        // Configure the cell...
        if(!searchActive){
            cell.textLabel?.text = airports[indexPath.row].iso_country! + " - " + airports[indexPath.row].name!;
        } else {
            cell.textLabel?.text = filtered[indexPath.row].iso_country! + " - " + filtered[indexPath.row].name!;
        }

//        cell.textLabel?.text = airports[indexPath.row].iso_country! + " - " + airports[indexPath.row].name!;

        return cell
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        let destination = segue.destinationViewController as! PersonDetailViewController
        //        destination.personFirst.text = "hallo"
        
        // Check if the right segue is handled
        if segue.identifier == "detailSegue" {
            
            // Get destination controller
            if let destination = segue.destination as? DetailViewController {
                
                // Get selected row and lookup selected person in array
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    
                    // Pass person to detailed view
                    if searchActive {
                        let airport = filtered[(indexPath as NSIndexPath).row]
                        destination.airport = airport
                    }
                    else {
                        let airport = airports[(indexPath as NSIndexPath).row]
                        destination.airport = airport
                    }
                }
            }
        }
    }
    
    
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
