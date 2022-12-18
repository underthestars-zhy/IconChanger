//
//  Request.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/28.
//

import Foundation
import AppKit
import SwiftyJSON

class MyRequestController {
    func sendRequest(_ URL: URL) async throws -> NSImage? {
        /* Configure session, choose between:
         * defaultSessionConfiguration
         * ephemeralSessionConfiguration
         * backgroundSessionConfigurationWithIdentifier:
         And set session-wide properties, such as: HTTPAdditionalHeaders,
         HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
         */
        let sessionConfig = URLSessionConfiguration.default

        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

        /* Create the Request:
         Request (16) (GET https://media.macosicons.com/parse/files/macOSicons/acb24773e8384e032faf6b07704796d3_Spark_icon.icns)
         */

        if URL.isFileURL {
            return NSImage(byReferencing: URL)
        }

        var request = URLRequest(url: URL)
        request.httpMethod = "GET"

        // Headers

        request.addValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: "Accept")
        request.addValue("zh-CN,zh-Hans;q=0.9", forHTTPHeaderField: "Accept-Language")
        request.addValue("keep-alive", forHTTPHeaderField: "Connection")
        request.addValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Safari/605.1.15", forHTTPHeaderField: "User-Agent")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        /* Start a new Task */
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return nil
        }

        return NSImage(data: data)
    }
}

class MyQueryRequestController {
    func sendRequest(_ query: String) async throws -> [IconRes] {
        /* Configure session, choose between:
         * defaultSessionConfiguration
         * ephemeralSessionConfiguration
         * backgroundSessionConfigurationWithIdentifier:
         And set session-wide properties, such as: HTTPAdditionalHeaders,
         HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
         */
        let query = qeuryMix(query)

        let sessionConfig = URLSessionConfiguration.default

        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

        /* Create the Request:
         Request (POST https://p1txh7zfb3-3.algolianet.com/1/indexes/macOSicons/query)
         */

        guard let URL = URL(string: "https://\(UserDefaults.standard.string(forKey: "queryHost") ?? "p1txh7zfb3-2.algolianet.com")/1/indexes/macOSicons/query") else { return [] }
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"

        // Headers
        request.addValue("P1TXH7ZFB3", forHTTPHeaderField: "x-algolia-application-id")
        request.addValue("0ba04276e457028f3e11e38696eab32c", forHTTPHeaderField: "x-algolia-api-key")
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Safari/605.1.15", forHTTPHeaderField: "User-Agent")
        request.addValue("https://macosicons.com", forHTTPHeaderField: "Origin")

        // Form URL-Encoded Body

        let bodyObject: [String : Any] = [
            "hitsPerPage": 100,
            "query": query,
            "filters": "approved:true",
            "page": 0
        ]
        request.httpBody = try! JSONSerialization.data(withJSONObject: bodyObject, options: [])

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return []
        }

        let json = try JSON(data: data)
        let res = json["hits"].arrayValue.compactMap { hit in
            if let lowResPngUrl = hit["lowResPngUrl"].url, let icnsUrl = hit["icnsUrl"].url {
                return IconRes(appName: hit["appName"].stringValue, icnsUrl: icnsUrl, lowResPngUrl: lowResPngUrl, downloads: hit["downloads"].intValue)
            } else {
                return nil
            }
        }

        return res
            .filter {
                $0.appName.lowercased().replace(target: " ", withString: "").contains(query.lowercased().replace(target: " ", withString: ""))
            }
            .sorted { res1, res2 in
                res1.downloads > res2.downloads
            }
    }

    func qeuryMix(_ query: String) -> String {
        switch query {
        case "PyCharm Professional Edition": return "PyCharm"
        case "Discord PTB": return "Discord"
        default: return query
        }
    }
}


protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }

}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
     */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}

