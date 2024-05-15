import SwiftUI

struct SessionData {
    let sessionID: String
    let sinkID: String
    let sensorID: String
    let waterAmount: String
    let duration: String
    let startTime: String
    let endTime: String
    let date: String
}

struct SensorDataView: View {
    let jsonData: String
    
    var sessionData: [SessionData] {
        var sessions = [SessionData]()
        
        // Removing brackets and splitting into individual session strings
        let sessionStrings = jsonData.replacingOccurrences(of: "[{", with: "").replacingOccurrences(of: "}]", with: "").split(separator: "}, {")
        
        // Parsing each session string
        for sessionString in sessionStrings {
            let sessionComponents = sessionString.components(separatedBy: ", ")
            var sessionID = ""
            var sinkID = ""
            var sensorID = ""
            var waterAmount = ""
            var duration = ""
            var startTime = ""
            var endTime = ""
            var date = ""
            
            for component in sessionComponents {
                let keyValue = component.components(separatedBy: ": ")
                if keyValue.count == 2 {
                    let key = keyValue[0].trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "\"", with: "")
                    let value = keyValue[1].trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "\"", with: "")
                    
                    switch key {
                    case "session ID":
                        sessionID = value
                    case "sink ID":
                        sinkID = value
                    case "sensor ID":
                        sensorID = value
                    case "water amount":
                        waterAmount = value
                    case "duration":
                        duration = value
                    case "start time":
                        startTime = value
                    case "end time":
                        endTime = value
                    case "data":
                        date = value
                    default:
                        break
                    }
                }
            }
            
            sessions.append(SessionData(sessionID: sessionID, sinkID: sinkID, sensorID: sensorID, waterAmount: waterAmount, duration: duration, startTime: startTime, endTime: endTime, date: date))
        }
        
        return sessions
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(sessionData, id: \.sessionID) { session in
                VStack(alignment: .leading, spacing: 5) {
                    Text("Session ID: \(session.sessionID)")
                    Text("Sink ID: \(session.sinkID)")
                    Text("Sensor ID: \(session.sensorID)")
                    Text("Water Amount: \(session.waterAmount)")
                    Text("Duration: \(session.duration)")
                    Text("Start Time: \(session.startTime)")
                    Text("End Time: \(session.endTime)")
                    Text("Date: \(session.date)")
                }
                .padding()
                .border(Color.gray)
            }
        }
        .padding()
    }
}

