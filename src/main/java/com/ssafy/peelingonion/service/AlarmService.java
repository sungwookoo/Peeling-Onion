package com.ssafy.peelingonion.service;

import static com.ssafy.peelingonion.common.ConstValues.*;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.common.net.HttpHeaders;
import com.ssafy.peelingonion.common.ConstValues;
import com.ssafy.peelingonion.domain.Alarm;
import com.ssafy.peelingonion.domain.AlarmRepository;
import com.ssafy.peelingonion.domain.FcmMessage;
import com.ssafy.peelingonion.service.exceptions.AlarmNotFoundException;
import com.ssafy.peelingonion.service.exceptions.Client4xxException;
import com.ssafy.peelingonion.service.exceptions.Client5xxException;

import lombok.extern.slf4j.Slf4j;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import reactor.core.publisher.Mono;

@Service
@Slf4j
public class AlarmService {
	private final AlarmRepository alarmRepository;
	private final ObjectMapper objectMapper;
	private final OkHttpClient CLIENT = new OkHttpClient();
	private final static String FIREBASE_CONFIG_PATH = "firebase/firebase_service_key.json";

	public AlarmService(AlarmRepository alarmRepository, ObjectMapper objectMapper) {
		this.alarmRepository = alarmRepository;
		this.objectMapper = objectMapper;
	}

	public void sendMessageTo(String targetToken, String title, String body) throws IOException {
		String message = makeMessage(targetToken, title, body);
		Request request = newRequest(message, FCM_API_URL);
		Response response = CLIENT.newCall(request).execute();
		log.info("{}", response.body().string());
	}

	public void sendMessageTo(Alarm alarm) throws IOException {
		// 해당 유저의 토큰값 가져오기.
		String fcmToken = getFCMTokenByUserId(alarm.getReceiverId());

		// contentType 설정
		String msg = makeContentByType(alarm);

		// overloading 함수 재사용
		sendMessageTo(fcmToken, "Peeling Onion", msg);
	}

	private String makeContentByType(Alarm alarm) {
		final String sender = getNameByUserId(alarm.getSenderId());
		final String receiver = getNameByUserId(alarm.getReceiverId());

		String msg;
		switch (alarm.getType().intValue()) {
			case ConstValues.ONION_DEAD:
				msg = "양파가 상하기 직전이에요.";
				break;
			case ConstValues.ONION_RECEIVE:
				msg = sender + "에게 양파가 도착했어요";
				break;
			case ConstValues.ONION_GROW_DONE:
				msg = "양파를 보낼 수 있어요.";
				break;
			case ConstValues.ONION_ADD_SENDER:
				msg = sender + "님이 " + receiver + "에게 보내는 메시지에 초대했어요";
				break;
			default:
				msg = "Peeling Onion";
				break;
		}
		return msg;
		// AlarmDto alarmDto = AlarmDto.from(alarm);
		// alarmDto.content = msg;
		// return alarmDto.toString();
	}

	private Request newRequest(String message, String url) throws IOException {
		RequestBody requestBody = RequestBody.create(message,
			MediaType.get("application/json; charset=utf-8"));
		return new Request.Builder()
			.url(url)
			.post(requestBody)
			.addHeader(HttpHeaders.AUTHORIZATION, "Bearer " + getAccessToken())
			.addHeader(HttpHeaders.CONTENT_TYPE, "application/json; UTF-8")
			.build();
	}

	private String makeMessage(String targetToken, String title, String body)
		throws JsonProcessingException {
		FcmMessage fcmMessage = FcmMessage.builder()
			.message(FcmMessage.Message.builder()
				.token(targetToken)
				.notification(
					FcmMessage.Notification
						.builder()
						.title(title)
						.body(body)
						.image(null)
						.build())
				.build())
			.validateOnly(false)
			.build();

		return objectMapper.writeValueAsString(fcmMessage);
	}

	private String getAccessToken() throws IOException {
		GoogleCredentials googleCredentials = GoogleCredentials
			.fromStream(new ClassPathResource(FIREBASE_CONFIG_PATH).getInputStream())
			.createScoped(List.of("https://www.googleapis.com/auth/cloud-platform"));

		googleCredentials.refreshIfExpired();
		return googleCredentials.getAccessToken().getTokenValue();
	}

	public void saveNotification(Alarm alarm) {
		alarm.setIsRead(false);
		alarmRepository.save(alarm);
	}

	/**
	 * User Service와 통신하여 userId로 FCMtoken을 반환
	 * @param userId
	 * @return
	 */
	public String getFCMTokenByUserId(Long userId) {
		try {
			return USER_SERVER_CLIENT.get()
				.uri("/user/fcm/" + userId.toString())
				.retrieve()
				.onStatus(HttpStatus::is4xxClientError, clientResponse -> Mono.error(Client4xxException::new))
				.onStatus(HttpStatus::is5xxServerError, clientResponse -> Mono.error(Client5xxException::new))
				.bodyToMono(String.class)
				.block();
		} catch (Exception e) {
			return "";
		}
	}

	/**
	 * userID를 통해서 닉네임을 찾는다.
	 * 해당 유저가 없거나, 통신에 실패할 경우 빈문자열을 반환한다.
	 * @param userId
	 * @return
	 */
	public String getNameByUserId(Long userId) {
		try {
			return USER_SERVER_CLIENT.get()
				.uri("/user/" + userId.toString() + "/nickname")
				.retrieve()
				.onStatus(HttpStatus::is4xxClientError, clientResponse -> Mono.error(Client4xxException::new))
				.onStatus(HttpStatus::is5xxServerError, clientResponse -> Mono.error(Client5xxException::new))
				.bodyToMono(String.class)
				.block();
		} catch (Exception e) {
			return "";
		}
	}

	/**
	 * 해당 user의 모든 알림정보를 반환한다.
	 * @param userId
	 * @return
	 */
	public List<Alarm> getAlarmList(Long userId) {
		return alarmRepository.findByReceiverIdOrderByIdDesc(userId);
	}

	/**
	 * userId를 가진 유저의 프로필 이미지 링크를 불러온다.
	 * @param userId
	 * @return
	 */
	public String getUserImgSrc(Long userId) {
		try {
			return USER_SERVER_CLIENT.get()
				.uri("/user/img/" + userId.toString())
				.retrieve()
				.onStatus(HttpStatus::is4xxClientError, clientResponse -> Mono.error(Client4xxException::new))
				.onStatus(HttpStatus::is5xxServerError, clientResponse -> Mono.error(Client5xxException::new))
				.bodyToMono(String.class)
				.block();
		} catch (Exception e) {
			return "";
		}
	}

	public boolean readAlarm(Long userId, Long alarmId) {
		Alarm alarm = alarmRepository.findById(alarmId).orElseThrow(AlarmNotFoundException::new);
		if (alarm.getReceiverId() == userId) {
			alarm.setIsRead(true);
			alarmRepository.save(alarm);
			return true;
		}
		return false;
	}
}