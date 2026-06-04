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

import logger from '../../utils/Logger';

@Entry
@Component
struct SetTouchableAreas {
  // API 20 不再提供窗口级 setTouchableAreas，这里保留页面内 1/4 区域可点、2/3 区域不可点的演示行为。
  private readonly touchableAreas: string[] = ['area1', 'area4'];

  private isTouchableArea(areaId: string): boolean {
    return this.touchableAreas.includes(areaId);
  }

  private getAreaLabel(areaId: string): string {
    switch (areaId) {
      case 'area1':
        return 'area1';
      case 'area2':
        return 'area2';
      case 'area3':
        return 'area3';
      case 'area4':
        return 'area4';
      default:
        return areaId;
    }
  }

  private onButtonClick(msg: string) {
    try {
      this.getUIContext().getPromptAction().showToast({
        message: `click ${msg}`,
        duration: 2000,
        bottom: 100
      });
    } catch (e) {
      logger.error(`show toast error, caused by: ${JSON.stringify(e)}`);
    }
  }

  private onAreaClick(areaId: string) {
    if (!this.isTouchableArea(areaId)) {
      return;
    }
    try {
      this.onButtonClick(this.getAreaLabel(areaId));
    } catch (e) {
      logger.error(`show toast error, caused by: ${JSON.stringify(e)}`);
    }
  }

  build() {
    Column() {
      Text($r("app.string.area1"))
        .width('100%')
        .height('25%')
        .backgroundColor($r("app.color.light_gray"))
        .textAlign(TextAlign.Center)
        .id('area1')
        .onClick(() => this.onAreaClick('area1'))
      Text($r("app.string.area2"))
        .width('100%')
        .height('25%')
        .backgroundColor($r("app.color.blue"))
        .textAlign(TextAlign.Center)
        .id('area2')
        .onClick(() => this.onAreaClick('area2'))
      Text($r("app.string.area3"))
        .width('100%')
        .height('25%')
        .backgroundColor($r("app.color.red"))
        .textAlign(TextAlign.Center)
        .id('area3')
        .onClick(() => this.onAreaClick('area3'))
      Text($r("app.string.area4"))
        .width('100%')
        .height('25%')
        .backgroundColor($r("app.color.green"))
        .textAlign(TextAlign.Center)
        .id('area4')
        .onClick(() => this.onAreaClick('area4'))
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.light_gray'))
  }
}
