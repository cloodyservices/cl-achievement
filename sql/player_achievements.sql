CREATE TABLE IF NOT EXISTS `player_achievements` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(64) NOT NULL,
    `achievement` VARCHAR(64) NOT NULL,
    `unlocked_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `citizen_achievement` (`citizenid`, `achievement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
