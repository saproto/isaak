//
//  dateHelper.swift
//  proto-application
//
//  Created by Hessel Bierma on 12/12/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//

import Foundation

extension Date
{
    func readableString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
}
