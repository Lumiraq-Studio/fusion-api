import {CallHandler, ExecutionContext, HttpException, HttpStatus, Injectable, NestInterceptor,} from '@nestjs/common';
import {catchError, Observable} from 'rxjs';
import {map} from 'rxjs/operators';
import {format} from 'date-fns';

@Injectable()
export class ResponseInterceptor implements NestInterceptor {
    intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
        const now = Date.now();
        const response = context.switchToHttp().getResponse();

        return next.handle().pipe(
            map((data) => {
                let statusCode = context.switchToHttp().getResponse().statusCode;
                let errorCode: string | number = null;
                let errorMessage: string | object = null;
                let responseData: any = '';

                // Check for error_message in data regardless of status code
                const hasErrorMessage = Array.isArray(data)
                    ? data.some(item => item.error_message)
                    : data?.error_message;

                // Handle HttpException
                if (data instanceof HttpException) {
                    statusCode = data.getStatus();
                    errorCode = statusCode;
                    errorMessage = data.getResponse();
                    response.status(statusCode);
                }
                // Handle data with error_message even if status is 2XX
                else if (hasErrorMessage) {
                    statusCode = HttpStatus.BAD_REQUEST;
                    errorCode = HttpStatus.BAD_REQUEST;
                    errorMessage = Array.isArray(data)
                        ? data.find(item => item.error_message)?.error_message
                        : data.error_message;
                    response.status(statusCode);
                }
                // Handle database error
                else if (
                    data?.RowDataPacket &&
                    (statusCode < 200 || statusCode >= 300)
                ) {
                    statusCode = HttpStatus.BAD_REQUEST;
                    errorCode = HttpStatus.BAD_REQUEST;
                    errorMessage = data.error_message;
                    response.status(statusCode);
                }
                // Handle undefined data
                else if (typeof data === 'undefined') {
                    statusCode = HttpStatus.NOT_FOUND;
                    errorCode = HttpStatus.NOT_FOUND;
                    errorMessage = 'Records not found. Please contact system administrator.';
                    response.status(statusCode);
                }
                // Handle success response
                else {
                    responseData = data;
                }
                return {
                    response: statusCode,
                    path: context.switchToHttp().getRequest().path,
                    timestamp: format(now, 'yyyy-MM-dd HH:mm:ss'),
                    ...(errorCode && { error: errorCode }),
                    ...(errorMessage && { message: errorMessage }),
                    ...(responseData && { data: responseData }),
                };
            }),
            catchError((error) => {
                console.log('Unhandled Error:', error);
                response.status(HttpStatus.INTERNAL_SERVER_ERROR);
                throw error;
            }),
        );
    }
}