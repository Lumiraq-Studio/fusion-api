import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, Repository} from "typeorm";
import {processPaginationData} from "../../utils/utils";

@Injectable()
export class PaymentTermsService {


    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }


    async find(
        type:string,
        items_per_page:number,
        page_number:number

    ) {
        const result = await this.dataSourceRepository.query('CALL payment_type_find(?,?,?)',[
            type,
            items_per_page,
            page_number
        ])
        return processPaginationData(result)
    }
}
