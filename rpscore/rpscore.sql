CREATE TABLE IF NOT EXISTS users (
    identifier VARCHAR(50) PRIMARY KEY,
    rp_score CHAR(1) DEFAULT 'C'
);

CREATE TABLE IF NOT EXISTS bans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(50),
    reason VARCHAR(255),
    duration INT,
    expire_time TIMESTAMP,
    FOREIGN KEY (identifier) REFERENCES users(identifier)
);
