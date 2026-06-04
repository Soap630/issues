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

  @Builder private dragPreviewBuilder() {
    Row({ space: 10 }) {
      Image($r('app.media.icon'))
        .width(28)
        .aspectRatio(1)
      Column({ space: 2 }) {
        Text($r('app.string.formcomponent'))
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
        Text('API 20')
          .fontSize(12)
          .fontColor($r('app.color.font_color_shallow'))
      }
      .alignItems(HorizontalAlign.Start)
    }
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor(Color.White)
    .borderRadius(24)
  }

  build() {
    Column() {
      Row({ space: 10 }) {
        Image($r('app.media.icon'))
          .width(28)
          .aspectRatio(1)
        Column({ space: 2 }) {
          Text($r('app.string.formcomponent'))
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
          Text('API 20')
            .fontSize(12)
            .fontColor($r('app.color.font_color_shallow'))
        }
        .alignItems(HorizontalAlign.Start)
      }
        .id('formComponent')
        .padding({ left: 16, right: 16, top: 12, bottom: 12 })
        .backgroundColor(Color.White)
        .borderRadius(24)
        .visibility(this.visible ? Visibility.Visible : Visibility.Hidden)
        .draggable(true)
        .onDragStart(() => {
          this.visible = false
          return this.dragPreviewBuilder
        })
        .onDragEnd(() => {
          this.visible = true
        })
    }
    .width(400)
    .height(80)
    .backgroundColor(0xF9CF93)
    .justifyContent(FlexAlign.Center)
  }
}
