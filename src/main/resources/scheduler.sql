SHOW VARIABLES WHERE VARIABLE_NAME = 'event_scheduler';

SET GLOBAL event_scheduler = ON;

-- 양파 상하기 전에
DELIMITER $$
DROP PROCEDURE IF EXISTS SP_ONION_DEAD $$
CREATE PROCEDURE SP_ONION_DEAD()
BEGIN
    INSERT INTO notificate.alarm(sender_id, receiver_id, content, created_at, is_sended, is_read, type)
    SELECT a.user_id as sender_id,
           a.user_id as "receiver_id",
           'content' as content,
           now()     as created_at,
           false     as is_sended,
           false     as is_read,
           1         as type
    FROM onion.onion a,
         onion.send_onion b
    WHERE 1 = 1
      AND a.send_date is null
      AND a.id = b.onion_id
      AND a.latest_modify BETWEEN (a.grow_due_date + INTERVAL 2 day) AND (a.grow_due_date + INTERVAL 3 day);
END$$
DELIMITER ;

-- 양파 성장완료
DELIMITER $$
DROP PROCEDURE IF EXISTS SP_ONION_GROW $$
CREATE PROCEDURE SP_ONION_GROW()
BEGIN
    INSERT INTO notificate.alarm(sender_id, receiver_id, content, created_at, is_sended, is_read, type)
    SELECT a.user_id as sender_id,
           a.user_id as "receiver_id",
           'content' as content,
           now()     as created_at,
           false     as is_sended,
           false     as is_read,
           3         as type
    FROM onion.onion a
    WHERE 1 = 1
      AND a.send_date is null
      AND a.grow_due_date <= now();
END$$
DELIMITER ;


-- EVENT 등록
CREATE EVENT IF NOT EXISTS onion_dead_event
    ON SCHEDULE EVERY '1' DAY STARTS '2023-03-25'
    DO CALL SP_ONION_DEAD();

CREATE EVENT IF NOT EXISTS onion_grow_event
    ON SCHEDULE EVERY '1' DAY STARTS '2023-03-25'
    DO CALL SP_ONION_GROW();
