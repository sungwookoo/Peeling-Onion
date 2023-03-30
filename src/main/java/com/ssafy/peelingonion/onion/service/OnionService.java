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
import java.util.List;
import java.util.Optional;

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
			.created_at(Instant.now())
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
			onion.setLatestModify(Instant.now());
			Onion oni = onionRepository.save(onion);
			messageRepository.save(Message.from(userId, oni, record, messageCreateRequest));
		}
	}

	public void throwOnion(Long onionId) {
		Optional<Onion> opOnion = onionRepository.findById(onionId);
		if (opOnion.isPresent()) {
			Onion onion = opOnion.get();
			// getGrowDueDate가 지났다면, 그리고 삭제한 양파가 아니라면 아래의 로직을 실행
			if (onion.getGrowDueDate().isBefore(Instant.now()) && !onion.getIsDisabled()) {
				// 양파의 전송일 추가하기
				onion.setSendDate(Instant.now());
				onionRepository.save(onion);
				// 내가 만든 양파에서 해당 양파 전송여부 true
				SendOnion sendOnion = sendOnionRepository.findByOnion(onion);
				sendOnion.setIsSended(Boolean.TRUE);
				sendOnionRepository.save(sendOnion);
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
		// ***** 에러처리를 이렇게 하는게 맞나??!! *****//
		return opOnion.orElseGet(() -> Onion.builder()
			.id(1000000L)
			.build());
	}

	public ReceiveOnion findReceiveOnionByOnionId(Long onionId, Long userId) {
		Optional<Onion> opOnion = onionRepository.findById(onionId);
		if (opOnion.isPresent()) {
			ReceiveOnion receiveOnion = receiveOnionRepository.findByOnion(opOnion.get());
			if (!receiveOnion.getIsChecked()) {
				receiveOnion.setIsChecked(Boolean.TRUE);
				MyField myField = myFieldRepository.findByUserIdAndIsDefault(userId, Boolean.TRUE);
				Onion o = receiveOnion.getOnion();
				storageRepository.save(Storage
					.builder()
					.field(myField.getField())
					.onion(o)
					.createdAt(o.getCreatedAt())
					.isBookmarked(Boolean.FALSE)
					.build());
				return receiveOnionRepository.save(receiveOnion);
			}
			return receiveOnion;
		}
		// 만약 해당 아이디의 양파가 없다면, (그럴 일은 없지만, 버린다.)
		return ReceiveOnion.builder()
			.id(100000000L)
			.build();
	}

	public List<ReceiveOnion> findBookmarkedOnions(Long userId) {
		return receiveOnionRepository.findByUserIdAndIsBookmarked(userId, Boolean.TRUE);
	}

	public void bookmarkOnion(Long onionId) {
		Optional<Onion> opOnion = onionRepository.findById(onionId);
		if (opOnion.isPresent()) {
			Onion onion = opOnion.get();
			ReceiveOnion receiveOnion = receiveOnionRepository.findByOnionId(onionId);
			if (receiveOnion.getIsBookmarked()) {
				receiveOnion.setIsBookmarked(Boolean.FALSE);
			} else {
				receiveOnion.setIsBookmarked(Boolean.TRUE);
			}
			receiveOnionRepository.save(receiveOnion);
		}

	}

	public void deleteOnion(Long onionId) {
		// ***** 만약 없다면 ***** //
		Optional<Onion> opOnion = onionRepository.findById(onionId);
		if (opOnion.isPresent()) {
			Onion onion = opOnion.get();
			onion.setIsDisabled(Boolean.TRUE);
			onionRepository.save(onion);
		}
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
