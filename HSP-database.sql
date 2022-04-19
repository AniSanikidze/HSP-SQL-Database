-- MySQL Workbench Forward Engineering
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
-- -----------------------------------------------------
-- Schema hsp
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `hsp`;
USE `hsp` ;
-- -----------------------------------------------------
-- Table `hsp`.`patient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`patient` (
  `pat_no` INT NOT NULL AUTO_INCREMENT,
  `f_name` VARCHAR(45) NOT NULL,
  `l_name` VARCHAR(45) NOT NULL,
  `addmission_date` DATE NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `sex` VARCHAR(45) NOT NULL,
  `street` VARCHAR(45) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `diagnosis` MEDIUMTEXT NOT NULL,
  PRIMARY KEY (`pat_no`))
ENGINE = InnoDB;
#index for searching patient by admission date
CREATE INDEX addmis_date ON patient (addmission_date);
#index for searching patient by lASt and first names
CREATE INDEX pat_l_f_names ON patient (l_name,f_name);

-- -----------------------------------------------------
-- Table `hsp`.`bill`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`bill` (
  `bill_no` INT NOT NULL AUTO_INCREMENT,
  `pat_no` INT NOT NULL,
  `bill_amount` INT NOT NULL,
  `pat_type` VARCHAR(45) NOT NULL,
  `doctor_charge` INT NOT NULL,
  `room_charge` INT NULL DEFAULT NULL,
  `surgery_charge` INT NULL DEFAULT NULL,
  `nursing_charge` INT NULL DEFAULT NULL,
  PRIMARY KEY (`bill_no`, `pat_no`),
  INDEX `fk_Bill_patient1` (`pat_no` ASC) VISIBLE,
  CONSTRAINT `fk_Bill_patient1`
    FOREIGN KEY (`pat_no`)
    REFERENCES `hsp`.`patient` (`pat_no`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`department` (
  `dept_no` INT NOT NULL AUTO_INCREMENT,
  `dept_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`dept_no`))
ENGINE = InnoDB;

#index for searching department by department name
CREATE INDEX department_name ON department (dept_name);

