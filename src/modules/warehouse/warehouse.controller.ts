import {Body, Controller, Get, Param, Patch, Post} from '@nestjs/common';
import {WarehouseService} from './warehouse.service';
import {CreateWarehouseDTO, UpdateWarehouseDTO} from "./warehouse.entity";

@Controller()
export class WarehouseController {
    constructor(private readonly warehouseService: WarehouseService) {
    }

    // @Get('/find')
    // async find(
    //     @Query('warehouse_code') warehouseCode: string,
    //     @Query('warehouse_name') warehouseName: string,
    //     @Query('contact_person_name') contactPerson: string,
    //     @Query('warehouse_address') address: string,
    //     @Query('items_per_page') items_per_page: number,
    //     @Query('page_number') page_number: number,
    // ) {
    //     return await this.warehouseService.find(warehouseCode, warehouseName, contactPerson, address, +items_per_page, +page_number)
    // }

    @Get(':id')
    async get(
        @Param('id') id: number,
    ) {
        return await this.warehouseService.get(+id)
    }



    @Patch('/:id')
    async update(@Param('id') id: number, @Body() updateWarehouseDTO: UpdateWarehouseDTO) {
        return await this.warehouseService.update(id, updateWarehouseDTO)
    }

    @Post()
    async create(@Body() createWarehouseDTO: CreateWarehouseDTO) {
        return await this.warehouseService.create(createWarehouseDTO)
    }

    @Get()
    async getAll() {
        return this.warehouseService.getAll()
    }

}
