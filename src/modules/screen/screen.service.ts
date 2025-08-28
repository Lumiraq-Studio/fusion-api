import {Injectable} from '@nestjs/common';
import {processData} from "../../utils/utils";
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, Repository} from "typeorm";

@Injectable()
export class ScreenService {

    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }

    async customerDetails() {
        const result = await this.dataSourceRepository.query('CALL customer_screen()')
        return processData(result, 1)

    }

    async salesTeamDetails() {
        const result = await this.dataSourceRepository.query('CALL sales_screen()')
        return processData(result, 1)

    }

}
