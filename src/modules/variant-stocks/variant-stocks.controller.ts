import {Body, Controller, Get, Param, Post} from '@nestjs/common';
import {VariantStocksService} from './variant-stocks.service';
import {CreateVariantStock} from "./variant-stock.entity";

@Controller()
export class VariantStocksController {
    constructor(private readonly variantStocksService: VariantStocksService) {
    }

    @Post()
    async createUser(@Body() createUserDTO: CreateVariantStock) {
        return await this.variantStocksService.create(createUserDTO);
    }

    @Get(':id')
    async getByProduct(@Param('id') id: number) {
        return await this.variantStocksService.variant_stock_get_by_product(id)
    }

}
