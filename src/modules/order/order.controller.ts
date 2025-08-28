import {Body, Controller, Get, Param, Patch, Post, Query} from '@nestjs/common';
import {OrderService} from './order.service';
import {CreateOrderDTO, UpdateOrderDTO} from "./order.entity";

@Controller()
export class OrderController {
    constructor(private readonly orderService: OrderService) {
    }


    @Get('find')
    async findOrders(
        @Query('order_type') orderType: string,
        @Query('order_date') orderDate: string,
        @Query('order_status') orderStatus: string,
        @Query('order_reference') orderReference: string,
        @Query('shop_name') shopName: string,
        @Query('sales_rep_name') salesRepName: string,
        @Query('payment_type') paymentType: string,
        @Query('route_id') routeId: number,
        @Query('items_per_page') itemsPerPage: number,
        @Query('page_number') pageNumber: number
    ) {
        return await this.orderService.find(
            orderType,
            orderDate,
            orderStatus,
            orderReference,
            shopName,
            salesRepName,
            paymentType,
            routeId,
            +itemsPerPage,
            +pageNumber
        );
    }

    @Get('summary/:date')
    async getCash(
        @Param('date') dateValue: string
    ) {
        return await this.orderService.getTodayCash(dateValue);
    }

    @Post()
    async createOrder(@Body() createOrderDTO: CreateOrderDTO) {
        return await this.orderService.create(createOrderDTO);
    }

    @Get(':id')
    async getOrder(@Param('id') id: number) {
        return await this.orderService.get(+id);
    }

    @Patch(':id')
    async updatePaid(@Param('id') id: number, @Body() updateOrderDTO: UpdateOrderDTO) {
        return await this.orderService.update(+id, updateOrderDTO);
    }


}
