import {Controller, Get} from '@nestjs/common';
import { StatisticsService } from './statistics.service';

@Controller()
export class StatisticsController {
  constructor(private readonly statisticsService: StatisticsService) {}

    @Get('/base')
    async getBaseStatistics() {
        return this.statisticsService.getBaseStatistics();
    }

    @Get('sales-week')
    async getSalesOverviewWeek() {
        return this.statisticsService.getSalesOverviewWeek();
    }

    @Get('monthly-performance')
    async getMonthlyPerformance() {
        return this.statisticsService.getMonthlyPerformance();
    }
    
}


