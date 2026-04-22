

import 'dart:math';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import '../models/room.dart';

class RoomService {
  final _db = FirebaseDatabase.instance.ref();

  static bool useMock = false; 
  static final Map<String, Map<String, dynamic>> _mockRooms = {};
  static final Map<String, StreamController<GameRoom>> _mockControllers = {};

  static const List<String> _emojis = [
    '😎','🎉','🔥','⭐','🎬','🍕','👾','🦁','🐺','🦊'
  ];

  String _randomEmoji() => _emojis[Random().nextInt(_emojis.length)];

  String generateRoomCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return List.generate(6, (_) => chars[Random().nextInt(chars.length)]).join();
  }

  Future<String> createRoom({
    required String hostId,
    required String hostName,
  }) async {
    final code = generateRoomCode();
    
    if (useMock) {
      _mockRooms[code] = {
        'code':    code,
        'hostId':  hostId,
        'status':  'waiting',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'members': {},
        'votes': {},
      };
      await joinRoom(code: code, memberId: hostId, memberName: hostName);
      return code;
    }

    final roomRef = _db.child('rooms/$code');
    await roomRef.set({
      'code':    code,
      'hostId':  hostId,
      'status':  'waiting',
      'createdAt': ServerValue.timestamp,
    });

    await joinRoom(
      code:       code,
      memberId:   hostId,
      memberName: hostName,
    );

    return code;
  }

  Future<void> joinRoom({
    required String code,
    required String memberId,
    required String memberName,
  }) async {
    if (useMock) {
      final room = _mockRooms[code];
      if (room == null) return;
      
      final member = {
        'id':      memberId,
        'name':    memberName,
        'emoji':   _randomEmoji(),
        'isReady': false,
        'joinedAt': DateTime.now().millisecondsSinceEpoch,
      };
      
      (room['members'] as Map)[memberId] = member;
      _notifyMockSubscribers(code);
      return;
    }

    final memberRef = _db.child('rooms/$code/members/$memberId');
    await memberRef.set({
      'id':      memberId,
      'name':    memberName,
      'emoji':   _randomEmoji(),
      'isReady': false,
      'joinedAt': ServerValue.timestamp,
    });

    await memberRef.onDisconnect().remove();
  }

  Stream<GameRoom> watchRoom(String code) {
    if (useMock) {
      _mockControllers[code] ??= StreamController<GameRoom>.broadcast();
      
      Timer(const Duration(milliseconds: 100), () => _notifyMockSubscribers(code));
      return _mockControllers[code]!.stream;
    }

    return _db.child('rooms/$code').onValue.map((event) {
      if (event.snapshot.value == null) throw Exception('Room not found');
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return GameRoom.fromJson(data);
    });
  }

  void _notifyMockSubscribers(String code) {
    final data = _mockRooms[code];
    if (data != null && _mockControllers.containsKey(code)) {
      _mockControllers[code]!.add(GameRoom.fromJson(data));
    }
  }

  Future<void> submitVote({
    required String roomCode,
    required String memberId,
    required int movieId,
    required bool liked,
  }) async {
    if (useMock) {
      final room = _mockRooms[roomCode];
      if (room == null) return;
      
      final voteKey = '${memberId}_$movieId';
      (room['votes'] as Map)[voteKey] = {
        'memberId': memberId,
        'movieId':  movieId,
        'liked':    liked,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      _notifyMockSubscribers(roomCode);
      return;
    }

    final voteKey = '${memberId}_$movieId';
    await _db.child('rooms/$roomCode/votes/$voteKey').set({
      'memberId': memberId,
      'movieId':  movieId,
      'liked':    liked,
      'timestamp': ServerValue.timestamp,
    });
  }

  Future<void> startGame(String code) async {
    if (useMock) {
      final room = _mockRooms[code];
      if (room != null) {
        room['status'] = 'swiping';
        _notifyMockSubscribers(code);
      }
      return;
    }
    await _db.child('rooms/$code/status').set('swiping');
  }

  Future<void> setMatch(String code, int movieId) async {
    if (useMock) {
      final room = _mockRooms[code];
      if (room != null) {
        room['status'] = 'matched';
        room['matchedMovieId'] = movieId;
        _notifyMockSubscribers(code);
      }
      return;
    }
    await _db.child('rooms/$code').update({
      'status':         'matched',
      'matchedMovieId': movieId,
    });
  }

  Future<void> resetRoom(String code) async {
    if (useMock) {
      final room = _mockRooms[code];
      if (room != null) {
        room['votes'] = {};
        room['status'] = 'swiping';
        room['matchedMovieId'] = null;
        _notifyMockSubscribers(code);
      }
      return;
    }
    await _db.child('rooms/$code/votes').remove();
    await _db.child('rooms/$code').update({
      'status':         'swiping',
      'matchedMovieId': null,
    });
  }

  Future<void> leaveRoom(String code, String memberId) async {
    if (useMock) {
      final room = _mockRooms[code];
      if (room != null) {
        (room['members'] as Map).remove(memberId);
        _notifyMockSubscribers(code);
      }
      return;
    }
    await _db.child('rooms/$code/members/$memberId').remove();
  }

  Future<void> deleteRoom(String code) async {
    if (useMock) {
      _mockRooms.remove(code);
      _mockControllers[code]?.close();
      _mockControllers.remove(code);
      return;
    }
    await _db.child('rooms/$code').remove();
  }

  Future<bool> roomExists(String code) async {
    if (useMock) {
      return _mockRooms.containsKey(code);
    }
    final snap = await _db.child('rooms/$code').get();
    return snap.exists;
  }
}
