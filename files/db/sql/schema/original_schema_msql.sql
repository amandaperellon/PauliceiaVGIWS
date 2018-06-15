-- MySQL Script generated by MySQL Workbench
-- Sex 15 Jun 2018 09:39:33 -03
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`pauliceia_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`pauliceia_user` ;

CREATE TABLE IF NOT EXISTS `mydb`.`pauliceia_user` (
  `user_id` INT NOT NULL,
  `email` TEXT NOT NULL,
  `password` TEXT NOT NULL,
  `username` TEXT NOT NULL,
  `name` TEXT NULL,
  `created_at` TIMESTAMP NOT NULL,
  `is_email_valid` TINYINT(1) NOT NULL,
  `terms_agreed` TINYINT(1) NOT NULL,
  `login_date` TIMESTAMP NULL,
  `is_the_admin` TINYINT(1) NOT NULL COMMENT 'O sistema terá apenas 1 administrador …',
  `receive_notification_by_email` TINYINT(1) NOT NULL,
  PRIMARY KEY (`user_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`layer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`layer` ;

CREATE TABLE IF NOT EXISTS `mydb`.`layer` (
  `layer_id` INT NOT NULL,
  `f_table_name` TEXT NOT NULL,
  `name` TEXT NOT NULL,
  `description` TEXT NULL,
  `source_description` TEXT NULL COMMENT 'Descrição sobre a fonte do layer',
  `created_at` TIMESTAMP NOT NULL,
  PRIMARY KEY (`layer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`changeset`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`changeset` ;

