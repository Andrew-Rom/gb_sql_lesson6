DROP DATABASE IF EXISTS hw6;
CREATE DATABASE hw6;
USE hw6;
SET GLOBAL log_bin_trust_function_creators = 1;

/*
1. Создайте функцию, которая принимает кол-во сек и формат их в кол-во дней, часов, минут и секунд.
Пример: 123456 ->'1 days 10 hours 17 minutes 36 seconds '
*/

DROP FUNCTION IF EXISTS seconds_converter;

DELIMITER //

CREATE FUNCTION seconds_converter (input_time INT)
RETURNS TEXT NOT DETERMINISTIC
BEGIN
  SET @in_time = input_time;
  SET @out_time = '';

  IF input_time > 0 THEN
    SET @get_seconds = input_time % 60;
    SET input_time = input_time DIV 60;
    SET @get_minutes = input_time % 60;
    SET input_time = input_time DIV 60;
    SET @get_hours = input_time % 24;
    SET @get_days = input_time DIV 24;

    IF @get_days != 0 THEN SET @out_time = CONCAT(@get_days, ' days ');
    END IF;

    IF @get_hours != 0 THEN SET @out_time = CONCAT(@out_time, @get_hours, ' hours ');
    END IF;

    IF @get_minutes != 0 THEN SET @out_time = CONCAT(@out_time, @get_minutes, ' minutes ');
    END IF;

    IF @get_seconds != 0 THEN SET @out_time = CONCAT(@out_time, @get_seconds, ' seconds');
    END IF;

    RETURN CONCAT(@in_time, ' seconds -> ', @out_time);

  ELSEIF input_time = '0' THEN
    RETURN 'You entered 0 seconds';

  ELSE
    RETURN 'Incorrect input';

  END IF;

END//

DELIMITER ;

SELECT seconds_converter(123456); -- Вызов функции


/*
2. Выведите только четные числа от 1 до 10.
Пример: 2,4,6,8,10
*/

DROP PROCEDURE IF EXISTS get_even_digits;

DELIMITER //

CREATE PROCEDURE get_even_digits (IN value INT)
BEGIN
  DECLARE i INT DEFAULT 2;

  IF value > 0 AND value % 2 = 0 THEN
    DROP TABLE IF EXISTS result;
    CREATE TEMPORARY TABLE result (id INT DEFAULT 0, res INT);
    WHILE i <= value DO
	  INSERT INTO result(res) VALUES (i);
      SET i = i + 2;
    END WHILE;
    SELECT GROUP_CONCAT(res SEPARATOR ', ') AS 'RESULT' FROM result GROUP BY id;

  ELSEIF value > 1 AND value % 2 != 0 THEN
    DROP TABLE IF EXISTS result;
    CREATE TEMPORARY TABLE result (id INT DEFAULT 0, res INT);
    WHILE i < value DO
	  INSERT INTO result(res) VALUES (i);
      SET i = i + 2;
    END WHILE;
    SELECT GROUP_CONCAT(res SEPARATOR ', ') AS 'RESULT' FROM result GROUP BY id;

  ELSEIF value = '0' OR value = '1' THEN
    SELECT 'No digits';

  ELSE
    SELECT 'Incorrect input';

  END IF;

END//

DELIMITER ;

CALL get_even_digits(10);