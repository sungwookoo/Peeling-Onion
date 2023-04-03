package com.ssafy.peelingonion.onion.service;

import static com.ssafy.peelingonion.common.ConstValues.*;

import com.ssafy.peelingonion.field.domain.*;
import com.ssafy.peelingonion.onion.controller.dto.AlarmRequest;
import com.ssafy.peelingonion.onion.controller.dto.MessageCreateRequest;
import com.ssafy.peelingonion.onion.controller.dto.OnionCreateRequest;
import com.ssafy.peelingonion.onion.domain.*;
import com.ssafy.peelingonion.record.domain.MyRecord;
import com.ssafy.peelingonion.record.domain.MyRecordRepository;
import com.ssafy.peelingonion.record.domain.Record;
import com.ssafy.peelingonion.record.domain.RecordRepository;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Slf4j
@Service
public class OnionService {
	private final OnionRepository onionRepository;
	private final SendOnionRepository sendOnionRepository;
	private final RecordRepository recordRepository;
	private final MyRecordRepository myRecordRepository;
	private final MessageRepository messageRepository;
	private final ReceiveOnionRepository receiveOnionRepository;
	private final FieldRepository fieldRepository;
	private final StorageRepository storageRepository;
	private final MyFieldRepository myFieldRepository;

	private final long DEAD_TIME = 60 * 60 * 24 * 3L;
	public OnionService(OnionRepository onionRepository,
		SendOnionRepository sendOnionRepository,
		RecordRepository recordRepository,
		MyRecordRepository myRecordRepository,
		MessageRepository messageRepository,
		ReceiveOnionRepository receiveOnionRepository,
		FieldRepository fieldRepository,
		StorageRepository storageRepository,
		MyFieldRepository myFieldRepository) {
		this.onionRepository = onionRepository;
		this.sendOnionRepository = sendOnionRepository;
		this.recordRepository = recordRepository;
		this.myRecordRepository = myRecordRepository;
		this.messageRepository = messageRepository;
		this.receiveOnionRepository = receiveOnionRepository;
		this.fieldRepository = fieldRepository;
		this.storageRepository = storageRepository;
		this.myFieldRepository = myFieldRepository;
	}

	public void createOnion(OnionCreateRequest onionCreateRequest, Long userId) {
		Onion onion = Onion.from(onionCreateRequest, userId);
		Onion newOnion = onionRepository.save(onion);
		List<Long> senderIds = onionCreateRequest.getUser_id_list();
		senderIds.add(userId);
		for (Long senderId : senderIds) {
			sendOnionRepository.save(SendOnion.from(senderId, onionCreateRequest, newOnion));
		}
		receiveOnionRepository.save(ReceiveOnion.from(onion, userId, onionCreateRequest));
		// 모아보내기의 경우, 알림서버에 해당 메시지를 등록한다.
		if (!onionCreateRequest.is_single.booleanValue()) {
			senderIds.stream()
				.forEach(e -> addAlarm(userId, e, ONION_ADD_SENDER));
		}
	}

	public void addAlarm(Long srcUserId, Long desUserId, int type) {
		AlarmRequest alarmRequest = AlarmRequest.builder()
			.sender_id(srcUserId)
			.receiver_id(desUserId)
			.content("")
			.created_at(Instant.now().plusSeconds(60*60*9))
			.type(type)
			.build();
		try {
			ALARM_SERVER_CLIENT.post()
				.uri("/alarm")
				.bodyValue(alarmRequest)
				.retrieve()
				.onStatus(HttpStatus::is4xxClientError, clientResponse -> Mono.error(RuntimeException::new))
				.onStatus(HttpStatus::is5xxServerError, clientResponse -> Mono.error(RuntimeException::new))
				.bodyToMono(Void.class)
				.block();
		} catch (Exception e) {
			log.error(e.getMessage());
		}
	}

	public List<SendOnion> findSendOnions(Long userId) {
		return sendOnionRepository.findALlByUserIdAndIsSended(userId, Boolean.FALSE);
	}

