CREATE DATABASE IF NOT EXISTS analytics_optimized;
USE analytics_optimized;

CREATE TABLE IF NOT EXISTS `urls` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `url` VARCHAR(255) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `pv` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT UNSIGNED NOT NULL,
    `url_id` INT UNSIGNED NOT NULL,
    `country` CHAR(2) NOT NULL,
    `device` TINYINT UNSIGNED NOT NULL,
    `created_at` DATETIME NOT NULL,
    `duration_ms` INT UNSIGNED NOT NULL,
    INDEX `idx_report_lookup` (`created_at`, `country`, `url_id`)
) ENGINE=InnoDB;