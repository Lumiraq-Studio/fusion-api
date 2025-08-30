import { Injectable } from '@nestjs/common';
import {DataSource, Repository} from 'typeorm';
import {processData} from "../../utils/utils";
import {InjectRepository} from "@nestjs/typeorm";


@Injectable()
export class StatisticsService {
    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }

    async getBaseStatistics() {
        const response: any = await this.dataSourceRepository.query(`CALL base_statistics_get()`);
        return processData(response, 1);
    }

    async getSalesOverviewWeek() {
        const response: any = await this.dataSourceRepository.query(`CALL sales_overview_week_get()`);
        return processData(response, 0);
    }

    async getMonthlyPerformance() {
        const response: any = await this.dataSourceRepository.query(`CALL monthly_performance_get()`);
        return processData(response, 0);
    }
}
