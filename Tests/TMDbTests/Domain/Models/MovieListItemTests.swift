//
//  MovieListItemTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct MovieListItemTests {

    @Test("JSON decoding of MovieListItem", .tags(.decoding))
    func decodeReturnsMovieListItem() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            MovieListItem.self, fromResource: "movie-list-item"
        )

        #expect(result == movie)
    }

    @Test("Date formatter for TMDb release dates uses UTC", .tags(.decoding))
    func dateFormatterUsesUTC() {
        let formatter = DateFormatter.theMovieDatabase
    
        #expect(formatter.calendar.identifier == .gregorian)
        #expect(formatter.timeZone?.secondsFromGMT() == 0)
        #expect(formatter.date(from: "1995-03-31") != nil)
    }

    @Test("JSON decoding of MovieListItem keeps DST-edge release dates", .tags(.decoding))
    func decodeHandlesDSTEdgeReleaseDate() throws {
        let json = """
        {
          "id": 9067,
          "title": "Tank Girl",
          "original_title": "Tank Girl",
          "original_language": "en",
          "overview": "Test overview",
          "genre_ids": [28],
          "release_date": "1995-03-31"
        }
        """
    
        let item = try JSONDecoder.theMovieDatabase.decode(
            MovieListItem.self,
            from: Data(json.utf8)
        )
    
        let releaseDate = try #require(item.releaseDate)
        let expected = try #require(DateFormatter.theMovieDatabase.date(from: "1995-03-31"))
        #expect(releaseDate == expected)
    }
}

extension MovieListItemTests {

    private var movie: MovieListItem {
        .init(
            id: 437_342,
            title: "The First Omen",
            originalTitle: "The First Omen",
            originalLanguage: "en",
            originCountry: ["US"],
            overview:
            // swiftlint:disable:next line_length
            "When a young American woman is sent to Rome to begin a life of service to the church, she encounters a darkness that causes her to question her own faith and uncovers a terrifying conspiracy that hopes to bring about the birth of evil incarnate.",
            genreIDs: [27],
            releaseDate: DateFormatter.theMovieDatabase.date(from: "2024-04-05"),
            posterPath: URL(string: "/uGyiewQnDHPuiHN9V4k2t9QBPnh.jpg"),
            backdropPath: URL(string: "/tkHQ7tnYYUEnqlrKuhufIsSVToU.jpg"),
            popularity: 1080.713,
            voteAverage: 6.768,
            voteCount: 455,
            hasVideo: false,
            isAdultOnly: false
        )
    }

}
