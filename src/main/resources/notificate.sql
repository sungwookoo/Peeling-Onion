create table notificate.alarm
(
    id          bigint auto_increment
        primary key,
    sender_id   bigint       null,
    receiver_id bigint       null,
    content     varchar(255) null,
    created_at  datetime     null,
    read_or_not tinyint(1)   null
);

