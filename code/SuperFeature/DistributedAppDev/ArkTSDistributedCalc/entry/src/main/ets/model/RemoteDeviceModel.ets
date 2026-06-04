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
import { Callback } from '@ohos.base'

export interface DistributedDeviceInfo {
  deviceId: string
  deviceName: string
  deviceType: string
  networkId?: string
}

interface DeviceData {
  device: DistributedDeviceInfo
}

interface ExtraInfo {
  bindType: number
  targetPkgName: string
  appName: string
}

interface DeviceStateChangeEvent {
  action: number
  device: DistributedDeviceInfo
}

interface DeviceManagerInstance {
  getAvailableDeviceListSync(): Array<DistributedDeviceInfo>
  on(type: 'deviceStateChange', callback: (data: DeviceStateChangeEvent | null) => void): void
  on(type: 'discoverSuccess', callback: (data: DeviceData | null) => void): void
  on(type: 'discoverFailure', callback: (data: object | null) => void): void
  on(type: 'serviceDie', callback: () => void): void
  startDiscovering(discoverParam: Record<string, number>, filterOptions: Record<string, number>): void
  stopDiscovering(): void
  off(type: 'deviceStateChange' | 'discoverSuccess' | 'discoverFailure' | 'serviceDie'): void
  bindTarget(deviceId: string, extraInfo: ExtraInfo, callback: (err: object | null, data: object | null) => void): void
}

interface DeviceManagerModule {
  DeviceStateChange: Record<'AVAILABLE' | 'UNKNOWN' | 'UNAVAILABLE', number>
  createDeviceManager(bundleName: string): DeviceManagerInstance
}

interface ErrorInfo {
  code?: number
  message?: string
}

declare function requireNapi(moduleName: string): object

const TAG: string = 'RemoteDeviceModel'
let SUBSCRIBE_ID: number = 100

export const BUNDLE_NAME: string = 'ohos.samples.distributedcalc'

export class RemoteDeviceModel {
  public deviceList: Array<DistributedDeviceInfo> | null = []
  public discoverList: Array<DistributedDeviceInfo> = []
  private callback: () => void = () => {
  }
  private authCallback: () => void = () => {
  }
  private deviceManager: DeviceManagerInstance | undefined = undefined
  private deviceManagerModule: DeviceManagerModule | undefined = undefined

  private getErrorMessage(error: object): string {
    const errorInfo: ErrorInfo = error as ErrorInfo
    return `code:${JSON.stringify(errorInfo.code)} message:${errorInfo.message}`
  }

  private getDeviceManagerModule(): DeviceManagerModule | undefined {
    if (this.deviceManagerModule !== undefined) {
      return this.deviceManagerModule
    }
    if (typeof requireNapi === 'undefined') {
      Logger.error(TAG, 'requireNapi is unavailable, distributed device manager is not supported')
      return undefined
    }
    try {
      this.deviceManagerModule = requireNapi('distributedDeviceManager') as DeviceManagerModule
      return this.deviceManagerModule
    } catch (error) {
      Logger.error(TAG, `load distributedDeviceManager failed: ${this.getErrorMessage(error as object)}`)
      return undefined
    }
  }

  registerDeviceListCallback(callback: Callback<void>) {
    Logger.info(TAG, `deviceManager type =${typeof (this.deviceManager)} ,${JSON.stringify(this.deviceManager)} ,${JSON.stringify(this.deviceManager) === '{}'}`)
    if (typeof (this.deviceManager) !== 'undefined') {
      this.registerDeviceListCallbackImplement(callback)
      return
    }
    Logger.info(TAG, 'deviceManager.createDeviceManager begin')
    const deviceManagerModule: DeviceManagerModule | undefined = this.getDeviceManagerModule()
    if (deviceManagerModule === undefined) {
      this.registerDeviceListCallbackImplement(callback)
      Logger.info(TAG, 'deviceManager.createDeviceManager skipped because module is unavailable')
      return
    }
    try {
      let dmInstance = deviceManagerModule.createDeviceManager(BUNDLE_NAME);
      this.deviceManager = dmInstance
      this.registerDeviceListCallbackImplement(callback)
      Logger.info(TAG, `createDeviceManager callback returned, value= ${JSON.stringify(this.deviceManager)}`)
    } catch (error) {
      Logger.error(TAG, `createDeviceManager throw ${this.getErrorMessage(error as object)}`)
      this.registerDeviceListCallbackImplement(callback)
    }
    Logger.info(TAG, 'deviceManager.createDeviceManager end')
  }

