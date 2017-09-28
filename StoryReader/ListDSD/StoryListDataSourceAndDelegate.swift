//
//  StoryListDataSourceAndDelegate.swift
//  StoryReader
//
//  Created by Abrar Ul Haq on 27/09/2017.
//  Copyright © 2017 AbrarUlHaq. All rights reserved.
//

import Foundation
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            
            return sections.count
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if  let cell = tableView.dequeueReusableCell(withIdentifier: "SRStoryListTableViewCell", for: indexPath) as? SRStoryListTableViewCell {
            let storyDTO = controller.object(at: indexPath as IndexPath)
            cell.configureCell(storyDTO: storyDTO, cdate: self.currentDate!)
            return cell
        }else {
            return SRStoryListTableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let storyDTO = controller.object(at: indexPath as IndexPath)
            //let storyObj = StoryModel(storyObj: storyDTO)
            self.delegateStorySelection?.storyDidDelete(storyDTO:storyDTO)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyDTO = controller.object(at: indexPath as IndexPath)
        let storyObj = StoryModel(storyObj: storyDTO)
        self.delegateStorySelection?.storyDidSelect(storyDTO:storyObj)
        /*
        if self.stories != nil {
            let item = self.stories[indexPath.row]
            self.delegateStorySelection?.storyDidSelect(storyDTO:item)
            
        }
 */
        
    }
    
}
