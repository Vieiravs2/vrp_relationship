CREATE TABLE vieira_relationship (
`id` INT NOT NULL,
`solteiro` INT NOT NULL, 
`namorando` INT NOT NULL,
`noivando`INT NOT NULL,
`casado` INT NOT NULL,
`divorciado` INT NOT NULL,
`conjid` INT DEFAULT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;