# ERD
https://www.erdcloud.com/d/AJzd3G3yNaKh93CLM


![beyond-sw-order-system (4)](https://github.com/clean2001/order-system-database/assets/64718002/3cff7471-2709-46dc-996f-83a85d2d9448)

---

# 요구 사항 정의

## 회원 서비스
### 회원가입
- 회원은 회원가입을 할 수 있습니다.

### 로그인
- 회원은 로그인을 할 수 있습니다.

### 탈퇴
- 회원은 탈퇴할 수 있습니다.

---
## 주문
### 주문하기
- 회원은 주문을 할 수 있습니다.
- 주문 시 쿠폰을 적용할 수 있습니다.

## 주문 내역 조회
- 회원은 자신의 주문 내역 리스트를 볼 수 있습니다.
  - 페이지와 한 페이지에 표시될 주문 내역 개수를 입력합니다.

## 주문 세부사항 조회
- 회원은 자신의 주문의 세부사항을 볼 수 있습니다.

---
## 쿠폰
## 쿠폰 발급
- 회원은 쿠폰을 발급받을 수 있습니다.
- 쿠폰을 발급받으면 쿠폰의 재고가 1 감소합니다.

## 쿠폰 등록
- admin 회원은 새로운 쿠폰을 등록할 수 있습니다.

---
## 브랜드 입점/상품 판매

### 가게 입점
- seller 회원은 입점할 수 있습니다.

### 상품 등록
- seller 회원은 상품을 등록할 수 있습니다.

---
## 상품

### 상품 목록 조회
- 회원들은 상품 목록을 페이지 별로 조회 가능합니다.
  - 페이지와 한 페이지에 표시될 상품 개수를 입력합니다.
  - 일단 카테고리는 무시하고 모든 상품의 리스트를 볼 수 있습니다.

### 상품 디테일 조회
- 회원들은 상품의 디테일 정보를 볼 수 있습니다.

---
# 리뷰

## 리뷰 작성
- 회원은 구매한 상품의 리뷰를 작성할 수 있습니다.

## 리뷰 조회
- 회원들은 다른 회원이 쓴 리뷰를 볼 수 있습니다.
