//
//  SRStoryListViewController.swift
//  StoryReader
//
//  Created by Abrar Ul Haq on 27/09/2017.
//  Copyright © 2017 AbrarUlHaq. All rights reserved.
//

import UIKit

/**
 The purpose of the `SRStoryListViewController` view controller is to provide a user interface where a list **Recent Posts** available to view all briefly.
 
 There's a matching scene in the *Main.storyboard* file, and in that scene there are one tableview and activityindictorview. Go to Interface Builder for details.
 
 The `SRStoryListViewController` class is a subclass of the `UIViewController`, and it conforms to the `StorySelectionDelegate` protocol and `NSFetchedResultsControllerDelegate` protocol.
 */

/// This is an **RestApi Parsing Api** integrated using **cocoapods**.
import Alamofire
/// This is an **iOS CoreData Framework**.
import CoreData



class SRStoryListViewController: UIViewController,StorySelectionDelegate,NSFetchedResultsControllerDelegate {
    
    // MARK: IBOutlet Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingProgress: UIActivityIndicatorView!
    
    var stories = [StoryModel]()
    private let refreshControl = UIRefreshControl()
    var controller: NSFetchedResultsController<Story>!
    var dataSourceAndDelegate: StoryListDataSourceAndDelegate!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "SRStoryListTableViewCell", bundle: nil), forCellReuseIdentifier: "SRStoryListTableViewCell")
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshPostsData(_:)), for: .valueChanged)
        
        self.dataSourceAndDelegate = StoryListDataSourceAndDelegate()
        self.dataSourceAndDelegate.controller = self.controller
        self.dataSourceAndDelegate.delegateStorySelection = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadingProgress.startAnimating()
        self.downloadStoriesData {
            self.attemptFetch()
        }
    }
    
    // MARK: Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "StoryDetail" {
            if let destination = segue.destination as? SRStoryDetailViewController{
                if let story = sender as? StoryModel {
                    destination.storyDTO = story
                }
            }
        }
    }
    
    // MARK: StorySelectionDelegate Protocol Methods To Review Post in Webview
    
    func storyDidSelect(storyDTO: StoryModel){
        performSegue(withIdentifier: "StoryDetail", sender: storyDTO)
    }
    
    // MARK: StorySelectionDelegate Protocol Methods To Delete Post
    
    func storyDidDelete(storyDTO: Story) {
        
        var story: Story!
        story = storyDTO
        story.setValue(true, forKey: "delStatus")
        ad.saveContext()
        self.attemptFetch()
        self.tableView .reloadData()
        
        
    }
    // MARK: Pull To Refresh Methods
    
    @objc private func refreshPostsData(_ sender: Any) {
        self.downloadStoriesData {
            
            self.attemptFetch()
        }
    }
    
    // MARK: To parse recent post via api link
    
    func downloadStoriesData(completed: @escaping DownloadComplete){
        
        let storiesURL = URL(string: Stories_URL)!
        Alamofire.request(storiesURL).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, Any>{
                
                if let list = dict["hits"] as? [Dictionary<String, Any>]{
                    
                    for obj in list {
                        
                        self.saveToDataPersistant(storyObj: obj)
                    }
                    
                }
                
                
            }
            completed()
        }
    }
    
    // MARK: To Persist Data Locally To support Offline Version also
    
    func saveToDataPersistant(storyObj: Dictionary<String, Any>)  {
        
        
        do {
            
            let formatRequest : NSFetchRequest<Story> = Story.fetchRequest()
            formatRequest.predicate = NSPredicate(format: "created_at == %@", (storyObj["created_at"] as? String)!)
            var fetchedResults =  [Story]()
            if #available(iOS 10.0, *) {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                fetchedResults = try context.fetch(formatRequest)
            } else {
                fetchedResults = try ad.managedObjectContext.fetch(formatRequest)
            }
            if fetchedResults.first == nil {
                var story: Story!
                if #available(iOS 10.0, *) {
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    story = Story(context: context)
                } else {
                    let entityDescription = NSEntityDescription.entity(forEntityName: "Story", in: ad.managedObjectContext)
                    story = NSManagedObject(entity: entityDescription!, insertInto: ad.managedObjectContext) as! Story
                    
                }
                if let storyTitle = storyObj["story_title"] as? String {
                    story.story_title = storyTitle
                }
                
                if let authorName = storyObj["author"] as? String {
                    var author: Author!
                    if #available(iOS 10.0, *) {
                        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                        author = Author(context: context)
                    } else {
                        let entityDescription = NSEntityDescription.entity(forEntityName: "Author", in: ad.managedObjectContext)
                        author = NSManagedObject(entity: entityDescription!, insertInto: ad.managedObjectContext) as! Author
                    }
                    author.author = authorName
                    story.toAuthor = author
                }
                
                if let ceationTime = storyObj["created_at"] as? String {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
                    let date = dateFormatter.date(from: ceationTime)
                    story.dateFilter = date! as NSDate
                    story.created_at = ceationTime
                }
                
                if let storyId = storyObj["objectID"] as? String {
                    story.story_id = storyId
                }
                
                if let storyURL = storyObj["story_url"] as? String {
                    story.story_url = storyURL
                }
                
                if let createdAt = storyObj["created_at_i"] as? Double {
                    story.created_at_i = createdAt
                }
                
                ad.saveContext()
            }
            
        }
        catch {
            print ("fetch task failed", error)
        }
        
    }
    
    // MARK: To Fect Data from offline storage after syncing with api
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Story> = Story.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "delStatus == NO")
        let dateSort = NSSortDescriptor(key: "dateFilter", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        if #available(iOS 10.0, *) {
            self.controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        } else {
            self.controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: ad.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        }
        controller.delegate = self
        //self.controller = controller
        self.dataSourceAndDelegate.controller = self.controller
        
        let currentDate = NSDate()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let myString = formatter.string(from: currentDate as Date)
        self.dataSourceAndDelegate.currentDate = formatter.date(from: myString)
        
        self.tableView.dataSource = self.dataSourceAndDelegate
        self.tableView.delegate = self.dataSourceAndDelegate;
        do {
            try controller.performFetch()
            self.tableView.reloadData()
            self.loadingProgress.stopAnimating()
            self.refreshControl.endRefreshing()
        }
        catch{
            
            let error = error as NSError
            print("\(error)")
            
        }
        
    }
    
    /*
     func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
     
     tableView.beginUpdates()
     }
     
     func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
     
     tableView.endUpdates()
     }
     
     func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
     
     switch (type) {
     
     case.insert:
     if let indexPath = newIndexPath {
     
     tableView.insertRows(at: [indexPath], with: .fade)
     }
     break
     
     case.delete:
     
     if let indexPath = indexPath {
     
     tableView.deleteRows(at: [indexPath], with: .fade)
     }
     break
     
     case .update:
     
     if  let indexPath = indexPath {
     self.tableView.reloadRows(at: [indexPath], with: .none)
     
     }
     break
     
     case.move:
     
     if let indexPath = indexPath{
     
     tableView.deleteRows(at: [indexPath], with: .fade)
     }
     if let indexPath = newIndexPath {
     tableView.insertRows(at: [indexPath], with: .fade)
     }
     break
     }
     }
     */
}
