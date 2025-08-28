import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, Repository} from "typeorm";
import {processData, processPaginationData} from "../../utils/utils";
import {CreateMaterialDTO, UpdateMaterialDTO} from "./material.entity";

@Injectable()
export class MaterialsService {

    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }


    async create(createMaterialDTO: CreateMaterialDTO) {
        const result = await this.dataSourceRepository.query('CALL material_save(?,?,?)', [
            createMaterialDTO.name,
            createMaterialDTO.unitCost,
            createMaterialDTO.quantity
        ])
        return processData(result, 0)

    }

    async find(
        material_name: string,
        items_per_page: number,
        page_number: number
    ) {
        const result = await this.dataSourceRepository.query('CALL material_find(?,?,?)', [
            material_name,
            items_per_page,
            page_number
        ])
        return processPaginationData(result)
    }

    async get(id: number) {
        const result = await this.dataSourceRepository.query('CALL material_get(?)', [
            id
        ])
        return processData(result, 1)
    }

    async update(id: number, updateMaterialDTO: UpdateMaterialDTO) {
        const result = await this.dataSourceRepository.query('CALL material_update(?,?,?,?,?)', [
            id,
            updateMaterialDTO.name,
            updateMaterialDTO.unitCost,
            updateMaterialDTO.quantity,
            updateMaterialDTO.availableQty,

        ])
        return processData(result, 0)
    }

}
