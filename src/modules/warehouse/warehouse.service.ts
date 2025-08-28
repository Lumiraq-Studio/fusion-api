import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, Repository} from "typeorm";

import {processData, processPaginationData} from "../../utils/utils";
import {CreateWarehouseDTO, UpdateWarehouseDTO} from "./warehouse.entity";

@Injectable()
export class WarehouseService {


    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }

    async create(createWarehouseDTO: CreateWarehouseDTO) {
        const result = await this.dataSourceRepository.query('CALL warehouse_save(?,?,?,?,?,?)', [
            createWarehouseDTO.code,
            createWarehouseDTO.name,
            createWarehouseDTO.address,
            createWarehouseDTO.contactPerson,
            createWarehouseDTO.mobile,
            createWarehouseDTO.created_by,

        ])
        return processData(result, 0)
    }

    async update(unitId: number, updateWarehouseDTO: UpdateWarehouseDTO) {
        const result = await this.dataSourceRepository.query('CALL warehouse_update(?,?,?,?,?,?,?)', [
            unitId,
            updateWarehouseDTO.name,
            updateWarehouseDTO.address,
            updateWarehouseDTO.contactPerson,
            updateWarehouseDTO.mobile,
            updateWarehouseDTO.created_by,
        ])
        return processData(result, 0)
    }

    async get(id: number) {
        const result = await this.dataSourceRepository.query('CALL warehouse_get(?)', [id])
        return processData(result, 0)
    }

    async find(
        warehouseCode:string,
        warehouseName:string,
        contactPerson:string,
        address:string,
        items_per_page:number,
        page_number:number

    ) {
        const result = await this.dataSourceRepository.query('CALL warehouse_find(?,?,?,?,?,?)',[
            warehouseCode,
            warehouseName,
            contactPerson,
            address,
            items_per_page,
            page_number
        ])
        return processPaginationData(result)
    }

    async getAll() {
        const result = await this.dataSourceRepository.query('CALL  warehouse_getAll()')
        return processData(result, 0)
    }
}