CREATE TABLE IF NOT EXISTS `mydb`.`changeset` (
  `changeset_id` INT NOT NULL,
  `description` TEXT NOT NULL,
  `created_at` TIMESTAMP NOT NULL,
  `closed_at` TIMESTAMP NULL,
  `user_id_creator` INT NOT NULL,
  `layer_id` INT NOT NULL,
  PRIMARY KEY (`changeset_id`),
  INDEX `fk_tb_project_tb_user1_idx` (`user_id_creator` ASC),
  INDEX `fk_change_set_project1_idx` (`layer_id` ASC),
  CONSTRAINT `fk_tb_project_tb_user1`
    FOREIGN KEY (`user_id_creator`)
    REFERENCES `mydb`.`pauliceia_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_change_set_project1`
    FOREIGN KEY (`layer_id`)
    REFERENCES `mydb`.`layer` (`layer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`version_<feature_table>`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`version_<feature_table>` ;

CREATE TABLE IF NOT EXISTS `mydb`.`version_<feature_table>` (
  `id` INT NOT NULL,
  `geom` GEOMETRYCOLLECTION NOT NULL,
  `<attributes>` TEXT NULL,
  `version` INT NOT NULL,
  `removed_at` TIMESTAMP NOT NULL,
  `changeset_id` INT NOT NULL,
  PRIMARY KEY (`id`, `version`),
  INDEX `fk_tb_contribution_tb_project1_idx` (`changeset_id` ASC),
  CONSTRAINT `fk_tb_contribution_tb_project1`
    FOREIGN KEY (`changeset_id`)
    REFERENCES `mydb`.`changeset` (`changeset_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`user_layer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`user_layer` ;

CREATE TABLE IF NOT EXISTS `mydb`.`user_layer` (
  `user_id` INT NOT NULL,
  `layer_id` INT NOT NULL,
  `created_at` TIMESTAMP NULL,
  `is_the_creator` TINYINT(1) NULL COMMENT 'Cada layer tem um usuário que o criou no banco de dados',
  INDEX `fk_project_subscriber_user1_idx` (`user_id` ASC),
  PRIMARY KEY (`user_id`, `layer_id`),
  INDEX `fk_user_layer_layer1_idx` (`layer_id` ASC),
  CONSTRAINT `fk_project_subscriber_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`pauliceia_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_layer_layer1`
    FOREIGN KEY (`layer_id`)
    REFERENCES `mydb`.`layer` (`layer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`<feature_table>`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`<feature_table>` ;

CREATE TABLE IF NOT EXISTS `mydb`.`<feature_table>` (
  `id` INT NOT NULL,
  `geom` GEOMETRYCOLLECTION NOT NULL,
  `<attributes>` TEXT NULL,
  `version` INT NOT NULL,
  `changeset_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_tb_contribution_tb_project1_idx` (`changeset_id` ASC),
  CONSTRAINT `fk_tb_contribution_tb_project10`
    FOREIGN KEY (`changeset_id`)
    REFERENCES `mydb`.`changeset` (`changeset_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`keyword`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`keyword` ;

CREATE TABLE IF NOT EXISTS `mydb`.`keyword` (
  `keyword_id` INT NOT NULL,
  `name` TEXT NULL,
  `created_at` TIMESTAMP NULL,
  `parent_id` INT NULL,
  `user_id_creator` INT NOT NULL,
  PRIMARY KEY (`keyword_id`),
  INDEX `fk_theme_theme1_idx` (`parent_id` ASC),
  INDEX `fk_theme_user1_idx` (`user_id_creator` ASC),
  CONSTRAINT `fk_theme_theme1`
    FOREIGN KEY (`parent_id`)
    REFERENCES `mydb`.`keyword` (`keyword_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_theme_user1`
    FOREIGN KEY (`user_id_creator`)
    REFERENCES `mydb`.`pauliceia_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`notification`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`notification` ;

CREATE TABLE IF NOT EXISTS `mydb`.`notification` (
  `notification_id` INT NOT NULL,
  `name` TEXT NOT NULL,
  `description` TEXT NOT NULL COMMENT 'Uma notificação pode estar associada a plataforma em geral, a um tema, a um layer ou a uma outra notificação.',
  `icon` TEXT NULL,
  `created_at` TIMESTAMP NOT NULL,
  `user_id_creator` INT NULL COMMENT 'quem criou a notificação',
  `layer_id` INT NULL COMMENT 'O layer que a notificação está associada',
  `keyword_id` INT NULL COMMENT 'O tema que a notificação está associada',
  `notification_id_parent` INT NULL,
  PRIMARY KEY (`notification_id`),
  INDEX `fk_notification_layer1_idx` (`layer_id` ASC),
  INDEX `fk_notification_theme1_idx` (`keyword_id` ASC),
  INDEX `fk_notification_user_1_idx` (`user_id_creator` ASC),
  INDEX `fk_notification_notification1_idx` (`notification_id_parent` ASC),
  CONSTRAINT `fk_notification_layer1`
    FOREIGN KEY (`layer_id`)
    REFERENCES `mydb`.`layer` (`layer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_notification_theme1`
    FOREIGN KEY (`keyword_id`)
    REFERENCES `mydb`.`keyword` (`keyword_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_notification_user_1`
    FOREIGN KEY (`user_id_creator`)
    REFERENCES `mydb`.`pauliceia_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_notification_notification1`
    FOREIGN KEY (`notification_id_parent`)
    REFERENCES `mydb`.`notification` (`notification_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`user_notification`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`user_notification` ;

CREATE TABLE IF NOT EXISTS `mydb`.`user_notification` (
  `user_id` INT NOT NULL,
  `notification_id` INT NOT NULL,
  `is_read` TINYINT(1) NULL,
  INDEX `fk_user_notification_user_1_idx` (`user_id` ASC),
  INDEX `fk_user_notification_notification1_idx` (`notification_id` ASC),
  PRIMARY KEY (`user_id`, `notification_id`),
  CONSTRAINT `fk_user_notification_user_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`pauliceia_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_notification_notification1`
    FOREIGN KEY (`notification_id`)
    REFERENCES `mydb`.`notification` (`notification_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`layer_followers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`layer_followers` ;

CREATE TABLE IF NOT EXISTS `mydb`.`layer_followers` (
  `user_id` INT NOT NULL,
  `layer_id` INT NOT NULL,
  `created_at` TIMESTAMP NULL,
  INDEX `fk_user_follows_layer_user_1_idx` (`user_id` ASC),
  INDEX `fk_user_follows_layer_layer1_idx` (`layer_id` ASC),
  PRIMARY KEY (`user_id`, `layer_id`),
  CONSTRAINT `fk_user_follows_layer_user_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`pauliceia_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_follows_layer_layer1`
    FOREIGN KEY (`layer_id`)
    REFERENCES `mydb`.`layer` (`layer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`keyword_followers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`keyword_followers` ;

CREATE TABLE IF NOT EXISTS `mydb`.`keyword_followers` (
  `user_id` INT NOT NULL,
  `keyword_id` INT NOT NULL,
  `created_at` TIMESTAMP NULL,
  INDEX `fk_user_follows_theme_user_1_idx` (`user_id` ASC),
  INDEX `fk_user_follows_theme_theme1_idx` (`keyword_id` ASC),
  PRIMARY KEY (`keyword_id`, `user_id`),
  CONSTRAINT `fk_user_follows_theme_user_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`pauliceia_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_follows_theme_theme1`
    FOREIGN KEY (`keyword_id`)
    REFERENCES `mydb`.`keyword` (`keyword_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`reference`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`reference` ;

CREATE TABLE IF NOT EXISTS `mydb`.`reference` (
  `reference_id` INT NOT NULL,
  `description` TEXT NULL COMMENT 'BibiText',
  `user_id_creator` INT NOT NULL,
  PRIMARY KEY (`reference_id`),
  INDEX `fk_reference_pauliceia_user1_idx` (`user_id_creator` ASC),
  CONSTRAINT `fk_reference_pauliceia_user1`
    FOREIGN KEY (`user_id_creator`)
    REFERENCES `mydb`.`pauliceia_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`curator`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`curator` ;

CREATE TABLE IF NOT EXISTS `mydb`.`curator` (
  `user_id` INT NOT NULL COMMENT 'Um tema pode ter 1 ou n curadores',
  `keyword_id` INT NOT NULL,
  `region` TEXT NULL,
  `created_at` TIMESTAMP NULL,
  INDEX `fk_curator_user_theme_user_1_idx` (`user_id` ASC),
  INDEX `fk_curator_user_theme_theme1_idx` (`keyword_id` ASC),
  PRIMARY KEY (`user_id`, `keyword_id`),
  CONSTRAINT `fk_curator_user_theme_user_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`pauliceia_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_curator_user_theme_theme1`
    FOREIGN KEY (`keyword_id`)
    REFERENCES `mydb`.`keyword` (`keyword_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`layer_keyword`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`layer_keyword` ;

CREATE TABLE IF NOT EXISTS `mydb`.`layer_keyword` (
  `layer_id` INT NOT NULL,
  `keyword_id` INT NOT NULL,
  INDEX `fk_layer_theme_layer1_idx` (`layer_id` ASC),
  INDEX `fk_layer_theme_theme1_idx` (`keyword_id` ASC),
  PRIMARY KEY (`layer_id`, `keyword_id`),
  CONSTRAINT `fk_layer_theme_layer1`
    FOREIGN KEY (`layer_id`)
    REFERENCES `mydb`.`layer` (`layer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_layer_theme_theme1`
    FOREIGN KEY (`keyword_id`)
    REFERENCES `mydb`.`keyword` (`keyword_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`layer_reference`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`layer_reference` ;

CREATE TABLE IF NOT EXISTS `mydb`.`layer_reference` (
  `layer_id` INT NOT NULL,
  `reference_id` INT NOT NULL,
  PRIMARY KEY (`layer_id`, `reference_id`),
  INDEX `fk_reference_layer_reference1_idx` (`reference_id` ASC),
  CONSTRAINT `fk_reference_layer_layer1`
    FOREIGN KEY (`layer_id`)
    REFERENCES `mydb`.`layer` (`layer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reference_layer_reference1`
    FOREIGN KEY (`reference_id`)
    REFERENCES `mydb`.`reference` (`reference_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`file`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`file` ;

CREATE TABLE IF NOT EXISTS `mydb`.`file` (
  `file_id` INT NOT NULL,
  `f_table_name` TEXT NOT NULL,
  `feature_id` INT NOT NULL,
  `name` TEXT NULL,
  `extension` TEXT NULL,
  PRIMARY KEY (`file_id`, `f_table_name`, `feature_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`time_columns`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`time_columns` ;

CREATE TABLE IF NOT EXISTS `mydb`.`time_columns` (
  `f_table_name` TEXT NOT NULL,
  `start_date_column_name` TEXT NULL,
  `end_date_column_name` TEXT NULL,
  `start_date` TEXT NULL,
  `end_date` TEXT NULL,
  PRIMARY KEY (`f_table_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`media_columns`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`media_columns` ;

CREATE TABLE IF NOT EXISTS `mydb`.`media_columns` (
  `f_table_name` TEXT NOT NULL,
  `media_column_name` TEXT NOT NULL,
  `media_type` TEXT NULL,
  PRIMARY KEY (`f_table_name`, `media_column_name`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
