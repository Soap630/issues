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

import Logger from '../model/Logger'
import { BusinessError } from '@ohos.base'
import sim from '@ohos.telephony.sim'
import radio from '@ohos.telephony.radio'

const TAG = '[RadioStatus]'

export class RadioStatus {
    constructor() {
    }

    private getErrorMessage(methodName: string, error: BusinessError): string {
        const errorMessage = `error:${JSON.stringify(error)}`
        Logger.error(`${TAG}, ${methodName} failed -> ${errorMessage}`)
        return errorMessage
    }

    async getSimSpn(slotId: number): Promise<string> {
        try {
            const simSpn = await sim.getSimSpn(slotId)
            Logger.info(`${TAG}, getSimSpn radioTech = ${simSpn}`)
            return simSpn.length > 0 ? simSpn : 'not available'
        } catch (error) {
            return this.getErrorMessage('getSimSpn', error as BusinessError)
        }
    }

    async getRadioTech(slotId: number): Promise<string> {
        try {
            const radioTech = await radio.getRadioTech(slotId)
            const radioTechText = JSON.stringify(radioTech)
            Logger.info(`${TAG}, getRadioTech radioTech = ${radioTechText}`)
            return radioTechText
        } catch (error) {
            return this.getErrorMessage('getRadioTech', error as BusinessError)
        }
    }

    async getSignalInformation(slotId: number): Promise<string> {
        try {
            const signalInformation = await radio.getSignalInformation(slotId)
            const signalInformationText = signalInformation.length === 0 ? 'not available' : JSON.stringify(signalInformation)
            Logger.info(`${TAG}, getSignalInformation signalInformation = ${signalInformationText}`)
            return signalInformationText
        } catch (error) {
            return this.getErrorMessage('getSignalInformation', error as BusinessError)
        }
    }

    async getNetworkSelectionMode(slotId: number): Promise<string> {
        Logger.info(`${TAG}, getNetworkSelectionMode networkSelectionMode start`)
        try {
            const networkSelectionMode = await radio.getNetworkSelectionMode(slotId)
            const networkSelectionModeText = JSON.stringify(networkSelectionMode)
            Logger.info(`${TAG}, getNetworkSelectionMode networkSelectionMode = ${networkSelectionModeText}`)
            return networkSelectionModeText
        } catch (error) {
            return this.getErrorMessage('getNetworkSelectionMode', error as BusinessError)
        }
    }

    async getISOCountryCodeForNetwork(slotId: number): Promise<string> {
        try {
            const iSOCountryCode = await radio.getISOCountryCodeForNetwork(slotId)
            Logger.info(`${TAG}, getISOCountryCodeForNetwork iSOCountryCode = ${iSOCountryCode}`)
            return typeof iSOCountryCode === 'undefined' ? 'not available' : iSOCountryCode
        } catch (error) {
            return this.getErrorMessage('getISOCountryCodeForNetwork', error as BusinessError)
        }
    }

    async getNetworkState(): Promise<string> {
        try {
            const data = await radio.getNetworkState()
            Logger.info(`${TAG}, getNetworkState data = ${JSON.stringify(data)}`)
            const networkState: string = `longOperatorName:${JSON.stringify(data.longOperatorName)}\n` +
            `shortOperatorName:${JSON.stringify(data.shortOperatorName)}\n` +
            `plmnNumeric:${JSON.stringify(data.plmnNumeric)}\n` +
            `isRoaming:${JSON.stringify(data.isRoaming)}\n` +
            `regState:${JSON.stringify(data.regState)}\n` +
            `nsaState:${JSON.stringify(data.nsaState)}\n` +
            `isCaActive:${JSON.stringify(data.isCaActive)}\n` +
            `isEmergency:${JSON.stringify(data.isEmergency)}\n`
            Logger.info(`${TAG}, getNetworkState networkState = ${JSON.stringify(networkState)}`)
            return networkState
        } catch (error) {
            return this.getErrorMessage('getNetworkState', error as BusinessError)
        }
    }

    async getRadioOn(): Promise<string> {
        Logger.info(`${TAG}, getRadioOn radioOn start`)
        try {
            const radioOn = await radio.isRadioOn()
            Logger.info(`${TAG}, getRadioOn radioOn = ${radioOn}`)
            return radioOn.toString()
        } catch (error) {
            return this.getErrorMessage('getRadioOn', error as BusinessError)
        }
    }
}
