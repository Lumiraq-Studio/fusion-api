import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, Repository} from "typeorm";
import {processData} from "../../utils/utils";

@Injectable()
export class ReportService {

    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }

    async salesOrderReport(routeId: number,
                 salesRepId: number,
                 customerId: number,
                 status: string,
                 startDate: string,
                 endDate: string,
    ) {
        const result = await this.dataSourceRepository.query('CALL sales_order_report(?,?,?,?,?,?)', [
            routeId,
            salesRepId,
            customerId,
            status,
            startDate,
            endDate,
        ])
        return processData(result, 0)

    }

    async getPrices(routeId:number){
        const result = await this.dataSourceRepository.query('CALL price_by_route_id(?)', [
            routeId
        ])
        return processData(result, 0)
    }


}
