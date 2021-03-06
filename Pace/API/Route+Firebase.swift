//
//  Route+Firebase.swift
//  Pace
//
//  Created by Julius Sander on 5/4/19.
//  Copyright © 2019 nus.cs3217.pace. All rights reserved.
//

extension Route: FirebaseStorable {
    var asDictionary: [String: Any] {
        let startingLocation = creatorRun!.startingLocation!
        return [
            "name": name,
            "creator": creator?.objectId ?? "",
            "creatorName": creator?.name ?? "",
            "startingGeohash": Constants.defaultGridManager.getGridId(startingLocation.coordinate).code,
            "creatorRun": creatorRun?.asDictionary ?? [:],
            "creatorRunId": creatorRun?.objectId ?? "",
            "runs": Array(paces.map { $0.objectId })
        ]
    }

    static func fromDictionary(objectId: String?, value: [String: Any]) -> Route? {
        guard
            let name = value["name"] as? String,
            let creatorName = value["creatorName"] as? String,
            let creatorId = value["creator"] as? String,
            var creatorRun = value["creatorRun"] as? [String: Any],
            let creatorRunId = value["creatorRunId"] as? String,
            let objectId = objectId
            else {
                return nil
        }
        if creatorRun["runnerName"] == nil {
            creatorRun["runnerName"] = creatorName
        }
        let route = Route(creator: UserReference(name: creatorName, id: creatorId),
                          name: name,
                          creatorRun: Run.fromDictionary(objectId: creatorRunId, value: creatorRun)!)
        route.objectId = objectId
        return route
    }
}
