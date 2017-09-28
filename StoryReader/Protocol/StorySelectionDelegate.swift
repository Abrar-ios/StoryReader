//
//  StorySelectionDelegate.swift
//  StoryReader
//
//  Created by Abrar Ul Haq on 27/09/2017.
//  Copyright © 2017 AbrarUlHaq. All rights reserved.
//

import Foundation


protocol StorySelectionDelegate {
    
    func storyDidSelect(storyDTO: StoryModel)
    func storyDidDelete(storyDTO: Story)
}
