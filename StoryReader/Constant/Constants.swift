//
//  Constants.swift
//  RainyShinyCloudy
//
//  Created by abrar  ul haq on 13/03/2017.
//  Copyright © 2017 locopixel. All rights reserved.
//

import Foundation


let BASE_URL = "https://hn.algolia.com/api/v1/search_by_date?"
let Query_Param = "query=ios"

typealias DownloadComplete = () -> ()

let Stories_URL = "\(BASE_URL)\(Query_Param)"

