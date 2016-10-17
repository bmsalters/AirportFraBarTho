//
//  PersonTableTableViewController.swift
//  SQLiteCRUD
//
//  Created by Diederich Kroeske on 06/10/2016.
//  Copyright © 2016 Diederich Kroeske. All rights reserved.
//

import UIKit

class PersonTableTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var airports : [Airport] = []
    var countries : [String] = []
       
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries = DataBaseHelper.sharedInstance.getCountries()
        pickerView.delegate = self;
        
        //pickerView.dataSource = countries
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataBaseHelper.sharedInstance.read().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)

        // Configure the cell...
        airports = DataBaseHelper.sharedInstance.read()
        cell.textLabel?.text = airports[indexPath.row].name;

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
                    let airport = airports[(indexPath as NSIndexPath).row]
                    destination.airport = airport
                    
                }
            }
        }
    }
    
    
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
}
