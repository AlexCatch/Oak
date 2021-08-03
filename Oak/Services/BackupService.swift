//
//  Backup.swift
//  OakOTP
//
//  Created by Alex Catchpole on 03/08/2021.
//

import Foundation

protocol BackupService {
    func generateBackup()
}

class RealBackupService: BackupService {
    func generateBackup() {
        
    }
}
