import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

void main() => runApp(Myapp());

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Speech to Text App',
      home: VoiceHome(),
      theme: ThemeData.dark(),
    );
  }
}

// MAIN LOGIC BEHIND SPEECH-TO-TEXT RECOGNISTION (dyamic approch of statefulwidget)
class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {
// variables for use in code
  SpeechRecognition _speechRecognition;

  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  //  LOGIC FUNCTION FOR RECOGNIZER

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    // for availabilty callback
    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => _isAvailable = result),
    );

    // for starting record callback
    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );

    // for speech to text
    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => resultText = speech),
    );

    // for ending record callback
    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => _isListening = false),
    );

////// NOW TO ACTIVATE THE MICROPHONE ////
    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            //for cancel
         /*   FloatingActionButton(
              child: Icon(Icons.cancel),
              mini: true,
              backgroundColor: Colors.redAccent,
              onPressed: () {
                if (_isListening) {
                  _speechRecognition.cancel().then(
                        (result) => setState(() {
                          _isListening = result;
                          resultText = "";
                        }),
                      );
                }
              },
            ), */
            // to record
            FloatingActionButton(
              child: Icon(Icons.mic),
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                // if available and not listening then print the speech to text
                if (_isAvailable && !_isListening) {
                  _speechRecognition
                      .listen(locale: "en_US") // language
                      .then((result) => print('$result'));
                }
              },
            ),

            /// to stop/pause
          /*  FloatingActionButton(
              child: Icon(Icons.stop),
              mini: true,
              backgroundColor: Colors.greenAccent,
              onPressed: () {
                if (_isListening) {
                  _speechRecognition.stop().then(
                        // this will turn result true to false
                        (result) => setState(() => _isListening = result),
                      );
                }
              },
            ),*/
          ]),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              resultText,
              style: TextStyle(fontSize: 24.0),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              borderRadius: BorderRadius.circular(6.0),
            ),
          )
        ],
      )),
    );
  }
}
