import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_shop_flutter/model/video_model.dart';
import 'package:video_shop_flutter/page/video_page.dart';

import '../model/category.dart';

class VideoShopFlutter extends StatefulWidget {
  /// Create Video Player Layout Like Tiktok.
  ///
  /// The listData, pageSize, loadMore are required.
  ///
  /// The others arguments use for custom UI (not required),
  ///
  /// if you want to hide them, you can return SizeBox.shrink().
  ///
  /// Note: the [listData] is a list of Map, each Map is a Video object and
  ///
  /// video object required some field of data like this:
  ///
  /// ```dart
  /// {
  ///   'id': 123,
  ///   'url': 'https://video.mp4',
  ///   'thumbnail': 'https://thumbnail.jpg',
  ///   'likes': 100,
  ///   'liked': true,
  /// }
  /// ```
  ///
  /// Please follow above format data.
  ///
  /// The [pageSize] is size of list data every time load more data,
  ///
  /// it affects when to load more data.
  ///
  /// The loadMore is a function to load more data,
  ///
  /// it is called every time current PageView is at position:
  ///
  /// [listData.length] - ([pageSize]/2)
  ///
  /// Example:
  ///
  /// ```dart
  /// VideoShopFlutter(
  ///       listData: data,
  ///       pageSize: 10,
  ///       loadMore: (){
  ///         debugPrint("load more...");
  ///         setState(() {
  ///           data = [...data, ...playList];
  ///         });
  ///       }
  ///  )
  ///
  /// ```
  const VideoShopFlutter({
    Key? key,
    required this.listData,
    this.customVideoInfo,
    this.followWidget,
    this.likeWidget,
    this.commentWidget,
    this.shareWidget,
    this.buyWidget,
    this.viewWidget,
    required this.pageSize,
    required this.loadMore,
    this.informationPadding,
    required this.videoWatched,
    this.lastSeenPage,
    this.actionsPadding,
    this.informationAlign,
    this.actionsAlign,
    this.updateLastSeenPage,
    this.enableBackgroundContent,
    required this.productsVideoControllers,
    this.categories,
    this.selectCategory,
    required this.onCategoryChange
  }) : super(key: key);

  /// Index of last seen page.
  ///
  /// If [lastSeenPage] has value: initial page of video page view is [lastSeenPage].
  ///
  /// Default value is 0.
  final int? lastSeenPage;

  /// Callback function to update last seen page.
  ///
  /// Called every time video page is changed.
  final Function(int lastSeenPage)? updateLastSeenPage;

  /// Id of your watched videos.
  ///
  /// The [videoWatched] will be updated every time new video is watched.
  final List<String> videoWatched;

  /// Your input data.
  ///
  /// Data must be a List<Map<String, dynamic>.
  ///
  /// Follow this format data:
  ///
  /// ```dart
  /// {
  ///   'id': 123,
  ///   'url': 'https://video.mp4',
  ///   'thumbnail': 'https://thumbnail.jpg',
  ///   'likes': 100,
  ///   'liked': true,
  ///   'description': 'this is description'
  ///   'video_title': this is title of video'
  /// }
  /// ```
  final List<Map<String, dynamic>> listData;

  /// Your pageSize when you call get-list API.
  final int pageSize;

  /// Load more data.
  ///
  /// It is called every time current PageView is at position:
  ///
  /// [listData.length] - ([pageSize]/2)
  ///
  /// The first argument is current page of video list (start at 0),
  ///
  /// it depends on [pageSize].
  ///
  /// The seconds argument is your [pageSize]
  final Function(int page, int pageSize) loadMore;

  /// Alignment of video information.
  final AlignmentGeometry? informationAlign;

  /// Alignment of video actions.
  final AlignmentGeometry? actionsAlign;

  /// Padding of video actions.
  final EdgeInsetsGeometry? actionsPadding;

  /// Padding of video information.
  final EdgeInsetsGeometry? informationPadding;

  /// Create video information widget.
  final Widget Function(VideoModel? video)? customVideoInfo;

  /// Create follow action widget.
  final Widget Function(VideoModel? video)? followWidget;

  /// Create like action widget.
  ///
  /// The first argument is instant of Video.
  ///
  /// The second argument is function to update data,
  ///
  /// this function receives two argument:
  ///
  /// first is total likes, second is liked status (true or false)
  ///
  /// this function need be called when total likes or liked status be changed
  final Widget Function(VideoModel? video, Function(int likes, bool liked))? likeWidget;

  /// Create action comment widget.
  final Widget Function(VideoModel? video)? commentWidget;

  /// Create action share widget.
  final Widget Function(VideoModel? video)? shareWidget;

  /// Create action buy widget.
  final Widget Function(VideoModel? video)? buyWidget;

  /// Create action view product widget
  final Widget Function(VideoModel? video, int index)? viewWidget;

  final List<Category>? categories;

  final Function({int? id})? selectCategory;

  final Function(int) onCategoryChange;

  /// On/Off background content.
  ///
  /// If `enableBackgroundContent = true` background is showed,
  ///
  /// if value is null or false, background is hidden
  final bool? enableBackgroundContent;
  final List<VideoPlayerController> productsVideoControllers;

  @override
  State<VideoShopFlutter> createState() => _VideoShopFlutterState();
}

class _VideoShopFlutterState extends State<VideoShopFlutter> {
  late PageController _pageController;
  int currentPage = 0;
  int currentCategory = 0;


