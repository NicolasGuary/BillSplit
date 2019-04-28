import Foundation

extension Date{
    
    func format() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
    
    static func generator() -> Date{
        var dc = DateComponents()
        dc.year = 1900
        dc.month = 12
        dc.day = 1
        return Calendar.current.date(from: dc)!
    }
    
    static func currentDate() -> Date{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyyy"
        let formattedDate = format.string(from: date)
        return Date.toDate(dateString: formattedDate)
    }
    
    static func toDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: dateString) ?? currentDate()
    }
    
    static func toString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let myString = formatter.string(from: date)
        return myString
    }
    
}
