import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navi/widgets/path.dart';

class DatabaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  
  // Get all paths
  Future<Path> getPaths(String id) async {
    var snap = await db.collection('paths').doc(id).get();

    final data = snap.data() ?? <String, dynamic>{};

    return Path.fromMap(data);
  }
  
  // Stream specific path
  Stream<Path> streamPath(String id) {
    return db
        .collection('paths')
        .doc(id)
        .snapshots()
        .map((snap) {
          final data = snap.data() ?? <String, dynamic>{};
          return Path.fromMap(data);
        });
  }

}