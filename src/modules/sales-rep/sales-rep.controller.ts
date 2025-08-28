import {Body, Controller, Get, Param, Post, Query} from '@nestjs/common';
import {SalesRepService} from './sales-rep.service';
import {CreateSalesRep} from "./sales-rep.entity";

@Controller()
export class SalesRepController {
    constructor(private readonly salesRepService: SalesRepService) {
    }

    @Get('find')
    async findSalesReps(
        @Query('rep_name') repName: string,
        @Query('status') repStatus: string,
        @Query('items_per_page') itemsPerPage: number,
        @Query('page_number') pageNumber: number
    ) {
        return await this.salesRepService.find(
            repName,
            repStatus,
            itemsPerPage,
            pageNumber
        );
    }

    @Post()
    async createSalesRep(@Body() createSalesRep: CreateSalesRep) {
        return await this.salesRepService.create(createSalesRep);
    }


    @Get('summary/:id')
    async getRepSummary(@Param('id') id: number) {
      return await this.salesRepService.getRepSummary(id);
    }
}
