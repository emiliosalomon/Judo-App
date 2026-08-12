/// Ein Eintrag in der Sterne-Rangliste.
class LeaderboardEntry {
  final String userId;
  final String nickname;
  final int stars;

  const LeaderboardEntry({
    required this.userId,
    required this.nickname,
    required this.stars,
  });
}
