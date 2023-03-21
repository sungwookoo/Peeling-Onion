package com.ssafy.peelingonion.onion.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.Instant;
import java.util.Date;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
// 양파 생성하기 위한 요청 정보
public class OnionCreateRequestDto {
    // 1. 양파 이름
    public String onion_name;
    // 2. 보내는 사람 정보
    public List<Integer> user_id_list;
    // 3. 받는 사람 정보(전화번호)
    public String mobile_number;
    // 4. 키울 기한 설정(언제까지 키울지 정보, 년-월-일)
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    public Date grow_due_date;
    // 5. 양파 종류 -> S3의 소스 주소가 들어간다.
    public String img_src;
}