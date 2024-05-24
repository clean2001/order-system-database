-- -------------------- 회원 서비스 -----------------------

-- 회원 가입
DELIMITER //
CREATE PROCEDURE 회원가입(IN 이메일 VARCHAR(255), IN 이름 VARCHAR(255), IN 비밀번호 VARCHAR(20))
BEGIN
    INSERT INTO member (email, member_name, password) VALUES (이메일, 이름, 비밀번호);
    SELECT '회원가입 성공';
END
// DELIMITER ;



-- 로그인
DELIMITER //
CREATE PROCEDURE 로그인(IN 이메일 VARCHAR(255), IN 비밀번호 VARCHAR(20))
BEGIN
    DECLARE 회원아이디 INT;
    SELECT member_id INTO 회원아이디 FROM member WHERE email = 이메일 AND password = 비밀번호;
    IF 회원아이디 IS NOT NULL THEN
        SELECT '로그인 되셨습니다. 회원아이디:' + 회원아이디;
    ELSE SELECT '로그인 실패';
    END IF;
END
// DELIMITER ;


-- -------------------- 주문 서비스 -----------------------

-- 주문하기

-- 주문서 만들기
DELIMITER //
CREATE PROCEDURE 주문하기(IN 이메일 VARCHAR(255), IN 비밀번호 VARCHAR(20), IN 발급된쿠폰아이디 BIGINT)
BEGIN
    DECLARE 회원아이디 INT;
    DECLARE 주문번호 INT;
    SELECT member_id INTO 회원아이디 FROM member WHERE email = 이메일 AND password = 비밀번호;
    IF 회원아이디 IS NULL THEN
        SELECT '없는 회원입니다.';
    ELSE
        INSERT INTO  `order` (member_id, issued_coupon_id, original_price, final_price)
            VALUES(회원아이디, 발급된쿠폰아이디, 0, 0);
        SELECT order_id INTO 주문번호 FROM `order` WHERE member_id = 회원아이디 ORDER BY created_at DESC LIMIT 1; -- 내가 주문한 가장 최근 주문 가져오기
        SELECT '주문이 생성되었습니다. 주문번호: ' + 주문번호;
    END IF;
END
// DELIMITER ;

-- 주문 세부 내역 만들기
DELIMITER //
CREATE PROCEDURE 상품을주문하기(IN 주문번호 BIGINT, IN 상품옵션아이디 BIGINT, IN 수량 INT)
BEGIN
    DECLARE 발급된쿠폰번호 BIGINT;
    DECLARE 상품가격 INT;
    DECLARE 쿠폰타입 ENUM('amount', 'rate');
    DECLARE 쿠폰이적용된가격 INT;
    DECLARE 할인율 INT;
    DECLARE 할인가 INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION -- exception 처리
    BEGIN
        START TRANSACTION; -- 트랜잭션으로 묶기 -> 재고가 줄어들면, 주문도 제대로 들어가야합니다.
        -- 재고 감소
        UPDATE product_option SET stock = stock - 수량 WHERE product_option_id = 상품옵션아이디;

        -- 주문된 상품 테이블에 정보 추가
        INSERT INTO ordered_product (quantity, order_id, product_option_id)
            VALUES (수량, 주문번호, 상품옵션아이디);

        -- 주문 테이블에서 결제 가격을 업데이트
        SELECT price INTO 상품가격 FROM product
        WHERE product_id = (SELECT product_id FROM product_option WHERE product_option_id = 상품옵션아이디);

        SELECT issued_coupon_id INTO 발급된쿠폰번호 FROM `order` WHERE order_id = 주문번호;
        IF 발급된쿠폰번호 IS NOT NULL THEN -- 적용된 쿠폰이 있음
#             SELECT c.type INTO 쿠폰타입, c.discount_rate INTO 할인율, c.discount_amount INTO 할인가
#             FROM coupon c INNER JOIN issued_coupon i ON i.coupon_id = c.coupon_id
#             WHERE i.issued_coupon_id = 발급된 쿠폰번호;

            -- 쿠폰 적용 로직 포기하겠습니다!

            -- 쿠폰을 사용합니다.
            UPDATE issued_coupon SET used_yn = 1 WHERE issued_coupon_id = 발급된쿠폰번호;

            IF 쿠폰타입 = 'rate' THEN
                SET 쿠폰이적용된가격 = 상품가격 * 수량 * 할인율 / 100;
            ELSEIF 할인가 < 상품가격 * 수량 THEN
                SET 쿠폰이적용된가격 = 상품가격 * 수량 - 할인가;
            ELSE
                SET 쿠폰이적용된가격 = 0;
            END IF;
            -- 가격 저장
            UPDATE `order` SET original_price = original_price + 상품가격 * 수량 WHERE order_id = 주문번호;
            UPDATE `order` SET final_price = final_price + 쿠폰이적용된가격 WHERE order_id = 주문번호;
        ELSE -- 적용된 쿠폰이 없음
            UPDATE `order` SET original_price = original_price + 상품가격 * 수량 WHERE order_id = 주문번호;
            UPDATE `order` SET final_price = final_price + 상품가격 * 수량 WHERE order_id = 주문번호;
        END IF;
        COMMIT; -- 커밋
        END;
END
// DELIMITER ;

-- -------------------- 상품을 등록하기 -----------------------

-- 구현 예정입니다.