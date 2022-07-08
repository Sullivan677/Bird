//
//  BirdViewModel.swift
//  Bird
//
//  Created by Sullivan De carli on 08/07/2022.
//

import Foundation
import FirebaseDatabase

final class BirdViewModel: ObservableObject {
    @Published var birds: [Bird] = []
    
    private lazy var databasePath: DatabaseReference? = {
        let ref = Database.database().reference().child("birds")
        return ref
    }()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func listentoRealtimeDatabase() {
        guard let databasePath = databasePath else {
            return
        }
        databasePath
            .observe(.childAdded) { [weak self] snapshot in
                guard
                    let self = self,
                    var json = snapshot.value as? [String: Any]
                else {
                    return
                }
                json["id"] = snapshot.key
                do {
                    let birdData = try JSONSerialization.data(withJSONObject: json)
                    let bird = try self.decoder.decode(Bird.self, from: birdData)
                    self.birds.append(bird)
                } catch {
                    print("an error occurred", error)
                }
            }
    }
    
    func stopListening() {
        databasePath?.removeAllObservers()
    }
}