	public void recordMessage(MessageCreateRequest messageCreateRequest, Long userId) {
		Record record = recordRepository.save(Record.from(messageCreateRequest));
		myRecordRepository.save(MyRecord.from(record, userId));
		Optional<Onion> opOnion = onionRepository.findById(messageCreateRequest.getId());
		// 메시지를 저장할 때, 뭘해야하나???
		if (opOnion.isPresent()) {
			Onion onion = opOnion.get();
			onion.setLatestModify(Instant.now().plusSeconds(60*60*9));
			Onion oni = onionRepository.save(onion);
			messageRepository.save(Message.from(userId, oni, record, messageCreateRequest));
		}
	}

	public boolean checkOnionIsWatered(Onion onion) {
		Instant lastModified = onion.getLatestModify();
		// 1. 메세지가 없다면 그냥 추가하면 된다.
		if(onion.getMessages().isEmpty()) {
			return false;
		// 2. 메세지가 있다면
		} else {
			// 2-1. lastModified의 날짜를 가져와서 오늘 날짜와 비교
			// 오늘 == 수정일 -> isWatered: true/ 아니면 false
			Date dateNow = Date.from(Instant.now().plusSeconds(60*60*9));
			Date dateModified = Date.from(lastModified);
			Calendar calendar1 = Calendar.getInstance();
			calendar1.setTime(dateNow);
			Calendar calendar2 = Calendar.getInstance();
			calendar2.setTime(dateModified);
			int year1 = calendar1.get(Calendar.YEAR);
			int month1 = calendar1.get(Calendar.MONTH) + 1;
			int day1 = calendar1.get(Calendar.DAY_OF_MONTH);
			int year2 = calendar2.get(Calendar.YEAR);
			int month2 = calendar2.get(Calendar.MONTH) + 1;
			int day2 = calendar2.get(Calendar.DAY_OF_MONTH);

			return year1 == year2 && month1 == month2 && day1 == day2;
		}
	}

	public Map<String, Boolean> checkOnionIsDeadAndTime2Go(Onion onion) {
		// 이미 썪어있다면 썪은 여부는 판단이 불가능하다.
		Map<String, Boolean> isDeadAndTime2Go = new HashMap<>();
		// 키우는 기간이 3일 미만인 양파의 경우
		// 양파 생성 due date에서 양파 생성일을 빼기
		Instant createdTime = onion.getCreatedAt();
		Instant growDueDate = onion.getGrowDueDate();
		Instant lastModified = onion.getLatestModify();
		long growTime = createdTime.until(growDueDate, ChronoUnit.SECONDS);
		// 1. 키우는 기간이 3일 이상인 경우
		if(growTime >= DEAD_TIME) {
			// 1-1. 지금이 growDueDate를 넘었다면 -> 보낼 수도 있음
			if(Instant.now().plusSeconds(60*60*9).isAfter(growDueDate)) {
				// 1-1-1. lastModified가 growDueDate차이가 3일이 넘기면 썪음
				if(lastModified.until(growDueDate, ChronoUnit.SECONDS) >= DEAD_TIME) {
					isDeadAndTime2Go.put("isDead", true);
					isDeadAndTime2Go.put("time2Go", false);
				// 1-1-2. lastModified가 growDueDate차이가 3일 안이면 안썪음
				} else {
					isDeadAndTime2Go.put("isDead", false);
					isDeadAndTime2Go.put("time2Go", true);
				}
				// 1-2. 아직 growDueDate를 넘기지 않았다면 -> 못보냄, 썪음 여부만 판단
			} else {
				// 1-2-1. lastModified가 3일이 지났다면 -> 썪음
				if(lastModified.until(growDueDate, ChronoUnit.SECONDS) >= DEAD_TIME) {
					isDeadAndTime2Go.put("isDead", true);
				// 1-2-2. lastModified가 3일이 지나지 않았다면 -> 썪지 않음
				} else {
					isDeadAndTime2Go.put("isDead", false);
				}
				isDeadAndTime2Go.put("time2Go", false);
			}

			// 2. 키우는 기간이 3일 미만인 경우
		} else {
			// 2-1.지금이 growDueDate를 넘었다면
			if(Instant.now().plusSeconds(60*60*9).isAfter(growDueDate)) {
				// 2-1-1. 만약 onion에 메시지가 있다면 보낼 수 있음
				if(!onion.getMessages().isEmpty()) {
					isDeadAndTime2Go.put("isDead", false);
					isDeadAndTime2Go.put("time2Go", true);
					// 2-1-2. onion에 메세지가 없다면 썪었고, 보낼 수 없음
				} else {
					isDeadAndTime2Go.put("isDead", true);
					isDeadAndTime2Go.put("time2Go", false);
				}
				// 2-2. 아직 growDueDate를 못넘겼다면 -> 안썪음, 보낼 수 없음
			} else {
				isDeadAndTime2Go.put("isDead", false);
				isDeadAndTime2Go.put("time2Go", false);
			}
		}
		return isDeadAndTime2Go;
	}

