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
import { BusinessError } from '@ohos.base'
import AbilityConstant from '@ohos.app.ability.AbilityConstant'
import UIAbility from '@ohos.app.ability.UIAbility'
import Want from '@ohos.app.ability.Want'
import Window from '@ohos.window'
import Logger from '../model/Logger'

const TAG: string = 'MainAbility'

export default class MainAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    AppStorage.setOrCreate('UIAbilityContext', this.context)
    const isRemote: string | undefined = want.parameters?.['isRemote'] as string | undefined
    if (isRemote) {
      AppStorage.setOrCreate('isRemote', isRemote)
    }
    Logger.info(TAG, `MainAbility onCreate`)
  }

  onDestroy(): void {
    Logger.info(TAG, `MainAbility onDestroy`)
  }

  onWindowStageCreate(windowStage: Window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info(TAG, `MainAbility onWindowStageCreate`)
    windowStage.loadContent('pages/Index')
      .then((): void => {
        Logger.info(TAG, 'Succeeded in loading the content.')
      })
      .catch((err: BusinessError): void => {
        Logger.info(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`)
      })
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, `MainAbility onWindowStageDestroy`)
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info(TAG, `MainAbility onForeground`)
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info(TAG, `MainAbility onBackground`)
  }
}