-- -----------------------------------------------------
-- Table `hsp`.`employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`employee` (
  `emp_no` INT NOT NULL AUTO_INCREMENT,
  `f_name` VARCHAR(45) NOT NULL,
  `L_name` VARCHAR(45) NOT NULL,
  `sex` VARCHAR(45) NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `street` VARCHAR(45) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `qualification` VARCHAR(256) NOT NULL,
  `specialty` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`emp_no`))
ENGINE = InnoDB;

#index for searching employee by lASt and first names
CREATE INDEX employee_l_f_name ON employee (l_name, f_name);

-- -----------------------------------------------------
-- Table `hsp`.`doctor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`doctor` (
  `doct_no` INT NOT NULL,
  `dept_no` INT NOT NULL,
  INDEX `fk_Doctor_department1` (`dept_no` ASC) VISIBLE,
  PRIMARY KEY (`doct_no`),
  CONSTRAINT `fk_Doctor_department1`
    FOREIGN KEY (`dept_no`)
    REFERENCES `hsp`.`department` (`dept_no`),
  CONSTRAINT `fk_Nurse_Employee10`
    FOREIGN KEY (`doct_no`)
    REFERENCES `hsp`.`employee` (`emp_no`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`hospital`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`hospital` (
  `hospital_code` INT NOT NULL AUTO_INCREMENT,
  `hospital_name` VARCHAR(45) NOT NULL,
  `street` VARCHAR(45) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`hospital_code`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`lab`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`lab` (
  `lab_no` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `hospital_code` INT NOT NULL,
  PRIMARY KEY (`lab_no`),
  INDEX `fk_lab_Hospital1` (`hospital_code` ASC) VISIBLE,
  CONSTRAINT `fk_lab_Hospital1`
    FOREIGN KEY (`hospital_code`)
    REFERENCES `hsp`.`hospital` (`hospital_code`))
ENGINE = InnoDB;

#index for searching the lab by lab name
CREATE INDEX lab_name ON lab (name);

-- -----------------------------------------------------
-- Table `hsp`.`research_activity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`research_activity` (
  `resact_no` INT NOT NULL AUTO_INCREMENT,
  `start_date` DATE NOT NULL,
  `finish_date` DATE NOT NULL,
  `topic` TINYTEXT NOT NULL,
  PRIMARY KEY (`resact_no`))
ENGINE = InnoDB;

#index for searching research ASctivity by start and finish dates
CREATE INDEX resactivity_start_finish ON research_activity (start_date, finish_date);

-- -----------------------------------------------------
-- Table `hsp`.`doctor_conducts_research`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`doctor_conducts_research` (
  `resact_no` INT NOT NULL,
  `lab_no` INT NOT NULL,
  `doct_no` INT NOT NULL,
  PRIMARY KEY (`resact_no`, `lab_no`, `doct_no`),
  INDEX `fk_research_activity_hAS_Doctor_lab1` (`lab_no` ASC) VISIBLE,
  INDEX `fk_doctor_conducts_research_Doctor1` (`doct_no` ASC) VISIBLE,
  CONSTRAINT `fk_doctor_conducts_research_Doctor1`
    FOREIGN KEY (`doct_no`)
    REFERENCES `hsp`.`doctor` (`doct_no`),
  CONSTRAINT `fk_research_activity_hAS_Doctor_lab1`
    FOREIGN KEY (`lab_no`)
    REFERENCES `hsp`.`lab` (`lab_no`),
  CONSTRAINT `fk_research_activity_hAS_Doctor_research_activity1`
    FOREIGN KEY (`resact_no`)
    REFERENCES `hsp`.`research_activity` (`resact_no`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`room`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`room` (
  `room_no` INT NOT NULL AUTO_INCREMENT,
  `dept_no` INT NOT NULL,
  PRIMARY KEY (`room_no`),
  INDEX `fk_room_department1` (`dept_no` ASC) VISIBLE,
  CONSTRAINT `fk_room_department1`
    FOREIGN KEY (`dept_no`)
    REFERENCES `hsp`.`department` (`dept_no`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`inpatient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`inpatient` (
  `inpat_no` INT NOT NULL,
  `discharge_date` DATE NOT NULL,
  `room_no` INT NOT NULL,
  PRIMARY KEY (`inpat_no`),
  INDEX `fk_inpatient_room1` (`room_no` ASC) VISIBLE,
  CONSTRAINT `fk_inpatient_patient1`
    FOREIGN KEY (`inpat_no`)
    REFERENCES `hsp`.`patient` (`pat_no`),
  CONSTRAINT `fk_inpatient_room1`
    FOREIGN KEY (`room_no`)
    REFERENCES `hsp`.`room` (`room_no`))
ENGINE = InnoDB;

#index for searching inpatient by discharge date
CREATE INDEX discharge_date ON inpatient (discharge_date);

-- -----------------------------------------------------
-- Table `hsp`.`doctor_monitors_inpatient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`doctor_monitors_inpatient` (
  `doct_no` INT NOT NULL,
  `inpat_no` INT NOT NULL,
  PRIMARY KEY (`doct_no`, `inpat_no`),
  INDEX `fk_doctor_monitors_inpatient_inpatient1` (`inpat_no` ASC) VISIBLE,
  CONSTRAINT `fk_doctor_monitors_inpatient_Doctor1`
    FOREIGN KEY (`doct_no`)
    REFERENCES `hsp`.`doctor` (`doct_no`),
  CONSTRAINT `fk_doctor_monitors_inpatient_inpatient1`
    FOREIGN KEY (`inpat_no`)
    REFERENCES `hsp`.`inpatient` (`inpat_no`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`employee_phone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`employee_phone` (
  `emp_no` INT NOT NULL,
  `phone_number` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`emp_no`, `phone_number`),
  CONSTRAINT `fk_Employee_phone_Employee1`
    FOREIGN KEY (`emp_no`)
    REFERENCES `hsp`.`employee` (`emp_no`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`employee_works_in_hospital`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`employee_works_in_hospital` (
  `emp_no` INT NOT NULL,
  `hospital_code` INT NOT NULL,
  `salary` INT NOT NULL,
  `hire_date` DATE NOT NULL,
  PRIMARY KEY (`emp_no`, `hospital_code`),
  INDEX `fk_Employee_hAS_Hospital_Hospital1` (`hospital_code` ASC) VISIBLE,
  CONSTRAINT `fk_Employee_hAS_Hospital_Employee1`
    FOREIGN KEY (`emp_no`)
    REFERENCES `hsp`.`employee` (`emp_no`),
  CONSTRAINT `fk_Employee_hAS_Hospital_Hospital1`
    FOREIGN KEY (`hospital_code`)
    REFERENCES `hsp`.`hospital` (`hospital_code`))
ENGINE = InnoDB;

#index for searching employee by hire date
CREATE INDEX employee_hire_date ON employee_works_in_hospital (hire_date);

-- -----------------------------------------------------
-- Table `hsp`.`examination`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`examination` (
  `pat_no` INT NOT NULL,
  `doct_no` INT NOT NULL,
  `lab_no` INT NOT NULL,
  `date` DATE NOT NULL,
  `conducted_test` MEDIUMTEXT NOT NULL,
  PRIMARY KEY (`pat_no`, `doct_no`, `lab_no`, `date`),
  INDEX `fk_examination_lab1` (`lab_no` ASC) VISIBLE,
  INDEX `fk_examination_Doctor1` (`doct_no` ASC) VISIBLE,
  CONSTRAINT `fk_examination_Doctor1`
    FOREIGN KEY (`doct_no`)
    REFERENCES `hsp`.`doctor` (`doct_no`),
  CONSTRAINT `fk_examination_lab1`
    FOREIGN KEY (`lab_no`)
    REFERENCES `hsp`.`lab` (`lab_no`),
  CONSTRAINT `fk_patient_hAS_Doctor_patient1`
    FOREIGN KEY (`pat_no`)
    REFERENCES `hsp`.`patient` (`pat_no`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`hospital_phone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`hospital_phone` (
  `hospital_code` INT NOT NULL,
  `phone_number` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`hospital_code`, `phone_number`),
  CONSTRAINT `fk_patient_phone_copy1_Hospital1`
    FOREIGN KEY (`hospital_code`)
    REFERENCES `hsp`.`hospital` (`hospital_code`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`hospital_uses_lab`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`hospital_uses_lab` (
  `hospital_code` INT NOT NULL,
  `lab_no` INT NOT NULL,
  PRIMARY KEY (`hospital_code`, `lab_no`),
  INDEX `fk_Hospital_hAS_Lab_Lab1` (`lab_no` ASC) VISIBLE,
  CONSTRAINT `fk_Hospital_hAS_Lab_Hospital1`
    FOREIGN KEY (`hospital_code`)
    REFERENCES `hsp`.`hospital` (`hospital_code`),
  CONSTRAINT `fk_Hospital_hAS_Lab_Lab1`
    FOREIGN KEY (`lab_no`)
    REFERENCES `hsp`.`lab` (`lab_no`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`surgery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`surgery` (
  `surg_no` INT NOT NULL AUTO_INCREMENT,
  `name` MEDIUMTEXT NOT NULL,
  `price` INT NOT NULL,
  `dept_no` INT NOT NULL,
  PRIMARY KEY (`surg_no`),
  INDEX `fk_surgery_department1` (`dept_no` ASC) VISIBLE,
  CONSTRAINT `fk_surgery_department1`
    FOREIGN KEY (`dept_no`)
    REFERENCES `hsp`.`department` (`dept_no`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`inpatient_undergoes_surgery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`inpatient_undergoes_surgery` (
  `surg_no` INT NOT NULL,
  `date` DATE NOT NULL,
  `doct_no` INT NOT NULL,
  `inpat_no` INT NOT NULL,
  PRIMARY KEY (`surg_no`, `date`, `doct_no`, `inpat_no`),
  INDEX `fk_inpatient_undergoes_surgery_Doctor1` (`doct_no` ASC) VISIBLE,
  INDEX `fk_inpatient_undergoes_surgery_inpatient1` (`inpat_no` ASC) VISIBLE,
  CONSTRAINT `fk_inpatient_hAS_Doctor_surgery1`
    FOREIGN KEY (`surg_no`)
    REFERENCES `hsp`.`surgery` (`surg_no`),
  CONSTRAINT `fk_inpatient_undergoes_surgery_Doctor1`
    FOREIGN KEY (`doct_no`)
    REFERENCES `hsp`.`doctor` (`doct_no`),
  CONSTRAINT `fk_inpatient_undergoes_surgery_inpatient1`
    FOREIGN KEY (`inpat_no`)
    REFERENCES `hsp`.`inpatient` (`inpat_no`))
ENGINE = InnoDB;

#index for searching already performed surgery by the date of execution
CREATE INDEX surgery_date ON inpatient_undergoes_surgery (date);

-- -----------------------------------------------------
-- Table `hsp`.`medicine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`medicine` (
  `mdcn_no` INT NOT NULL AUTO_INCREMENT,
  `mdcn_name` VARCHAR(45) NOT NULL,
  `manufacturer` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`mdcn_no`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`nurse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`nurse` (
  `nurse_no` INT NOT NULL,
  `dept_no` INT NOT NULL,
  INDEX `fk_nurse_department1` (`dept_no` ASC) VISIBLE,
  PRIMARY KEY (`nurse_no`),
  CONSTRAINT `fk_nurse_department1`
    FOREIGN KEY (`dept_no`)
    REFERENCES `hsp`.`department` (`dept_no`),
  CONSTRAINT `fk_Nurse_Employee1`
    FOREIGN KEY (`nurse_no`)
    REFERENCES `hsp`.`employee` (`emp_no`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`nurse_monitors_room`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`nurse_monitors_room` (
  `room_no` INT NOT NULL,
  `nurse_no` INT NOT NULL,
  PRIMARY KEY (`room_no`, `nurse_no`),
  INDEX `fk_nurse_monitors_room_nurse1` (`nurse_no` ASC) VISIBLE,
  CONSTRAINT `fk_nurse_monitors_room_nurse1`
    FOREIGN KEY (`nurse_no`)
    REFERENCES `hsp`.`nurse` (`nurse_no`),
  CONSTRAINT `fk_room_hAS_Nurse_room1`
    FOREIGN KEY (`room_no`)
    REFERENCES `hsp`.`room` (`room_no`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`outpatient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`outpatient` (
  `outpat_no` INT NOT NULL,
  PRIMARY KEY (`outpat_no`),
  CONSTRAINT `fk_outpatient_patient1`
    FOREIGN KEY (`outpat_no`)
    REFERENCES `hsp`.`patient` (`pat_no`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`patient_phone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`patient_phone` (
  `pat_no` INT NOT NULL,
  `phone_number` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`pat_no`, `phone_number`),
  CONSTRAINT `fk_Employee_phone_copy1_Patient1`
    FOREIGN KEY (`pat_no`)
    REFERENCES `hsp`.`patient` (`pat_no`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`prescription`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`prescription` (
  `mdcn_no` INT NOT NULL,
  `outpat_no` INT NOT NULL,
  `doct_no` INT NOT NULL,
  `dose` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`mdcn_no`, `outpat_no`, `doct_no`),
  INDEX `fk_prescription_outpatient1` (`outpat_no` ASC) VISIBLE,
  INDEX `fk_prescription_Doctor1` (`doct_no` ASC) VISIBLE,
  CONSTRAINT `fk_prescription_Doctor1`
    FOREIGN KEY (`doct_no`)
    REFERENCES `hsp`.`doctor` (`doct_no`),
  CONSTRAINT `fk_prescription_medicine1`
    FOREIGN KEY (`mdcn_no`)
    REFERENCES `hsp`.`medicine` (`mdcn_no`),
  CONSTRAINT `fk_prescription_outpatient1`
    FOREIGN KEY (`outpat_no`)
    REFERENCES `hsp`.`outpatient` (`outpat_no`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`researcher`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`researcher` (
  `res_no` INT NOT NULL,
  `status` CHAR(45) NOT NULL,
  `researcher_allowance` VARCHAR(45) NOT NULL,
  `lab_no` INT NOT NULL,
  INDEX `fk_Researcher_lab1` (`lab_no` ASC) VISIBLE,
  PRIMARY KEY (`res_no`),
  CONSTRAINT `fk_Researcher_Employee1`
    FOREIGN KEY (`res_no`)
    REFERENCES `hsp`.`employee` (`emp_no`),
  CONSTRAINT `fk_Researcher_lab1`
    FOREIGN KEY (`lab_no`)
    REFERENCES `hsp`.`lab` (`lab_no`))
ENGINE = InnoDB;

#index for searching the researcher by researcher status
CREATE INDEX res_status ON researcher (status);

-- -----------------------------------------------------
-- Table `hsp`.`technician`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`technician` (
  `tech_no` INT NOT NULL,
  PRIMARY KEY (`tech_no`),
  CONSTRAINT `fk_Technician_Employee1`
    FOREIGN KEY (`tech_no`)
    REFERENCES `hsp`.`employee` (`emp_no`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`technician_operates_lab`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`technician_operates_lab` (
  `lab_no` INT NOT NULL,
  `tech_no` INT NOT NULL,
  PRIMARY KEY (`lab_no`, `tech_no`),
  INDEX `fk_technician_operates_lab_Technician1` (`tech_no` ASC) VISIBLE,
  CONSTRAINT `fk_Technician_hAS_lab_lab1`
    FOREIGN KEY (`lab_no`)
    REFERENCES `hsp`.`lab` (`lab_no`),
  CONSTRAINT `fk_technician_operates_lab_Technician1`
    FOREIGN KEY (`tech_no`)
    REFERENCES `hsp`.`technician` (`tech_no`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`department_directors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`department_directors` (
  `doct_no` INT NOT NULL,
  `dept_no` INT NOT NULL,
  PRIMARY KEY (`doct_no`, `dept_no`),
  INDEX `fk_Department_Directors_department1_idx` (`dept_no` ASC) VISIBLE,
  CONSTRAINT `fk_Department_Directors_doctor1`
    FOREIGN KEY (`doct_no`)
    REFERENCES `hsp`.`doctor` (`doct_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Department_Directors_department1`
    FOREIGN KEY (`dept_no`)
    REFERENCES `hsp`.`department` (`dept_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hsp`.`Lab_Director`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hsp`.`Lab_Director` (
  `res_no` INT NOT NULL,
  `lab_no` INT NOT NULL,
  PRIMARY KEY (`res_no`, `lab_no`),
  INDEX `fk_Lab_Director_lab1_idx` (`lab_no` ASC) VISIBLE,
  CONSTRAINT `fk_Lab_Director_researcher1`
    FOREIGN KEY (`res_no`)
    REFERENCES `hsp`.`researcher` (`res_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lab_Director_lab1`
    FOREIGN KEY (`lab_no`)
    REFERENCES `hsp`.`lab` (`lab_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;

-- -----------------------------------------------------
-- Stored procedures
-- -----------------------------------------------------
#Outputs doctors' details who work in a given department,
#recieves the department name as an input.
#e.g. call hsp.doctors_work_in_department('Cardiology');
DROP procedure IF EXISTS `doctors_work_in_department`;
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `doctors_work_in_department` (department_name VARCHAR(45))
BEGIN
SELECT * FROM employee WHERE emp_no IN 
(SELECT doct_no FROM doctor WHERE dept_no IN 
(SELECT dept_no FROM department WHERE dept_name = department_name));
END$$
DELIMITER ;

#Outputs nurses' details who work in a given department,
#recieves the department name as an input.
#e.g. call hsp.nurses_work_in_department('Neurology'); 
DROP procedure IF EXISTS `nurses_work_in_department`;
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `nurses_work_in_department` (department_name VARCHAR(45))
BEGIN
SELECT * FROM employee WHERE emp_no IN 
(SELECT nurse_no FROM nurse WHERE dept_no IN 
(SELECT dept_no FROM department WHERE dept_name = department_name));
END$$
DELIMITER ;

#Outputs researchers' details who are affilated with the given lab,
#recieves the lab name as an input.
#e.g.. call hsp.researchers_affiliated_with_lab('Clinical Lab');
DROP procedure IF EXISTS `researchers_affilated_with_lab`;
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `researchers_affiliated_with_lab` (lab_name VARCHAR(45))
BEGIN
SELECT * FROM employee WHERE emp_no IN 
(SELECT res_no FROM researcher WHERE lab_no IN 
(SELECT lab_no FROM lab WHERE name = lab_name));
END$$
DELIMITER ;

#Outputs technicians' details who operate the given lab,
#recieves the lab name as an input.
#e.g.. call hsp.technicians__operate_lab('Chemistry lab');
DROP procedure IF EXISTS `technicians__operate_lab`;
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `technicians__operate_lab` (lab_name VARCHAR(45))
BEGIN
SELECT * FROM employee WHERE emp_no IN 
(SELECT tech_no FROM technician_operates_lab WHERE lab_no IN 
(SELECT lab_no FROM lab WHERE name = lab_name));
END$$
DELIMITER ;

#Outputs full-time or part-time researchers' details, bASed on the given status.
#recieves the researcher status as an input.
#e.g. call hsp.`researchers_full-time/part-time`('full-time');
DROP procedure IF EXISTS `researchers_full-time/part-time`;
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `researchers_full-time/part-time` (given_status VARCHAR(45))
BEGIN
SELECT * FROM employee WHERE emp_no IN 
(SELECT res_no FROM researcher WHERE status = given_status);
END$$
DELIMITER ;

#Outputs the name of the department with more than n nurses
#recieves the number as an input.
#e.g. call hsp.depts_with_more_than_n_nurses(2);
DROP procedure IF EXISTS `depts_with_more_than_n_nurses`;	
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `depts_with_more_than_n_nurses` (number INT)
BEGIN
SELECT dept_name
  FROM nurse
     INNER JOIN department
       ON department.dept_no = nurse.dept_no
        GROUP BY department.dept_name
          HAVING COUNT(*) > number;
END$$
DELIMITER ;

#Outputs number of inpatients, outpatients and 
#the ratio between them in a given period of time.
#Recieves start and finish dates as inputs
#e.g. call hsp.`ratio_inpat/outpat`('2020-12-12', '2020-12-25');
DROP procedure IF EXISTS `ratio_inpat/outpat`;	
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `ratio_inpat/outpat` (start_date DATE, finish_date DATE)
BEGIN
SELECT SUM(inpatient) AS num_of_inpats, SUM(outpatient) as num_of_outpats, SUM(inpatient) / SUM(outpatient) AS ratio
FROM ((SELECT pat_no, 1 AS outpatient, 0 AS inpatient
       FROM patient, outpatient
       WHERE (addmission_date  > start_date AND addmission_date < finish_date)
       AND pat_no = outpat_no
		) UNION ALL
     (SELECT pat_no, 0 AS outpatient, 1 AS inpatient 
     FROM patient, inpatient
     WHERE (addmission_date  > start_date AND addmission_date < finish_date)
     AND (discharge_date >	start_date AND discharge_date < finish_date)
     AND pat_no = inpat_no))	inpats;
END$$
DELIMITER ;

#Outputs the details of doctors who operated more than n patients in a given period of time.
#Recieves start,finish dates and number as inputs.
#e.g. call hsp.docts_operated_more_than_n_patients('2020-12-01', '2020-12-31', 1);
DROP procedure IF EXISTS `docts_operated_more_than_n_patients`;	
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `docts_operated_more_than_n_patients` (start_date DATE,finish_date DATE,number INT)
BEGIN
SELECT *
	FROM employee WHERE emp_no IN 
	(SELECT doctor.doct_no
		FROM doctor,inpatient_undergoes_surgery
        WHERE doctor.doct_no = inpatient_undergoes_surgery.doct_no
        AND  (inpatient_undergoes_surgery.date >  start_date AND
			  inpatient_undergoes_surgery.date < finish_date)
        GROUP BY doct_no
        HAVING COUNT(*) > number);
END$$
DELIMITER ;

#Outputs the details of doctor who operated highest number of patients in a given period of time.
#Recieves start and finish dates as inputs.
#e.g. call hsp.doct_operated_highest_num_of_patients('2020-12-01', '2020-12-31');
DROP procedure IF EXISTS `doct_operated_highest_num_of_patients`;	
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `doct_operated_highest_num_of_patients` (start_date DATE,finish_date DATE)
BEGIN
SELECT * FROM employee WHERE emp_no IN
(SELECT doct_no FROM 
(SELECT doct_no, MAX(num_of_pat) FROM
(SELECT doctor.doct_no, COUNT(*) AS num_of_pat
		FROM doctor,inpatient_undergoes_surgery
        WHERE doctor.doct_no = inpatient_undergoes_surgery.doct_no
        AND  (inpatient_undergoes_surgery.date > start_date AND
			  inpatient_undergoes_surgery.date < finish_date)
        GROUP BY doct_no) doct_pat
        ORDER BY doct_no) max_pat);
END$$
DELIMITER ;

#Outputs room number with highest number of inpatients at a given addmission date.
#e.g. call hsp.room_with_highest_num_of_pats('2020-12-15');
DROP procedure IF EXISTS `room_with_highest_num_of_pats`;	
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `room_with_highest_num_of_pats` (addmission_date DATE)
BEGIN
SELECT room_no, COUNT(*) AS number_of_inpats
FROM inpatient WHERE inpat_no IN
(SELECT pat_no FROM patient 
WHERE addmission_date = addmission_date)
GROUP BY room_no
ORDER BY number_of_inpats desc
limit 1;
END$$
DELIMITER ;

#Outputs the number of inpatients and the number of outpatients treated by a given doctor at a given date.
#Receieves, date, doctor last and first names as inputs.
#e.g. call hsp.`doctor_treated_num_of_in/outpats`('2020-12-14', 'Taylor', 'Susan');
DROP procedure IF EXISTS `doctor_treated_num_of_in/outpats`;	
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `doctor_treated_num_of_in/outpats` (date DATE, doctor_l_name VARCHAR (45),doctor_f_name VARCHAR(45))
BEGIN
SELECT examination.doct_no, COUNT(inpatient.inpat_no) AS num_of_inpats, COUNT(outpatient.outpat_no) AS num_of_outpats
FROM examination 
LEFT JOIN inpatient ON examination.pat_no = inpatient.inpat_no
LEFT JOIN outpatient ON examination.pat_no = outpatient.outpat_no
WHERE doct_no IN (SELECT emp_no FROM employee WHERE L_name = doctor_l_name  AND f_name = doctor_f_name )
AND examination.date = date;
END$$
DELIMITER ;

#Outputs the number of doctors conducting researcher,those who don't,
#and the ratio between the number of doctors conducting a research activity 
#and the number of those that do not during a given period of time.
#Recieves start and finish dates as inputs.
#e.g. call hsp.`ratio_doct-research/docts`('2020-12-01', '2020-12-31');
DROP procedure IF EXISTS `ratio_doct-research/docts`;	
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE  `ratio_doct-research/docts` (start_date DATE ,finish_date DATE)
BEGIN
SELECT SUM(doctors_conducting_research) AS docts_conduct_research, SUM(doctors) as docts_without_research_act,
	   SUM(doctors_conducting_research) / SUM(doctors) AS ratio
FROM ((SELECT doctor.doct_no,  1 AS doctors_conducting_research, 0 AS doctors
       FROM doctor, doctor_conducts_research
       WHERE resact_no  IN 
       (SELECT resact_no FROM research_activity 
       WHERE (research_activity.start_date  > start_date AND research_activity.finish_date < finish_date))
       AND doctor.doct_no = doctor_conducts_research.doct_no)
       UNION ALL
     (SELECT doctor.doct_no, 0 AS doctors_conducting_research, 1 AS doctors 
     FROM doctor
     WHERE doctor.doct_no NOT IN 
     (SELECT doct_no FROM doctor_conducts_research)))	doctors_wihtout_research;
END$$
DELIMITER ;

#Outputs the number of full time,part time researchers 
#and a ratio between full-time and part-time researchers in a given lab
#Recieves lab name as an input.
#e.g. call hsp.`ratio_full/part_researcher`('Clinical lab');
DROP procedure IF EXISTS `ratio_full/part_researcher`;	
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `ratio_full/part_researcher` (lab_name VARCHAR(45))
BEGIN
SELECT SUM(full_time_researcher) AS num_of_full_time_res, SUM(part_time_researcher) AS num_of_part_time_res, 
	   SUM(full_time_researcher) / SUM(part_time_researcher) AS ratio
FROM ((SELECT res_no, 1 AS full_time_researcher, 0 AS part_time_researcher
       FROM researcher
       WHERE lab_no IN
       (SELECT lab_no FROM lab
       WHERE name = lab_name)
       AND status = 'full-time'
		) UNION ALL
     (SELECT res_no, 0 AS full_time_researcher, 1 AS part_time_researcher
	  FROM researcher
       WHERE lab_no IN
       (SELECT lab_no FROM lab
       WHERE name = lab_name)
       AND status = 'part-time')) part_time_researchers;
END$$
DELIMITER ;

#Outputs the medicine  which was prescribed maximum times
#e.g.. call hsp.medicine_prescribed_max_times();
DROP procedure IF EXISTS `medicine_prescribed_max_times`;	
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `medicine_prescribed_max_times` ()
BEGIN
SELECT mdcn_no, COUNT(*) AS number_of_prescription
FROM prescription
GROUP BY mdcn_no
ORDER BY number_of_prescription desc
limit 1;
END$$
DELIMITER ;

#Outputs details of technicians who operate more than n labs.
#Recieves number as an input.
#e.g call hsp.technicians__operate_more_than_n_lab(1);
DROP procedure IF EXISTS `technicians__operate_more_than_n_lab`;
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `technicians__operate_more_than_n_lab` (number INT)
BEGIN
SELECT *
	FROM employee WHERE emp_no IN 
	(SELECT technician.tech_no
		FROM technician, technician_operates_lab
        WHERE technician.tech_no = technician_operates_lab.tech_no
        GROUP BY tech_no
        HAVING COUNT(*) > number);
END$$
DELIMITER ;

#Outputs the number of employees hired in a given year.
#Recieves year as an input.
#e.g call hsp.num_of_employees_hired_in_year(2018);
DROP procedure IF EXISTS `num_of_employees_hired_in_year`;
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `num_of_employees_hired_in_year` (year INT)
BEGIN
SELECT COUNT(*) AS number_of_employees
	FROM employee_works_in_hospital WHERE 
    YEAR(hire_date) = year;
END$$
DELIMITER ;

#Outputs the details of the most expansive surgery in a given department
#Recieves the department name as an input.
# e.g. call hsp.most_expansive_surgery_in_department('Cardiology');
DROP procedure IF EXISTS `most_expansive_surgery_in_department`;
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `most_expansive_surgery_in_department` (department_name VARCHAR(45))
BEGIN
SELECT * FROM surgery
	WHERE dept_no IN 
    (SELECT dept_no FROM department WHERE dept_name = department_name)
    GROUP BY surg_no
    ORDER BY price
    limit 1;
END$$
DELIMITER ;

#Outputs the number of doctors monitoring the given inpatient.
#Recieves first and last names of the inpatient.
# e.g. call hsp.num_of_docts_monitoring_patient('Jake', 'Allen');
DROP procedure IF EXISTS `num_of_docts_monitoring_patient`;
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `num_of_docts_monitoring_patient` (inpatient_f_name VARCHAR(45), inpatient_l_name VARCHAR(45))
BEGIN
SELECT COUNT(*) AS num_of_doctors
FROM doctor_monitors_inpatient 
WHERE inpat_no IN 
(SELECT pat_no FROM patient WHERE l_name = inpatient_l_name AND f_name = inpatient_f_name);
END$$
DELIMITER ;

#Outputs the name of the department with more than n doctors
#Recieves number as an input.
#e.g. call hsp.depts_with_more_than_n_doctors(3);
DROP procedure IF EXISTS `depts_with_more_than_n_doctors`;	
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `depts_with_more_than_n_doctors` (number INT)
BEGIN
SELECT dept_name
  FROM doctor
     INNER JOIN department
       ON department.dept_no = doctor.dept_no
        GROUP BY department.dept_name
          HAVING COUNT(*) > number;
END$$
DELIMITER ;

#Outputs the average salary of doctors.
#Does not receive an input.
#e.g. call hsp.doctor_average_salary();
DROP procedure IF EXISTS `doctors_average_salary`;	
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `doctor_average_salary` ()
BEGIN
SELECT AVG(DISTINCT salary) AS "Avg Salary"
FROM employee_works_in_hospital
WHERE emp_no IN 
(SELECT doct_no FROM doctor);
END$$
DELIMITER ;

#Outputs the average salary of nurses.
#Does not receive an input.
#e.g. call hsp.nurse_average_salary();
DROP procedure IF EXISTS `nurse_average_salary`;	
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `nurse_average_salary` ()
BEGIN
SELECT AVG (DISTINCT salary) AS "Nurse_average_salary"
FROM employee_works_in_hospital
WHERE emp_no IN 
(SELECT nurse_no FROM nurse);
END$$
DELIMITER ;

#Outputs the average salary of technicians.
#Does not receive an input.
#e.g. call hsp.tech_average_salary();
DROP procedure IF EXISTS `tech_average_salary`;	
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `tech_average_salary` ()
BEGIN
SELECT AVG (DISTINCT salary) AS "Tech_average_salary"
FROM employee_works_in_hospital
WHERE emp_no IN 
(SELECT tech_no FROM technician);
END$$
DELIMITER ;

#Average salaries of researchers
#e.g.. call hsp.res_average_salary();
DROP procedure IF EXISTS `res_average_salary`;	
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `res_average_salary` ()
BEGIN
SELECT AVG (DISTINCT salary) AS "Res_average_salary"
FROM employee_works_in_hospital
WHERE emp_no IN 
(SELECT res_no FROM researcher);
END$$
DELIMITER ;

#Outputs details of the given lab director.
#Recieves lab name as an input.
#e.g. call hsp.lab_director('Clinical Lab');
DROP procedure IF EXISTS `lab_director`;	
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `lab_director` (lab VARCHAR(45))
BEGIN
SELECT * FROM employee 
WHERE emp_no IN 
(SELECT res_no FROM lab_director
WHERE lab_no IN 
(SELECT lab_no FROM lab
WHERE name = lab));
END$$
DELIMITER ;

#Outputs the details of the given department director.
#Recieves department name as an input.
#e.g. call hsp.dept_director('Cardiology');
DROP procedure IF EXISTS `dept_director`;	
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `dept_director` (department VARCHAR(45))
BEGIN
SELECT * FROM employee 
WHERE emp_no IN 
(SELECT doct_no FROM department_directors
WHERE dept_no IN 
(SELECT dept_no FROM department
WHERE dept_name = department));
END$$
DELIMITER ;

#Outputs the lab name and number of hospitals that use the given lab.
#Recieves lab name as an input.
#e.g. call hsp.lab_used_by_num_of_hospitals('Clinical lab');
DROP procedure IF EXISTS `lab_used_by_num_of_hospitals`;	
DELIMITER $$
USE `hsp`$$
CREATE PROCEDURE `lab_used_by_num_of_hospitals` (lab VARCHAR(45))
BEGIN
SELECT lab.name, COUNT(hospital_uses_lab.lab_no) AS number_of_hospitals
FROM lab
LEFT JOIN hospital_uses_lab on hospital_uses_lab.lab_no = lab.lab_no
WHERE lab.name = lab;
END$$
DELIMITER ;

-- -----------------------------------------------------
-- Data population
-- -----------------------------------------------------
USE hsp;
#Hospitals
INSERT INTO hospital (hospital_name, street, city)
VALUES ('HSP', 'Fayette Street 15', 'London');
INSERT INTO hospital (hospital_name, street, city)
VALUES ('Newlife', 'Harley Street 58', 'London');
INSERT INTO hospital (hospital_name, street, city)
VALUES ('Medwin Cares', 'Carnaby Street 56', 'London');
INSERT INTO hospital (hospital_name, street, city)
VALUES ('Flowerence', 'Piccadilly 37','London');
INSERT INTO hospital (hospital_name, street, city)
VALUES ('JFK Medical Center', 'Brick Lane 14', 'London');
#Employees
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty) 
VALUES ('Oliver',  'Adams',	'm', '1989-07-26', 'Oxford 49', 'London','MASter of Clinical Medicine','Interventional Cardiologist');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty) 
VALUES ('Oliver', 'Sanchez', 'm', '1989-07-22','Addle 48','London','MASter of Biomedical Sciences', 'Biomedical Researcher') ;
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty) 
VALUES ('Jake',	'Campbell',	'm'	, '1989-02-26', 'John Carenter 45', 'London' ,	'Msc in CardiovAScular Science', 'Cardiologist') ;
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty) 
VALUES ('Noah',	'Flores', 'm',	'1979-07-07', 'Idol Lane 55','London','MASter of Clinical Medicine', 'Cardiologist');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty) 
VALUES ('James','Allen', 'm',	'1969-06-03', 'Kenghorn 85','London','PhD in anesthesiology ', 'anesthesiologist');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty) 
VALUES ('Jack','Rivera', 'm',	'1975-03-14', 'Nevill Lane 42','London','PhD in anesthesiology ', 'anesthesiologist');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty) 
VALUES ('Jake','Mitchell', 'm',	'1968-03-27', 'Rangoon 21','London','PhD in anesthesiology ', 'anesthesiologist');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty) 
VALUES ('Noah','Green', 'm','1967-04-30', 'Benet 42','London','MASter of Clinical Medicine', 'Medical/Clinical Lab Technician');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty) 
VALUES ('James','Hague','m','1968-04-25','Rose Alley 59','London','MASter of Clinical Medicine','Medical/Clinical Lab Technician');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty) 
VALUES ('Connor','Furry', 'm','1971-03-24', 'Waithman 23','London','PhD in CHemistry', 'chemist');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty) 
VALUES ('Liam','Higgins', 'm','1973-01-27', 'Fairlwield 56','London','PhD in CHemistry', 'chemist'); 
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('John','Evans', 'm','1984-01-01', 'Ekwall 23','London','MASters in Biology, Medicine and Health', 'Nuclear Medicine Technician'); 
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Harry','Philips', 'm','1975-12-09', 'Fann Street 12','London','MASters in Clinical Laboratory', 'Medical laboratory Scientist'); 
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Callum','Adams', 'm','1974-03-12', 'Fenchurch Street 25','London','MSc in Medical GAStroenterology', 'GAStroenterologists');  
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('MASon','Gomez', 'm','1981-08-06', 'Philpot Lane 22','London','MSc in Medical GAStroenterology', 'GAStroenterologists'); 
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Robert','Moralez', 'm','1993-01-08', 'Wormwood Street 58','London','MASter in Medicine and Surgery', 'General Surgeon'); 
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Jacob','Mendez', 'm','1989-01-01', 'Camomile Street 2','London','PhD in GAStroenterology', 'GAStroenterologist'); 
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Jacob','Shayk', 'm','1984-07-15', 'Cannon Street 12','London','PhD in Medicine and Surgery', 'General Surgeon'); 
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Emma','Reyes', 'f','1992-06-18', 'Paternoster Row	23','London','MASter in Science of Nursing', 'Nurse Practitioner'); 
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Mary','Fisher', 'f','1991-03-28', 'Cheapside 22','London','MSc Nursing and Health', 'Clinical Nurse Specialist');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Robert','Moralez', 'm','1993-01-08', 'Wormwood Street 58','London','MASter in Medicine and Surgery', 'General Surgeon'); 
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Robertz','Adams', 'm','1983-03-27', 'Lawrence Lane 32','London','PhD in Medicine', 'General Surgeon'); 
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Linda','Powell', 'f','1995-05-27', 'Cornhill 233','Milton Keynes','MASter in Science of Nursing', 'Nurse Practitioner'); 
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Ava','Butler', 'f','1983-02-16', 'Fen Court 33','London','MSc in Haematology', 'Hematologist'); 
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Mia','Brown', 'f','1984-01-28', 'Lombard Street 99','London','PhD in Haematology', 'Hematology Technician'); 
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Michael','VASquez', 'm','1964-01-19', 'Giltspur Street 69','London','MASter of Clinical Medicine', 'Hematology Researcher'); 
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('David','Tran', 'm','1975-12-12', 'Pudding Lane 117','London','PhD in Haematology', 'Hematologist'); 
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Kyle','Stevens', 'm','1980-03-11', 'Charterhouse Street 45','Milton Keynes','MASters Degrees in Nephrology', 'Nephrologist'); 
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Emily','Siena', 'm', '1990-05-16', 'Golden Lane 99','London','MASter in Science of Nursing', 'Nurse Practitioner');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Margaret','Gracechurch', 'f', '1982-07-20', 'Golden Lane 200 ','London','	MASters in Neurology', 'Neurologist');  
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Olivia','Brown', 'f', '1974-03-12', 'lorem ipsum','lorem ipsum','lorem ipsum', 'lorem ipsum'); 
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Samantha','Harvey', 'f', '1990-07-15', 'lorem ipsum','lorem ipsum','lorem ipsum', 'lorem ipsum');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Patricia','Harvey', 'f', '1980-12-16', 'lorem ipsum','lorem ipsum','lorem ipsum', 'lorem ipsum');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Sisla','Williams', 'f', '1990-07-15', 'lorem ipsum','lorem ipsum','lorem ipsum', 'lorem ipsum');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Bethany','James', 'f', '1990-07-15', 'lorem ipsum','lorem ipsum','lorem ipsum', 'lorem ipsum');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Jennifer','Peterson', 'f', '1990-07-15', 'lorem ipsum','lorem ipsum','lorem ipsum', 'lorem ipsum');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Emily','Jones', 'f', '1974-03-12', 'lorem ipsum','lorem ipsum','lorem ipsum', 'lorem ipsum');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Isabella','Armstrong', 'f', '1974-03-12', 'lorem ipsum','lorem ipsum','lorem ipsum', 'lorem ipsum');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Joanne','Lopez', 'f', '1974-03-12', 'lorem ipsum','lorem ipsum','lorem ipsum', 'lorem ipsum');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Ava','Wilson', 'f', '1974-03-12', 'lorem ipsum','lorem ipsum','lorem ipsum', 'lorem ipsum');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Emily','ThomAS', 'f', '1974-03-12', 'lorem ipsum','lorem ipsum','lorem ipsum', 'lorem ipsum');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Susan','Taylor', 'f', '1974-03-12', 'lorem ipsum','lorem ipsum','lorem ipsum', 'lorem ipsum');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Lauren','Marti', 'f', '1974-03-12', 'lorem ipsum','lorem ipsum','lorem ipsum', 'lorem ipsum');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('Madison','Ramirez', 'f', '1974-03-12', 'lorem ipsum','lorem ipsum','lorem ipsum', 'lorem ipsum');
INSERT INTO employee (f_name, l_name, sex, date_of_birth, street, city, qualification, specialty)
VALUES ('George','Myers', 'm', '1974-03-12', 'lorem ipsum','lorem ipsum','lorem ipsum', 'lorem ipsum');
#Employee_works_in_Hospital
INSERT INTO employee_works_in_hospital VALUES (1, 1, 2500, '2012-05-25');
INSERT INTO employee_works_in_hospital VALUES (2, 1, 2200, '2013-05-25');
INSERT INTO employee_works_in_hospital VALUES (3, 1, 2000, '2014-07-25');
INSERT INTO employee_works_in_hospital VALUES (4, 1, 2000, '2018-07-25');
INSERT INTO employee_works_in_hospital VALUES (5, 1, 2000, '2018-07-28');
INSERT INTO employee_works_in_hospital VALUES (6, 1, 2050, '2015-08-28');
INSERT INTO employee_works_in_hospital VALUES (7, 1, 2250, '2017-08-28');
INSERT INTO employee_works_in_hospital VALUES (8, 1, 4050, '2019-08-22');
INSERT INTO employee_works_in_hospital VALUES (9, 1, 4050, '2009-08-22');
INSERT INTO employee_works_in_hospital VALUES (10, 1, 4950, '2014-04-22');
INSERT INTO employee_works_in_hospital VALUES (11, 1, 4950, '2014-02-25');
INSERT INTO employee_works_in_hospital VALUES (12, 1, 5000, '2015-03-25');
INSERT INTO employee_works_in_hospital VALUES (13, 1, 4700, '2012-06-22');
INSERT INTO employee_works_in_hospital VALUES (14, 1, 2900, '2011-06-20');
INSERT INTO employee_works_in_hospital VALUES (15, 1, 2900, '2010-01-12');
INSERT INTO employee_works_in_hospital VALUES (16, 1, 5600, '2014-12-02');
INSERT INTO employee_works_in_hospital VALUES (17, 1, 2300, '2012-11-02');
INSERT INTO employee_works_in_hospital VALUES (18, 1, 2400, '2009-11-02');
INSERT INTO employee_works_in_hospital VALUES (19, 1, 1500, '2019-01-27');
INSERT INTO employee_works_in_hospital VALUES (20, 1, 2000, '2019-01-27');
INSERT INTO employee_works_in_hospital VALUES (21, 1, 5000, '2018-10-24');
INSERT INTO employee_works_in_hospital VALUES (22, 1, 5000, '2017-11-24');
INSERT INTO employee_works_in_hospital VALUES (23, 1, 2500, '2016-09-18');
INSERT INTO employee_works_in_hospital VALUES (24, 1, 3500, '2017-09-18');
INSERT INTO employee_works_in_hospital VALUES (25, 1, 3300, '2017-10-18');
INSERT INTO employee_works_in_hospital VALUES (26, 1, 3900, '2018-10-18');
INSERT INTO employee_works_in_hospital VALUES (27, 1, 4000, '2018-11-18');
INSERT INTO employee_works_in_hospital VALUES (28, 1, 2900, '2018-11-30');
INSERT INTO employee_works_in_hospital VALUES (29, 1, 1900, '2013-11-30');
INSERT INTO employee_works_in_hospital VALUES (30, 1, 2000, '2013-11-30');
INSERT INTO employee_works_in_hospital VALUES (31, 1, 1500, '2016-11-30');
INSERT INTO employee_works_in_hospital VALUES (32, 1, 1700, '2015-11-30');
INSERT INTO employee_works_in_hospital VALUES (33, 1, 2900, '2012-11-30');
INSERT INTO employee_works_in_hospital VALUES (34, 1, 1500, '2012-11-30');
INSERT INTO employee_works_in_hospital VALUES (35, 1, 2600, '2011-11-30');
INSERT INTO employee_works_in_hospital VALUES (36, 1, 2800, '2019-11-30');
INSERT INTO employee_works_in_hospital VALUES (37, 1, 2800, '2014-11-30');
INSERT INTO employee_works_in_hospital VALUES (38, 1, 1800, '2013-11-30');
INSERT INTO employee_works_in_hospital VALUES (39, 1, 1800, '2011-11-30');
INSERT INTO employee_works_in_hospital VALUES (40, 1, 1800, '2011-10-30');
INSERT INTO employee_works_in_hospital VALUES (41, 1, 1800, '2014-10-30');
INSERT INTO employee_works_in_hospital VALUES (42, 1, 5000, '2014-10-30');
INSERT INTO employee_works_in_hospital VALUES (43, 1, 3000, '2018-10-30');
INSERT INTO employee_works_in_hospital VALUES (44, 1, 1000, '2018-10-30');
INSERT INTO employee_works_in_hospital VALUES (45, 1, 4000, '2020-10-30');
#Departments 
INSERT INTO department (dept_name) VALUES ('Cardiology');
INSERT INTO department (dept_name) VALUES ('Anaesthetics');
INSERT INTO department (dept_name) VALUES ('GAStroenterology');
INSERT INTO department (dept_name) VALUES ('General Surgery');
INSERT INTO department (dept_name) VALUES ('Neurology');
INSERT INTO department (dept_name) VALUES ('Haematology');
INSERT INTO department (dept_name) VALUES ('Nephrology');
INSERT INTO department (dept_name) VALUES ('Dentistry');
INSERT INTO department (dept_name) VALUES ('Orthopedics');
INSERT INTO department (dept_name) VALUES ('Pathology');
#Doctors 
INSERT INTO doctor VALUES (1,1);
INSERT INTO doctor VALUES (3,1);
INSERT INTO doctor VALUES (4,1);
INSERT INTO doctor VALUES (5,2);
INSERT INTO doctor VALUES (6,2);
INSERT INTO doctor VALUES (7,2);
INSERT INTO doctor VALUES (14,3);
INSERT INTO doctor VALUES (15,3);
INSERT INTO doctor VALUES (16,4);
INSERT INTO doctor VALUES (17,9);
INSERT INTO doctor VALUES (18,4);
INSERT INTO doctor VALUES (21,4);
INSERT INTO doctor VALUES (22,4);
INSERT INTO doctor VALUES (24,6);
INSERT INTO doctor VALUES (27,6);
INSERT INTO doctor VALUES (28,7);
INSERT INTO doctor VALUES (30,5);
INSERT INTO doctor VALUES (42,10);
INSERT INTO doctor VALUES (43,8);
#Department-Directors
INSERT INTO department_directors VALUES (1,1);
INSERT INTO department_directors VALUES (5,2);
INSERT INTO department_directors VALUES (14,3);
INSERT INTO department_directors VALUES (16,4);
INSERT INTO department_directors VALUES (24,6);
INSERT INTO department_directors VALUES (28,7);
INSERT INTO department_directors VALUES (30,5);
#Nurses
INSERT INTO nurse VALUES (19,5);
INSERT INTO nurse VALUES (20,4);
INSERT INTO nurse VALUES (23,5);
INSERT INTO nurse VALUES (29,7);
INSERT INTO nurse VALUES (31,1);
INSERT INTO nurse VALUES (32,8);
INSERT INTO nurse VALUES (33,9);
INSERT INTO nurse VALUES (34,4);
INSERT INTO nurse VALUES (38,2);
INSERT INTO nurse VALUES (39,10);
INSERT INTO nurse VALUES (40,5);
INSERT INTO nurse VALUES (41,6);
INSERT INTO nurse VALUES (44,3);
#Labs 
INSERT INTO lab (name, hospital_code) VALUES ('Clinical lab', 1);
INSERT INTO lab (name, hospital_code) VALUES ('Pathological lab', 1);
INSERT INTO lab (name, hospital_code) VALUES ('Chemistry lab', 1);
INSERT INTO lab (name, hospital_code) VALUES ('VAScular Lab', 1);
#Researchers
INSERT INTO researcher VALUES  (2, 'full-time', 'YES', 1);
INSERT INTO researcher VALUES  (10, 'full-time', 'YES', 3);
INSERT INTO researcher VALUES  (11, 'part-time', 'YES', 4);
INSERT INTO researcher VALUES  (13, 'part-time', 'YES', 1);
INSERT INTO researcher VALUES  (26, 'full-time', 'YES', 4);
INSERT INTO researcher VALUES  (35, 'part-time', 'YES', 1);
INSERT INTO researcher VALUES  (37, 'full-time', 'YES', 2);
#Technician
INSERT INTO technician VALUES (8);
INSERT INTO technician VALUES (9);
INSERT INTO technician VALUES (12);
INSERT INTO technician VALUES (25);
INSERT INTO technician VALUES (36);
INSERT INTO technician VALUES (45);
#Lab_Director
INSERT INTO lab_director VALUES (2,1);
INSERT INTO lab_director VALUES (10,3);
INSERT INTO lab_director VALUES (26,4);
INSERT INTO lab_director VALUES (37,2);
#Technician Operates Lab
INSERT INTO technician_operates_lab VALUES (1,8);
INSERT INTO technician_operates_lab VALUES (3,8);
INSERT INTO technician_operates_lab VALUES (1,9);
INSERT INTO technician_operates_lab VALUES (3,9);
INSERT INTO technician_operates_lab VALUES (3,12);
INSERT INTO technician_operates_lab VALUES (1,12);
INSERT INTO technician_operates_lab VALUES (3,25);
INSERT INTO technician_operates_lab VALUES (1,36);
INSERT INTO technician_operates_lab VALUES (4,36);
INSERT INTO technician_operates_lab VALUES (2,36);
INSERT INTO technician_operates_lab VALUES (3,36);
#Patients
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('Oliver', 'Sanchez', '2020-12-25', '1980-07-26','m', 'Oxford 40', 'London', 'HYPERTENSION');
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('Oliver', 'Adams', '2020-12-12', '1988-07-22','m', 'Addle 49', 'London', 'CORONARY ARTERY DISEASE');
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('James', 'Campbell', '2020-12-14', '1959-06-03','m', 'Kenghorn 82', 'London', 'Valurive DISEASE');
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('Jack', 'Flores', '2020-12-26', '1975-03-14','m', 'Nevill Lane 24', 'London', 'CONGESTIVE FAILURE');
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('Noah', 'Furry', '2020-12-28', '1947-04-30','m', 'Benet 49', 'London', 'ATRIAL FIBRILLATION');
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('James', 'Mitchell', '2020-12-29', '1958-04-25','m', 'Rose Alley 75', 'London', 'ATRIAL FIBRILLATION');
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('Olivia', 'Allen', '2020-12-05', '1958-04-25','f', 'Rose Alley 75', 'London', 'ATRIAL FIBRILLATION');
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('Bethany', 'Williams', '2020-12-23', '1958-04-25','f', 'Rose Alley 75', 'London', 'lorem ipsum');
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('Sophia', 'James', '2020-12-29', '1958-04-25','f', 'lorem ipsum', 'lorem ipsum', 'lorem ipsum'); 
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('Elizabeth', 'Armstrong', '2020-12-13', '1958-04-25','m', 'lorem ipsum', 'lorem ipsum', 'lorem ipsum');
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('Jake', 'Allen', '2020-12-20', '1987-02-26','m', 'John Carenter 41', 'London', 'VALVULAR Heart DISEASE');
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('Noah', 'Rivera', '2020-12-15', '1977-07-07','m', 'Idol Lane 56', 'London', 'VALVULAR Heart DISEASE');
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('Liam', 'Evans', '2020-12-15', '1973-02-27','m', 'lorem ipsum', 'London', 'CHRONIC OBSTRUCTIVE PULMONARY ');
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('Liam', 'Hall', '2020-12-12', '1973-02-12','m', 'lorem ipsum', 'London', 'lorem ipsum');
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('Abi', 'Hughes', '2020-12-19', '1973-02-27','f', 'lorem ipsum', 'London', 'lorem ipsum'); 
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('Ethany', 'Foster', '2020-12-19', '1973-02-27','m', 'lorem ipsum', 'lorem ipsum', 'lorem ipsum'); 
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('David', 'Rossy', '2020-12-15', '1973-02-27','m', 'lorem ipsum', 'lorem ipsum', 'lorem ipsum'); 
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('George', 'Myel', '2020-12-19', '1973-02-27','m', 'lorem ipsum', 'lorem ipsum', 'lorem ipsum'); 
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('Madison', 'Foster', '2020-12-05', '1973-02-27','m', 'lorem ipsum', 'lorem ipsum', 'lorem ipsum'); 
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('Michael', 'Perezza', '2020-12-14', '1973-02-27','m', 'lorem ipsum', 'lorem ipsum', 'lorem ipsum');
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('Abi', 'Styles', '2020-12-27', '1973-02-27','f', 'lorem ipsum', 'lorem ipsum', 'lorem ipsum'); 
INSERT INTO patient (f_name, l_name,addmission_date,date_of_birth, sex, street, city, diagnosis)
VALUES ('OscarM', 'Brown', '2020-12-28', '1973-02-27','m', 'lorem ipsum', 'lorem ipsum', 'lorem ipsum'); 
#examination
INSERT INTO examination VALUES (1,5,1, '2020-12-25', 'lorem ipsum');
INSERT INTO examination VALUES (2,1,4, '2020-12-12', 'lorem ipsum');
INSERT INTO examination VALUES (3,42,2, '2020-12-14', 'lorem ipsum');
INSERT INTO examination VALUES (4,14,1, '2020-12-26', 'lorem ipsum');
INSERT INTO examination VALUES (5,24,3, '2020-12-28', 'lorem ipsum');
INSERT INTO examination VALUES (6,17,1, '2020-12-29', 'lorem ipsum');
INSERT INTO examination VALUES (7,17,1, '2020-12-05', 'lorem ipsum');
INSERT INTO examination VALUES (8,28,1, '2020-12-23', 'lorem ipsum');
INSERT INTO examination VALUES (9,43,1, '2020-12-29', 'lorem ipsum');
INSERT INTO examination VALUES (10,17,1, '2020-12-13', 'lorem ipsum');
INSERT INTO examination VALUES (11,1,4, '2020-12-20', 'lorem ipsum');
INSERT INTO examination VALUES (12,1,4, '2020-12-15', 'lorem ipsum');
INSERT INTO examination VALUES (13,3,4, '2020-12-15', 'lorem ipsum');
INSERT INTO examination VALUES (14,14,3, '2020-12-12', 'lorem ipsum');
INSERT INTO examination VALUES (15,18,1, '2020-12-09', 'lorem ipsum');
INSERT INTO examination VALUES (16,30,3, '2020-12-19', 'lorem ipsum');
INSERT INTO examination VALUES (17,30,3, '2020-12-15', 'lorem ipsum');
INSERT INTO examination VALUES (18,30,3, '2020-12-19', 'lorem ipsum');
INSERT INTO examination VALUES (19,42,2, '2020-12-05', 'lorem ipsum');
INSERT INTO examination VALUES (20,42,2, '2020-12-14', 'lorem ipsum');
INSERT INTO examination VALUES (21,42,2, '2020-12-27', 'lorem ipsum');
INSERT INTO examination VALUES (22,24,3, '2020-12-28', 'lorem ipsum');
#outpatients
INSERT INTO outpatient VALUES (1);
INSERT INTO outpatient VALUES (2);
INSERT INTO outpatient VALUES (3);
INSERT INTO outpatient VALUES (4);
INSERT INTO outpatient VALUES (5);
INSERT INTO outpatient VALUES (6);
INSERT INTO outpatient VALUES (7);
INSERT INTO outpatient VALUES (8);
INSERT INTO outpatient VALUES (9);
INSERT INTO outpatient VALUES (10);
#Rooms
INSERT INTO room  (dept_no) VALUES (1);
INSERT INTO room  (dept_no) VALUES (3);
INSERT INTO room  (dept_no) VALUES (4);
INSERT INTO room  (dept_no) VALUES (5);
INSERT INTO room  (dept_no) VALUES (7);
INSERT INTO room  (dept_no) VALUES (10);
INSERT INTO room  (dept_no) VALUES (6);
#Inpatient
INSERT INTO inpatient VALUES (11, '2020-12-31', 1);
INSERT INTO inpatient VALUES (12, '2020-12-22', 1);
INSERT INTO inpatient VALUES (13, '2020-12-22', 1);
INSERT INTO inpatient VALUES (14, '2020-12-22', 2);
INSERT INTO inpatient VALUES (15, '2020-12-24', 3);
INSERT INTO inpatient VALUES (16, '2020-12-22', 4);
INSERT INTO inpatient VALUES (17, '2020-12-26', 5);
INSERT INTO inpatient VALUES (18, '2020-12-28', 5);
INSERT INTO inpatient VALUES (19, '2020-12-12', 6);
INSERT INTO inpatient VALUES (20, '2020-12-22', 6);
INSERT INTO inpatient VALUES (21, '2020-12-31', 6);
INSERT INTO inpatient VALUES (22, '2020-12-31', 7);
#doctor_monitors_inpatient
INSERT INTO doctor_monitors_inpatient VALUES (1,11);
INSERT INTO doctor_monitors_inpatient VALUES (3,11);
INSERT INTO doctor_monitors_inpatient VALUES (1,12);
INSERT INTO doctor_monitors_inpatient VALUES (4,12);
INSERT INTO doctor_monitors_inpatient VALUES (4,13);
INSERT INTO doctor_monitors_inpatient VALUES (14,14);
INSERT INTO doctor_monitors_inpatient VALUES (15,14);
INSERT INTO doctor_monitors_inpatient VALUES (16,15);
INSERT INTO doctor_monitors_inpatient VALUES (18,15);
#Medicine
INSERT INTO medicine (mdcn_name, manufacturer) VALUES ('lorem ipsum','lorem ipsum'); 
INSERT INTO medicine (mdcn_name, manufacturer) VALUES ('lorem ipsum','lorem ipsum');
INSERT INTO medicine (mdcn_name, manufacturer) VALUES ('lorem ipsum','lorem ipsum');
INSERT INTO medicine (mdcn_name, manufacturer) VALUES ('lorem ipsum','lorem ipsum');
INSERT INTO medicine (mdcn_name, manufacturer) VALUES ('lorem ipsum','lorem ipsum');
INSERT INTO medicine (mdcn_name, manufacturer) VALUES ('lorem ipsum','lorem ipsum');
INSERT INTO medicine (mdcn_name, manufacturer) VALUES ('lorem ipsum','lorem ipsum');
#Prescription
INSERT INTO prescription VALUES (1, 1, 5, 'loprem ipSUM');
INSERT INTO prescription VALUES (2, 2, 1, 'loprem ipSUM');
INSERT INTO prescription VALUES (3, 3, 42, 'loprem ipSUM');
INSERT INTO prescription VALUES (4, 4, 14, 'loprem ipSUM');
INSERT INTO prescription VALUES (5, 5, 24, 'loprem ipSUM');
INSERT INTO prescription VALUES (6, 6, 17, 'loprem ipSUM');
INSERT INTO prescription VALUES (7, 7, 17, 'loprem ipSUM');
INSERT INTO prescription VALUES (7, 8, 28, 'loprem ipSUM');
INSERT INTO prescription VALUES (1, 9, 43, 'loprem ipSUM');
INSERT INTO prescription VALUES (1, 10, 17, 'loprem ipSUM');
#surgery
INSERT INTO surgery(name,price,dept_no) VALUES ('Aneurysm repair', 2590, 1);
INSERT INTO surgery(name,price,dept_no) VALUES ('Maze surgery', 2530, 1);
INSERT INTO surgery(name,price,dept_no) VALUES ('Heart valve repair or replacement', 4430, 1);
INSERT INTO surgery(name,price,dept_no) VALUES ('lorem ipsum', 2430, 3);
INSERT INTO surgery(name,price,dept_no) VALUES ('lorem ipsum', 4430, 4);
INSERT INTO surgery(name,price,dept_no) VALUES ('lorem ipsum', 6430, 5);
INSERT INTO surgery(name,price,dept_no) VALUES ('lorem ipsum', 4230, 7);
INSERT INTO surgery(name,price,dept_no) VALUES ('lorem ipsum', 5230, 10);
#inpatient-surgery
INSERT INTO inpatient_undergoes_surgery VALUES (1, '2020-12-29', 1, 11);
INSERT INTO inpatient_undergoes_surgery VALUES (2, '2020-12-28', 1, 12);
INSERT INTO inpatient_undergoes_surgery VALUES (3, '2020-12-27', 1, 13);
INSERT INTO inpatient_undergoes_surgery VALUES (4, '2020-12-21', 14, 14);
INSERT INTO inpatient_undergoes_surgery VALUES (5, '2020-12-20', 16, 15);
INSERT INTO inpatient_undergoes_surgery VALUES (6, '2020-12-20', 30, 16);
INSERT INTO inpatient_undergoes_surgery VALUES (7, '2020-12-23', 28, 17);
INSERT INTO inpatient_undergoes_surgery VALUES (8, '2020-12-07', 42, 19);
INSERT INTO inpatient_undergoes_surgery VALUES (8, '2020-12-16', 42, 20);
#Research Activity 
INSERT INTO research_activity (start_date,finish_date, topic) VALUES ('2020-12-01','2020-12-05','lorem ipsum');
INSERT INTO research_activity (start_date,finish_date, topic) VALUES ('2020-12-12','2020-12-20','lorem ipsum');
INSERT INTO research_activity (start_date,finish_date, topic) VALUES ('2020-12-12','2020-12-15','lorem ipsum');
INSERT INTO research_activity (start_date,finish_date, topic) VALUES ('2020-12-11','2020-12-19','lorem ipsum');
INSERT INTO research_activity (start_date,finish_date, topic) VALUES ('2020-12-01','2020-12-04','lorem ipsum');
INSERT INTO research_activity (start_date,finish_date, topic) VALUES ('2020-12-25','2020-12-29','lorem ipsum');
INSERT INTO research_activity (start_date,finish_date, topic) VALUES ('2020-12-24','2020-12-25','lorem ipsum');
INSERT INTO research_activity (start_date,finish_date, topic) VALUES ('2020-12-21','2020-12-26','lorem ipsum');
INSERT INTO research_activity (start_date,finish_date, topic) VALUES ('2020-12-12','2020-12-14','lorem ipsum');
INSERT INTO research_activity (start_date,finish_date, topic) VALUES ('2020-12-25','2020-12-28','lorem ipsum');
#doctor conducts research
INSERT INTO doctor_conducts_research VALUES (1,1,1);
INSERT INTO doctor_conducts_research VALUES (2,1,5);
INSERT INTO doctor_conducts_research VALUES (3,1,6);
INSERT INTO doctor_conducts_research VALUES (4,2,6);
INSERT INTO doctor_conducts_research VALUES (5,2,7);
INSERT INTO doctor_conducts_research VALUES (6,2,14);
INSERT INTO doctor_conducts_research VALUES (7,3,22);
INSERT INTO doctor_conducts_research VALUES (8,3,27);
INSERT INTO doctor_conducts_research VALUES (9,4,17);
INSERT INTO doctor_conducts_research VALUES (10,4,28);
#bill
INSERT INTO bill (pat_no,bill_amount,pat_type,doctor_charge, room_charge,surgery_charge,nursing_charge) 
VALUES (1, 500, 'outpatient', 500, NULL, NULL, NULL);
INSERT INTO bill (pat_no,bill_amount,pat_type,doctor_charge, room_charge,surgery_charge,nursing_charge) 
 VALUES (2, 700, 'outpatient', 700, NULL, NULL, NULL);
