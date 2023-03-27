package com.ssafy.peelingonion.common;

import org.springframework.stereotype.Component;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;

public class StringToInstant {

    public static Instant S2Ins(String s) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate date = LocalDate.parse(s, formatter);
        Instant inst = date.atStartOfDay(ZoneOffset.UTC).toInstant();
        return inst;
    }
}
