// import 'package:cached_video_player_plus/cached_video_player_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:video_player/video_player.dart';
// import 'package:ysr_project/features/home_screen/providers/home_feed_repository.dart';
//
// void main() {
//   runApp(ProviderScope(
//     child: MyApp(),
//   ));
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ConsumerStatefulWidgetExp(),
//     );
//   }
// }
//
// class ConsumerStatefulWidgetExp extends ConsumerStatefulWidget {
//   @override
//   _ConsumerStatefulWidgetState createState() => _ConsumerStatefulWidgetState();
// }
//
// class _ConsumerStatefulWidgetState
//     extends ConsumerState<ConsumerStatefulWidget> {
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = ref.watch(homeFeedNotifierProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video player testing'),
//       ),
//       body: viewModel.homeFeedViewModels.isEmpty
//           ? Center(
//               child: Text('No videos found'),
//             )
//           : ListView.builder(
//               itemCount: viewModel.homeFeedViewModels.length,
//               itemBuilder: (context, index) {
//                 final homeFeedViewModel = viewModel.homeFeedViewModels[index];
//                 // Use Column instead of ListView.builder for the inner list
//                 return Column(
//                   // <--- Changed from ListView.builder
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start, // Optional: Align children
//                   children: homeFeedViewModel.media.map((media) {
//                     if (media.fileType.contains("mp4")) {
//                       return VideoPlayerTemp(
//                         videoUrl: media.fileUrl,
//                       );
//                     } else {
//                       return ListTile(
//                         title: Text(media.fileUrl),
//                       );
//                     }
//                   }).toList(),
//                 );
//               },
//             ),
//     );
//   }
// }
//
// class VideoPlayerTemp extends StatefulWidget {
//   final String videoUrl;
//
//   const VideoPlayerTemp({
//     Key? key,
//     required this.videoUrl,
//   }) : super(key: key);
//
//   @override
//   _VideoPlayerTempState createState() => _VideoPlayerTempState();
// }
//
// class _VideoPlayerTempState extends State<VideoPlayerTemp> {
//   late CachedVideoPlayerPlusController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = CachedVideoPlayerPlusController.network(widget.videoUrl);
//     _initializeVideoPlayerFuture = _controller.initialize().then((_) {
//       setState(() {});
//       _controller.play(); // 🔥 START PLAYBACK
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initializeVideoPlayerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           // If the VideoPlayerController has finished initialization, use
//           // the data it provides to limit the aspect ratio of the video.
//           return AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             // Use the VideoPlayer widget to display the video.
//             child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(width: 1, color: Colors.grey),
//                 ),
//                 margin: const EdgeInsets.all(10),
//                 padding: const EdgeInsets.all(10),
//                 child: CachedVideoPlayerPlus(_controller)),
//           );
//         } else {
//           // If the VideoPlayerController is still initializing, show a
//           // loading spinner.
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
