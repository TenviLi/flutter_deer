
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deer/res/resources.dart';
import 'package:flutter_deer/util/utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'load_image.dart';

/// 搜索页的AppBar
class SearchBar extends StatefulWidget implements PreferredSizeWidget{

  const SearchBar({
    Key key,
    this.hintText: "",
    this.backImg: "assets/images/ic_back_black.png",
    this.onPressed,
  }): super(key: key);

  final String backImg;
  final String hintText;
  final Function(String) onPressed;
  
  @override
  _SearchBarState createState() => _SearchBarState();

  @override
  Size get preferredSize => Size.fromHeight(48.0);
}

class _SearchBarState extends State<SearchBar> {

  SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle.light;
  TextEditingController _controller = TextEditingController();

  Color getColor(){
    return overlayStyle == SystemUiOverlayStyle.light ? Colors.white : Colours.text_dark;
  }
  
  @override
  Widget build(BuildContext context) {

    overlayStyle = Utils.isDark(context) ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Material(
        child: SafeArea(
          child: Container(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 48.0,
                  height: 48.0,
                  child: InkWell(
                    onTap: (){
                      FocusScope.of(context).unfocus();
                      Navigator.maybePop(context);
                    },
                    borderRadius: BorderRadius.circular(24.0),
                    child: Padding(
                      key: const Key('search_back'),
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        widget.backImg,
                        color: getColor(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 32.0,
                    decoration: BoxDecoration(
                      color: Utils.isDark(context) ? Colours.dark_bg_gray : Colours.bg_gray,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Localizations(
                      locale: const Locale("en", ""),
                      delegates: [
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      child: TextField(
                        key: const Key('srarch_text_field'),
                        //style: TextStyles.textDark14,
                        autofocus: true,
                        controller: _controller,
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(top: 6.0, left: -8.0, right: -16.0, bottom: 6.0),
                          border: InputBorder.none,
                          icon: Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
                            child: const LoadAssetImage("order/order_search"),
                          ),
                          hintText: widget.hintText,
                          //hintStyle: TextStyles.textGrayC14,
                          suffixIcon: InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                              child: const LoadAssetImage("order/order_delete"),
                            ),
                            onTap: (){
                              /// https://github.com/flutter/flutter/issues/35909
                              SchedulerBinding.instance.addPostFrameCallback((_) {
                                _controller.text = "";
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Gaps.hGap8,
                Theme(
                  data: Theme.of(context).copyWith(
                    buttonTheme: ButtonThemeData(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        height: 32.0,
                        minWidth: 44.0,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 距顶部距离为0
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        )
                    ),
                  ),
                  child: FlatButton(
                      color: Colours.app_main,
                      textColor: Colors.white,
                      onPressed:(){
                        widget.onPressed(_controller.text);
                      },
                      child: Text("搜索", style: TextStyle(fontSize: 14.0)),
                  ),
                ),
                Gaps.hGap16,
              ],
            )
          ),
        ),
      ),
    );
  }
}
