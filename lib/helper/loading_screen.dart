import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:freecodecamp/helper/loading_handler.dart';

class LoadingScreen {
  static final _singlescreen = LoadingScreen._initializer();
  LoadingScreen._initializer();
  factory LoadingScreen() => _singlescreen;
  void show({required String text, required BuildContext context}) {
    if (controler?.updateloading(text) ?? false) {
      return;
    } else {
      controler = overlayscreen(context: context, text: text);
    }
  }

  void hide() {
    controler?.closeloading();
    controler = null;
  }

  LoadingControler? controler;
  LoadingControler overlayscreen({
    required BuildContext context,
    required String text,
  }) {
    final _text = StreamController<String>();
    _text.add(text);
    final state = Overlay.of(context);
    final renderbox = context.findRenderObject() as RenderBox;
    final size = renderbox.size;
    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 16),
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 16,
                      ),
                      StreamBuilder(
                        stream: _text.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data as String,
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return const Text(
                              "loading......",
                              textAlign: TextAlign.center,
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    state.insert(overlay);
    return LoadingControler(
      closeloading: () {
        overlay.remove();
        _text.close();
        return true;
      },
      updateloading: (text) {
        _text.add(text);
        return true;
      },
    );
  }
}
