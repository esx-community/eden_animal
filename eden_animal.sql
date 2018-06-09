USE `essentialmode`;

INSERT INTO `shops` (`name`, `item`, `price`) VALUES
	('LTDgasoline', 'croquettes', 100)
;

INSERT INTO `items` (`name`, `label`, `limit`) VALUES
	('croquettes', 'Croquettes', 20)
;

ALTER TABLE `users` ADD COLUMN `animal` VARCHAR(255) NULL;