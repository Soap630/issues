/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import window from '@ohos.window';
import emitter from '@ohos.events.emitter';
import display from '@ohos.display';
import Logger from '../util/Logger';
import { WindowColor, WindowEventId, WindowType } from '../util/WindowConst';

const windowPoint = {
  x: 50, // 窗口移动的起始坐标X
  y: 250, // 窗口移动的起始坐标Y
};
const WIDTH = 320;
const HEIGHT = 240;
const MOVE_X = 10;
let MOVE_Y = 500;
const WINDOW_EVENT_TEXT: Record<string, string> = {
  '1': 'foreground',
  '2': 'get_focus',
  '3': 'lose_focus',
  '4': 'background'
};

class WindowManger {
  private tag: string = 'WindowManger';
  private startX: number = 0; // 窗口移动的起始坐标X
  private startY: number = 0; // 窗口移动的起始坐标Y
  private endX: number = MOVE_X; // 窗口移动的结束坐标X
  private endY: number = MOVE_Y; // 窗口移动的结束坐标Y
  private distanceX: number = 0; // 窗口在X轴上移动距离
  private distanceY: number = 0; // 窗口在Y轴上移动距离
  private windowWidth: number = 0; // 当前窗口宽度
  private windowHeight: number = 0; // 当前窗口高度
  private densityPixels: number = 1;

  private vpToPx(value: number): number {
    return Math.round(value * this.densityPixels);
  }

  initMainWindow(windowStage: window.WindowStage) {
    windowStage.getMainWindow((err, data) => {
      if (err.code) {
        Logger.error(this.tag, 'Failed to obtain the main window. Cause: ' + JSON.stringify(err));
        return;
      }
      ;
      let mainWindow = data;
      // 窗口规避区域
      mainWindow.on('avoidAreaChange', ({type, area}) => {
        if (type === window.AvoidAreaType.TYPE_SYSTEM) {
          AppStorage.setOrCreate<number>('topHeight', area.topRect.height);
          AppStorage.setOrCreate<number>('topWidth', area.topRect.width);
        }
      });
      mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      // 设置主窗口沉浸式
      mainWindow.setWindowLayoutFullScreen(true);
      // 设置主窗口导航栏、状态栏、文字颜色等属性
      const sysBarProps: window.SystemBarProperties = {
        statusBarColor: WindowColor.statusBarColor,
        navigationBarColor: WindowColor.navigationBarColor,
        statusBarContentColor: WindowColor.statusBarContentColor,
        navigationBarContentColor: WindowColor.navigationBarContentColor
      };
      // 加载状态变量
      mainWindow.setWindowSystemBarProperties(sysBarProps);
    });

    try {
      const displayClass = display.getDefaultDisplaySync();
      this.windowWidth = displayClass.width;
      this.windowHeight = displayClass.height;
      this.densityPixels = displayClass.densityPixels;
      MOVE_Y = this.windowHeight / 2;
      this.endY = MOVE_Y;
    } catch (err) {
      Logger.error(this.tag, 'Failed to obtain the default display object. Code: ' + JSON.stringify(err));
    }
    ;
  }