	public void throwOnion(Long onionId) {
		Optional<Onion> opOnion = onionRepository.findById(onionId);
		if (opOnion.isPresent()) {
			Onion onion = opOnion.get();
			// getGrowDueDate가 지났다면, 그리고 삭제한 양파가 아니라면 아래의 로직을 실행
			if (onion.getGrowDueDate().isBefore(Instant.now().plusSeconds(60*60*9)) && !onion.getIsDisabled().booleanValue()) {
				// 양파의 전송일 추가하기
				onion.setSendDate(Instant.now().plusSeconds(60*60*9));
				onionRepository.save(onion);
				// 내가 만든 양파에서 해당 양파 전송여부 true
				Set<SendOnion> sendOnions = onion.getSendOnions();
				for (SendOnion sendOnion : sendOnions) {
					sendOnion.setIsSended(Boolean.TRUE);
					sendOnionRepository.save(sendOnion);
				}
				// 내가 받은 양파에서 수신 여부 true
				ReceiveOnion receiveOnion = receiveOnionRepository.findByOnion(onion);
				receiveOnion.setIsReceived(Boolean.TRUE);
				receiveOnionRepository.save(receiveOnion);
				Long targetId = getUserIdFromMobileNumber(receiveOnion.getReceiverNumber());
				if (targetId > 0) {
					addAlarm(onion.getUserId(), targetId, ONION_RECEIVE);
				}
			}
		}
	}

	public List<ReceiveOnion> findReceiveOnions(String receiverNumber) {
		return receiveOnionRepository.findAllByReceiverNumberAndIsReceivedAndIsChecked(receiverNumber, Boolean.TRUE,
			Boolean.FALSE);
	}

	public Onion findOnionById(Long onionId) {
		Optional<Onion> opOnion = onionRepository.findById(onionId);
		if (opOnion.isPresent()) {
			return opOnion.get();
		} else {
			throw new IllegalArgumentException("해당 양파가 없음");
		}
	}

	public ReceiveOnion findReceiveOnionByOnionId(Long onionId, Long userId) {
		Optional<Onion> opOnion = onionRepository.findById(onionId);
		// 양파가 존재하는 경우
		if (opOnion.isPresent()) {
			Optional<ReceiveOnion> opReceiveOnion = receiveOnionRepository.findByOnionIdAndIsReceived(
				opOnion.get().getId(), Boolean.TRUE);
			// 받은 양파가 없다면
			if (opReceiveOnion.isPresent()) {
				ReceiveOnion receiveOnion = opReceiveOnion.get();
				// 양파가 체크 안되있는 경우 -> 택배함, 읽고 체크해주고, 새롭게 store을 만들어야한다.(기본밭으로)
				if (!receiveOnion.getIsChecked().booleanValue()) {
					receiveOnion.setIsChecked(Boolean.TRUE);
					Optional<MyField> opMyField = myFieldRepository.findByUserIdAndIsDefault(userId, Boolean.TRUE);
					// 기본밭을 찾는데 있다면
					if (opMyField.isPresent()) {
						Onion o = receiveOnion.getOnion();
						MyField myField = opMyField.get();
						storageRepository.save(Storage
							.builder()
							.field(myField.getField())
							.onion(o)
							.createdAt(o.getCreatedAt())
							.isBookmarked(Boolean.FALSE)
							.build());
						return receiveOnionRepository.save(receiveOnion);
					}
					throw new IllegalStateException("기본밭이 없는경우");
				} else {
					// 양파가 체크 되어 있는 경우 -> 밭에서 확인하는 경우
					return receiveOnion;
				}
			} else {
				throw new IllegalStateException("양파는 있는데, 받은 양파가 조회가 안됨");
			}
		}
		// 만약 해당 아이디의 양파가 없다면, (그럴 일은 없지만, 버린다.)
		throw new IllegalStateException("해당 양파가 없음");
	}

