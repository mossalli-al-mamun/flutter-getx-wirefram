// import '../../Utils/app_logger.dart';
//
// class PaginatedResponse<T> {
//   final List<T> data;
//   final int totalPage;
//   final int perPage;
//   final int currentPage;
//   final int lastPage;
//   final int totalItems;
//
//   PaginatedResponse({
//     required this.data,
//     required this.totalPage,
//     required this.perPage,
//     required this.currentPage,
//     required this.lastPage,
//     required this.totalItems,
//   });
//
//   factory PaginatedResponse.fromJson(
//     dynamic json,
//     T Function(dynamic) fromJson,
//     Map<String, String>? headers,
//   ) {
//     appLogger('The response plugin...: $json');
//     appLogger('Response Headers: $headers');
//
//     final List<dynamic> rawData = json ?? [];
//
//     // Extract pagination info from headers
//     final totalItems = int.tryParse(headers?['x-wp-total'] ?? '0') ?? 0;
//     final totalPages = int.tryParse(headers?['x-wp-totalpages'] ?? '1') ?? 1;
//
//     // Parse current page from the 'Link' header
//     final linkHeader = headers?['link'] ?? '';
//     int currentPage = 1;
//
//     if (linkHeader.contains('rel="prev"')) {
//       // If there's a prev link, we're at least on page 2
//       final prevMatch = RegExp(r'page=(\d+).*rel="prev"').firstMatch(linkHeader);
//       if (prevMatch != null) {
//         currentPage = int.parse(prevMatch.group(1)!) + 1;
//       }
//     }
//
//     // Default per_page is 10 in WooCommerce if not specified
//     final perPage = int.tryParse(headers?['X-Wp-Per-Page'] ?? '10') ?? 10;
//
//     return PaginatedResponse<T>(
//       data: rawData.map((item) => fromJson(item)).toList(),
//       totalPage: totalPages,
//       perPage: perPage,
//       currentPage: currentPage,
//       lastPage: totalPages,
//       totalItems: totalItems,
//     );
//   }
// }