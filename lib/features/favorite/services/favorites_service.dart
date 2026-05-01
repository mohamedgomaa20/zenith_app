import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../movies/data/models/movie_model.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _favoritesRef => _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('favorites');

  Future<void> toggleFavorite(Movie movie) async {
    final doc = _favoritesRef.doc(movie.id.toString());
    final snapshot = await doc.get();

    if (snapshot.exists) {
      await doc.delete();
    } else {
      Map<String, dynamic> movieData = movie.toJson();
      movieData['addedAt'] = FieldValue.serverTimestamp();
      await doc.set(movieData);
    }
  }

  Stream<List<Movie>> getFavoritesStream() {
    return _favoritesRef.orderBy('addedAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => Movie.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
