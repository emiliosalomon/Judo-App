/// Kuratierte YouTube-Links zu einzelnen Techniken.
///
/// Quelle: eine vom Nutzer selbst zusammengestellte OeJV-Pruefungsunterlage
/// ("1. Dan Zusammenfassung mit Videolinks") mit Verlinkungen zu Gokyo-no-waza
/// (40 Wurftechniken), Katame-waza (Halte-/Wuerge-/Hebeltechniken) und den
/// Renraku/Gonosen-Zusatztechniken des 1. Dan. Die Technik-Namen ueberschneiden
/// sich mit vielen Kyu- und Dan-Programmpunkten, daher ist die Zuordnung hier
/// nicht auf eine Guertelstufe beschraenkt.
///
/// Fuer Techniken ohne Eintrag hier faellt die App auf eine YouTube-Suche
/// zurueck (siehe youtube_link.dart).
const techniqueVideos = <String, String>{
  // Gokyo-no-waza (Wurftechniken, Gruppe 1-5)
  'De-ashi-barai': 'https://www.youtube.com/watch?v=4BUUvqxi_Kk',
  'Hiza-guruma': 'https://www.youtube.com/watch?v=JPJx9-oAVns',
  'Sasae-tsuri-komi-ashi': 'https://www.youtube.com/watch?v=699i--pvYmE',
  'Uki-goshi': 'https://www.youtube.com/watch?v=bPKwtB4lyOQ',
  'O-soto-gari': 'https://www.youtube.com/watch?v=c-A_nP7mKAc',
  'O-goshi': 'https://www.youtube.com/watch?v=yhu1mfy2vJ4',
  'O-uchi-gari': 'https://www.youtube.com/watch?v=0itJFhV9pDQ',
  'Seoi-nage': 'https://www.youtube.com/watch?v=FQnOlCxo4oI',
  'Ko-soto-gari': 'https://www.youtube.com/watch?v=jeQ541ScLB4',
  'Ko-uchi-gari': 'https://www.youtube.com/watch?v=3Jb3tZvr9Ng',
  'Koshi-guruma': 'https://www.youtube.com/watch?v=SU7Id6uVJ44',
  'Tsuri-komi-goshi': 'https://www.youtube.com/watch?v=McfzA0yRVt4',
  'Okuri-ashi-barai': 'https://www.youtube.com/watch?v=nw1ZdRjrdRI',
  'Ko-soto-gake': 'https://www.youtube.com/watch?v=8b6kY4s4zH4',
  'Tsuri-goshi': 'https://www.youtube.com/watch?v=51Htlp7xEvE',
  'Yoko-otoshi': 'https://www.youtube.com/watch?v=MnNG67pF_a0',
  'Ashi-guruma': 'https://www.youtube.com/watch?v=ROeayhvom9U',
  'Harai-tsuri-komi-ashi': 'https://www.youtube.com/watch?v=gGPXvWL8VbE',
  'Sumi-gaeshi': 'https://www.youtube.com/watch?v=5VhduA5xkbA',
  'Tani-otoshi': 'https://www.youtube.com/watch?v=3b9Me3Fohpk',
  'Hane-maki-komi': 'https://www.youtube.com/watch?v=6CRBGLGz9j8',
  'Sukui-nage': 'https://www.youtube.com/watch?v=vU6aJ2kFxoI',
  'Utsuri-goshi': 'https://www.youtube.com/watch?v=4pQd_bEnlf0',
  'O-guruma': 'https://www.youtube.com/watch?v=SnZciTAY9vc',
  'Soto-maki-komi': 'https://www.youtube.com/watch?v=bWG9O1BVKtQ',
  'Uki-otoshi': 'https://www.youtube.com/watch?v=6H5tmncOY4Q',
  'O-soto-guruma': 'https://www.youtube.com/watch?v=92KbCm6pQeI',
  'Uki-waza': 'https://www.youtube.com/watch?v=weVOpJ63gII',
  'Yoko-wakare': 'https://www.youtube.com/watch?v=bp1tscHlePI',
  'Yoko-guruma': 'https://www.youtube.com/watch?v=MehP6I5cY2c',
  'Ushiro-goshi': 'https://www.youtube.com/watch?v=ORIYstuxYT8',
  'Ura-nage': 'https://www.youtube.com/watch?v=Fgi9b8DJ5sQ',
  'Sumi-otoshi': 'https://www.youtube.com/watch?v=lLU9wv52ni0',
  'Yoko-gake': 'https://www.youtube.com/watch?v=tP1Sj1uDfSo',

  // Katame-waza: Osae-komi-waza (Festhaltegriffe)
  'Kesa-gatame': 'https://www.youtube.com/watch?v=NDaQuJOFBYk',
  'Kuzure-kesa-gatame': 'https://www.youtube.com/watch?v=Q2fb9jaoUFQ',
  'Ushiro-kesa-gatame': 'https://www.youtube.com/watch?v=SBapox2M2dE',
  'Kata-gatame': 'https://www.youtube.com/watch?v=zQR3IOXxO_Q',
  'Kami-shiho-gatame': 'https://www.youtube.com/watch?v=HFuMjOv0WN8',
  'Kuzure-kami-shiho-gatame': 'https://www.youtube.com/watch?v=YUrogQWdwiY',
  'Yoko-shiho-gatame': 'https://www.youtube.com/watch?v=TT7XJVSEQxA',
  'Tate-shiho-gatame': 'https://www.youtube.com/watch?v=55-rFmBx53g',
  'Uki-gatame': 'https://www.youtube.com/watch?v=e_lAjik1SUM',
  'Ura-gatame': 'https://www.youtube.com/watch?v=eeAHZB0v3XY',

  // OeJV-Kyu-Programm "Prinzip"-Uebungen (10./9. Kyu): Positions-Grundprinzip
  // der jeweiligen Shiho-gatame-Familie, daher auf die Basistechnik verlinkt.
  'Prinzip „Kesa"': 'https://www.youtube.com/watch?v=NDaQuJOFBYk',
  'Prinzip „Yoko"': 'https://www.youtube.com/watch?v=TT7XJVSEQxA',
  'Prinzip „Tate"': 'https://www.youtube.com/watch?v=55-rFmBx53g',
  'Prinzip „Kami"': 'https://www.youtube.com/watch?v=HFuMjOv0WN8',

  // Katame-waza: Shime-waza (Wuergetechniken)
  'Nami-juji-jime': 'https://www.youtube.com/watch?v=k2cHry9HByQ',
  'Gyaku-juji-jime': 'https://www.youtube.com/watch?v=t3tQriIPdlI',
  'Kata-juji-jime': 'https://www.youtube.com/watch?v=3VZVUAmiMD8',
  'Hadaka-jime': 'https://www.youtube.com/watch?v=9f0n8jez7iA',
  'Okuri-eri-jime': 'https://www.youtube.com/watch?v=EiqyoVcIAi8',
  'Kata-ha-jime': 'https://www.youtube.com/watch?v=yaTGgRjnwB8',
  'Kata-te-jime': 'https://www.youtube.com/watch?v=cHeIs-fSqwE',
  'Sode-guruma-jime': 'https://www.youtube.com/watch?v=E3nvQzClcAU',
  'Tsukkomi-jime': 'https://www.youtube.com/watch?v=dKKpnD3eLcY',
  'Sankaku-jime': 'https://www.youtube.com/watch?v=lq1CUBRAm7s',

  // Katame-waza: Kansetsu-waza (Hebeltechniken)
  'Ude-garami': 'https://www.youtube.com/watch?v=AIlTvZb4RlE',
  'Ude-hishigi-juji-gatame': 'https://www.youtube.com/watch?v=OWgSOlCuMXw',
  'Ude-hishigi-ude-gatame': 'https://www.youtube.com/watch?v=SBf0aTma1VI',
  'Ude-hishigi-hiza-gatame': 'https://www.youtube.com/watch?v=H2HtAJdiJcE',
  'Ude-hishigi-waki-gatame': 'https://www.youtube.com/watch?v=8F5p1zuJRG0',
  'Ude-hishigi-hara-gatame': 'https://www.youtube.com/watch?v=ZzEycg8R_9M',
  'Ude-hishigi-ashi-gatame': 'https://www.youtube.com/watch?v=ClY7g_pX-4s',
  'Ude-hishigi-te-gatame': 'https://www.youtube.com/watch?v=6DnvhY0tQVM',
  'Ude-hishigi-sankaku-gatame': 'https://www.youtube.com/watch?v=WefAmW4azhk',

  // Renraku/Gonosen-Zusatztechniken (1. Dan)
  'Seoi-otoshi': 'https://www.youtube.com/watch?v=vu1TMVNnq34',
  'Sode-tsuri-komi-goshi': 'https://www.youtube.com/watch?v=QsmAxpmYLOI',
  'Tsubame-gaeshi': 'https://www.youtube.com/watch?v=GwweWqqFB5g',
  'Kubi-nage': 'https://www.youtube.com/watch?v=7zCgLqa1VbI',
  'O-soto-otoshi': 'https://www.youtube.com/watch?v=2DsVvDw7b8g',
  'Obi-otoshi': 'https://www.youtube.com/watch?v=ff8U2TVZIYI',
  'Uchi-mata-sukashi': 'https://www.youtube.com/watch?v=V-RS3uhtVWM',
  'O-soto-gaeshi': 'https://www.youtube.com/watch?v=8ZjM3X_EANo',
  'Yama-arashi': 'https://www.youtube.com/watch?v=MGlyKmSuzdc',
  'O-uchi-gaeshi': 'https://www.youtube.com/watch?v=dCyZTXyjIXE',
  'Ko-uchi-gaeshi': 'https://www.youtube.com/watch?v=_MWAdYi_LC4',
  'Harai-goshi-gaeshi': 'https://www.youtube.com/watch?v=4U3It-7PPsc',
  'Ko-uchi-maki-komi': 'https://www.youtube.com/watch?v=_1eygIXLD_w',
  'Hane-goshi-gaeshi': 'https://www.youtube.com/watch?v=9bZAZSBtnGs',
};

/// Sucht per Teilstring-Abgleich (gleiches Prinzip wie findTechniqueImage in
/// technique_media_data.dart), da Programmnamen oft Suffixe/Varianten haben.
String? findTechniqueVideo(String technique) {
  final normalized = technique.toLowerCase();
  for (final entry in techniqueVideos.entries) {
    if (normalized.contains(entry.key.toLowerCase())) return entry.value;
  }
  return null;
}
