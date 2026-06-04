/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { CommentDataModel, LiveInfoDataModel } from '../model/LiveDataModel'

function createCommentData(name: string | Resource, comment: string | Resource): CommentDataModel {
  return {
    name: name,
    comment: comment
  }
}

function createLiveInfoData(uri: string | Resource, name: string | Resource, peopleNum: string | Resource,
  commentList: CommentDataModel[]): LiveInfoDataModel {
  return {
    uri: uri,
    name: name,
    peopleNum: peopleNum,
    commentList: commentList
  }
}

export const LiveData: Array<LiveInfoDataModel> = [
  createLiveInfoData($rawfile('video_1.mp4'), $r("app.string.first_author"), '520', [
    createCommentData($r("app.string.first_one_name"), $r("app.string.first_one_comment")),
    createCommentData($r("app.string.first_two_name"), $r("app.string.first_two_comment")),
    createCommentData($r("app.string.first_three_name"), $r("app.string.first_three_comment")),
    createCommentData($r("app.string.first_four_name"), $r("app.string.first_four_comment")),
    createCommentData($r("app.string.first_five_name"), $r("app.string.first_five_comment"))
  ]),
  createLiveInfoData($rawfile('video_2.mp4'), $r("app.string.two_author"), '360', [
    createCommentData($r("app.string.first_one_name"), $r("app.string.first_one_comment")),
    createCommentData($r("app.string.first_two_name"), $r("app.string.first_two_comment")),
    createCommentData($r("app.string.first_three_name"), $r("app.string.first_three_comment")),
    createCommentData($r("app.string.first_four_name"), $r("app.string.first_four_comment")),
    createCommentData($r("app.string.first_five_name"), $r("app.string.first_five_comment"))
  ]),
  createLiveInfoData($rawfile('video_3.mp4'), $r("app.string.three_author"), '777', [
    createCommentData($r("app.string.first_one_name"), $r("app.string.first_one_comment")),
    createCommentData($r("app.string.first_two_name"), $r("app.string.first_two_comment")),
    createCommentData($r("app.string.first_three_name"), $r("app.string.first_three_comment")),
    createCommentData($r("app.string.first_four_name"), $r("app.string.first_four_comment")),
    createCommentData($r("app.string.first_five_name"), $r("app.string.first_five_comment"))
  ])
]
