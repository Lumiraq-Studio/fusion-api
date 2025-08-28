import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, Repository} from "typeorm";
import {processData, processPaginationData} from "../../utils/utils";
import {CreateSalesRep, UpdateSalesRep} from "./sales-rep.entity";

@Injectable()
export class SalesRepService {

    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }

    async create(createSalesRep: CreateSalesRep) {
        const result = await this.dataSourceRepository.query('CALL sales_rep_save(?,?,?,?)', [
            createSalesRep.name,
            createSalesRep.mobile,
            createSalesRep.userId,
            createSalesRep.createdBy
        ])
        return processData(result, 0)
    }

    async find(
        rep_name: string,
        rep_status: string,
        itemsPerPage: number,
        pageNumber: number
    ) {
        const result = await this.dataSourceRepository.query('CALL sales_rep_find(?,?,?,?)', [
            rep_name,
            rep_status,
            itemsPerPage,
            pageNumber
        ])
        return processPaginationData(result)
    }

    async get(id: number) {
        const result = await this.dataSourceRepository.query('CALL sales_rep_get(?)', [
            id
        ])
        return processData(result, 1)

    }

    async update(id:number,updateSalesRep: UpdateSalesRep) {
        const result = await this.dataSourceRepository.query('CALL sales_rep_save(?,?,?,?,?,?)', [
            id,
            updateSalesRep.name,
            updateSalesRep.status,
            updateSalesRep.mobile,
            updateSalesRep.userId,
            updateSalesRep.updated_by
        ])
        return processData(result, 0)
    }

    async getRepSummary(id: number) {
        const result = await this.dataSourceRepository.query('CALL sales_rep_order_details(?)', [
            id
        ])
        return processData(result, 1)

    }


}
