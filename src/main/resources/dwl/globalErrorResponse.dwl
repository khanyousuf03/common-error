%dw 2.0
import * from dw::Runtime
output application/json skipNullOn="everywhere"
---
{
  "errorCode": write(vars.httpStatus,"application/json"),
  "errorMessage": if (upper(vars.jsonLoggerObject.apiLayer)=="PRC" and error.errorType.identifier == "MULE_CUSTOM_ERROR") (error.description default error.errorMessage.payload default "Internal Server Error") else if (upper(vars.jsonLoggerObject.apiLayer)=="SYS")  (try(()-> (error.suppressedErrors[0].errorMessage.payload[0].message default error.description default error.errorMessage.payload)) orElseTry (error.description default error.errorMessage.payload) orElseTry (error.errorMessage.payload) orElse ("Internal Server Error")) default "Internal Server Error" else vars.statusMessage,
   "transactionId": correlationId,
   "timeStamp": now() as String { format: "yyyy-MM-dd'T'HH:mm:ss" },
   "applicationId": vars.jsonLoggerObject.applicationId
}
