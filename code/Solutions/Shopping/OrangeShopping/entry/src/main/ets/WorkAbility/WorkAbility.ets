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

import WorkSchedulerExtensionAbility from '@ohos.WorkSchedulerExtensionAbility';
import { BusinessError } from '@ohos.base';
import { logger } from '@ohos/details-page-component';
import workScheduler from '@ohos.resourceschedule.workScheduler';
import notificationManager from '@ohos.notificationManager'
import { ParametersObject } from '../utils/TypeClass';

const TAG: string = 'WorkAbility';
const NOTIFICATION_ID: number = 1 // 定义发送通知的id,默认1

export default class WorkAbility extends WorkSchedulerExtensionAbility {
  onWorkStart(workInfo: workScheduler.WorkInfo): void {
    logger.info(TAG, `onWorkStart ${JSON.stringify(workInfo)}`);
    if (workInfo.parameters) {
      this.publishNotification(workInfo.parameters);
    }
  }

  onWorkStop(workInfo: workScheduler.WorkInfo): void {
    logger.info(TAG, `onWorkStop ${JSON.stringify(workInfo)}`);
    notificationManager.cancel(NOTIFICATION_ID).catch((error: BusinessError) => {
      logger.info(TAG, `cancel notification error ${JSON.stringify(error)}`);
    });
  }

  async publishNotification(parameters: Object): Promise<void> {
    let parametersObject: ParametersObject = JSON.parse(JSON.stringify(parameters));
    logger.info(TAG, `publishNotification parametersObject= ${parametersObject}`);
    let basicContent: notificationManager.NotificationBasicContent = {
      title: parametersObject.title,
      text: parametersObject.secondButton
    };
    let notificationContent: notificationManager.NotificationContent = {
      notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
      normal: basicContent
    };
    let notificationRequest: notificationManager.NotificationRequest = {
      id: NOTIFICATION_ID,
      content: notificationContent,
      notificationSlotType: notificationManager.SlotType.SERVICE_INFORMATION
    };
    try {
      await notificationManager.publish(notificationRequest);
    } catch (error) {
      const businessError: BusinessError = error as BusinessError;
      logger.info(TAG, `publish notification error ${JSON.stringify(businessError)}`);
    }
  }
}
