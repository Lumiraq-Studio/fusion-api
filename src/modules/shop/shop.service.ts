import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, Repository} from "typeorm";
import {processData, processPaginationData} from "../../utils/utils";
import {CreateShopDTO, UpdateShopDTO} from "./shop.entity";

@Injectable()
export class ShopService {

    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }

    async create(createShopDTO: CreateShopDTO) {

        const result = await this.dataSourceRepository.query('CALL shop_save(?,?,?,?,?,?,?,?)', [
            createShopDTO.fullName,
            createShopDTO.shortName,
            createShopDTO.address,
            createShopDTO.city,
            createShopDTO.mobile,
            createShopDTO.routeId,
            createShopDTO.shopType,
            createShopDTO.createdBy
        ])
        return processData(result, 0)
    }

    async find(
        shop_code: string,
        full_name: string,
        typeId: number,
        routeId: number,
        itemsPerPage: number,
        pageNumber: number
    ) {
        const result = await this.dataSourceRepository.query('CALL shop_find(?,?,?,?,?,?)', [
            shop_code,
            full_name,
            typeId,
            routeId,
            itemsPerPage,
            pageNumber
        ])
        return processPaginationData(result)
    }

    async get(id: number) {
        const result = processData(await this.dataSourceRepository.query('CALL shop_data_get(?)', [id]), 1);
        return result
    }

    async getByRoutes(id: number) {
        return JSON.parse(processData(await this.dataSourceRepository.query('CALL shop_getAll_by_routes(?)', [id]), 1).data);
    }

    async update(id: number, updateShopDTO: UpdateShopDTO) {
        const result = await this.dataSourceRepository.query('CALL shop_update(?,?,?,?,?,?,?,?,?)', [
            id,
            updateShopDTO.fullName,
            updateShopDTO.shortName,
            updateShopDTO.address,
            updateShopDTO.mobile,
            updateShopDTO.status,
            updateShopDTO.routeId,
            updateShopDTO.shopType,
            updateShopDTO.updatedBy
        ])
        return processData(result, 0)
    }

    async getTypes() {
        const result = processData(await this.dataSourceRepository.query('CALL shop_types_get()'), 0);
        return result
    }

}
