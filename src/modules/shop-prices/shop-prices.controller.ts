import {Body, Controller, Get, Param, Patch, Post} from '@nestjs/common';
import {ShopPricesService} from './shop-prices.service';
import {CreatePricesDTO, UpdateShopPricesDTO} from "./shop-prices.entity";

@Controller()
export class ShopPricesController {
    constructor(private readonly shopPricesService: ShopPricesService) {
    }

    @Get('by/routes/:id')
    async getShopPrice(@Param('id') id: number) {
        return await this.shopPricesService.getByRoutes(id);
    }

    @Get(':id')
    async get(@Param('id') id: number) {
        return await this.shopPricesService.get(+id);
    }

    @Post()
    async createShopPrices(@Body() createShopPricesDTO: CreatePricesDTO) {
        return await this.shopPricesService.create(createShopPricesDTO);
    }


    @Patch()
    async update(@Param('id') id: number, @Body() updateShopPricesDTO: UpdateShopPricesDTO) {
        return await this.shopPricesService.update(id, updateShopPricesDTO);
    }


}
