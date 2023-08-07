create table user.notify_type
(
    id    bigint auto_increment
        primary key,
    type  varchar(50) null,
    value int         null
);

create table user.user
(
    id            bigint auto_increment
        primary key,
    kakao_id      varchar(50)  null,
    nickname      varchar(20)  null,
    img_src       varchar(200) null,
    created_at    datetime     null,
    activate      tinyint(1)   null,
    mobile_number varchar(11)  null
);

create table user.auth
(
    id         bigint auto_increment
        primary key,
    user_id    bigint      not null,
    auth_code  varchar(10) null,
    auth_state tinyint(1)  null,
    constraint FK_user_TO_auth_1
        foreign key (user_id) references user.user (id)
);

create table user.blocked
(
    id         bigint auto_increment
        primary key,
    user_id    bigint   not null,
    target_id  bigint   not null,
    created_at datetime null,
    constraint FK_user_TO_blocked_1
        foreign key (user_id) references user.user (id),
    constraint FK_user_TO_blocked_2
        foreign key (target_id) references user.user (id)
);

create table user.configure
(
    uid     bigint not null,
    user_id bigint not null,
    value   int    null,
    constraint FK_user_TO_configure_1
        foreign key (user_id) references user.user (id)
);

create table user.report
(
    id         bigint auto_increment
        primary key,
    user_id    bigint      not null,
    target_id  bigint      not null,
    reason     varchar(20) null,
    created_at datetime    null,
    constraint FK_user_TO_report_1
        foreign key (user_id) references user.user (id),
    constraint FK_user_TO_report_2
        foreign key (target_id) references user.user (id)
);

create table user.withdraw
(
    id         bigint auto_increment
        primary key,
    user_id    bigint       not null,
    reason     varchar(255) null,
    created_at datetime     null,
    constraint FK_user_TO_withdraw_1
        foreign key (user_id) references user.user (id)
);