  initialazation() async {
    //TODO MY CODE

    if (widget.productsVideoControllers.isNotEmpty) {
      /// Initialize 1st video
      await _initializeControllerAtIndex(currentPage);

      /// Play 1st video
      _playControllerAtIndex(currentPage);

      /// Initialize 2nd vide
      _initializeControllerAtIndex(currentPage + 1); //if (widget.productsVideoControllers.length >= currentPage + 1) 

      /// Initialize 3nd vide
      _initializeControllerAtIndex(currentPage + 2); //if (widget.productsVideoControllers.length >= currentPage + 2)
    }

    //TODO MY CODE


  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.lastSeenPage ?? 0);
    initialazation();
    
  }


  Future _initializeControllerAtIndex(int index) async {
    //TODO MY CODE
    if (widget.listData.length > index && index >= 0) {
      VideoModel video = VideoModel.fromJson(widget.listData[index]);

      /// Create new controller
      final VideoPlayerController _controller = VideoPlayerController.network(video.url);

      /// Initialize
      if (!widget.productsVideoControllers[index].value.isInitialized) {
        widget.productsVideoControllers[index] = _controller;
      }
      widget.productsVideoControllers[index].initialize();

      log('🚀🚀🚀 INITIALIZED $index');
    }
    //TODO MY CODE

  }

  void _playControllerAtIndex(int index) async{

    if (widget.listData.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController _controller = widget.productsVideoControllers[index];

      /// Play controller
      _controller.play();
      
      log('🚀🚀🚀 PLAYING $index');
    }
  }

  void _stopControllerAtIndex(int index) {

    if (widget.listData.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController _controller = widget.productsVideoControllers[index];

      /// Pause
      _controller.pause();

      /// Reset postiton to beginning
      _controller.seekTo(const Duration());
      log('🚀🚀🚀 STOPPED $index');
    }
  }

  void _playPrevious(int index) {

    /// Play current video (already initialized)
    _playControllerAtIndex(index);

    /// Initialize [index - 1] controller
   if(index - 1 >= 0 ) _initializeControllerAtIndex(index - 1);

    /// Initialize [index - 2] controller
   if(index - 2 >= 0 ) _initializeControllerAtIndex(index - 2);

    /// Stop [index + 1] controller
    _stopControllerAtIndex(index + 1);

    /// Stop [index + 2] controller
    _stopControllerAtIndex(index + 2);

    /// Dispose [index + 2] controller
    //_disposeControllerAtIndex(index + 2);

  }

  void _playNext(int index) {


    /// Play current video (already initialized)
    _playControllerAtIndex(index);
    /// Initialize [index + 1] controller
    if(index + 1 <= widget.productsVideoControllers.length) _initializeControllerAtIndex(index + 1);
    /// Initialize [index + 2] controller
   if(index + 2 <= widget.productsVideoControllers.length) _initializeControllerAtIndex(index + 2);

    /// Stop [index - 1] controller
    _stopControllerAtIndex(index - 1 < 0 ? 0 : index - 1);
    /// Stop [index - 1] controller
    _stopControllerAtIndex(index - 2 < 0 ? 0 : index - 2);

    /// Dispose [index - 1] controller
    ///_disposeControllerAtIndex(index - 1 < 0 ? 0 : index - 1);
    /// Dispose [index - 2] controller
   /// _disposeControllerAtIndex(index - 2 < 0 ? 0 : index - 2);
  }

  void _disposeControllerAtIndex(int index) {
    if (index >= 0 && widget.productsVideoControllers.length > index) {
      /// Get controller at [index]
      final VideoPlayerController _controller = widget.productsVideoControllers[index];

      /// Dispose controller
      _controller.dispose();
      //widget.productsVideoControllers.remove(_controller);
      log('🚀🚀🚀 DISPOSED $index');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle load more.
    _pageController.addListener(() {
      if (_pageController.page != null) {
        if (_pageController.page!.round() != currentPage) {
          currentPage = _pageController.page!.round();
          if (currentPage == widget.listData.length - (widget.pageSize / 2)) {
            widget.loadMore(
              (currentPage ~/ widget.pageSize),
              widget.pageSize,
            );
          }
        }
      }
    });

    return PageView(
      onPageChanged: widget.onCategoryChange,
      scrollDirection: Axis.horizontal,
      children: List.generate(
        widget.categories!.length, (index) => PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: List.generate(widget.listData.length, (index) {
              return VideoPage(
                enableBackgroundContent: widget.enableBackgroundContent,
                updateLastSeenPage: widget.updateLastSeenPage,
                video: VideoModel.fromJson(widget.listData[index]),
                customVideoInfo: widget.customVideoInfo,
                followWidget: widget.followWidget,
                likeWidget: widget.likeWidget,
                commentWidget: widget.commentWidget,
                shareWidget: widget.shareWidget,
                buyWidget: widget.buyWidget,
                videoWatched: widget.videoWatched,
                actionsAlign: widget.actionsAlign,
                actionsPadding: widget.actionsPadding,
                informationAlign: widget.informationAlign,
                informationPadding: widget.informationPadding,
                viewWidget: widget.viewWidget,
                index: index,
                videoController: widget.productsVideoControllers[index],
                categories: widget.categories,
              );
            }),
            onPageChanged: (value) {
              print('_pageController.page! == ${_pageController.page}');
              print('value == $value');
              if (value > _pageController.page!.floor()) {
                 _playNext(value);
              } else {
                _playPrevious(currentPage);
              }
              setState(() {
                currentPage = value.round();
                print('currentPage == $currentPage');
              });
            },
          )),
    );

        
      
  }
}
