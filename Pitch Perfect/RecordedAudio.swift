//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Wilding Threlfall on 12/18/14.
//  Copyright (c) 2014 Wilding Threlfall. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
   
    var filePathURL: NSURL!
    var title: String!
    
    
    init (filePathURL: NSURL!, title: String!) {
        self.filePathURL = filePathURL
        self.title = title
    }
}