  async initSubWindow(windowStage: window.WindowStage | null, _windowAttribute: WindowType) {
    if (!windowStage) {
      Logger.warn(this.tag, 'Window stage is not ready.');
      return;
    }
    let subWindow: window.Window;
    try {
      subWindow = await windowStage.createSubWindow('mySubWindow');
      subWindow.on('avoidAreaChange', ({type, area}) => {
        if (type === window.AvoidAreaType.TYPE_SYSTEM) {
          AppStorage.setOrCreate<number>('topHeight', area.topRect.height);
          AppStorage.setOrCreate<number>('bottomHeight', area.bottomRect.height);
        }
      });
    } catch (err) {
      Logger.error(this.tag, 'Failed to create sub window. Cause: ' + JSON.stringify(err));
      return;
    }
    try {
      subWindow.setWindowFocusable(true, (err) => {
        if (err.code) {
          console.error('Failed to set the window to be focusable. Cause:' + JSON.stringify(err));
          return;
        }
        console.info('Succeeded in setting the window to be focusable.');
      });
      subWindow.on('windowEvent', (data) => {
        console.info('Sub Window event happened. Event:' + JSON.stringify(data));
        const message = WINDOW_EVENT_TEXT[String(data)] ?? 'unknown';
        AppStorage.setOrCreate('focusText', message);
      });
    } catch (exception) {
      console.error('Failed to register callback. Cause: ' + JSON.stringify(exception));
    }
    ;

    try {
      windowStage.on('windowStageEvent', (data) => {
        console.info('Succeeded in enabling the listener for window stage event changes. Data: ' +
        JSON.stringify(data));
      });
    } catch (exception) {
      console.error('Failed to enable the listener for window stage event changes. Cause:' +
      JSON.stringify(exception));
    }
    ;

    try {
      Logger.info(this.tag, 'show');
      await subWindow.resize(this.vpToPx(WIDTH), this.vpToPx(HEIGHT));
      await subWindow.moveWindowTo(MOVE_X, MOVE_Y); // 移动至坐标x为10，y为500的位置
      await subWindow.setUIContent('pages/SubWindowPage');
      await subWindow.setWindowTouchable(true);
      await subWindow.showWindow();
    } catch (err) {
      Logger.error(this.tag, 'Failed to show sub window. Cause: ' + JSON.stringify(err));
      return;
    }

    // onTouch的坐标绑定
    let innerEvent = {
      eventId: WindowEventId.SUB_WINDOW_INNER_EVENT_ID
    };
    let callback = (eventData) => {
      Logger.info(this.tag, 'onTouchEventData' + eventData.data.x);
      if (!this.startX || !this.startY || eventData.data.type === 0) {
        this.startX = eventData.data.x;
        this.startY = eventData.data.y;
        return;
      }
      ;
      this.distanceX = eventData.data.x - this.startX;
      this.distanceY = eventData.data.y - this.startY;
      this.endX += this.vpToPx(this.distanceX);
      this.endY += this.vpToPx(this.distanceY);
      this.startX = eventData.data.x;
      this.startY = eventData.data.y;
      const topHeight = Number(AppStorage.get('topHeight') ?? 0);
      if (this.endX > 0 && this.endX < this.windowWidth - this.vpToPx(WIDTH) && this.endY > topHeight
        && this.endY < this.windowHeight - this.vpToPx(HEIGHT)) {
        subWindow.moveWindowTo(this.endX, this.endY);
      }
      ;
    };
    emitter.on(innerEvent, callback);
  }

  async setSubWindowAttribute(windowStage: window.WindowStage, windowAttribute: WindowType) {
    try {
      let subWindow: window.Window = await windowStage.getMainWindow();
      await subWindow.moveWindowTo(windowAttribute.moveToWidth, windowAttribute.moveToHeight);
      await subWindow.setWindowTouchable(windowAttribute.setTouchable);
      await subWindow.resize(windowAttribute.resetSizeWidth, windowAttribute.resetSizeHeight);
      await subWindow.setWindowBrightness(windowAttribute.setBrightness);
    } catch (err) {
      Logger.error(this.tag, 'Failed to update sub window attribute. Cause: ' + JSON.stringify(err));
    }
  }

  changeWindowDirection(windowStage: window.WindowStage | null, orientation: window.Orientation) {
    if (!windowStage) {
      Logger.warn(this.tag, 'Window stage is not ready.');
      return;
    }
    windowStage.getMainWindow((err, data) => {
      if (err.code) {
        Logger.error(this.tag, 'Failed to change the window: ' + JSON.stringify(err));
        return;
      }
      data.setPreferredOrientation(orientation);
    });
  }

  destorySubWindowCallback() {
    this.startX = 0;
    this.startY = 0;
    this.endX = MOVE_X;
    this.endY = MOVE_Y;
    this.distanceX = 0;
    this.distanceY = 0;
  }
}

const windowManger = new WindowManger();

export { windowManger as WindowManger };
export default windowManger;
