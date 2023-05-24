# Color Dumbbell

<br/>

> **Color Dumbbell**은 운동 일지를 등록하면 경험치가 쌓여서 덤벨 색깔이 바뀌는 서비스입니다. 
> 이 외에도 본인의 운동 루틴을 추가해서 일지를 등록할 때 사용할 수 있고, 홈 화면에서 본인의 주간 운동 시간 및 운동 횟수를 그래프 형태로 한눈에 파악할 수 있게 개발했습니다. 현재 **App Store 등록이 완료**된 애플리케이션입니다.
>
> 진행 기간: 2023. 03. 06 ~ 2023. 04. 18

<br/>

## 팀 구성

|                        최명선(개발자)                        |                       김서하(디자이너)                       |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img src="https://avatars.githubusercontent.com/u/74762699?s=400&u=44a002eb9bfd2be6f192a6f994f9552d081060b8&v=4" width="250" height="250" style="border-radius: 50%;"/> | <img src="https://avatars.githubusercontent.com/u/88692742?v=4" width="250" height="250" style="border-radius: 50%;"/> |
|      [Github Profile](https://github.com/myungsun7782)       |        [Github Profile](https://github.com/jnuseoha)         |

<br/>

## App Store Link

[Color Dumbbell](https://apps.apple.com/kr/app/color-dumbbell/id6447961186)

<br/>

## App Thumbnail

![](https://github.com/myungsun7782/ColorDumbbell/assets/74762699/fa3e126a-2e74-452f-9782-793f6fe48884)

<br/>

## 사용 기술 및 라이브러리

- iOS, Swift, UIKit, CocoaPods
- Firebase(Cloud Firestore, Storage), SwiftDate
- RxSwift, RxCocoa, RxKeyboard, RxGesture
- Chart, SnapKit, FSCalendar
- LicensePlist, YPImagePicker

<br/>

## 담당한 기능(iOS)

- 사용자 초기 설정
- 주간 운동 시간 및 운동 횟수 그래프로 표현
- 운동 루틴(추가/수정/삭제)
- 운동 일지(추가/수정/삭제)
- 월별 운동 일지 조회
- 마이 페이지

<br/>

## 프로젝트를 하면서 배운 점 

- **setNeedsLayout 메서드**는 뷰 계층 구조에서 뷰의 속성이 변경되거나 서브뷰가 추가/삭제되었을 때  레이아웃 업데이트를 요청할 때 사용한다. 이 메서드를 호출하면, 시스템은 레이아웃 업데이트를 바로 수행하지 않고, 다음 드로잉 사이클까지 기다린다. 하지만, 레이아웃 업데이트를 즉시 수행하려면, layoutIfNeeded 메서드를 사용할 수 있다.
- **LicensePlist 라이브러리**를 사용해 내가 사용한 오픈 소스 라이브러리들의 정보를 한번에 자동으로 가져오고, 저작권을 표시할 수 있다.
- **@escaping**은 함수가 반환된 이후에 실행되는 클로저를 나타내기 위한 키워드이다. 보통 클로저가 비동기 작업에 사용되는 경우에 @escaping 키워드를 사용한다. 네트워크 요청이나 GCD(Grand Central Dispatch) 작업이 사용되는 경우를 예시로 들 수 있다. 또한, 클로저가 함수의 매개변수로 전달되면, 기본적으로 참조 카운트가 증가하지 않는다. 하지만 함수를 벗어나서 클로저가 실행되거나 저장되는 경우, 클로저가 캡처한 객체에 대한 참조를 관리하기 위해 참조 카운트를 증가시킬 필요가 있다. @escaping 키워드를 사용하면, 컴파일러가 이러한 참조 관리를 자동으로 처리할 수 있다.
- **Cloud Firestore**에서 whereField 메서드를 사용해 특정 필드의 값을 기준으로 문서를 필터링하고, 특정 조건을 충족하는 문서만 반환할 수 있다. 그리고 ‘orderBy’, ‘limit’, ‘startAt’, ‘endAt’ 등의 메서드와 함께 사용하여 검색 결과를 정렬, 제한, 범위를 지정할 수 있다.