  changeStateOnline(device: DistributedDeviceInfo) {
    if (this.deviceList !== null) {
      this.deviceList![this.deviceList!.length] = device;
    }
    Logger.debug(TAG, `online, device list= ${JSON.stringify(this.deviceList)}`);
    this.callback();
    if (this.authCallback !== null) {
      this.authCallback();
      this.authCallback = () => {
      }
    }
  }

  changeStateOffline(device: DistributedDeviceInfo) {
    if (this.deviceList !== null && this.deviceList!.length > 0) {
      let list: Array<DistributedDeviceInfo> = [];
      for (let j = 0; j < this.deviceList!.length; j++) {
        if (this.deviceList![j].deviceId !== device.deviceId) {
          list[j] = device;
        }
      }
      this.deviceList = list;
    }
    Logger.info(TAG, `offline, updated device list=${JSON.stringify(device)}`);
    this.callback();
  }

  changeState(device: DistributedDeviceInfo, state: number) {
    const availableState: number | undefined = this.deviceManagerModule?.DeviceStateChange.AVAILABLE
    if (this.deviceList !== null && this.deviceList!.length <= 0) {
      this.callback();
      return;
    }
    if (this.deviceList !== null && availableState !== undefined && state === availableState) {
      let list: Array<DistributedDeviceInfo> = new Array();
      for (let i = 0; i < this.deviceList!.length; i++) {
        if (this.deviceList![i].deviceId !== device.deviceId) {
          list[i] = device;
        }
      }
      this.deviceList = list;
      Logger.debug(TAG, `ready, device list= ${JSON.stringify(device)}`);
      this.callback();
    } else {
      if (this.deviceList !== null) {
        for (let j = 0; j < this.deviceList!.length; j++) {
          if (this.deviceList![j].deviceId === device.deviceId) {
            this.deviceList![j] = device;
            break;
          }
        }
        Logger.debug(TAG, `offline, device list= ${JSON.stringify(this.deviceList)}`);
        this.callback();
      }
    }
  }

  registerDeviceListCallbackImplement(callback: Callback<void>) {
    Logger.info(TAG, 'registerDeviceListCallback')
    this.callback = callback
    if (this.deviceManager === undefined) {
      Logger.error(TAG, 'deviceManager has not initialized')
      this.callback()
      return
    }
    Logger.info(TAG, 'getTrustedDeviceListSync begin')
    try {
      let list = this.deviceManager !== undefined ? this.deviceManager.getAvailableDeviceListSync() : null;
      Logger.debug(TAG, `getTrustedDeviceListSync end, deviceList= ${JSON.stringify(list)}`);
      if (typeof (list) !== 'undefined' && JSON.stringify(list) !== '[]') {
        this.deviceList = list!;
      }
      Logger.info(TAG, `getTrustedDeviceListSync end, deviceList=${JSON.stringify(list)}`);
    } catch (error) {
      Logger.error(TAG, `getTrustedDeviceListSync throw ${this.getErrorMessage(error as object)}`);
    }
    this.callback();
    Logger.info(TAG, 'callback finished');
    try {
      const deviceStateChange: Record<'AVAILABLE' | 'UNKNOWN' | 'UNAVAILABLE', number> | undefined =
        this.deviceManagerModule?.DeviceStateChange
      if (this.deviceManager !== undefined && deviceStateChange !== undefined) {
        this.deviceManager.on('deviceStateChange', (data: DeviceStateChangeEvent | null) => {
          if (data === null) {
            return
          }
          Logger.debug(TAG, `deviceStateChange data= ${JSON.stringify(data)}`)
          switch (data.action) {
            case deviceStateChange.AVAILABLE:
              this.changeState(data.device, deviceStateChange.AVAILABLE)
              break
            case deviceStateChange.UNKNOWN:
              this.changeStateOnline(data.device)
              break
            case deviceStateChange.UNAVAILABLE:
              this.changeStateOffline(data.device)
              break
            default:
              break
          }
        })
      }
      if (this.deviceManager !== undefined) {
        this.deviceManager.on('discoverSuccess', (data: DeviceData | null) => {
          if (data === null) {
            return
          }
          this.discoverList = []
          Logger.info(TAG, `discoverSuccess data=${JSON.stringify(data)}`)
          this.deviceFound(data.device)
        })
        this.deviceManager.on('discoverFailure', (data) => {
          Logger.info(TAG, `discoverFailure data= ${JSON.stringify(data)}`)
        })
        this.deviceManager.on('serviceDie', () => {
          Logger.error(TAG, 'serviceDie')
        })
      }
    } catch (error) {
      Logger.error(TAG, `on throw ${this.getErrorMessage(error as object)}`)
    }
    this.startDeviceDiscovery()
  }

