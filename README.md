# peeling_onion



## directory structure은 layer-first 방식으로 결정

이유

- 많은 기능보다는 UI 디자인을 중점으로 해야 하는 프로젝트의 특성 상, 레이어 중심의 구조를 채택
- 프로젝트의 기능이 많은 편이 아니고, 확장 가능성이 적음 => feature-first 방식을 채택해야 할 이유가 적음



폴더 별 설명 (lib 폴더 내부)

- models :  앱에서 자주 사용할 데이터 구조
- screens : 앱의 페이지. 이 안에 기능을 작성
- widgets : UI를 담당하는 위젯들을 모아두는 폴더.
- services : 앱 외부의 서비스들 관련 기능 (api 요청, 게임  등)



## 네이밍 규칙

- 폴더명과 파일명은 snake_case
- 클래스명은 PascalCase
- 변수명, 함수명은 camelCase
- 클래스를 하나의 파일로 정리한다면 파일명과 클래스명은 동일하게 작성할 것
  ex) 파일명: login_screen.dart , 클래스명: LoginScreen
- 폴더명과 내부 파일의 역할이 정확한 분류라면 파일의 이름에 폴더명을 추가할 것
  (굳이 적지 않아도 명확히 특정 폴더 소속임이 명확하다면 파일 이름에 폴더명을 생략해도 좋다.)
  ex) 폴더명: screens, 파일명: login_screen.dart
- 폴더명은 복수형으로, 파일명은 단수형으로 작성할 것
  ex) 폴더명: screens, 파일명: login_screen.dart



참고) https://couldi.tistory.com/34

