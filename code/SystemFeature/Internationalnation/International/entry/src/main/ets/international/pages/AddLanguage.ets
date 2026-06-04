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
import i18n from '@ohos.i18n';
import Logger from '../../utils/Logger';
import OperationListView from '../../components/OperationListView';
import TitleBar from '../../components/TitleBar';
import { BaseData } from '../../utils/LazyDataSource';
import SystemApiCompat from '../../utils/SystemApiCompat';

const TAG: string = 'AddLanguage';

@Entry
@Component
struct AddLanguage {
  private languageIds: Array<string> = [];
  @State languages: Array<BaseData> = [];
  @State preferredLanguages: Array<BaseData> = [];

  aboutToAppear() {
    this.languages = [];
    this.preferredLanguages = [];
    let preferredLanguageIds = i18n.System.getPreferredLanguageList();
    let localeTag = SystemApiCompat.getCurrentLocaleTag();
    Logger.info(TAG, `preferredLanguageIds = ${JSON.stringify(preferredLanguageIds)}`);
    preferredLanguageIds.forEach(id => {
      this.preferredLanguages.push(
        { id: id,
          key: i18n.System.getDisplayLanguage(id, id),
          value: i18n.System.getDisplayLanguage(id, localeTag)
        }
      );
    });
    this.languageIds = i18n.System.getSystemLanguages();
    Logger.info(TAG, `this.languageIds = ${JSON.stringify(this.languageIds)}`);
    this.languageIds.forEach(id => {
      this.languages.push(
        {
          id: id,
          key: i18n.System.getDisplayLanguage(id, id),
          value: i18n.System.getDisplayLanguage(id, localeTag)
        }
      );
    });
  }

  addLanguage = (index: number) => {
    let language = this.languageIds[index];
    Logger.info(TAG, `addPreferredLanguage = ${language}`);
    try {
      SystemApiCompat.addPreferredLanguage(language);
    } catch (err) {
      Logger.error(`addPreferredLanguage failed, code is ${err.code}, message is ${err.message}`);
    }
    this.getUIContext().getRouter().back();
  }

  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.add_language') })
      Scroll() {
        Column() {
          OperationListView({
            title: $r('app.string.added_language'),
            operations: this.preferredLanguages,
            handleItemClick: () => {
            }
          })
          OperationListView({
            title: $r('app.string.all_language'),
            operations: this.languages,
            handleItemClick: this.addLanguage
          }).id('edit_lan_lv')
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.f5f5f5'))
  }
}
