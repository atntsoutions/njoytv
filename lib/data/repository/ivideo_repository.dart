import 'package:njoytv/data/models/video.dart';

abstract class iVideoRepository {
  Future<List<video>> GetList(String source);
  Future<bool> IsDataOK();
  Future<bool> Save();
}
