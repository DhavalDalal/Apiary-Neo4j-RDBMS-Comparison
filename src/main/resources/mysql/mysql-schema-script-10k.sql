#DROP SCHEMA `apiary_10k` ;
CREATE SCHEMA `apiary_10k` ;

CREATE  TABLE `apiary_10k`.`person` (
  `id` BIGINT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL ,
  `level` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `idx_person_level` (`level` ASC) ,
  INDEX `idx_person_name` (`name` ASC));

CREATE  TABLE `apiary_10k`.`person_direct_reportee` (
  `id` BIGINT NOT NULL AUTO_INCREMENT ,
  `person_id` BIGINT NOT NULL ,
  `directly_manages` BIGINT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_person_direct_reportee_1_idx` (`person_id` ASC) ,
  INDEX `fk_person_direct_reportee_2_idx` (`directly_manages` ASC) ,
  CONSTRAINT `fk_person_direct_reportee_1`
    FOREIGN KEY (`person_id` )
    REFERENCES `apiary_10k`.`person` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_person_direct_reportee_2`
    FOREIGN KEY (`directly_manages` )
    REFERENCES `apiary_10k`.`person` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);

CREATE  TABLE `apiary_10k`.`person_indirect_reportee` (
  `id` BIGINT NOT NULL AUTO_INCREMENT ,
  `person_id` BIGINT NOT NULL ,
  `indirectly_manages` BIGINT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_person_indirect_reportee_1_idx` (`person_id` ASC) ,
  INDEX `fk_person_indirect_reportee_2_idx` (`indirectly_manages` ASC) ,
  CONSTRAINT `fk_person_indirect_reportee_1`
    FOREIGN KEY (`person_id` )
    REFERENCES `apiary_10k`.`person` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_person_indirect_reportee_2`
    FOREIGN KEY (`indirectly_manages` )
    REFERENCES `apiary_10k`.`person` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);

COMMIT;
