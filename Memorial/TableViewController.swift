//
//  TableViewController.swift
//  Memorial
//
//  Created by 迫 佑樹 on 2016/01/01.
//  Copyright © 2016年 迫 佑樹. All rights reserved.
//

import UIKit

var places = [Dictionary<String, String>()]

var activePlace = -1

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(places.count)
        if places.count == 1{
            
            places.removeAtIndex(0)
            
            places.append(["name": "R大学","explain" :"我らの大学", "lat":"34.9822158", "lon":"135.9624112"])
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:  indexPath) as UITableViewCell
        

        cell.textLabel?.text = "\(places[indexPath.row]["explain"]!), \(places[indexPath.row]["name"]!)"
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        activePlace = indexPath.row

        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newPlace" {
            activePlace = -1
        }
    }

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

}
