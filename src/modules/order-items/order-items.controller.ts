import {Body, Controller, Get, Param, Post, Query} from '@nestjs/common';
import {OrderItemsService} from './order-items.service';
import {CreateOrderItem} from "./order-item.entity";

@Controller()
export class OrderItemsController {
  constructor(private readonly orderItemsService: OrderItemsService) {}


  @Get('find')
  async findOrderItems(
      @Query('product_name') productName: string,
      @Query('order_reference') orderReference: string,
      @Query('items_per_page') itemsPerPage: number,
      @Query('page_number') pageNumber: number
  ) {
    return await this.orderItemsService.find(
        productName,
        orderReference,
        itemsPerPage,
        pageNumber
    );
  }

  @Post()
  async createOrderItem(@Body() createOrderItem: CreateOrderItem) {
    return await this.orderItemsService.create(createOrderItem);
  }



  @Get(':id')
  async getOrderItem(@Param('id') id: number) {
    return await this.orderItemsService.get(id);
  }
}
