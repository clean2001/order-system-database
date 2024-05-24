-- CREATE DATABASE open_market;
-- USE open_market;

-- ALTER DATABASE open_market CHARACTER SET utf8mb4;
SET foreign_key_checks = 0;

DROP TABLE IF EXISTS member;

CREATE TABLE member (
    member_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    member_name VARCHAR(255),
    password VARCHAR(20),
    role ENUM('member', 'seller', 'admin') DEFAULT 'member',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    del_yn TINYINT(1) NOT NULL DEFAULT 0
);

DROP TABLE IF EXISTS shop;

CREATE TABLE shop (
    shop_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    shop_name VARCHAR(255),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    del_yn tinyint(1) NOT NULL DEFAULT 0,
    member_id BIGINT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES member(member_id)
);

DROP TABLE IF EXISTS product;

CREATE TABLE product (
    product_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    category ENUM('식품', '패션', '디지털'),
    subcategory ENUM(
        '쌀/잡곡', '음료', '과자/베이커리',
        '상의', '하의', '신발',
        '휴대폰', '카메라'
    ),
    price INT NOT NULL,

    detail_image_url VARCHAR(2083),
    del_yn TINYINT(1) not null default 0,
    shop_id BIGINT NOT NULL,
    FOREIGN KEY (shop_id) REFERENCES shop(shop_id)
);

DROP TABLE IF EXISTS product_option;

CREATE TABLE product_option (
    product_option_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_option_name VARCHAR(255) NOT NULL,
    stock INT UNSIGNED,
    product_id BIGINT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

DROP TABLE IF EXISTS coupon;

CREATE TABLE coupon (
    coupon_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    coupon_name VARCHAR(255) NOT NULL,
    started_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expired_at DATETIME NOT NULL DEFAULT DATE_ADD(CURRENT_TIMESTAMP, INTERVAL +10 DAY), -- 쿠폰 시작 후 10일
    stock INT UNSIGNED NOT NULL DEFAULT 0,
    discount_rate INT DEFAULT 0,
    discount_amount INT DEFAULT 0,
    type ENUM('rate', 'amount')
);

DROP TABLE IF EXISTS issued_coupon;

CREATE TABLE issued_coupon (
    issued_coupon_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    used_yn TINYINT(1) NOT NULL DEFAULT 0,
    member_id BIGINT NOT NULL,
    coupon_id BIGINT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES member(member_id),
    FOREIGN KEY (coupon_id) REFERENCES coupon(coupon_id)
);

DROP TABLE IF EXISTS `order`;

CREATE TABLE `order` (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    cancel_yn tinyint(1) NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    canceled_at DATETIME,
    original_price int NOT NULL,
    final_price int NOT NULL,
    address varchar(3000),
    member_id bigint NOT NULL,
    issued_coupon_id bigint,
    FOREIGN KEY (member_id) REFERENCES member(member_id),
    FOREIGN KEY (issued_coupon_id) REFERENCES issued_coupon(issued_coupon_id)
);



DROP TABLE IF EXISTS ordered_product;

CREATE TABLE ordered_product (
    ordered_product_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    status ENUM('before payment', 'preparing delivery', 'in transit', 'delivery completed', 'canceled'),
    quantity INT NOT NULL DEFAULT 0,
    order_id BIGINT NOT NULL,
    product_option_id BIGINT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES `order`(order_id),
    FOREIGN KEY (product_option_id) REFERENCES product_option(product_option_id)
);


DROP TABLE IF EXISTS review;

CREATE TABLE review (
    review_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    contents VARCHAR(300) NOT NULL DEFAULT '...',
    score ENUM('1', '2', '3', '4', '5'),
    member_id BIGINT NOT NULL,
    ordered_product_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id),
    FOREIGN KEY (ordered_product_id) REFERENCES ordered_product(ordered_product_id)
);

SET foreign_key_checks = 1;
