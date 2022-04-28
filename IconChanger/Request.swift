//
//  Request.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/28.
//

import Foundation
import AppKit

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
            print("do")
            return nil
        }

        return NSImage(data: data)
    }
}
