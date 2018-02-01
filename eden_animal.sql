USE `essentialmode`;


INSERT INTO `shops` (name, item, price) VALUES

	('LTDgasoline','croquettes',1000)
;

INSERT INTO `items` (name, label) VALUES 
	('croquettes', 'Croquettes'),
;

ALTER TABLE `users`
  ADD `animal` VARCHAR(50) NULL DEFAULT '',

;