  deviceFound(data: DistributedDeviceInfo) {
    for (let i = 0;i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId === data.deviceId) {
        Logger.info(TAG, 'device founded ignored')
        return
      }
    }
    this.discoverList[this.discoverList.length] = data
    Logger.debug(TAG, `deviceFound self.discoverList= ${this.discoverList}`)
    this.callback()
  }

  /**
   * 通过SUBSCRIBE_ID搜索分布式组网内的设备
   */
  startDeviceDiscovery() {
    let discoverParam: Record<string, number> = {
      'discoverTargetType': 1
    };

    let filterOptions: Record<string, number> = {
      'availableStatus': 0,
    };

    Logger.info(TAG, `startDeviceDiscovery${SUBSCRIBE_ID}`);
    try {
      if (this.deviceManager !== undefined) {
        this.deviceManager.startDiscovering(discoverParam, filterOptions)
      }
    } catch (error) {
      Logger.error(TAG, `startDeviceDiscovery throw ${this.getErrorMessage(error as object)}`)
    }
  }

  unregisterDeviceListCallback() {
    Logger.debug(TAG, `stopDeviceDiscovery ${SUBSCRIBE_ID}`)
    if (this.deviceManager === undefined) {
      return
    }
    if (this.deviceManager !== undefined) {
      try {
        Logger.info(TAG, `stopDiscovering`)
        this.deviceManager.stopDiscovering();
      } catch (error) {
        Logger.error(TAG, `stopDeviceDiscovery throw ${this.getErrorMessage(error as object)}`)
      }
      try {
        this.deviceManager.off('deviceStateChange')
        this.deviceManager.off('discoverSuccess')
        this.deviceManager.off('discoverFailure')
        this.deviceManager.off('serviceDie')
      } catch (error) {
        Logger.error(TAG, `off throw ${this.getErrorMessage(error as object)}`)
      }
    }
    this.deviceList = []
    this.discoverList = []
  }

  authenticateDevice(device: DistributedDeviceInfo, callBack: Callback<void>) {
    Logger.info(TAG, `authenticateDevice ${JSON.stringify(device)}`)
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId !== device.deviceId) {
        continue
      }
      if (this.deviceManager === undefined) {
        return
      }
      try {
        if (this.deviceManager !== undefined) {
          this.deviceManager.bindTarget(device.deviceId, {
            bindType: 1,
            targetPkgName: BUNDLE_NAME,
            appName: 'Distributed distributecalc',
          }, (err: object | null, data: object | null) => {
            if (err) {
              Logger.error(TAG, `authenticateDevice error: ${JSON.stringify(err)}`)
              this.authCallback = () => {
              }
              return
            }
            Logger.debug(TAG, `authenticateDevice succeed: ${JSON.stringify(data)}`)
            this.authCallback = callBack
          })
        }
      } catch (error) {
        Logger.error(TAG, `authenticateDevice throw throw ${this.getErrorMessage(error as object)}`)
      }
    }
  }
}
