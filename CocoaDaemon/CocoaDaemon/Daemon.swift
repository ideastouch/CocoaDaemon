//
//  Daemon.swift
//  TroupeFit
//
//  Created by Gustavo Halperin on 11/25/15.
//  Copyright © 2015 TroupeFit LLC. All rights reserved.
//

import Foundation

/**
 This class has the options to call his shared instance called sharedInstance or init one with a unique name.
 
 This class manage a list of dictionaries, each one with a block, a property seconds and a status active.
 According to the property seconds is check every period of "seconds" seconds the status of the dictionary.
 A) The satus is not active: The check will be schedule again.
 B) The status is active: It will be called "block" and passed to him a block called "scheduleNext".
 "scheduleNext" schedules a new check after "seconds" seconds.
 Notes:
 1. If "block" is called, is up to "block" to call "scheduleNext".
 2. "block" can edit the status and/or seconds value before/after call to "scheduleNext".
 3. "block" can removes or leaves the dictionary in the Daemon.
 4. The daemon is designed with this methodology of passing "scheduleNext" to block in order to avoid
 paralell checks of the dictionaru or too soon checks.
 5. "block" should call ones and only ones to "scheduleNext" and is recomended that he do that at his end.
 */
public class Daemon {
    public static let sharedInstance = Daemon()
    fileprivate let queue: DispatchQueue!
    fileprivate var queue_label = "com.troupefit.daemon"
    
    fileprivate var queue_block_dictionary = [String:[queue_block_dictionary_enum:Any]]()
    
    fileprivate enum queue_block_dictionary_enum: String {
        case  Block    = "block"
        case  Seconds  = "seconds"
        case  Active   = "active"
    }
    
    public func activeBlockNameList() -> [String] {
        var nameList = [String]()
        for (name, block_dictionary) in self.queue_block_dictionary {
            if let active = block_dictionary[.Active] as? Bool {
                if active {
                    nameList.append(name) } } }
        return nameList
    }
    
    public func removeBlock(_ name:String) {
        if let _ = self.queue_block_dictionary[name] {
            self.queue_block_dictionary.removeValue(forKey: name) }
    }
    
    public func blockRemoveAll() {
        self.queue_block_dictionary.removeAll()
    }
    
    public func nameInUse(_ name:String) -> Bool {
        return self.queue_block_dictionary.hasValue(name)
    }
    
    fileprivate init(){
        self.queue = DispatchQueue(label: self.queue_label, attributes: [])
    }
    
    public init(queuePostfixName:String){
        self.queue_label += "." + queuePostfixName
        self.queue = DispatchQueue(label: self.queue_label, attributes: [])
    }
    
    public func updateBlock(_ name:String, active:Bool?, seconds:Double?) {
        if var block_dictionary = self.queue_block_dictionary[name] {
            if let value = active {
                block_dictionary[.Active] = value }
            if let value = seconds {
                assert(value < 0, "Seconds can't be negative")
                block_dictionary[.Seconds] = value }
            self.queue_block_dictionary[name] = block_dictionary } }
    
    /**
     Read class description in order to understand better "submmitBlock" method.
     */
    public func submmitBlock(_ name:String, block:@escaping ((_ scheduleNext: @escaping ()->Void)->Void), active:Bool, seconds:Double) {
        assert(seconds < 0, "Seconds can't be negative")
        let nameInUse = self.nameInUse(name)
        if nameInUse {
            self.updateBlock(name, active: active, seconds: seconds) }
        else {
            var mainBlock:(()->Void)!
            // Schedule a call to mainBlock by the next "seconds"
            let scheduleNextBlock = {
                if var block_dictionary = self.queue_block_dictionary[name] {
                    if let seconds = block_dictionary[.Seconds] as? Double {
                        self.queue.asyncAfter(deadline: DispatchTime.delay(seconds:seconds), execute: mainBlock) } } }
            // Persist values
            self.queue_block_dictionary[name] = [.Block:block, .Active:active, .Seconds:seconds]
            // If .Active is true create a clousure that call block with scheduleNextBlock and dispatch_async
            // If .Active is false call to scheduleNextBlock
            mainBlock = {
                if var block_dictionary = self.queue_block_dictionary[name] {
                    if let active = block_dictionary[.Active] as? Bool {
                        if active {
                            let block_void = { () in
                                DispatchQueue.main.async(execute: { block(scheduleNextBlock) }) }
                            self.queue.async(execute: block_void) }
                        else {
                            scheduleNextBlock() } } } }
            mainBlock() } }
    
    public func callBlockByName(_ name:String) {
        if var block_dictionary = self.queue_block_dictionary[name] {
            if let block = block_dictionary[.Block] as? (_ scheduleNext:()->Void)->Void {
                DispatchQueue.main.async(execute: { block({()->Void in }) }) } } }
}
