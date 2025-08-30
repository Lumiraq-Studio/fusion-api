import {Controller, Get, Query} from '@nestjs/common';
import {PaymentTermsService} from './payment-terms.service';

@Controller()
export class PaymentTermsController {
  constructor(private readonly paymentTermsService: PaymentTermsService) {}


  @Get('find')
  async findRoutes(

      @Query('type') type: string,
      @Query('items_per_page') itemsPerPage: number,
      @Query('page_number') pageNumber: number
  ) {
    return await this.paymentTermsService.find(
        type,
        itemsPerPage,
        pageNumber
    );
  }


}
