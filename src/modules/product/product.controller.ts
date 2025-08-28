import {Body, Controller, Get, Param, Patch, Post, Query} from '@nestjs/common';
import {ProductService} from './product.service';
import {CreateProductDTO, UpdateProductDTO} from "./product.entity";

@Controller()
export class ProductController {
    constructor(private readonly productService: ProductService) {
    }

    @Get('find')
    async findProducts(
        @Query('product_name') productName: string,
        @Query('warehouse_code') warehouseCode: string,
        @Query('items_per_page') itemsPerPage: number,
        @Query('page_number') pageNumber: number
    ) {
        return await this.productService.find(
            productName,
            warehouseCode,
            +itemsPerPage,
            +pageNumber
        );
    }

    @Get('price')
    async getPricesByProducts(@Query('customer') customerId: number,
                              @Query('rep') repId: number,) {
        return await this.productService.getPricesByProductAndShop(customerId,repId);
    }

    @Get(':id')
    async getOrder(@Param('id') id: number) {
        return await this.productService.get(+id);
    }


    @Post()
    async create(@Body() createProductDTO: CreateProductDTO) {
        return await this.productService.create(createProductDTO);
    }

    @Patch(':id')
    async update(@Param('id') id: number, @Body() updateProductDTO: UpdateProductDTO) {
        return await this.productService.update(+id, updateProductDTO);
    }


}
