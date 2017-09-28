//
//  StoryModel.swift
//  StoryReader
//
//  Created by Abrar Ul Haq on 27/09/2017.
//  Copyright © 2017 AbrarUlHaq. All rights reserved.
//

import Foundation

class StoryModel {
    
    var _storyTitle: String!
    var _authorName: String!
    var _ceationTime: String!
    var _storyId: String!
    var _storyURL: String!
    var _createdAt: Double!
    
    
    var storyTitle: String {
        
        if _storyTitle == nil {
            _storyTitle = ""
        }
        
        return _storyTitle
    }
    
    var authorName: String {
        
        if _authorName == nil {
            _authorName = ""
        }
        
        return _authorName
    }
    /*
    var ceationTime: String {
        
        if _ceationTime == nil {
            
            _ceationTime = ""
        }
        
        return _ceationTime
    }
 */
    
    var storyId: String {
        
        if _storyId == nil {
            
            _storyId = ""
        }
        
        return _storyId
    }
    /*
    var createdAt: Double {
        
        if _createdAt == nil {
            
            _createdAt = 0.0
        }
        
        return _createdAt
    }
 */
    
    var storyURL: String {
        
        if _storyURL == nil {
            
            _storyURL = ""
        }
        
        return _storyURL
    }
    
   
    
    /*
    init(storyDict: Dictionary<String, Any>) {
        
        if let storyTitle = storyDict["story_title"] as? String {
            self._storyTitle = storyTitle
        }
        
        if let authorName = storyDict["author"] as? String {
            self._authorName = authorName
        }
        
        if let ceationTime = storyDict["created_at"] as? NSDate {
            self._ceationTime = ceationTime
        }
        
        if let storyId = storyDict["objectID"] as? String {
            self._storyId = storyId
        }
        
        if let storyURL = storyDict["story_url"] as? String {
            self._storyURL = storyURL
        }
        
        if let createdAt = storyDict["created_at_i"] as? Double {
            self._createdAt = createdAt
        }
        
        
    }
    */
    init(storyObj: Story) {
        
        if let storyTitle = storyObj.story_title {
            self._storyTitle = storyTitle
        }
        
        if let authorName = storyObj.toAuthor?.author {
            self._authorName = authorName
        }
        
        if let ceationTime = storyObj.created_at {
            self._ceationTime = ceationTime
        }
        
        if let storyId = storyObj.story_id {
            self._storyId = storyId
        }
        
        if let storyURL = storyObj.story_url {
            self._storyURL = storyURL
        }
        
        self._createdAt = storyObj.created_at_i
        
        
    }
    
}
