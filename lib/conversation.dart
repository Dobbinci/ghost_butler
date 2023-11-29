import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'package:rive/rive.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'login.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  late RiveAnimationController _controller;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  //fields for TTS
  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? _newVoiceText;
  int? _inputLength;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;



  @override
  void initState() {
    super.initState();
    _initSpeech();
    initTts();
    _controller = SimpleAnimation('idle');
  }
  //initialize for tts
  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    //var voice = {"locale": "en-US", "gender": "male", 'identifier': 'com.apple.speech.synthesis.voice.Fred', 'name': 'Fred'};
    await flutterTts.setLanguage('ko-KR');
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await flutterTts.speak(_newVoiceText!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }
  //나중에 필요할 수도 있을 것 같아서
  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  //여기에 jimmy의 응답을 string으로 넣으면 tts 작동
  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult, localeId: 'ko-KR');
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _onChange(_lastWords);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(40, 22, 59, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 22, 59, 1.0),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            //auth에서 가저온 정보 넣기
            UserAccountsDrawerHeader(
                accountName: Text('Vinci'),
                accountEmail: Text('vinci@handong.ac.kr')),
            ListTile(
              leading: Icon(
                Icons.person,
              ),
              title: Text('Jimmey'),
              iconColor: const Color.fromRGBO(232, 50, 230, 1.0),
              onTap: () {
                Navigator.pushNamed(context, '/mypage');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.chat,
              ),
              title: Text('채팅 모드'),
              iconColor: const Color.fromRGBO(232, 50, 230, 1.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
              ),
              title: Text('환경설정'),
              iconColor: const Color.fromRGBO(232, 50, 230, 1.0),
              onTap: () {
                Navigator.pushNamed(context, '/favorite');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
              ),
              title: Text('로그아웃'),
              iconColor: const Color.fromRGBO(232, 50, 230, 1.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Text(
            // If listening is active show the recognized words
            _speechToText.isListening
                ? '$_lastWords'
                // If listening isn't active but could be tell the user
                // how to start it, otherwise indicate that speech
                // recognition is not yet ready or not supported on
                // the target device
                : _speechEnabled
                    ? 'Tap the microphone to start listening...'
                    : 'Speech not available',
          style: TextStyle(color: Colors.white),),
        ),
        Expanded(
            child: Align(
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: 1,
            child: RiveAnimation.asset(
              'assets/rive/ghost.riv',
            ),
          ),
        )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 70.0),
            child: ElevatedButton(
              onPressed: () {
                _speechToText.isNotListening ? _startListening() : _stopListening();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                fixedSize: const Size(80, 80),
              ),
              child: Icon(
                  _speechToText.isNotListening ? Icons.mic_off : Icons.mic),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 70.0),
            child: ElevatedButton(
              onPressed: () {
                _speak();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                fixedSize: const Size(80, 80),
              ),
              child: Icon(Icons.surround_sound),
            ),
          ),
        )
      ]),
    );
  }
}
