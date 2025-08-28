import {Controller, Get, Param, Query} from '@nestjs/common';
import {ReportService} from './report.service';

@Controller()
export class ReportController {
    constructor(private readonly reportService: ReportService) {
    }


    @Get('download')
    async findRoutes(
        @Query('route') routeId: number,
        @Query('salesRep') salesRepId: number,
        @Query('customer') customerId: number,
        @Query('status') status: string,
        @Query('startDate') startDate: string,
        @Query('endDate') endDate: string
    ) {
        return await this.reportService.salesOrderReport(
            +routeId,
            +salesRepId,
            +customerId,
            status,
            startDate,
            endDate,
        );
    }

    @Get('price/:id')
    async Price(@Param('id') id: number) {
        return await this.reportService.getPrices(+id)
    }



}
