/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import { window } from '@kit.ArkUI';
import common from '@ohos.app.ability.common';

@Entry
@Component
struct GetPropertiesOfSystemBar {
  @State colorText: string = '';

  onPageShow() {
    this.colorText = '';
  }

  build() {
    Column() {
      Text(this.colorText)
        .id("propertiesText")
        .width('80%')
        .height('50%')
        .margin('10vp')
        .fontSize(20)
      Button($r("app.string.GetPropertiesOfSystemBar"))
        .fontSize(20)
        .standardButton(15, '80%')
        .onClick(() => this.showPropertiesOfSystemBar());
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.light_gray'))
  }

  async showPropertiesOfSystemBar() {
    try {
      const hostContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
      const parentWindow: window.Window = await window.getLastWindow(hostContext);
      this.colorText = JSON.stringify(parentWindow.getWindowSystemBarProperties(), null, 4);
    } catch (err) {
      this.colorText = JSON.stringify(err);
    }
  }
}

@Extend(Button)
function standardButton(fontSize: number, width: Length) {
  .fontSize(fontSize)
  .fontColor($r('app.color.dark_gray'))
  .backgroundColor($r('app.color.white'))
  .padding(15)
  .margin({ top: 20 })
  .width(width)
}
