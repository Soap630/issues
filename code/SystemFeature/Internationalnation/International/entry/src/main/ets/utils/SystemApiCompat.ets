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
import systemDateTime from '@ohos.systemDateTime';
import systemTime from '@ohos.systemTime';
import AbilityContextHolder from './AbilityContextHolder';

class SystemApiCompat {
  private readonly regionStorageKey: string = 'preferredRegion';

  getTimezone(): Promise<string> {
    return systemDateTime.getTimezone();
  }

  setDate(date: Date): Promise<void> {
    return systemTime.setDate(date);
  }

  setTime(time: number): Promise<void> {
    return systemTime.setTime(time);
  }

  setTimezone(timezone: string): Promise<void> {
    return systemTime.setTimezone(timezone);
  }

  set24HourClock(option: boolean): boolean {
    return i18n.set24HourClock(option);
  }

  addPreferredLanguage(language: string, index?: number): boolean {
    return i18n.addPreferredLanguage(language, index);
  }

  removePreferredLanguage(index: number): boolean {
    return i18n.removePreferredLanguage(index);
  }

  getCurrentLanguage(): string {
    let appPreferredLanguage = i18n.System.getAppPreferredLanguage();
    if (appPreferredLanguage && appPreferredLanguage !== 'default') {
      return appPreferredLanguage;
    }
    return i18n.System.getSystemLanguage();
  }

  getCurrentRegion(): string {
    return AppStorage.get<string>(this.regionStorageKey) ?? i18n.System.getSystemRegion();
  }

  getCurrentLocaleTag(): string {
    let language = this.getCurrentLanguage();
    if (language.includes('-')) {
      return language;
    }

    let locale = i18n.System.getSystemLocaleInstance();
    let script = locale.script ? `-${locale.script}` : '';
    let region = this.getCurrentRegion();
    return `${language}${script}${region ? `-${region}` : ''}`;
  }

  setAppLanguage(language: string): void {
    AbilityContextHolder.getApplicationContext()?.setLanguage(language);
    i18n.System.setAppPreferredLanguage(language);
  }

  setRegion(region: string): void {
    AppStorage.setOrCreate(this.regionStorageKey, region);
  }
}

export default new SystemApiCompat();
