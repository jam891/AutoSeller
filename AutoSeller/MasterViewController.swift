//
//  MasterViewController.swift
//  AutoSeller
//
//  Created by Vitaliy Delidov on 10/9/15.
//  Copyright © 2015 Vitaliy Delidov. All rights reserved.
//

import UIKit

class MasterViewController: PFQueryTableViewController {
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        parseClassName = "Vehicle"
        textKey = "model"
        pullToRefreshEnabled = true
        paginationEnabled = false
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Vehicle")
        query.orderByAscending("model")
        return query
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController = segue.destinationViewController as! DetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            if let obj = objects?[indexPath.row] as? PFObject {
                let vehicle = Vehicle()
                vehicle.type = obj["type"] as? String
                vehicle.model = obj["model"] as? String
                vehicle.color = obj["color"] as? String
                vehicle.condition = obj["condition"] as? String
                vehicle.imageFile = obj["imageFile"] as? PFFile
                vehicle.ownerID = obj["ownerID"] as? PFObject
                
                let owner = Owner()
                vehicle.ownerID?.fetchIfNeededInBackgroundWithBlock({
                    (obj: PFObject?, error: NSError?) -> Void in
                    owner.name = vehicle.ownerID?["name"] as? String
                    owner.phone = vehicle.ownerID?["phone"] as? String
                })
                viewController.currentOwner = owner
                viewController.currentVehicle = vehicle
            }
        }
    }

    // MARK: - Table View Data Source
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomTableViewCell
        if let model = object?["model"] as? String {
            cell.modelLabel.text = model
        }
        
        // Display image
        let initialThumbnail = UIImage(named: "question")
        cell.modelImageView.image = initialThumbnail
        if let thumbnail = object?["imageFile"] as? PFFile {
            cell.modelImageView.file = thumbnail
            cell.modelImageView.loadInBackground(nil)
        }
        return cell
    }

}
