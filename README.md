[![Swift 5.7](https://img.shields.io/badge/swift-5.7-ED523F.svg?style=flat)]() [![Xcode 14.3](https://img.shields.io/badge/Xcode-14.3-ED523F.svg?style=flat&color=blue)]()

# Karlo App
> `Karlo Ai`를 통해 이미지를 생성해주는 앱.

# 목차
1. [실행화면](#-실행화면)
2. [기술 스택](#-기술-스택)
3. [기능](#-기능)
4. [설계 및 기술적 도전](#-설계-및-기술적-도전)
5. [기술적 도전](#-기술적-도전)
6. [트러블 슈팅](#-트러블-슈팅)
7. [고민했던 점](#-고민했던-점)

## 실행화면

| 메인 화면 | 이미지 생성하기 | 생성된 이미지 | 공유 및 저장 |
| :--------: | :--------: | :--------: | :--------: | 
| <img src = "https://github.com/zhilly11/ios-Karlo/assets/99257965/53209059-4f48-4796-bd97-88875024beaa" width=300 height=410> | <img src = "https://github.com/zhilly11/ios-Karlo/assets/99257965/d79f47fd-a6fb-4e50-9569-6c1a99448dcf" width=300 height=410> | <img src = "https://github.com/zhilly11/ios-Karlo/assets/99257965/811ebf0b-74a5-45c0-aebc-38ccf19888fd" width=300 height=410> | <img src = "https://github.com/zhilly11/ios-Karlo/assets/99257965/af2dbe8d-9b83-471c-b326-0143d7f00a80" width=300 height=410> |

## 기술 스택

#### 개발환경
- `iOS DeploymentTarget` : `16.0+`
- `Swift` : `5.7`
- `Xcode` : `14.3`

#### 라이브러리
- `SwiftUI`
- [`TCA(The Composable Architecture)`](https://github.com/pointfreeco/swift-composable-architecture) : `1.0.0`
- `Swift Concurrency`

## 기능

| 기능 | 설명 |
| -------- | -------- |
| 이미지 생성 | 사용자가 제시어, 부정 제시어, 이미지 크기 등 상세하게 옵션을 설정하여 이미지를 생성할 수 있습니다. |
| 이미지 공유 | 사용자가 생성한 이미지를 다양한 옵션으로 공유할 수 있습니다. |
| 이미지 저장 | 사용자가 자신이 생성한 이미지를 디바이스에 저장할 수 있습니다. |

## 설계 및 기술적 도전

### TCA 구조
SwiftUI 프레임워크를 사용하는 환경에서 앱의 상태를 관리함에 따라 뷰의 변화를 더 효율적으로 설계하고, View와 데이터를 처리하는 로직을 확실하게 분리하기 위해 TCA를 채택하여 구현하였습니다.

또한 TCA를 채택함으로써 앱을 단방향의 구조로 만들 수 있게 되었습니다.

### 동시성 프로그래밍
연속된 Escaping Closure를 피하고, 선언형 프로그래밍을 통한 높은 가독성을 위해 GCD사용을 지양하고 Swift Concurrency를 사용하여 앱을 구현하였습니다.
GCD를 사용했을 때 보다 코드의 가독성이 향상되고, 성능측면에서도 이점이 있습니다.

또한 [[WWDC21] Use async/await with URLSession](https://developer.apple.com/wwdc21/10095)에서 Swift Concurrency를 활용하는 내용이 발표 되어서 프로젝트에서 구현했습니다.

### Custom View로 Tag 기능 구현
![]()
<img src = "https://hackmd.io/_uploads/Sk6AXZoJ6.png" widht = 300 height = 250>

## 트러블 슈팅

## 고민했던 점
