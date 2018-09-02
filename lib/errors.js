class AppError extends Error {
  constructor (message) {
    super(message)
    this.name = this.constructor.name
    if (typeof Error.captureStackTrace === 'function') {
      Error.captureStackTrace(this, this.constructor)
    } else {
      this.stack = (new Error(message)).stack
    }
  }
}

class InternalServerError extends AppError {}
class BadRequestError extends AppError {}

module.exports.AppError = AppError
module.exports.InternalServerError = InternalServerError
module.exports.BadRequestError = BadRequestError
