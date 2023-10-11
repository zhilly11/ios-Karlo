[![Swift 5.7](https://img.shields.io/badge/swift-5.7-ED523F.svg?style=flat)]() 
[![Xcode 14.3](https://img.shields.io/badge/Xcode-14.3-ED523F.svg?style=flat&color=blue)]() 
[![iOS 16+](https://img.shields.io/badge/iOS%20-16+-green)](https://developer.apple.com/ios/)
[![The Composable Architecture](https://img.shields.io/badge/TCA-1.0.0-blue)](https://github.com/pointfreeco/swift-composable-architecture)

# Karlo App
> Kakao사의 `Karlo Ai`를 통해 이미지를 생성해주는 앱.

# 목차

1. [사용 방법](#-사용-방법)
2. [실행화면](#-실행화면)
3. [기술 스택](#-기술-스택)
4. [기능](#-기능)
5. [설계 및 기술적 도전](#-설계-및-기술적-도전)
6. [기술적 도전](#-기술적-도전)

<br>

## 사용 방법
<details>
<summary>자세히 보기</summary>
<div markdown="1">
    
1. `Swift Package Manager`를 활용해 TCA를 설치합니다..
    > [TCA-Installation Docs](https://github.com/pointfreeco/swift-composable-architecture#installation) 를 활용해 설치해주세요.
2. 아래 첨부된 사진과 같이 `Resource`에 `Secret.plist` 파일을 생성합니다.
3. `Secret.plist` 파일에 `API_KEY`를 추가해줍니다.
    > `API_KEY`는 [Karlo 문서](https://developers.kakao.com/product/karlo)에서 발급받을 수 있습니다.

    ![image](https://github.com/zhilly11/ios-Karlo/assets/99257965/a85c3fe3-bbe3-428a-a2ff-58d2112c2b3e)

</div>
</details>

<br>

## 실행화면

| 메인 화면 | 이미지 생성하기 | 생성된 이미지 | 공유 및 저장 |
| :--------: | :--------: | :--------: | :--------: | 
| <img src = "https://github.com/zhilly11/ios-Karlo/assets/99257965/53209059-4f48-4796-bd97-88875024beaa" width=300 height=410> | <img src = "https://github.com/zhilly11/ios-Karlo/assets/99257965/d79f47fd-a6fb-4e50-9569-6c1a99448dcf" width=300 height=410> | <img src = "https://github.com/zhilly11/ios-Karlo/assets/99257965/811ebf0b-74a5-45c0-aebc-38ccf19888fd" width=300 height=410> | <img src = "https://github.com/zhilly11/ios-Karlo/assets/99257965/af2dbe8d-9b83-471c-b326-0143d7f00a80" width=300 height=410> |

<br>

## 기술 스택

#### 개발환경
- `iOS DeploymentTarget` : `16.0+`
- `Swift` : `5.7`
- `Xcode` : `14.3`

#### 라이브러리
- `SwiftUI`
- [`TCA(The Composable Architecture)`](https://github.com/pointfreeco/swift-composable-architecture) : `1.0.0`
- `Swift Concurrency`

<br>

## 기능

| 기능 | 설명 |
| -------- | -------- |
| 이미지 생성 | 사용자가 제시어, 부정 제시어, 이미지 크기 등 상세하게 옵션을 설정하여 이미지를 생성할 수 있습니다. |
| 이미지 공유 | 사용자가 생성한 이미지를 다양한 옵션으로 공유할 수 있습니다. |
| 이미지 저장 | 사용자가 자신이 생성한 이미지를 디바이스에 저장할 수 있습니다. |

<br>

## 설계 및 기술적 도전

### TCA(The Composable Architecture) 채택

SwiftUI 프레임워크를 사용하는 환경에서 앱의 상태를 관리함에 따라 뷰의 변화를 더 효율적으로 설계하고, View와 데이터를 처리하는 로직을 확실하게 분리하기 위해 TCA를 채택하여 구현하였습니다.

또한 TCA를 채택함으로써 앱을 단방향의 구조로 만들 수 있게 되었습니다.

### TCA - DependencyKey를 활용한 API Client 구현

DependencyKey 프로토콜을 활용해 앱 구동에서 사용하는 값, Preview에서 사용하는 값, Test에서 사용하는 값을 직접적으로 명시하지 않아도 `@Dependency` 키워드를 사용해 사용할 수 있도록 구현하였습니다. DependencyKey를 활용하면서 의존성 관리를 직접적으로 구현하지 않아도 가능하게 되었습니다.

```swift
// KarloClient.swift

struct KarloClient {
    var fetch: @Sendable (Encodable) async throws -> KarloResponse
}

extension DependencyValues {
    var karloClient: KarloClient {
        get { self[KarloClient.self] }
        set { self[KarloClient.self] = newValue }
    }
}

extension KarloClient: DependencyKey {
    static let liveValue = Self(
        fetch: { imageInfo in
            let karloAPI: KarloAPI = .init(session: URLSession.shared)
            return try await karloAPI.request(data: imageInfo)
        }
    )
    
    static let previewValue = Self(
        fetch: { _ in .mock }
    )

    static let testValue = Self(
        fetch: unimplemented("\(Self.self).fetch")
    )
}

```

### Testable한 UUID

TCA에서 제공하는 [Dependency](https://pointfreeco.github.io/swift-composable-architecture/0.41.0/documentation/composablearchitecture/dependencymanagement/)를 활용하여 `UUID`를 사용하는 객체를 테스트 가능하도록 구현하였습니다.

따라서 매번 생성할때마다 Random하게 생성되는 `UUID`를 제어하고 테스팅할 수 있게 되었습니다.

### 동시성 프로그래밍

연속된 Escaping Closure를 피하고, 선언형 프로그래밍을 통한 높은 가독성을 위해 GCD사용을 지양하고 Swift Concurrency를 사용하여 앱을 구현하였습니다.
GCD를 사용했을 때 보다 코드의 가독성이 향상되고, 성능측면에서도 이점이 있습니다.

또한 [[WWDC21] Use async/await with URLSession](https://developer.apple.com/wwdc21/10095)에서 Swift Concurrency를 활용하는 내용이 발표 되어서 해당 내용을 프로젝트에서 구현했습니다.

```swift
// 구현에 사용한 메서드
func data(for request: URLRequest, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse)
```

### Custom View로 Tag 기능 구현

여러 키워드를 입력할 수 있어야하고 사용자가 손쉽게 추가 및 삭제가 가능해야 하기 때문에 Tag 기능을 활용하여 구현하였습니다.
<br>
<img src = "https://github.com/zhilly11/ios-Karlo/assets/99257965/9d95b8f0-f5c7-40fa-9d9c-c436e1fcfd35" widht = 300 height = 250>

### Unit Test

어떠한 Action이 주어졌을 때 상태를 다음 상태로 변화시키는 `Reducer` 객체를 중점적으로 Test Code를 작성했습니다.

Test Code는 TCA에서 제공하는 아키텍처 내부의 기능을 테스트하는 방법 뿐만 아니라, 여러 파트로 구성된 기능의 테스트를 작성하는 방법을 활용하여 작성하였습니다.

![image](https://github.com/zhilly11/ios-Karlo/assets/99257965/b911ef61-e64e-4e37-8cae-3091dda1387e)
> Test Code가 `Reducer`객체의 **`95%`** 이상 `Code Coverage`를 가지고 있습니다.

### Constant 관리

App 내에서 사용되는 상수들, 시스템 이미지들을 [한 곳](https://github.com/zhilly11/ios-Karlo/blob/main/Karlo/Karlo/App/AppConstant.swift)에서 관리할 수 있도록 작성했습니다.
