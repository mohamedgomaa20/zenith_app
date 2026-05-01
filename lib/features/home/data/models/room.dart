class RoomMember {
  final String id;
  final String name;
  final String emoji;
  final bool isReady;

  RoomMember({
    required this.id,
    required this.name,
    required this.emoji,
    this.isReady = false,
  });

  factory RoomMember.fromJson(Map<String, dynamic> json) => RoomMember(
    id: json['id'] as String,
    name: json['name'] as String,
    emoji: json['emoji'] as String,
    isReady: json['isReady'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'emoji': emoji,
    'isReady': isReady,
  };
}

class RoomVote {
  final String memberId;
  final int movieId;
  final bool liked;

  RoomVote({
    required this.memberId,
    required this.movieId,
    required this.liked,
  });

  factory RoomVote.fromJson(Map<String, dynamic> json) => RoomVote(
    memberId: json['memberId'] as String,
    movieId: json['movieId'] as int,
    liked: json['liked'] as bool,
  );

  Map<String, dynamic> toJson() => {
    'memberId': memberId,
    'movieId': movieId,
    'liked': liked,
  };
}

class GameRoom {
  final String code;
  final String hostId;
  final List<RoomMember> members;
  final List<RoomVote> votes;
  final String status;
  final int? matchedMovieId;

  GameRoom({
    required this.code,
    required this.hostId,
    required this.members,
    required this.votes,
    required this.status,
    this.matchedMovieId,
  });

  bool get hasMatch => matchedMovieId != null;

  int get memberCount => members.length;

  bool get canStart => memberCount >= 2;

  int? checkForMatch() {
    if (members.isEmpty) return null;
    final memberIds = members.map((m) => m.id).toSet();

    final likesPerMovie = <int, Set<String>>{};
    for (final vote in votes) {
      if (vote.liked) {
        likesPerMovie.putIfAbsent(vote.movieId, () => {});
        likesPerMovie[vote.movieId]!.add(vote.memberId);
      }
    }

    for (final entry in likesPerMovie.entries) {
      if (entry.value.containsAll(memberIds)) {
        return entry.key;
      }
    }
    return null;
  }

  factory GameRoom.fromJson(Map<String, dynamic> json) => GameRoom(
    code: json['code'] as String,
    hostId: json['hostId'] as String,
    members: (json['members'] as Map<dynamic, dynamic>? ?? {}).values
        .map((v) => RoomMember.fromJson(Map<String, dynamic>.from(v as Map)))
        .toList(),
    votes: (json['votes'] as Map<dynamic, dynamic>? ?? {}).values
        .map((v) => RoomVote.fromJson(Map<String, dynamic>.from(v as Map)))
        .toList(),
    status: json['status'] as String? ?? 'waiting',
    matchedMovieId: json['matchedMovieId'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'code': code,
    'hostId': hostId,
    'status': status,
    if (matchedMovieId != null) 'matchedMovieId': matchedMovieId,
  };
}
