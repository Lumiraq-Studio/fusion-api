import {Body, Controller, Get, Param, Patch, Post, Query} from '@nestjs/common';
import {RepStockService} from './rep-stock.service';
import {CreateRepStockDTO, UnassignRepStockDto} from "./rep-stock.entity";


@Controller()
export class RepStockController {
    constructor(private readonly repStockService: RepStockService) {
    }

    @Post()
    async create(@Body() createRepStockDTO: CreateRepStockDTO) {
        return await this.repStockService.save(createRepStockDTO)
    }

    @Get()
    async getRepStockById(
        @Query('rep_id') id: number,
        @Query('assign_date') assignDate: string,) {
        return await this.repStockService.getByRep(+id,assignDate)
    }

    @Patch(':id')
    async update(@Param('id') id: number, @Body() unassignRepStockDto: UnassignRepStockDto) {
        return await this.repStockService.unassignRepStock(id, unassignRepStockDto);
    }


}
