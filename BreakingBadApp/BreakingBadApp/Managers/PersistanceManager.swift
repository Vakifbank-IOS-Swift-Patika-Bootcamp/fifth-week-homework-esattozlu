//
//  PersistanceManager.swift
//  BreakingBadApp
//
//  Created by Hasan Esat Tozlu on 29.11.2022.
//

import UIKit
import CoreData

final class PersistanceManager {
    static let shared = PersistanceManager()
    private let managedContext: NSManagedObjectContext!
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func saveNote(seasonEpisode: String, note: String) {
        let entity = NSEntityDescription.entity(forEntityName: "EpisodeNotes", in: managedContext)!
        let noteObject = NSManagedObject(entity: entity, insertInto: managedContext)
        noteObject.setValue(seasonEpisode, forKey: "seasonEpisode")
        noteObject.setValue(note, forKey: "note")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func getNotes() -> [EpisodeNotes]{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "EpisodeNotes")
        
        do {
            let notes = try managedContext.fetch(fetchRequest)
            return notes as! [EpisodeNotes]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    func deleteNote(note: EpisodeNotes) {
        managedContext.delete(note)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func updateNote(note: EpisodeNotes) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "EpisodeNotes")
        guard let episode = note.seasonEpisode, let newNote = note.note else { return }
        fetchRequest.predicate = NSPredicate(format: "seasonEpisode == %@", episode)
        guard let result = try? managedContext.fetch(fetchRequest) else { return }
        result[0].setValue(newNote, forKey: "note")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
