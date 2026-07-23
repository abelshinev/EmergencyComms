function getTimestamp() {
  const now = new Date();
  const hours = String(now.getHours()).padStart(2, '0');
  const minutes = String(now.getMinutes()).padStart(2, '0');
  const seconds = String(now.getSeconds()).padStart(2, '0');
  return `[${hours}:${minutes}:${seconds}]`;
}

const logger = {
  info: (message) => {
    console.log(`${getTimestamp()} ${message}`);
  },
  warn: (message) => {
    console.warn(`${getTimestamp()} [WARN] ${message}`);
  },
  error: (message) => {
    console.error(`${getTimestamp()} [ERROR] ${message}`);
  }
};

module.exports = logger;
