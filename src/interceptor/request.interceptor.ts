import {CallHandler, ExecutionContext, Injectable, NestInterceptor} from '@nestjs/common'
import {Observable} from 'rxjs'
import {v4 as uuidv4} from 'uuid'

@Injectable()
export class RequestInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest()
    const requestId = uuidv4()
    request.headers['x-request-id'] = requestId
    return next.handle()
  }
}
