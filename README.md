
![po1](https://github.com/sungwookoo/Peeling-Onion/assets/53362965/525186f1-ded7-4c3a-abac-7519d4afaebf)

**STT를 활용한 Flutter 메세징 앱 서비스**

<br>

✔️ **구현 사항**

- 회원가입 : 카카오 회원가입/로그인, SMS를 통한 전화번호 인증

- 양파 보내기 : 일대일/다대일 양파(음성 메세지) 전송 / 스케줄러 활용한 예약 전송

- 긍부정 판단 : 녹음된 메세지의 긍/부정 성향에 따라 양파의 상태에 반영

- 양파 밭 : 수신한 양파(메세지) 관리

- 알림 : 양파 수신, 발송 가능 상태알림 등 Back/Foreground Push 알림

<br>

✔️ **담당 역할**

**- 인프라** 

- AWS EC2 ubuntu CI/CD 환경 구축 

- Jenkins 활용 Docker 컨테이너 빌드로 CD 환경 구축

- Portainer 활용 컨테이너 생성/관리 및, Backend 디버깅 지원

- SpringBoot CI/CD

- MSA 아키텍처 구성, 각 마이크로 서비스 서버 분리

- Jenkins 활용 모든 마이크로 서비스 CI/CD 환경 구축

- Spring Cloud Gateway 활용 Flutter ↔ SpringBoot 라우트 (HTTPS 통신)

- Flutter CI/CD

- Jenkins Pipeline 구축을 통해, Flutter 앱 빌드 및 APK 파일 생성 및 배포

- React CI/CD

- Jenkins 활용 CI/CD 환경 구축

- 원스토어 이동 및 최신 버전 Release APK 다운로드 링크 제공

- 원스토어 배포

- Flutter CI/CD를 통해 산출 된 Flutter Release APK 파일을 원스토어 수동 배포

<br>

✔️ **기술 스택**

- Backend : SpringBoot, mariaDB, Redis, Firebase

- Frontend : Flutter

- Infra : AWS EC2/S3, Docker, Jenkins, Nginx Proxy Manager, Portainer, Github, Gitlab, Spring Cloud
<br>

✔️ **아키텍처**

![po2](https://github.com/sungwookoo/Peeling-Onion/assets/53362965/6fece4b7-7ff9-46d8-a11c-28a3648f38fb)

<br>

✔️ **ERD** 

![po3](https://github.com/sungwookoo/Peeling-Onion/assets/53362965/9725498c-e4ac-4195-9068-4886900fcdab)

<br>

✔️ **결과**

- [앱 다운로드 페이지](https://ssafy.shop)
- [원스토어 링크](https://onesto.re/0000768589)

![po12](https://github.com/sungwookoo/Peeling-Onion/assets/53362965/36ab8086-b5cd-4916-a332-2898cf8b7dba)
![po11](https://github.com/sungwookoo/Peeling-Onion/assets/53362965/34475bf9-bb1d-4b72-b7b1-a9875ef6225d)
![po10](https://github.com/sungwookoo/Peeling-Onion/assets/53362965/82863374-a033-4bb1-9a95-b4a0948c04b8)
![po9](https://github.com/sungwookoo/Peeling-Onion/assets/53362965/fc5947ef-92ba-4196-8a52-85f26eabc788)
![po8](https://github.com/sungwookoo/Peeling-Onion/assets/53362965/e0c8e275-c5aa-4b08-a591-c42412a716fb)
![po7](https://github.com/sungwookoo/Peeling-Onion/assets/53362965/c78d3b53-5d32-4c01-8b46-27dadf1d9a0d)
![po6](https://github.com/sungwookoo/Peeling-Onion/assets/53362965/251cf4ee-e3bb-4c7c-abf0-398df04eb3b3)
![po5](https://github.com/sungwookoo/Peeling-Onion/assets/53362965/22f7a97e-7569-4a87-8c28-ce4e1a06900f)
![po4](https://github.com/sungwookoo/Peeling-Onion/assets/53362965/7f121a8d-68d2-4ceb-b287-bd76243604c3)
