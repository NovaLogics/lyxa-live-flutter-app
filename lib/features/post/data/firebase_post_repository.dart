import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyxa_live/constants/constants.dart';
import 'package:lyxa_live/features/post/domain/entities/post.dart';
import 'package:lyxa_live/features/post/domain/repositories/post_repository.dart';

class FirebasePostRepository implements PostRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Path Firebase > posts
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection(FIRESTORE_COLLECTION_POSTS);

  @override
  Future<void> createPost(Post post) async {
    try {
      await postCollection.doc(post.id).set(post.toJson());
    } catch (error) {
      throw Exception('Error creating post ${error.toString()}');
    }
  }

  @override
  Future<void> deletePost(String postId) {
    // TODO: implement deletePost
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> fetchAllPosts() {
    // TODO: implement fetchAllPosts
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) {
    // TODO: implement fetchPostsByUserId
    throw UnimplementedError();
  }
}
