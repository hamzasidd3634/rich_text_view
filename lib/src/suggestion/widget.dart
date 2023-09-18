import 'package:flutter/material.dart';
import 'package:rich_text_view/rich_text_view.dart';

class SearchItemWidget extends StatelessWidget {
  final SuggestionController suggestionController;
  final TextEditingController? controller;
  final Color? suggestionColor;
  final Color? backgroundColor;
  final Function(TextEditingController)? onTap;

  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double radius;
  SearchItemWidget({
    required this.suggestionController,
    this.controller,
    this.suggestionColor,
    this.backgroundColor,
    this.onTap,        this.padding,
    this.margin,
    this.radius =20,


  });

  @override
  Widget build(BuildContext context) {
    var state = suggestionController.state;
    // var border = BorderSide(
    //     width: Theme.of(context).brightness == Brightness.dark ? 0.1 : 1.0,
    //     color:
    //         state.suggestionHeight > 1 ? suggestionColor! : Colors.transparent);
    return Container(
        constraints: BoxConstraints(
          minHeight: 0,
          maxHeight: state.suggestionHeight,
          maxWidth: double.infinity,
          minWidth: double.infinity,
        ),
        decoration: BoxDecoration(
          color: state.suggestionHeight == 1
              ? Colors.transparent
              : backgroundColor,
          // border: Border(
          //   top: suggestionController.position == SuggestionPosition.top &&
          //           state.suggestionHeight > 1.0
          //       ? border
          //       : BorderSide.none,
          //   left: border,
          //   right: border,
          //   bottom: border,
          // )
        ),
        child: state.loading
            ? Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator()),
            ))
            : Scrollbar(
          thickness: 3,
          child: state.last.startsWith(suggestionController.mentionSymbol)
              ? ListView.builder(
            padding: EdgeInsets.zero,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: state.mentions.length,
            itemBuilder: (context, index) {
              var mention = state.mentions[index];
              if (mention == null) return SizedBox();

              return InkWell(
                onTap: () {
                  var _controller = suggestionController.onuserselect(
                      '${suggestionController.mentionSymbol}${mention.subtitle}',
                      controller!);
                  suggestionController.onMentionSelected
                      ?.call(mention);
                  onTap!(_controller);
                },
                child: suggestionController.mentionSearchCard
                    ?.call(mention) ??
                    ListUserItem(
                      title: mention.title,
                      backgroundColor: backgroundColor!,
                      subtitle: mention.subtitle,
                      imageUrl: mention.imageURL,
                      padding: padding,
                      radius: radius,
                      margin: margin,
                    ),
              );
            },
          )
              : state.hashtags.isNotEmpty
              ? ListView.builder(
              padding: EdgeInsets.zero,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, position) {
                var item = state.hashtags[position];
                return InkWell(
                    onTap: () {
                      var _controller =
                      suggestionController.onuserselect(
                          '${item.hashtag}', controller!);
                      suggestionController.onHashTagSelected
                          ?.call(item);
                      onTap!(_controller);
                    },
                    child: suggestionController.hashTagSearchCard
                        ?.call(item) ??
                        ListTile(
                          onTap: null,
                          title: Text(
                            item.hashtag,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2,
                          ),
                          subtitle: Text(item.subtitle ?? ''),
                          trailing: item.trending
                              ? Text('Trending')
                              : SizedBox(height: 0, width: 0),
                        ));
              },
              itemCount: state.hashtags.length)
              : SizedBox(),
        ));
  }
}

class ListUserItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final Color backgroundColor;

  ListUserItem(
      {Key? key,
        required this.imageUrl,
        required this.backgroundColor,
        required this.title,
        required this.subtitle,
        this.padding,
        this.margin,
        this.radius =20,
      });
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double radius;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:padding?? const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: radius,
        ),
        Flexible(
            child: Container(
              margin:margin?? EdgeInsets.only(left: 20.0, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        title.trim(),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: backgroundColor == Colors.white
                                ? Colors.black
                                : Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0, right: 8.0),
                    child: Container(
                        child: Text(
                          subtitle,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontSize: 14),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  )
                ],
              ),
            )),
      ]),
    );
  }
}