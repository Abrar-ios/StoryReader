//
//  StorySelectionDelegate.swift
//  StoryReader
//
//  Created by Abrar Ul Haq on 27/09/2017.
//  Copyright © 2017 AbrarUlHaq. All rights reserved.
// 


import Foundation

/// This is an **Protocol** To Use Where we need to pass controll on Selection from DataSource to Required Class.

protocol StorySelectionDelegate {
    
    func storyDidSelect(storyDTO: StoryModel)
    func storyDidDelete(storyDTO: Story)
}
