/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import hiTraceMeter from '@ohos.hiTraceMeter';
import Logger from './Logger';
import { ChatModel, ChatContact, FriendMoment } from '../viewmodel/MsgBase';
import { ChatListData } from '../viewmodel/ChatListDataSource';
import Constants from './Constants';

const TAG: string = 'ChatList_DataFactory';
const MAKE_DATA_LOCAL_TRACE: string = 'ChatList_MakeDataLocal_HiTrace';
const MAKE_DATA_LOCAL_TRACE_ID: number = 1; // makeDataLocal 中使用的 taskId
const MAKE_DATA_LIST_TRACE: string = 'ChatList_MakeDataList_HiTrace';
const MAKE_DATA_LIST_TRACE_ID: number = 2; // makeDataList 中使用的 taskId
const MOCK_USER_NAMES: Array<string> = [
  '晨光', '远山', '木棉', '星河', '清风', '小满', '白露', '海盐', '沐风', '未央', '青禾', '知夏'
];
const MOCK_CHAT_MESSAGES: Array<string> = [
  '今天的进度我已经同步到群里了。',
  '中午一起去吃那家新开的店吗？',
  '资料我放在共享目录里了。',
  '下班前记得帮我看一下这个问题。',
  '刚刚的会议纪要我晚点发你。',
  '这个页面的交互我已经自测过一遍。',
  '周末要不要一起出去走走？',
  '这张图我重新导出了高清版本。',
  '别着急，我们一点点排查。',
  '收到，稍后给你反馈结果。',
  '辛苦了，今天先到这里吧。',
  '明早我再跟你确认最终方案。'
];
const MOCK_MOMENT_TEXTS: Array<string> = [
  '今天的天空很好看，随手记录一下。',
  '新的咖啡店味道不错，推荐给大家。',
  '散步路上拍到一片很舒服的树影。',
  '把最近喜欢的照片整理成了一个小合集。',
  '天气转凉了，大家记得多穿一点。',
  '周末去看展，色彩搭配很有灵感。',
  '忙里偷闲的一顿晚餐，治愈。',
  '换了新的桌面布置，工作心情都变好了。'
];

/**
 * 加载聊天列表数据，到参数传入的懒加载数据列表中
 * @param listData 懒加载数据列表
 */
export async function makeDataLocal(listData: ChatListData): Promise<void> {
  Logger.info(TAG, 'makeDataLocal');
  hiTraceMeter.startTrace(MAKE_DATA_LOCAL_TRACE, MAKE_DATA_LOCAL_TRACE_ID);
  let chatModelMockData = await getChatModelObjFromJSON();
  for (let i = 0; i < Constants.DATA_MOCK_COUNT; i++) {
    listData.pushData(chatModelMockData[i]);
  }
  hiTraceMeter.finishTrace(MAKE_DATA_LOCAL_TRACE, MAKE_DATA_LOCAL_TRACE_ID);
}

/**
 * 加载聊天列表数据，到参数传入的数据列表中
 * @param listData 普通数据列表
 */
export async function makeDataList(listData: Array<ChatModel>): Promise<void> {
  Logger.info(TAG, 'makeDataList');
  hiTraceMeter.startTrace(MAKE_DATA_LIST_TRACE, MAKE_DATA_LIST_TRACE_ID);
  let chatModelMockData = await getChatModelObjFromJSON();
  for (let i = 0; i < Constants.DATA_MOCK_COUNT; i++) {
    listData.push(chatModelMockData[i]);
  }
  hiTraceMeter.finishTrace(MAKE_DATA_LIST_TRACE, MAKE_DATA_LIST_TRACE_ID);
}

/**
 * 获取ChatModel的模拟数据列表
 */
export async function getChatModelObjFromJSON(): Promise<Array<ChatModel>> {
  Logger.info(TAG, 'getChatModelObjFromJSON');
  return buildMockChatModels(Constants.DATA_MOCK_COUNT);
}

/**
 * 获取FriendMoment的模拟数据列表
 */
export async function getFriendMomentObjFromJSON(): Promise<Array<FriendMoment>> {
  Logger.info(TAG, 'getFriendMomentObjFromJSON');
  return buildMockFriendMoments(Constants.FRIEND_MOMENT_MOCK_DATA_COUNT);
}

/**
 * 获取聊天内容模拟数据
 */
export async function getMessageListFromJSON(): Promise<string[]> {
  Logger.info(TAG, 'getMessageListFromJSON');
  return buildMockMessageList(Constants.MOCK_ELEMENT_COUNT);
}

function buildMockChatModels(count: number): Array<ChatModel> {
  let chatModels: Array<ChatModel> = new Array<ChatModel>();
  for (let i = 0; i < count; i++) {
    let userName: string = MOCK_USER_NAMES[i % MOCK_USER_NAMES.length] + (i + 1).toString();
    let contact: ChatContact = new ChatContact(i.toString(), userName, getPhotoPath(i));
    let lastMsg: string = MOCK_CHAT_MESSAGES[i % MOCK_CHAT_MESSAGES.length];
    chatModels.push(new ChatModel(contact, lastMsg, getTimeLabel(i), i % 4));
  }
  return chatModels;
}

function buildMockFriendMoments(count: number): Array<FriendMoment> {
  let friendMoments: Array<FriendMoment> = new Array<FriendMoment>();
  for (let i = 0; i < count; i++) {
    let userName: string = MOCK_USER_NAMES[i % MOCK_USER_NAMES.length] + (i + 1).toString();
    let contact: ChatContact = new ChatContact(i.toString(), userName, getPhotoPath(i + 12));
    let text: string = MOCK_MOMENT_TEXTS[i % MOCK_MOMENT_TEXTS.length];
    friendMoments.push(new FriendMoment(i.toString(), contact, text, '', buildMomentImageList(i)));
  }
  return friendMoments;
}

function buildMockMessageList(count: number): Array<string> {
  let messages: Array<string> = new Array<string>();
  for (let i = 0; i < count; i++) {
    messages.push(MOCK_CHAT_MESSAGES[i % MOCK_CHAT_MESSAGES.length]);
  }
  return messages;
}

function buildMomentImageList(seed: number): Array<string> {
  let imageList: Array<string> = new Array<string>();
  let imageCount: number = seed % 9 + 1;
  for (let i = 0; i < imageCount; i++) {
    imageList.push(getPhotoPath(seed + i));
  }
  return imageList;
}

function getPhotoPath(index: number): string {
  let photoIndex: number = index % Constants.MOCK_ELEMENT_COUNT;
  return '/resources/images/photo' + photoIndex.toString() + '.jpg';
}

function getTimeLabel(index: number): string {
  let hour: number = 23 - index % 24;
  let minute: number = (59 - index * 7 % 60 + 60) % 60;
  return padNumber(hour) + ':' + padNumber(minute);
}

function padNumber(value: number): string {
  if (value < 10) {
    return '0' + value.toString();
  }
  return value.toString();
}
