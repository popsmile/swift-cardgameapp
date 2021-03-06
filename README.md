# 카드게임 앱

1. <a href="#1-카드게임판-시작하기">카드게임판 시작하기</a>
2. <a href="#2-카드-UI">카드 UI</a>
3. <a href="#3-카드스택-화면-표시">카드스택 화면 표시</a>

<br>

## 1. 카드게임판 시작하기

### 요구사항

- StatusBar 스타일 변경
- ViewController 루트 뷰 배경이미지 지정
- 화면에서 카드가 적정 위치에 균등하게 보이도록 ViewController 에서 이미지 뷰 추가

<br>

### 구현방법

#### 1. StatusBar 스타일 변경

처음에는 `AppDelegate` 에서 `UIApplication.shared` 의 `setStatusBarStyle()` 메소드로 스타일을 변경하려고했습니다. [공식문서](https://developer.apple.com/documentation/uikit/uiapplication/1622923-setstatusbarstyle)를 찾아보니 이 방법은 Deprecated되었으며, iOS 7 이후 부터는 status bar를 뷰 컨트롤러가 관리한다고 명시되어있었습니다. 

따라서, `ViewController` 클래스에서 **preferredStatusBarStyle** 프로퍼티를 오버라이드하여 **UIStatusBarStyle.lightContent**로 지정했습니다.

<br>

#### 2. ViewController 루트 뷰 배경이미지 지정

Assets.xcassets에 저장한 파일로 UIImage를 생성한 후, 이 이미지를 패턴으로 하는 [UIColor](https://developer.apple.com/documentation/uikit/uicolor/1621933-init)를 뷰 컨트롤러 루트 뷰의 `backgroundColor` 로 지정했습니다.

```swift
private func setBackground() {
    guard let image = UIImage(named: "bg_pattern.png") else { return }
    self.view.backgroundColor = UIColor(patternImage: image)
}
```

<br>

#### 3. ViewController에서 화면에 균일하게 카드 이미지 뷰 추가

`UIImageView` 를 상속받는 `CardImageView` 커스텀 뷰를 생성하여, 이미지 뷰 왼쪽 위 좌표**(origin: CGPoint)**와 가로 길이**(width: CGFloat)**로 생성초기화하는 convenience init 메소드를 구현했습니다.

뷰 컨트롤러 내부에는 `CardImageViewCreater` 라는 구조체를 추가하여, 뷰 컨트롤러 루트 뷰의 **frame.width** 값을 바탕으로 `CardImageView` 의 좌표와 가로 길이를 계산하여 생성해주도록 구현했습니다. 이렇게 생성된 이미지 뷰는 루트 뷰의 서브 뷰로 추가되어 화면에 균등한 크기와 여백으로 나타나게됩니다.

```swift
class ViewController: UIViewController {
    ...
	private func addCardImageViews() {
        let cardCreater = CardImageViewCreater(numberOfCards: 7, sideMargin: 5, topMargin: 40)
        let cards = cardCreater.createHorizontally(within: self.view.frame.width)
        cards.forEach { self.view.addSubview($0) }
    }
    ...
}
```

<br>

### 실행화면

> 완성일자: 2019.01.23 18:32

![2019-01-23](./images/step1/2019-01-23.png)



<br>

## 2. 카드 UI

### 요구사항

- 레벨 2 CardGame 미션 프로젝트 코드 가져와서 사용
- Card 객체 개선
  - 해당 카드 이미지 매치
  - 앞뒷면 처리
- CardDeck 인스턴스 생성 후, 뽑은 카드를 바탕으로 주어진 화면과 동일하게 뷰 추가
- Shake 모션 이벤트 발생 시, 카드를 새롭게 뽑아 뷰에 반영

<br>

### 구현방법

#### 1. Card 클래스 객체 개선

지난 [카드게임 프로젝트](https://github.com/popsmile/swift-cardgame/tree/popsmile)에서 Main, Input/OutputView와 관련된 파일을 제외한 나머지 코드를 그대로 가져와 추가했습니다. 카드에 활용할 이미지파일도 프로젝트에 추가해주었습니다.

`Card` 클래스에 앞면인지, 뒷면인지 판단할 수 있는 프로퍼티 `isBack`과 뒤집는 메소드 `flip()`을 추가했습니다. 그리고 해당 카드와 매치되는 이미지 파일명을 프로퍼티로 추가했습니다. 만약 뒤집혀있다면 `nil` 을 리턴하도록 구현했습니다.

```swift
class Card {
	...
    private var isBack: Bool = true

    ...
    var imageName: String? {
        guard isBack else { return nil }
        guard let suit = self.suit.firstLetter else { return nil }
        return "\(suit)\(rank.value)"
    }
    
    func flip() {
        isBack.toggle()
    }
}
```

<br>

#### 2. CardDeck 에서 뽑은 카드로 화면에 뷰 추가

기존의 `CardImageView` 외에 빈 공간을 나타내는 `CardSpaceView` 클래스를 추가했습니다. 두 뷰를 모두 다루기위해 뷰 컨트롤러 내의 `CardImageViewCreater` 구조체를  `CardViewCreater` 로 이름을 바꿔주었습니다. 그리고 `Align` 열거형을 추가하여 왼쪽, 오른쪽 정렬을 지원하도록 추가 구현했습니다.

<br>

#### 3. Shake 모션 이벤트 발생 시, 카드를 새롭게 뽑아 뷰에 반영

Shake 모션 이벤트가 발생하여  뷰 컨트롤러의 `motionEnded()` 메소드가 호출되면, 기존 카드 이미지 뷰를 삭제하고 초기화한 `cardDeck` 에서 새롭게 뽑은 카드 뷰를 추가해주도록 구현했습니다.

```swift
override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    super.motionEnded(motion, with: event)
    if motion == .motionShake {
        cardImageViews.forEach { $0.removeFromSuperview() }
        cardDeck.reset()
        addCardImageViews()
    }
}
```

<br>

### 실행화면

> 완성일자: 2019.01.25 14:35

![Jan-25-2019](./images/step2/Jan-25-2019.gif)

<br>

### 수정내용

- `CardViewLayout` 구조체를 추가로 생성하여, 뷰 컨트롤러 내부에 선언되어있던 프로퍼티를 분리해서 구조화했습니다.

- 위 구현방법 3번의 뷰를 삭제하고 새로 추가하는 방식을 기존 뷰를 재사용해 이미지만 변경하는 방식으로 수정했습니다.

  ```swift
  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
      super.motionEnded(motion, with: event)
      if motion == .motionShake {
          cardDeck.reset()
          replaceImagesOfCardImageViews()
      }
  }
  ```

- 뷰 컨트롤러 내부에 nested 되어있던 `CardViewCreater` 구조체를 `CardViewFactory` 로 이름을 변경하고 별도의 객체로 분리하였습니다.

<br>

## 3. 카드스택 화면 표시

### 요구사항

- `CardDeck` 객체를 활용해 주어진 화면처럼 카드스택 형태의 뷰 구현하기
  - 카드스택을 관리하는 모델 객체 설계
  - 각 스택 맨 위 카드만 앞면으로 뒤집기
- 카드스택에 표시한 카드를 제외한 나머지 카드를 우측 상단에 모두 뒤집어 쌓아놓기
- 우측 상단 카드를 터치하면 카드를 뒤집어 좌측에 표시하기
- 남은 카드가 없을 시, 리프레시 이미지 표시하기
- Shake 이벤트 발생 시, `CardDeck` 을 초기화하고 처음 상태로 되돌리기

### 구현방법

#### 1. 카드스택 형태의 뷰 구현하기

`CardStackView` 클래스를 추가해 서브 뷰로 `CardView` 를 갖도록 구현했습니다. `CardViewFactory` 객체에서 가로 방향으로 카드 뷰를 추가하는 과정을 카드 스택 뷰를 추가하도록 수정했습니다. 

<br>

#### 2. 카드 덱의 나머지 카드 우측 상단에 모두 쌓아놓기 / 터치 시, 카드 뒤집어 좌측에 표시

`CardStackView` 를 상속받는 `CardDeckView` 클래스를 추가했고, 우측 상단에 해당 뷰를 추가하여 카드 덱의 나머지 카드 이미지 뷰를 쌓아놓았습니다.

위 카드 덱 뷰의 좌측에 `CardDeckView` 를 하나 더 추가하여 cardDeckOpenedView라고 이름지었습니다. 위의 카드 덱 뷰를 터치 시에 좌측 덱 뷰로 뒤집혀 이동하도록 구현했습니다.

#### + 남은 카드가 없을 시, 리프레시 이미지 표시하기

그리고 카드 덱 뷰에 더 이상 터치할 카드 뷰가 남지 않았을 경우, 리프레시 이미지를 표시해주기 위한 메소드 `popWithRefreshImage()` 를 사용했습니다.

```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    guard let touch = touches.first else { return }
    if touch.view == cardDeckView {
        guard let cardView = cardDeckView.popWithRefreshImage() else { return }
        cardView.flip()
        cardDeckOpenedView.push(cardView)
    }
}
```

<br>

#### 3. Shake 이벤트 발생 시,  모두 초기 상태로 되돌리기

전 단계에서 `resetCardDeckView()` 메소드를 추가해, 위 2번에서 터치 시에 우측 카드 덱 뷰에서 좌측 카드 덱 뷰로 이동한 모든 카드 뷰를 다시 원상복귀시켰습니다.

```swift
override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    super.motionEnded(motion, with: event)
    if motion == .motionShake {
        cardDeck.reset()
        resetCardDeckView() // 전 단계 이후에 추가된 메소드
        replaceImagesOfCardViews()
    }
}
```

<br>

 #### + ViewModel 클래스 추가

`CardView` , `CardStackView` , `CardStacksView` 에 1:1로 대응하는 뷰 모델 클래스 `CardViewModel` , `CardStackViewModel` , `CardStacksViewModel` 을 구현했습니다. 아래는 그 중 **CardViewModel** 예시이고, 이 클래스가 **CardView** 에 어떤 방식으로 쓰였는지 나와있습니다.

```swift
protocol CardViewModelDelegate {
    init(card: Card)
    var imageName: String? { get }
    var imageDidChange: ((CardViewModelDelegate) -> ())? { get set }
    func flip()
}

class CardViewModel: CardViewModelDelegate {
    private var card: Card

    required init(card: Card) {
        self.card = card
    }

    var imageName: String? {
        didSet {
            imageDidChange?(self)
        }
    }

    var imageDidChange: ((CardViewModelDelegate) -> ())?

    func flip() {
        card.flip()
        imageName = card.imageName
    }

}
```

`CardView` 는 프로퍼티로 `CardViewModelDelegate` 를 갖고있고, 이 뷰 모델의 클로저 프로퍼티를 카드 뷰 내부에서 지정해줍니다. 따라서 카드 뷰가 **flip()** 되면, 뷰 모델에서 해당 카드를 플립하고 뷰 모델의 **이미지 이름을 갱신**합니다. 뷰 모델의 이미지 이름은 **didSet** 될 때마다, **imageDidChage** 클로저를 실행하고 이 클로저는 카드 뷰 안에서 이미지를 갱신해줍니다.

```swift
class CardView: UIImageView {

    var viewModel: CardViewModelDelegate! {
        didSet {
            viewModel.imageDidChange = { [unowned self] viewModel in
                self.setImage(named: viewModel.imageName)
            }
        }
    }
    ...

    func flip() {
        viewModel.flip()
    }
}
```

<br>

### 실행화면

> 완성일자: 2019.01.29 22:35
>
> 추가수정 완료일자: 2019.02.01 00:32

카드 덱 터치 시, 카드 한 장을 뒤집어 좌측에 표시하고 있습니다. 모든 카드를 뒤집어 소진되었을 시 리프레시 이미지가 표시되고, Shake 모션을 취하면 초기 상태로 되돌립니다.

![Jan-29-2019](./images/step3/Jan-29-2019.gif)

<br>

### 수정내용

CardView와 CardViewModel 관계를 중심으로 대폭 수정헀습니다.

#### 1. 뷰 계층

뷰는 아래와 같은 포함관계를 갖도록 수정했습니다. 뷰 모델과 모델 또한 동일한 포함관계를 갖도록 구현했습니다.

- ViewController
  - CardGameView
    - CardSpacesView
      - [CardSpaceView]
    - CardPileView
      - [CardView]
    - CardDeckView
      - [CardView]
    - CardStacksView
      - [CardStackView]
        - [CardView]

#### 2. NotificationCenter 활용

`CardDeckView` 에 터치 이벤트가 발생할 경우, `CardDeckViewModel` 내부의 `CardViewModel` 배열 중 마지막 요소가 `flip` 됩니다. `CardViewModel` 에서 관리하는 `opened` 프로퍼티가 변경되는 경우 `.cardDidFlip` 노티피케이션이 포스트되고, 이 뷰 모델을 소유한 `CardView` 에서 노티피케이션을 받아 뷰를 다시 그리도록 구현했습니다.

ShakeMotion이 발생하여 카드게임 판을 초기화시킬 경우에도 이와 같은 방식으로 구현했습니다.