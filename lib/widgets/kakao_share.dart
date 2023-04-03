import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';

void shareMessage() async {
  // 사용자 정의 템플릿 ID
  int templateId = 91849;
// 카카오톡 실행 가능 여부 확인
  bool isKakaoTalkSharingAvailable =
      await ShareClient.instance.isKakaoTalkSharingAvailable();

  if (isKakaoTalkSharingAvailable) {
    try {
      Uri uri = await ShareClient.instance.shareCustom(templateId: templateId);
      await ShareClient.instance.launchKakaoTalk(uri);
      print('카카오톡 공유 완료');
    } catch (error) {
      print('카카오톡 공유 실패 $error');
    }
  } else {
    try {
      Uri shareUrl =
          await WebSharerClient.instance.makeCustomUrl(templateId: templateId);
      await launchBrowserTab(shareUrl, popupOpen: true);
    } catch (error) {
      print('카카오톡 공유 실패 $error');
    }
  }
}
