
-- ============================================================
-- OTT 플랫폼 데이터베이스 설계
-- ============================================================


-- ------------------------------------------------------------
-- 1. plans 테이블 (요금제 정보)
-- ------------------------------------------------------------

CREATE TABLE plans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(30) NOT NULL,
    monthly_price INT NOT NULL,
    max_devices INT NOT NULL,
    video_quality VARCHAR(20) NOT NULL
);


-- ------------------------------------------------------------
-- 2. users 테이블 (회원 정보)
-- ------------------------------------------------------------

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL,
    age INT,
    gender CHAR(1),
    plan_id INT,
    join_date DATETIME NOT NULL,

    FOREIGN KEY (plan_id)
        REFERENCES plans(plan_id)
);


-- ------------------------------------------------------------
-- 3. contents 테이블 (콘텐츠 정보)
-- ------------------------------------------------------------

CREATE TABLE contents (
    content_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    genre VARCHAR(50),
    content_type VARCHAR(20) NOT NULL,
    runtime INT NOT NULL,
    release_date DATE,
    rating_standard VARCHAR(20)
);


-- ------------------------------------------------------------
-- 4. viewing_history 테이블 (시청 기록)
-- ------------------------------------------------------------

CREATE TABLE viewing_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content_id INT NOT NULL,
    viewed_at DATETIME NOT NULL,
    watched_time INT NOT NULL,
    device VARCHAR(20),

    FOREIGN KEY (user_id)
        REFERENCES users(user_id),

    FOREIGN KEY (content_id)
        REFERENCES contents(content_id)
);


-- ------------------------------------------------------------
-- 5. reviews 테이블 (리뷰 정보)
-- ------------------------------------------------------------

CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content_id INT NOT NULL,
    score DECIMAL(2,1) NOT NULL,
    review_text TEXT,
    created_at DATETIME NOT NULL,

    FOREIGN KEY (user_id)
        REFERENCES users(user_id),

    FOREIGN KEY (content_id)
        REFERENCES contents(content_id),

    UNIQUE(user_id, content_id)
);
```