	public List<ReceiveOnion> findBookmarkedOnions(Long userId) {
		return receiveOnionRepository.findByUserIdAndIsBookmarked(userId, Boolean.TRUE);
	}

	public void bookmarkOnion(Long onionId) {
		Optional<Onion> opOnion = onionRepository.findById(onionId);
		if (opOnion.isPresent()) {
			ReceiveOnion receiveOnion = receiveOnionRepository.findByOnionId(onionId);
			if (receiveOnion.getIsBookmarked().booleanValue()) {
				receiveOnion.setIsBookmarked(Boolean.FALSE);
			} else {
				receiveOnion.setIsBookmarked(Boolean.TRUE);
			}
			receiveOnionRepository.save(receiveOnion);
		}
	}

	public void deleteOnion(Long onionId, Long userId) {
		Optional<Onion> opOnion = onionRepository.findById(onionId);
		if (opOnion.isPresent()) {
			Onion onion = opOnion.get();
			Iterator<ReceiveOnion> iterator = onion.getReceiveOnions().iterator();
			ReceiveOnion receiveOnion = iterator.next();
			String receiverNumber = receiveOnion.getReceiverNumber();
			String requesterNumber = getMobileNumberByUserId(userId);
			if (onion.getUserId().equals(userId)) {
				onion.setIsDisabled(Boolean.TRUE);
				onionRepository.save(onion);
				return;
			} else if (Objects.equals(requesterNumber, receiverNumber)){
				onion.setIsDisabled(Boolean.TRUE);
				onionRepository.save(onion);
				return;
			} else {
				throw new IllegalStateException("양파를 만든 대표자나 양파의 수신자만 삭제할 수 있습니다.");
			}
		}
		throw new IllegalStateException("없는 양파입니다.");
	}

	public void transferOnion(Long fromFId, Long toFId, Long onionId) {
		Optional<Storage> opStorage = storageRepository.findByFieldIdAndOnionId(fromFId, onionId);
		Optional<Field> opToField = fieldRepository.findById(toFId);
		if (opStorage.isPresent() && opToField.isPresent()) {
			Storage storage = opStorage.get();
			storage.setField(opToField.get());
			storageRepository.save(storage);
		}
	}

	public Message findMessageById(Long messageId) {
		Optional<Message> opMessage = messageRepository.findById(messageId);
		return opMessage.orElseGet(() -> Message.builder()
			.id(10000000L)
			.build());
	}

	public String getNameByUserId(Long userId) {
		try {
			return USER_SERVER_CLIENT.get()
				.uri("/user/" + userId.toString() + "/nickname")
				.retrieve()
				.onStatus(HttpStatus::is4xxClientError, clientResponse -> Mono.error(RuntimeException::new))
				.onStatus(HttpStatus::is5xxServerError, clientResponse -> Mono.error(RuntimeException::new))
				.bodyToMono(String.class)
				.block();
		} catch (Exception e) {
			return "";
		}
	}

	public String getMobileNumberByUserId(Long userId) {
		try {
			return USER_SERVER_CLIENT.get()
				.uri("/user/" + userId.toString() + "/mobile")
				.retrieve()
				.onStatus(HttpStatus::is4xxClientError, clientResponse -> Mono.error(RuntimeException::new))
				.onStatus(HttpStatus::is5xxServerError, clientResponse -> Mono.error(RuntimeException::new))
				.bodyToMono(String.class)
				.block();
		} catch (Exception e) {
			return "";
		}
	}

	public Long getUserIdFromMobileNumber(String mobileNumber) {
		try {
			return USER_SERVER_CLIENT.get()
				.uri("/user/mobile/" + mobileNumber)
				.retrieve()
				.onStatus(HttpStatus::is4xxClientError, clientResponse -> Mono.error(RuntimeException::new))
				.onStatus(HttpStatus::is5xxServerError, clientResponse -> Mono.error(RuntimeException::new))
				.bodyToMono(Long.class)
				.block();
		} catch (Exception e) {
			log.error("{}", e.getMessage());
			return -2L;
		}
	}


}
