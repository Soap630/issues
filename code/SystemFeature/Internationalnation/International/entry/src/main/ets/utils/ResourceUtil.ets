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
import common from '@ohos.app.ability.common';
import AbilityContextHolder from './AbilityContextHolder';

class ResourceUtil {
  private getResourceManager() {
    let context = AbilityContextHolder.getContext() as common.UIAbilityContext | undefined;
    if (!context) {
      throw new Error('UIAbilityContext is not ready');
    }
    return context.resourceManager;
  }

  getString(id: number): string {
    return this.getResourceManager().getStringSync(id);
  }

  async getStringArray(id: number): Promise<Array<string>> {
    try {
      return await this.getResourceManager().getStringArrayValue(id);
    } catch (err) {
      return [];
    }
  }

  async getPluralString(id: number, num: number): Promise<string> {
    try {
      return await this.getResourceManager().getPluralStringValue(id, num);
    } catch (err) {
      return '';
    }
  }

  async getDirection(): Promise<string> {
    try {
      let configuration = await this.getResourceManager().getConfiguration();
      if (configuration.direction === 1) {
        return 'Horizontal';
      }
    } catch (err) {
    }
    return 'Vertical';
  }
}

export default new ResourceUtil()
