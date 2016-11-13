//
//  DataStore.swift
//  Minutes
//
//  Created by Ryan Arana on 11/12/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import Foundation

protocol Storable: NSCoding {
    static var pluralName: String { get }
}

class DataStore<DataType: Storable> {
    let storageURL: URL
    var data: [DataType] = []

    init(storageURL: URL? = nil) {
        self.storageURL = storageURL ??
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(DataType.pluralName)
        self.load()
    }

    @discardableResult
    func save() -> Bool {
        return NSKeyedArchiver.archiveRootObject(data, toFile: storageURL.path)
    }

    @discardableResult
    func load() -> [DataType]? {
        let loadedData = NSKeyedUnarchiver.unarchiveObject(withFile: storageURL.path) as? [DataType]
        data = loadedData ?? []
        return loadedData == nil ? nil : data
    }
}