INSERT INTO bill (pat_no,bill_amount,pat_type,doctor_charge, room_charge,surgery_charge,nursing_charge) 
 VALUES (3, 300, 'outpatient', 300, NULL, NULL, NULL);
INSERT INTO bill (pat_no,bill_amount,pat_type,doctor_charge, room_charge,surgery_charge,nursing_charge) 
VALUES (4, 250, 'outpatient', 250, NULL, NULL, NULL);
INSERT INTO bill (pat_no,bill_amount,pat_type,doctor_charge, room_charge,surgery_charge,nursing_charge) 
VALUES (11, 1250, 'inpatient', 550, 0, 0, 0);
INSERT INTO bill (pat_no,bill_amount,pat_type,doctor_charge, room_charge,surgery_charge,nursing_charge) 
VALUES (12, 1350, 'inpatient', 0, 0, 0, 0);
INSERT INTO bill (pat_no,bill_amount,pat_type,doctor_charge, room_charge,surgery_charge,nursing_charge) 
VALUES (13, 1250, 'inpatient', 0, 0, 0, 0);
INSERT INTO bill (pat_no,bill_amount,pat_type,doctor_charge, room_charge,surgery_charge,nursing_charge) 
VALUES (14, 1250, 'inpatient', 0, 0, 0, 0);
#Other hospitals using the labs of HSP
INSERT INTO hospital_uses_lab VALUES (2, 1);
INSERT INTO hospital_uses_lab VALUES (2, 2);
INSERT INTO hospital_uses_lab VALUES (3, 4);
INSERT INTO hospital_uses_lab VALUES (4, 1);
INSERT INTO hospital_uses_lab VALUES (4, 3);
INSERT INTO hospital_uses_lab VALUES (5, 1);
INSERT INTO hospital_uses_lab VALUES (5, 2);