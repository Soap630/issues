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

@Component
export struct FormComponentDrag {
  @State visible: boolean = true

  // SDK 20 no longer exposes FormComponent in ArkUI declarations, so keep the
  // drag sample runnable with a card-like placeholder.
  @Builder previewBuilder() {
    this.cardBuilder('#4D0A59F7')
  }

  @Builder cardBuilder(backgroundColor: ResourceColor = '#0A59F7') {
    Row({ space: 12 }) {
      Image($r('app.media.icon'))
        .size({ width: 28, height: 28 })
        .borderRadius(14)

      Column({ space: 2 }) {
        Text($r('app.string.formcomponent'))
          .fontSize(14)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
        Text('Drag demo')
          .fontSize(10)
          .fontColor('#DDEBFF')
      }
      .alignItems(HorizontalAlign.Start)
    }
    .padding({ left: 16, right: 16 })
    .size({ width: 160, height: 52 })
    .borderRadius(24)
    .backgroundColor(backgroundColor)
  }

  build() {
    Row() {
      this.cardBuilder()
    }
      .id('formComponent')
      .visibility(this.visible ? Visibility.Visible : Visibility.Hidden)
      .onDragStart(() => {
        this.visible = false
        return this.previewBuilder
      })
      .onDragEnd(() => {
        this.visible = true
      })
  }
}
