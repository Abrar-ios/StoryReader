//
//  StoryListDataSourceAndDelegate.swift
//  StoryReader
//
//  Created by Abrar Ul Haq on 27/09/2017.
//  Copyright © 2017 AbrarUlHaq. All rights reserved.
//

import Foundation

/**
 The purpose of the `StoryListDataSourceAndDelegate` is Class to provide seperate datasoure and delegate implementation for tableview.
 
 
 The `StoryListDataSourceAndDelegate` class is a subclass of the `NSObject`, and it conforms to the `UITableViewDelegate` protocol and `UITableViewDataSource` protocol.
 */

import UIKit
import CoreData

class StoryListDataSourceAndDelegate:NSObject,UITableViewDelegate, UITableViewDataSource {
    
    var stories :[StoryModel]! = []
    var delegateStorySelection: StorySelectionDelegate?
    var currentDate: Date?
    var controller: NSFetchedResultsController<Story>!
    
    /*
     func numberOfSections(in tableView: UITableView) -> Int {
     return 1
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     var totalCount = 0
     if self.stories != nil    {
     totalCount = self.stories.count
     }
     return totalCount
     }
     */
    
    // MARK: TableView Delegate Method to Implement number of Rows in list based on DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
        
    }
    
     // MARK: TableView Delegate Method to Implement number of Section in TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            
            return sections.count
        }
        
        return 0
        
    }
    
     // MARK: TableView Delegate Method to Render Cell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if  let cell = tableView.dequeueReusableCell(withIdentifier: "SRStoryListTableViewCell", for: indexPath) as? SRStoryListTableViewCell {
            let storyDTO = controller.object(at: indexPath as IndexPath)
            cell.configureCell(storyDTO: storyDTO, cdate: self.currentDate!)
            return cell
        }else {
            return SRStoryListTableViewCell()
        }
        
    }
    
     // MARK: TableView Delegate Method to Implement Editing Functionality in TableView
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let storyDTO = controller.object(at: indexPath as IndexPath)
            //let storyObj = StoryModel(storyObj: storyDTO)
            self.delegateStorySelection?.storyDidDelete(storyDTO:storyDTO)
        }
    }
    
     // MARK: TableView Delegate Method to To Show Selected Post In Detail View
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyDTO = controller.object(at: indexPath as IndexPath)
        let storyObj = StoryModel(storyObj: storyDTO)
        self.delegateStorySelection?.storyDidSelect(storyDTO:storyObj)
    
        
    }
    
}
