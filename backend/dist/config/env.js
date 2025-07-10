"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateEnv = validateEnv;
function validateEnv() {
    const requiredEnvVars = [
        'DATABASE_URL',
        'JWT_SECRET',
        'CLOVA_SERVICE_URL'
    ];
    const missingVars = requiredEnvVars.filter(varName => !process.env[varName]);
    if (missingVars.length > 0) {
        throw new Error(`Missing required environment variables: ${missingVars.join(', ')}`);
    }
}
//# sourceMappingURL=env.js.map