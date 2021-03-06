import 'package:njoytv/data/models/video.dart';
import 'package:njoytv/data/repository/video_respository.dart';
import 'package:njoytv/data/service/video_local_service.dart';
import 'package:njoytv/data/service/video_remote_service.dart';
import 'package:njoytv/utils/singleton.dart';

class VideoController {
  late VideoRepository videoRepository;
  VideoController() {
    videoRepository = VideoRepository(
        videoRemoteService: VideoRemoteService(),
        videoLocalService: VideoLocalService());
  }

  Future<bool> CheckServer() async {
    try {
      List<video> mList = [];

      bool bOk = await videoRepository.IsDataOK();
      if (bOk) {
        print('Loading Local Data');
        mList = await videoRepository.GetList('LOCAL');
        if (mList.length == 0) bOk = false;
      }
      //bOk = false;
      if (!bOk) {
        print('Loading Server Data');
        mList = await videoRepository.GetList('REMOTE');
        await videoRepository.Save();
      }
      Singleton.Version = videoRepository.getRemoteVersion();
      Singleton.AssignData(mList);
      return true;
    } catch (e) {
      print('Error : Check Server ${e}');
      return false;
    }
  }
}
