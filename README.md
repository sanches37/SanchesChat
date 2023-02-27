### 프로젝트 소개
* 소셜 로그인을 통한 채팅앱 구현
<br/>

### 로그인
* 카카오, 애플 소셜 로그인으로 Firebase 로그인 연동
* 카카오 로그인은 Firebase functions에서 user를 생성하고 앱으로 보내준 custom token을 사용하여 Firebase에 인증하는 방식 사용
* 애플 로그인은 파이어베이스 제공업체 로그인 방식 사용
<br/>

### 채팅
<kbd><img src = "https://user-images.githubusercontent.com/84059338/221384039-2752b7a0-3c01-476c-b612-9d5a60c03dc5.gif" width="250"></kbd>

* 첫 로그인시 email과 name을 Firestore의 users collection에 추가. 카카오는 photoURL도 추가
* 새 메시지 보내기로 Firebase Auth에 등록된 모든 유저에게 채팅을 보낼 수 있도록 구현
* 채팅 로그와 최근 메시지 리스트는 실시간으로 업데이트 되도록 구현
<br/>

### 프로필 수정
<kbd><img src = "https://user-images.githubusercontent.com/84059338/221384029-25931a22-da50-414c-9536-11cb07426a26.gif" width="250"></kbd>

* 프로필 수정시 프로필 이미지를 Firebase Storage에 저장 후 name과 photoURL을 firestore에 업데이트
* 프로필 수정시 firebase functions에서 트리거하여 최근 메시지 리스트의 변경된 프로필 모두를 수정
<br/>

### 푸시 알림
<kbd><img src = "https://user-images.githubusercontent.com/84059338/221384909-9d152650-f08a-4b40-9a4c-ea06ad83e00e.gif" width="250"></kbd>

* functions에서 최근 메시지 text를 트리거하여 메시지를 받는 사용자에게 알림을 보내도록 구현
* fcmToken으로 알림을 보낼 경우 같은 기기의 로그아웃한 사용자의 메시지도 받기 때문에, Topic으로 알림을 보내서 로그인한 사용자만 알림을 받게 구현
* 로그인시 사용자 uid로 Topic을 등록하고 로그아웃시 Topic 해제
* 채팅 확인시 앱 badge와 최근 메시지의 badge를 초기화
<br/>

### 사용기술
* SwiftUI
* Combine
* Kakao SDK
* Firebase Auth
* Firestore
* Firebase Storage
* Firebase Functions
* Firebase Cloud Messaging
* Kingfisher
