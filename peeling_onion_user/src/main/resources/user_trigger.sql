DELIMITER $$

CREATE TRIGGER update_item
    AFTER UPDATE ON user.user
    FOR EACH ROW
BEGIN
    IF NEW.activate != OLD.activate THEN
    DELETE FROM send_onion WHERE NEW.id = send_onion.user_id AND is_sended = 0;
END IF;
END; $$

DELIMITER ;