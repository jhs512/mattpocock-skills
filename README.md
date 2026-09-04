# 진짜 엔지니어링을 위한 스킬 모음

[Matt Pocock](https://www.aihero.dev)이 만든 코딩 에이전트용 스킬 모음([mattpocock/skills](https://github.com/mattpocock/skills))의 포크입니다. 바이브 코딩이 아니라, 실제로 굴러가는 소프트웨어를 만들기 위한 스킬들입니다.

에이전트로 앱을 만드는 건 어렵습니다. GSD, BMAD, Spec-Kit 같은 접근은 프로세스를 통째로 떠안는 방식으로 이 문제를 풀려다가, 통제권을 가져가고 프로세스에 생긴 버그를 고치기 어렵게 만듭니다. 이 스킬들은 작고, 고치기 쉽고, 조합 가능하도록 설계됐습니다. 어떤 모델에서도 동작합니다.

## 원본과 무엇이 다른가

**스킬 본문은 한 글자도 바꾸지 않았습니다.** 바꾼 것은 호출 정책 하나입니다.

|  | 원본 (mattpocock/skills) | 이 포크 (jhs512/mattpocock-skills) |
| --- | --- | --- |
| 스킬 내용 | 원본 | **동일** |
| 누가 호출할 수 있나 | 13개는 사람이 슬래시 명령을 타이핑해야만 실행 | `setup-matt-pocock-skills` 하나를 뺀 **전부**를 에이전트도 스스로 집어들 수 있음 |
| 설치 경로 | Claude Code 공식 마켓플레이스 | 이 저장소 자체 마켓플레이스, 또는 skills.sh |
| README | 영어 | 한국어 |

### 왜 바꿨나

원본은 스킬을 **역할**로 나눕니다. 사람이 타이핑해야만 실행되는 것(오케스트레이션 담당)과, 에이전트도 알아서 집어들 수 있는 것(재사용 가능한 규율)으로요.

이 포크는 그 구분을 버리고 질문 하나만 남겼습니다: **에이전트가 스스로 이걸 집어드는 게, 단지 도움이 안 되는 정도를 넘어 그 자체로 문제인가?**

여기에 "그렇다"고 답하는 건 `setup-matt-pocock-skills` 하나뿐입니다. 저장소의 이슈 트래커, triage 라벨, 문서 레이아웃을 다시 쓰기 때문입니다. 나머지는 전부 풀었습니다. 자세한 기준은 [.agents/invocation.md](./.agents/invocation.md)에 적혀 있습니다.

**타이핑해서 쓰는 방식은 그대로입니다.** 모델 호출을 허용한다고 사람의 호출이 사라지지 않습니다. 에이전트의 도달 경로가 하나 더 생길 뿐입니다.

덤으로 [원본 이슈 #693](https://github.com/mattpocock/skills/issues/693)의 영향도 줄어듭니다. 사람만 호출할 수 있는 스킬은 하네스가 에이전트에게 주입하는 스킬 목록에서 빠지는데, 에이전트는 그 목록을 전부라고 믿고 "그런 스킬 없습니다"라고 답합니다. 이 포크에서 그 영향을 받는 건 1개뿐입니다.

### 알아두면 좋은 한계

풀어놓은 13개의 스킬 설명문은 아직 사람이 읽는 한 줄 요약 그대로입니다. 원본에서 처음부터 모델 호출용이었던 스킬들은 "Use when the user..." 같은 트리거 문구를 갖고 있는데, 이 13개는 갖고 있지 않습니다. **문은 열렸지만 모델이 그 문을 찾을 단서는 아직 약합니다.** 자동으로 안 걸리면 그냥 슬래시 명령을 타이핑하면 됩니다.

## 설치 (30초)

두 가지 경로가 있고 철학이 다릅니다. **[Claude Code 플러그인](https://code.claude.com/docs/en/plugins)** 은 전체 세트를 읽기 전용 묶음으로 설치합니다. 구독하는 방식이지 고쳐 쓰는 방식이 아닙니다. **[skills.sh](https://skills.sh)** 는 스킬 파일을 프로젝트에 복사해 넣어서, 직접 고쳐 자기 것으로 만들 수 있게 합니다. **둘 중 하나만 고르세요.** 둘 다 설치하면 모든 스킬이 두 벌씩 생깁니다.

### 1. 스킬 받기

<details>
<summary><strong>Claude Code</strong></summary>

```bash
claude plugin marketplace add jhs512/mattpocock-skills
```

```bash
claude plugin install mattpocock-skills@jhs512
```

세션 안에서라면:

```
/plugin marketplace add jhs512/mattpocock-skills
/plugin install mattpocock-skills@jhs512
```

`@jhs512` 접미사가 이 포크를 고르는 부분입니다. 플러그인 이름만으로는 모호합니다. 원본이 공식 마켓플레이스에 같은 이름으로 올라가 있어서, 접미사가 없으면 원본이 설치될 수 있습니다.

자체 마켓플레이스는 자동 업데이트가 없습니다. 원할 때 직접 당겨오세요:

```bash
claude plugin marketplace update jhs512 && claude plugin update mattpocock-skills
```

</details>

<details>
<summary><strong>Codex, 그 외 에이전트</strong></summary>

```bash
npx skills@latest add jhs512/mattpocock-skills
```

원하는 스킬과, 설치할 코딩 에이전트를 고르면 됩니다. **설치할 스킬을 직접 고르게 되어 있으니 `setup-matt-pocock-skills`가 반드시 포함되게 하세요.**

Codex 네이티브 플러그인은 계획 단계입니다 ([`.agents/adr/0002-ship-as-a-claude-code-plugin.md`](./.agents/adr/0002-ship-as-a-claude-code-plugin.md) 참고).

</details>

<details>
<summary><strong>직접 고쳐 쓰고 싶다면</strong></summary>

같은 설치 도구를 Claude Code를 포함한 아무 에이전트에나 쓸 수 있습니다:

```bash
npx skills@latest add jhs512/mattpocock-skills
```

스킬을 저장소 안에 평범한 파일로 써넣습니다. 본인 소유이고 편집할 수 있으며, 모르는 사이에 갱신되는 일도 없습니다. 최신 변경은 원할 때 `npx skills update`로 당겨오면 됩니다.

</details>

### 2. `/setup-matt-pocock-skills` 실행

저장소마다 한 번씩 실행합니다. 이런 걸 물어봅니다:

- 어떤 이슈 트래커를 쓸 것인지 (GitHub, Linear, 또는 로컬 파일)
- triage할 때 티켓에 어떤 라벨을 붙이는지 (`/triage`가 라벨을 씁니다)
- 만들어지는 문서를 어디에 저장할지

### 3. 끝. 이제 쓰면 됩니다.

## 이 스킬들이 존재하는 이유

Claude Code, Codex를 비롯한 코딩 에이전트에서 반복적으로 나타나는 실패 유형들을 고치려고 만들어진 스킬들입니다.

### #1. 에이전트가 내가 원한 걸 안 만들었다

> "No-one knows exactly what they want"
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**문제.** 소프트웨어 개발에서 가장 흔한 실패는 어긋남입니다. 개발자가 내 의도를 안다고 생각했는데, 결과물을 보고 나서야 전혀 이해하지 못했다는 걸 깨닫습니다.

AI 시대라고 다르지 않습니다. 나와 에이전트 사이에는 소통의 간극이 있고, 이걸 메우는 방법이 **grilling(취조) 세션**입니다. 무엇을 만들 것인지 에이전트가 나를 상세히 심문하게 만드는 겁니다.

**해법:**

- [`/grill-me`](./skills/productivity/grill-me/SKILL.md): 코드가 아닌 것에도 쓸 수 있는 범용 버전
- [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md): 같은 취조에 문서화가 얹힌 버전 (아래 참고)

가장 인기 있는 스킬들입니다. 시작하기 전에 에이전트와 합을 맞추고, 만들려는 변경을 깊이 생각하게 해줍니다. 변경을 만들 때마다 쓰세요.

### #2. 에이전트가 너무 장황하다

> With a ubiquitous language, conversations among developers and expressions of the code are all derived from the same domain model.
>
> Eric Evans, [Domain-Driven-Design](https://www.amazon.co.uk/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)

**문제:** 프로젝트 초기에 개발자와 도메인 전문가는 보통 서로 다른 언어를 씁니다. 에이전트도 똑같습니다. 프로젝트에 툭 던져진 채로 용어를 알아서 파악하라는 요구를 받으니, 한 단어면 될 것을 스무 단어로 말합니다.

**해법**은 공용 언어입니다. 프로젝트에서 쓰는 용어를 에이전트가 해독할 수 있게 해주는 문서죠.

<details>
<summary>예시</summary>

Matt의 `course-video-manager` 저장소에 있는 [`CONTEXT.md`](https://github.com/mattpocock/course-video-manager/blob/076a5a7a182db0fe1e62971dd7a68bcadf010f1c/CONTEXT.md) 예시입니다. 어느 쪽이 읽기 쉬운가요?

- **이전**: "코스의 섹션 안에 있는 레슨이 '실재'가 될 때(즉 파일 시스템에 자리를 얻을 때) 문제가 생긴다"
- **이후**: "materialization cascade에 문제가 있다"

이 간결함은 세션이 쌓일수록 이득이 커집니다.

</details>

이건 [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md)에 내장되어 있습니다. 취조 세션이면서, 동시에 AI와의 공용 언어를 만들고 설명하기 어려운 결정을 ADR로 남깁니다.

이게 얼마나 강력한지는 말로 설명하기 어렵습니다. 이 저장소에서 가장 멋진 기법일지도 모릅니다. 직접 써보세요.

> [!TIP]
> 공용 언어는 장황함을 줄이는 것 말고도 여러 이득이 있습니다:
>
> - **변수, 함수, 파일 이름이 일관되게** 지어집니다
> - 그 결과 에이전트가 **코드베이스를 훨씬 잘 돌아다닙니다**
> - 더 간결한 언어를 쓸 수 있으니 **사고에 쓰는 토큰도 줄어듭니다**

### #3. 코드가 동작하지 않는다

> "Always take small, deliberate steps. The rate of feedback is your speed limit. Never take on a task that's too big."
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**문제:** 무엇을 만들지 합의까지 마쳤는데도 에이전트가 여전히 엉망인 코드를 내놓는다면?

피드백 루프를 봐야 할 때입니다. 자기가 만든 코드가 실제로 어떻게 도는지 피드백을 받지 못하면 에이전트는 눈을 감고 나는 셈입니다.

**해법:** 정적 타입, 브라우저 접근, 자동화된 테스트라는 익숙한 피드백 루프가 필요합니다.

테스트에서는 red-green-refactor 루프가 결정적입니다. 실패하는 테스트를 먼저 쓰고, 그 다음 통과시키는 방식이죠. 에이전트에게 일정한 수준의 피드백을 제공해서 훨씬 나은 코드를 만들게 합니다.

어느 프로젝트에나 끼워 넣을 수 있는 **[`/tdd`](./skills/engineering/tdd/SKILL.md)** 스킬이 있습니다. 디버깅에는 검증된 디버깅 관행을 단계별로 통제되는 루프로 감싼 **[`/diagnosing-bugs`](./skills/engineering/diagnosing-bugs/SKILL.md)** 가 있습니다.

### #4. 진흙 덩어리를 만들어버렸다

> "Invest in the design of the system _every day_."
>
> Kent Beck, [Extreme Programming Explained](https://www.amazon.co.uk/Extreme-Programming-Explained-Embrace-Change/dp/0321278658)

> "The best modules are deep. They allow a lot of functionality to be accessed through a simple interface."
>
> John Ousterhout, [A Philosophy Of Software Design](https://www.amazon.co.uk/Philosophy-Software-Design-2nd/dp/173210221X)

**문제:** 에이전트로 만든 앱 대부분은 복잡하고 바꾸기 어렵습니다. 에이전트는 코딩 속도를 극적으로 끌어올리는 만큼 소프트웨어 엔트로피도 가속합니다.

**해법**은 코드의 설계에 신경 쓰는 것입니다. 이 스킬들의 모든 층에 그게 들어가 있습니다:

- [`/to-spec`](./skills/engineering/to-spec/SKILL.md)은 스펙을 만들기 전에 어떤 모듈을 건드리는지 캐묻습니다
- 무엇보다 [`/improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md)가 코드베이스를 훑어 깊게 만들 후보들을 찾아 건네줍니다. 며칠에 한 번씩 돌려보길 권합니다. 이건 조사이지 구조 작업이 아닙니다. 오래된 코드베이스에서 진짜 후보들을 찾아주긴 하지만, 진흙을 대신 걷어내 주지는 않습니다

### 요약

소프트웨어 엔지니어링의 기본기는 그 어느 때보다 중요해졌습니다. 이 스킬들은 그 기본기를 반복 가능한 실천으로 압축하려는 시도입니다.

## 전체 스킬 목록

호출 축 하나로 나뉩니다. **사람 호출** 스킬은 타이핑해야만 실행됩니다. **모델 호출** 스킬은 타이핑해도 되고, 상황이 맞으면 에이전트가 알아서 집어들 수도 있습니다. 사람 호출 스킬은 모델 호출 스킬을 부를 수 있지만, 다른 사람 호출 스킬은 절대 부를 수 없습니다.

### Engineering

코드 작업에 매일 쓰는 스킬들.

**사람 호출**

- **[setup-matt-pocock-skills](./skills/engineering/setup-matt-pocock-skills/SKILL.md)**: 이 저장소에 엔지니어링 스킬들을 설정합니다 (이슈 트래커, triage 라벨, 도메인 문서 레이아웃). 다른 엔지니어링 스킬을 쓰기 전에 저장소마다 한 번 실행하세요.

**모델 호출**

- **[ask-matt](./skills/engineering/ask-matt/SKILL.md)**: 지금 상황에 어떤 스킬이나 흐름이 맞는지 물어봅니다. 이 저장소 스킬 전체의 라우터입니다.
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)**: 취조 세션이면서 프로젝트의 도메인 모델도 함께 만듭니다. 용어를 벼리고 `CONTEXT.md`와 ADR을 그 자리에서 갱신합니다.
- **[triage](./skills/engineering/triage/SKILL.md)**: 이슈를 triage 역할들의 상태 기계에 태워 통과시킵니다.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)**: 코드베이스에서 깊게 만들 기회를 훑어 시각적 HTML 보고서로 보여주고, 고른 것을 취조로 파고듭니다.
- **[to-spec](./skills/engineering/to-spec/SKILL.md)**: 지금 대화를 스펙으로 만들어 이슈 트래커에 올립니다. 인터뷰 없이, 이미 논의한 것을 종합하기만 합니다.
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)**: 어떤 계획, 스펙, 대화든 tracer-bullet 티켓 묶음으로 쪼갭니다. 각 티켓은 자신의 blocking 관계를 선언하며, 로컬 파일의 텍스트로도, 실제 트래커의 네이티브 blocking 링크로도 표현됩니다.
- **[implement](./skills/engineering/implement/SKILL.md)**: 스펙이나 티켓이 기술한 작업을 구현합니다. 미리 합의한 이음매에서 `/tdd`를 돌리고, 커밋 전에 `/code-review`로 마무리합니다.
- **[wayfinder](./skills/engineering/wayfinder/SKILL.md)**: 한 세션에 담기지 않는 거대한 작업을, 이슈 트래커 위의 결정 티켓 지도로 계획하고 하나씩 풀어가며 목적지까지의 길을 드러냅니다.
- **[prototype](./skills/engineering/prototype/SKILL.md)**: 설계 질문에 답하기 위한 버릴 프로토타입을 만듭니다. 상태나 로직 질문이면 공유 가능한 HTML 파일 하나로, UI 질문이면 한 라우트에서 토글되는 여러 시안으로.
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)**: 어려운 버그와 성능 회귀를 위한 통제된 진단 루프. 이 버그에서 빨간불이 켜지는 피드백 루프를 먼저 만들고, 최소화, 가설, 계측, 수정, 회귀 테스트로 이어집니다.
- **[research](./skills/engineering/research/SKILL.md)**: 신뢰도 높은 1차 자료를 뒤져 질문에 답하고, 인용이 달린 마크다운 파일로 저장소에 남깁니다. 백그라운드 에이전트로 돌아갑니다.
- **[tdd](./skills/engineering/tdd/SKILL.md)**: red-green-refactor 루프를 도는 테스트 주도 개발. 기능이나 버그 수정을 수직 슬라이스 하나씩 만들어 나갑니다.
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)**: 프로젝트의 도메인 모델을 능동적으로 만들고 벼립니다. 용어를 용어집에 비추어 따지고, 엣지 케이스 시나리오로 스트레스를 주고, `CONTEXT.md`와 ADR을 그 자리에서 갱신합니다.
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)**: 깊은 모듈을 설계하기 위한 공용 규율과 어휘. 작은 인터페이스 뒤에 많은 동작을, 깨끗한 이음매에 두고, 그 인터페이스를 통해 테스트 가능하게.
- **[code-review](./skills/engineering/code-review/SKILL.md)**: 기준점 이후의 디프를 두 축으로 리뷰합니다. **Standards**(저장소의 코딩 표준과 Fowler 스멜 기준을 따르는가)와 **Spec**(원래 이슈나 스펙이 요구한 것을 충실히 구현했는가)을 병렬 서브에이전트로 돌려 서로 오염되지 않게 합니다.
- **[resolving-merge-conflicts](./skills/engineering/resolving-merge-conflicts/SKILL.md)**: 진행 중인 git 머지나 리베이스 충돌을 헝크 단위로 풉니다. 줄을 고르는 게 아니라 양쪽의 1차 자료로 거슬러 올라가 의도로 해결하고, 작업을 끝냅니다 (`--abort`는 절대 하지 않습니다).
- **[wizard](./skills/engineering/wizard/SKILL.md)**: 사람만 할 수 있는 절차를 안내하는 대화형 bash 마법사를 생성합니다. 인프라 프로비저닝, 자격 증명이나 CI 시크릿 설정, 낯선 외부 대시보드 조작, 일회성 마이그레이션 같은 것들.

### Productivity

코드에 한정되지 않는 범용 작업 도구들.

**모델 호출**

- **[grill-me](./skills/productivity/grill-me/SKILL.md)**: 설계 트리의 모든 가지가 정리될 때까지 계획이나 설계에 대해 집요하게 심문당합니다.
- **[handoff](./skills/productivity/handoff/SKILL.md)**: 지금 대화를 인수인계 문서로 압축해서, 다른 에이전트가 작업을 이어받을 수 있게 합니다.
- **[teach](./skills/productivity/teach/SKILL.md)**: 현재 디렉토리를 상태를 가진 학습 작업공간으로 삼아, 여러 세션에 걸쳐 새로운 기술이나 개념을 가르칩니다.
- **[to-questionnaire](./skills/productivity/to-questionnaire/SKILL.md)**: 혼자 답할 수 없는 결정을, 답할 수 있는 그 사람을 위한 마크다운 설문지로 바꿉니다. 비동기로 채워도 되고 회의에서 함께 채워도 됩니다. 주제가 아니라 보내는 행위(누구에게, 무엇을 받아야 하는지)에 대해 당신을 심문합니다.
- **[wait-what](./skills/productivity/wait-what/SKILL.md)**: 상대의 말이 이해되지 않는 순간 바로 쏘세요. 빠져 있던 맥락을 채워서, `CONTEXT.md`의 어휘로, 쉬운 말로 다시 설명합니다.
- **[grilling](./skills/productivity/grilling/SKILL.md)**: 계획, 결정, 아이디어에 대해 설계 트리의 모든 가지가 정리될 때까지 사용자를 집요하게 심문합니다. `grill-me`, `grill-with-docs`, `triage`, `wayfinder`, `improve-codebase-architecture`의 바탕이 되는 재사용 가능한 인터뷰 원시 도구입니다.
- **[writing-for-agents](./skills/productivity/writing-for-agents/SKILL.md)**: 에이전트가 읽는 문서를 쓰는 법. 스킬, AGENTS.md/CLAUDE.md, 그리고 에이전트가 포인터를 따라 도달하는 모든 문서.

## 원작자

모든 스킬은 [Matt Pocock](https://www.aihero.dev)이 썼습니다. 원본 저장소는 [mattpocock/skills](https://github.com/mattpocock/skills)이고, 변경 사항을 따라가고 싶다면 [뉴스레터](https://www.aihero.dev/s/skills-newsletter)가 있습니다.

이 포크는 위에 적은 호출 정책 하나만 바꿉니다. 라이선스는 원본과 같은 MIT입니다.
