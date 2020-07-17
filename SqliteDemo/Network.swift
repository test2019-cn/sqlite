//
//  ScheduledTestDataModel.swift
//  MVCDemo
//
//  Created by WistronitsZH on 2020/7/6.
//  Copyright © 2020 Christian. All rights reserved.
//

import Foundation

class NetworkManager {

    // MARK: Completion handler
    var requestScheduledTestIDsCompletion:((_ scheduledTestIDs: [Int])->Void)?
    var requestScheduledTestCompletion:((_ entries: [ScheduledTest])->Void)?

    //MARK: Private variables
    private (set) var scheduledTests = [ScheduledTest]()
    
    //MARK: - Help func
    private func loadHttpRequestBody(withName name: String) -> RequestBody? {
        if let path  = Bundle.main.path(forResource: name, ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path) {
            do {
                return try PropertyListDecoder().decode(RequestBody.self, from: xml)
            } catch  {
                print(error)
            }
            
        }
        return nil
    }

    private func encodeRequestBody(since day: Int) -> Data? {
        if var body = loadHttpRequestBody(withName: "Asia_Scheduled_Requestbody") {
            let daysBefore = dateToStringSince(days: day)
            let tIndex = daysBefore.firstIndex(of: "T")
            let subString = daysBefore.prefix(upTo: tIndex!) + "T16:00:00"
            body.lastModifiedAt = ["gt":String(subString)]
            return try? JSONEncoder().encode(body)
        }
        return nil
    }
    
    private func dateToStringSince(days: Int) -> String {
        let today = Date()
        let nDayBefore = Calendar.current.date(byAdding: .day, value: days, to: today)
        let dt = DateFormatter()
        dt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dt.string(from: nDayBefore!)
    }

    func requestScheduledTestIDs(since day: Int) {
        guard let url = URL(string: "https://radar-webservices.apple.com/scheduled-tests/find") else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("50000", forHTTPHeaderField: "X-rowlimit")
        request.setValue("scheduledID, lastModifiedAt", forHTTPHeaderField: "X-Fields-Requested")

        if let httpBody = encodeRequestBody(since: day) {
            request.httpBody = httpBody
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                do {
                    let results = try JSONDecoder().decode([Hello].self, from: data)
                    let ids = results.map { $0.scheduledID }
                    self.requestScheduledTestIDsCompletion?(ids)
                } catch {
                    fatalError("decode error: \(error)")
                }
                
            }
        }
        task.resume()
    }
    
    func fetchScheduledTest(with ids:[Int]) {
        let idString = ids.map {String($0)}.joined(separator:",")
        
        let url = URL(string: "https://radar-webservices.apple.com/scheduled-tests/\(idString)")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("50000", forHTTPHeaderField: "X-rowlimit")
        request.setValue("lastModifiedAt, scheduledEndDate, scheduledStartDate, component, scheduledID,title, suiteID, suiteTitle", forHTTPHeaderField: "X-Fields-Requested")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200...299:
                    if let data = data {
                        do {
                            self.scheduledTests = try JSONDecoder().decode([ScheduledTest].self, from: data)
                            self.requestScheduledTestCompletion?(self.scheduledTests)
                        } catch {
                            print("Debug:\(error)")
                        }
                    }
                default:
                    print("response: \(response)")
                    return
                }
            }
        }
        task.resume()
    }
}
