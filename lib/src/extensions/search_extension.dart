import 'dart:convert';

import '../models/models.dart';
import '../youtube_explode_base.dart';

/// Search extension for [YoutubeExplode]
extension SearchExtension on YoutubeExplode {
  Future<Map<String, dynamic>> _getSearchResults(String query, int page) async {
    var url =
        'https://youtube.com/search_ajax?style=json&search_query=${Uri
        .encodeQueryComponent(query)}&page=$page&hl=en';
    var raw = (await client.get(url)).body;

    return json.decode(raw);
  }

  /// Searches videos using given query up to [maxPages] count.
  Future<List<Video>> searchVideos(String query, [int page = 0]) async {
    print('v0 = ${DateTime.now()}');
    var videos = <Video>[];
    var resultsJson = await _getSearchResults(query, page);

    var videosJson = resultsJson['video'] as List<dynamic>;
    if (videosJson == null) {
      return videos;
    }

    videosJson.forEach((videoJson) {
      var id = videoJson['encrypted_id'];
      var author = videoJson['author'];
      var title = videoJson['title'];
      var description = videoJson['description'];
      var duration = Duration(seconds: videoJson['length_seconds']);

      var thumbnails = ThumbnailSet(id);
      videos.add(Video(
          id: id,
          author: author,
          title: title,
          description: description,
          thumbnailSet: thumbnails,
          duration: duration));
    });

    print('v1 = ${DateTime.now()}');


    return videos;
  }
}
