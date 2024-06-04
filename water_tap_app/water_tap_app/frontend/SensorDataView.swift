import SwiftUI

struct SessionData: Identifiable {
    let id = UUID()
    let sessionID: String
    let sinkID: String
    let sensorID: String
    let waterAmount: String
    let duration: String
    let startTime: String
    let endTime: String
    let date: String
}


struct SessionTile: View {
    let session: SessionData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(session.startTime) - \(session.endTime)")
                    .font(.headline)
                    .padding(.bottom, 4)
                Spacer()
            }
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("**Location**: \(session.sinkID)")
                    Text("**Sensor Number** \(session.sensorID)")
                    Text("**Water Amount**: \(session.waterAmount)")
                    Text("**Session Duration**: \(session.duration)")
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct SensorDataView: View {
    let jsonData: String
    let date: String
    
    private var sessionData: [SessionData] {
        var sessions = [SessionData]()
        
        // Removing brackets and splitting into individual session strings
        let sessionStrings = jsonData.replacingOccurrences(of: "[{", with: "").replacingOccurrences(of: "}]", with: "").split(separator: "}, {")
        
        print(jsonData)
        
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
                        waterAmount = value + "L"
                    case "duration":
                        duration = value + " sec"
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
        
        return sessions.sorted { $0.startTime > $1.startTime }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Text("Sink Usage Sessions for: ")
                        .bold()
                    Text(date)
                        .bold()
                }
                .padding(.top)
                ForEach(sessionData) { session in
                    SessionTile(session: session)
                }
            }
            .padding()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}
