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
import Logger from './Logger';
import SystemApiCompat from './SystemApiCompat';

const TAG: string = 'IntlUtil';

class IntlUtil {
  fillNum(num: number) {
    return num > 9 ? `${num}` : `0${num}`;
  }

  getDateString() {
    let is24Hours = i18n.System.is24HourClock();
    let date = new Date();
    let localeTag = SystemApiCompat.getCurrentLocaleTag();
    console.info(`[IntlUtil] getDateString localeTag: ${localeTag}`);
    let currentLanguage = SystemApiCompat.getCurrentLanguage();
    Logger.info(TAG, `language = ${currentLanguage}`);
    let dateFormatter = new Intl.DateTimeFormat(localeTag, {
      dateStyle: 'medium'
    });
    let timeFormatter = new Intl.DateTimeFormat(localeTag, {
      timeStyle: 'medium',
      hourCycle: is24Hours ? 'h24' : 'h12'
    });
    return [dateFormatter.format(date), timeFormatter.format(date)];
  }

  getTimeZoneString(timeZone: i18n.TimeZone) {
    let offset = timeZone.getRawOffset();
    return `GMT${offset > 0 ? '+' : '-'}${this.getTimeString(offset)}  ${timeZone.getDisplayName(SystemApiCompat.getCurrentLanguage())}`;
  }

  getTimeZoneShortString(timeZone: i18n.TimeZone) {
    let offset = timeZone.getRawOffset();
    return `GMT${offset > 0 ? '+' : '-'}${this.getTimeString(offset)}`;
  }

  getTimeString(duration: number): string {
    let time = duration;
    if (time < 0) {
      time = 0 - time;
    }
    let hour = Math.floor(time / (1000 * 60 * 60));
    let minute = Math.floor((time % (1000 * 60 * 60)) / (1000 * 60));
    if (hour > 0) {
      return `${this.fillNum(hour)}:${this.fillNum(minute)}`;
    }
    return '';
  }

  getNumberFormatString() {
    let localeTag = SystemApiCompat.getCurrentLocaleTag();
    console.info(`[IntlUtil] getNumberFormatString localeTag: ${localeTag}`);
    let numberFormat = new Intl.NumberFormat(localeTag, {
      useGrouping: true
    });
    let currencyFormat = new Intl.NumberFormat(localeTag, {
      currency: 'CNY',
      style: 'currency'
    });
    let percentFormat = new Intl.NumberFormat(localeTag, {
      style: 'percent',
      useGrouping: true
    });
    // 此处返回的只是一个示例，因此1234567，123456，78.9并不具有实际意义
    return [numberFormat.format(1234567), currencyFormat.format(123456), percentFormat.format(78.9)];
  }
}

export default new IntlUtil()
