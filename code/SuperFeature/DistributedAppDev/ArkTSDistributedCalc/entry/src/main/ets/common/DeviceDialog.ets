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
import Logger from '../model/Logger'
import { DistributedDeviceInfo } from '../model/RemoteDeviceModel'

const TAG: string = 'DeviceDialog'

@CustomDialog
export struct DeviceDialog {
  controller?: CustomDialogController
  @StorageLink('deviceList') deviceList: Array<DistributedDeviceInfo> = AppStorage.get('deviceList')!
  selectedIndex: number | undefined = 0
  onSelectedIndexChange: (selectedIndex: number | undefined) => void = (): void => {}

  build() {
    Column() {
      Text($r('app.string.choiceDevice'))
        .fontSize(30)
        .width('100%')
        .height('20%')
        .fontColor(Color.Black)
        .textAlign(TextAlign.Start)
      List() {
        ForEach(this.deviceList, (item: DistributedDeviceInfo, index: number | undefined) => {
          ListItem() {
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
              Text(item.deviceName)
                .fontSize(30)
                .width('80%')
                .fontColor(Color.Black)
              Radio({ value: '', group: 'radioGroup' })
                .radioStyle({
                  checkedBackgroundColor: '#ff0d64fb'
                })
                .align(Alignment.Top)
                .width('3%')
                .checked(index === this.selectedIndex ? true : false)
            }
            .margin({ top: 17 })
            .onClick(() => {
              Logger.debug(TAG, `select device: ${item.deviceId}`)
              Logger.debug(TAG, `deviceList: ${JSON.stringify(this.deviceList)}`)
              if (this.selectedIndex !== undefined && index === this.selectedIndex) {
                Logger.info(TAG, `index:${JSON.stringify(index)} ty:${JSON.stringify(typeof (index))} this.selectedIndex:${JSON.stringify(this.selectedIndex)} ${JSON.stringify(typeof (this.selectedIndex))}`)
                return
              } else if (this.selectedIndex !== undefined) {
                this.selectedIndex = index
                this.onSelectedIndexChange(this.selectedIndex)
              }
            })
          }
          .width('100%')
          .height('40%')
        }, (item: DistributedDeviceInfo) => item.deviceId)
      }
      .height('60%')
      .width('100%')
      .layoutWeight(1)

      Button() {
        Text($r('app.string.cancel'))
          .width('90%')
          .fontSize(21)
          .fontColor('#ff0d64fb')
          .textAlign(TextAlign.Center)
      }
      .type(ButtonType.Capsule)
      .backgroundColor(Color.White)
      .onClick(() => {
        if (this.controller !== undefined) {
          this.controller.close()
        }
      })
    }
    .margin({ bottom: 15 })
    .width('80%')
    .height(240)
    .padding({ left: 18, right: 32 })
    .backgroundColor(Color.White)
    .border({ color: Color.White, radius: 20 })
  }
}
