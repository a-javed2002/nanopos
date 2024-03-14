import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';

class RingTonee extends StatelessWidget {
  const RingTonee({super.key});

  @override
  Widget build(BuildContext context) {
    List ringtones = [];
    var player = FlutterSoundPlayer();
    return Scaffold(
      body: Column(
        children: [
          if (ringtones.isNotEmpty)
            Expanded(
              child: ListView.builder(
                  itemCount: ringtones.length,
                  itemBuilder: (_, index) {
                    final ringtone = ringtones[index];

                    return Card(child: ListTile(onTap: ()async{
                      player =  (await player.openAudioSession())!;
                      player.startPlayer(
                        fromURI: '/system/media/audio/ringtones/$ringtone.ogg',
                        codec: Codec.opusOGG
                      );
                    },title: Text(ringtone)));
                  }),
            ),
          ElevatedButton(
              onPressed: () async {
                const channel = MethodChannel("flutter_channel");
                ringtones = await channel.invokeMethod('getRingtones');
              },
              child: Text("Get Ringtones"))
        ],
      ),
    );
  }
}
