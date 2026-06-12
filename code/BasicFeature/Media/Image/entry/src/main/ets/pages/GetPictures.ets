/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import photoAccessHelper from '@ohos.file.photoAccessHelper';

const LENGTH: number = 9;

export default class GetPictures {
  async getImage(): Promise<void> {
    try {
      let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = LENGTH;

      let photoPicker = new photoAccessHelper.PhotoViewPicker();
      let photoSelectResult: photoAccessHelper.PhotoSelectResult = await photoPicker.select(photoSelectOptions);
      let select: Array<string> = photoSelectResult.photoUris;
      if (select.length > 0) {
        let imageList: Array<string> = (AppStorage.Get('imageList') as Array<string>) ?? [];
        AppStorage.SetOrCreate<Array<string>>('imageList', imageList.concat(select));
      }
    } catch (err) {
      console.error(`PhotoViewPicker.select failed, err: ${JSON.stringify(err)}`);
    }
  }
}
