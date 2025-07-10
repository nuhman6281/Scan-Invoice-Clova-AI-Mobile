"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.errorHandler = errorHandler;
const logger_1 = require("../utils/logger");
function errorHandler(err, req, res, next) {
    const statusCode = err.statusCode || 500;
    const message = err.message || 'Internal Server Error';
    logger_1.logger.error({
        error: err.message,
        stack: err.stack,
        url: req.url,
        method: req.method,
        ip: req.ip,
        userAgent: req.get('User-Agent')
    });
    const errorResponse = {
        success: false,
        error: {
            message: process.env.NODE_ENV === 'production' ? 'Internal Server Error' : message,
            ...(process.env.NODE_ENV !== 'production' && { stack: err.stack })
        }
    };
    res.status(statusCode).json(errorResponse);
}
//# sourceMappingURL=errorHandler.js.map