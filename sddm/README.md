# SDDM 로그인 화면 (SilentSDDM)

## 레이아웃
- `tomie-a.conf`: 화면 아래쪽 가운데에 세로로 배치 (현재 사용 중)
- `tomie-b.conf`: 오른쪽에 큰 프로필 사진과 함께 가로로 배치

## 바꾸기
    ~/dotfiles/sddm/sddm-layout.sh a    # 또는 b

설정을 고칠 때는 이 폴더의 .conf 파일을 수정한 뒤 위 스크립트를 실행한다.
(/usr/share 쪽 파일을 직접 고치면 다음 적용 때 덮어써진다.)

## 테스트 (노트북 화면에서 실행)
    sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/silent

## 저장소에 넣지 않은 파일 (저작권)
- 배경 영상: /usr/share/sddm/themes/silent/backgrounds/tomie-login.mp4, tomie-login.jpg
  - 원본: ~/Videos/login/ (moewalls, 개인 사용 한정)
  - 소리 제거 + 아래로 120px, 왼쪽으로 60px 이동한 버전
- 프로필 사진: /usr/share/sddm/faces/tomie26.face.icon

## 주의
- sddm-silent-theme 패키지를 업데이트하면 metadata.desktop이 초기화될 수 있다.
  로그인 화면이 기본 테마로 돌아갔다면 sddm-layout.sh를 다시 실행한다.
