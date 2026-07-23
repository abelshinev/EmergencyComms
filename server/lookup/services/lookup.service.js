const fs = require('fs');
const path = require('path');
const logger = require('../../config/logger');

class LookupService {
  constructor() {
    this.devices = new Map();
    this.stations = new Map();
    this.isInitialized = false;
  }

  init() {
    try {
      const devicesPath = path.join(__dirname, '../data/devices.json');
      const stationsPath = path.join(__dirname, '../data/stations.json');

      const devicesRaw = fs.readFileSync(devicesPath, 'utf8');
      const stationsRaw = fs.readFileSync(stationsPath, 'utf8');

      const devicesList = JSON.parse(devicesRaw);
      const stationsList = JSON.parse(stationsRaw);

      this.devices.clear();
      this.stations.clear();

      devicesList.forEach((device) => {
        this.devices.set(device.deviceId, device);
      });

      stationsList.forEach((station) => {
        // Key station lookup by stationId + block (e.g. ST001_A)
        const key = `${station.stationId}_${station.block}`;
        this.stations.set(key, station);
      });

      this.isInitialized = true;
      logger.info(`[LookupService] Loaded ${this.devices.size} devices and ${this.stations.size} station-agent mappings into memory.`);
    } catch (err) {
      logger.error(`[LookupService] Failed to load registry files: ${err.message}`);
      throw err;
    }
  }

  resolveDevice(deviceId) {
    if (!this.isInitialized) {
      this.init();
    }

    const device = this.devices.get(deviceId);
    if (!device) {
      return null;
    }

    const stationKey = `${device.stationId}_${device.block}`;
    const station = this.stations.get(stationKey);

    return {
      deviceId: device.deviceId,
      stationId: device.stationId,
      block: device.block,
      agent: station
        ? {
            agentId: station.agentId,
            name: station.agentName,
            email: station.agentEmail
          }
        : null
    };
  }
}

module.exports = new LookupService();
