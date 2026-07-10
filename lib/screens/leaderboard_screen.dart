import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/leaderboard_entry.dart';
import '../services/leaderboard_repository.dart';
import '../services/leaderboard_scope.dart';
import '../services/nickname_store.dart';
import '../services/progress_scope.dart';
import '../theme/judo_theme.dart';
import '../widgets/nickname_prompt_dialog.dart';

/// Geraete-uebergreifende Sterne-Rangliste. Erfordert einen einmalig
/// gewaehlten Spitznamen; solange keiner gesetzt ist, taucht man selbst
/// nicht in der Liste auf.
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String? _nickname;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final store = await NicknameStore.load();
    final nickname = store.read();
    if (!mounted) return;
    setState(() {
      _nickname = nickname;
      _loading = false;
    });
    if (nickname != null) _submitCurrentScore(nickname);
  }

  void _submitCurrentScore(String nickname) {
    final stars = ProgressScope.of(context).countCompletedWithPrefix('');
    LeaderboardScope.of(context).submitScore(nickname: nickname, stars: stars);
  }

  Future<void> _joinOrRename() async {
    final nickname = await showNicknamePrompt(context, initialValue: _nickname);
    if (nickname == null || nickname.isEmpty || !mounted) return;
    final store = await NicknameStore.load();
    await store.write(nickname);
    if (!mounted) return;
    setState(() => _nickname = nickname);
    _submitCurrentScore(nickname);
  }

  @override
  Widget build(BuildContext context) {
    final repository = LeaderboardScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.leaderboardTitle),
        actions: [
          if (repository.isAvailable && !_loading)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: _joinOrRename,
            ),
        ],
      ),
      body: _buildBody(repository),
    );
  }

  Widget _buildBody(LeaderboardRepository repository) {
    if (!repository.isAvailable) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            AppStrings.leaderboardUnavailable,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_nickname == null) {
      return Center(
        child: FilledButton(
          onPressed: _joinOrRename,
          style: FilledButton.styleFrom(backgroundColor: JudoColors.red),
          child: const Text(AppStrings.leaderboardJoinButton),
        ),
      );
    }
    return StreamBuilder<List<LeaderboardEntry>>(
      stream: repository.watchTopEntries(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final entries = snapshot.data!;
        if (entries.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                AppStrings.leaderboardEmpty,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final isMe = entry.userId == repository.currentUserId;
            return ListTile(
              tileColor: isMe ? JudoColors.gold.withValues(alpha: 0.15) : null,
              leading: CircleAvatar(
                backgroundColor: index < 3 ? JudoColors.gold : JudoColors.black,
                foregroundColor: JudoColors.white,
                child: Text('${index + 1}'),
              ),
              title: Text(
                entry.nickname,
                style: TextStyle(
                  fontWeight: isMe ? FontWeight.w900 : FontWeight.w600,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, color: JudoColors.gold),
                  const SizedBox(width: 4),
                  Text(
                    '${entry.stars}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
