/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import common from '@ohos.app.ability.common';
import window from '@ohos.window';
import { WindowManger } from '@ohos/window-component';
import logger from '../utils/Logger';

interface CreateWindowEventData {
  context: common.UIAbilityContext | null;
  launchWant: Want | null;
  subWindow: window.WindowStage | null;
}

export default class MainAbility extends UIAbility {
  private TAG: string = 'WindowManger';
  private subWindow: window.WindowStage | null = null;

  onCreate(want: Want) {
    const that = this;
    try {
      this.context.eventHub.on('createWindow', (data: CreateWindowEventData) => {
        data.context = that.context;
        data.launchWant = want;
        data.subWindow = that.subWindow;
      });
    } catch (err) {
      logger.error(`${this.TAG} eventHub.on failed: ${JSON.stringify(err)}`);
    }
  }

  onDestroy() {
    logger.info(`${this.TAG} MainAbility onDestroy`);
  }

  async onWindowStageCreate(windowStage: window.WindowStage) {
    this.subWindow = windowStage;
    WindowManger.initMainWindow(windowStage);
    try {
      await windowStage.loadContent('pages/Index');
    } catch (err) {
      logger.error(`${this.TAG} loadContent failed: ${JSON.stringify(err)}`);
    }
  }

  onWindowStageDestroy() {
    logger.info(`${this.TAG} MainAbility onWindowStageDestroy`);
  }

  onForeground() {
    logger.info(`${this.TAG} MainAbility onForeground`);
  }

  onBackground() {
    logger.info(`${this.TAG} MainAbility onBackground`);
  }
}
