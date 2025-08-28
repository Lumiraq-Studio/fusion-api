import {Body, Controller, Get, Param, Patch, Post, Query} from '@nestjs/common';
import {ShopService} from './shop.service';
import {CreateShopDTO, UpdateShopDTO} from "./shop.entity";

@Controller()
export class ShopController {
    constructor(private readonly shopService: ShopService) {
    }

    @Get('find')
    async findShops(
        @Query('shop_code') shopCode: string,
        @Query('full_name') fullName: string,
        @Query('type') typeId: number,
        @Query('route') routeId: number,
        @Query('items_per_page') itemsPerPage: number,
        @Query('page_number') pageNumber: number
    ) {
        return await this.shopService.find(
            shopCode,
            fullName,
            typeId,
            routeId,
            itemsPerPage,
            pageNumber
        );
    }

    @Get('types')
    async typesGet() {
        return await this.shopService.getTypes();
    }

    @Post()
    async createShop(@Body() createShopDTO: CreateShopDTO) {
        return await this.shopService.create(createShopDTO);
    }

    @Get(':id')
    async getShop(@Param('id') id: number) {
        return await this.shopService.get(+id);
    }

    @Patch(':id')
    async update(@Param('id') id: number, @Body() updateShopDTO: UpdateShopDTO) {
        return await this.shopService.update(id, updateShopDTO);
    }
}
